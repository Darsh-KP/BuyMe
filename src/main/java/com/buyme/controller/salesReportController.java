package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class salesReportController {
    private salesReportController () {}

    public static String getTotalEarnings () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection totalEarningsConnection = database.newConnection();

            // Get total earnings from db
            Statement statement = totalEarningsConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT round(sum(bid_amount),2) as total_earnings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW();"
            );

            // Process total earnings
            String totalEarnings = "$0";
            if (resultSet.next()) {
                totalEarnings = "$" + resultSet.getString("total_earnings");
            }

            // Close connections
            resultSet.close();
            statement.close();
            totalEarningsConnection.close();

            return totalEarnings;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting total earnings...");
                e.printStackTrace();
            }
        }

        return "$0";
    }

    public static List<String> getEarningsPerSubcategory () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection earningsSubcategoryConnection = database.newConnection();

            // Get earning per subcategory
            Statement statement = earningsSubcategoryConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT subcategory, round(sum(bid_amount), 2) as earnings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW()\n" +
                            "Group by subcategory\n" +
                            "order by subcategory;"
            );

            // Process each earning
            List<String> earningPerSubcategory = new ArrayList<String>();
            while (resultSet.next()) {
                earningPerSubcategory.add(resultSet.getString("subcategory") + ": $" + resultSet.getString("earnings"));
            }

            // Close connections
            resultSet.close();
            statement.close();
            earningsSubcategoryConnection.close();

            return earningPerSubcategory;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting earnings per subcategory...");
                e.printStackTrace();
            }
        }

        return new ArrayList<String>();
    }

    public static List<String> getTop3SellingItems () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection topItemsConnection = database.newConnection();

            // Get earning per items
            Statement statement = topItemsConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT product_id, product_name, bid_amount as earnings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW()\n" +
                            "order by earnings desc limit 3;"
            );

            // Process each earning
            List<String> top3SellingItems = new ArrayList<String>();
            while (resultSet.next()) {
                top3SellingItems.add("#" + resultSet.getString("product_id") + ", \"" +
                        resultSet.getString("product_name") + "\": $" + resultSet.getString("earnings"));
            }

            // Close connections
            resultSet.close();
            statement.close();
            topItemsConnection.close();

            return top3SellingItems;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting top selling items...");
                e.printStackTrace();
            }
        }

        return new ArrayList<String>();
    }

    public static List<String> getTop3Buyers () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection topBuyersConnection = database.newConnection();

            // Get earning per buyer
            Statement statement = topBuyersConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT username as buyer, round(sum(bid_amount),2) as spendings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW()\n" +
                            "Group by username\n" +
                            "order by spendings desc limit 3;"
            );

            // Process each earning
            List<String> top3SellingItems = new ArrayList<String>();
            while (resultSet.next()) {
                top3SellingItems.add(resultSet.getString("buyer") + ": $" + resultSet.getString("spendings"));
            }

            // Close connections
            resultSet.close();
            statement.close();
            topBuyersConnection.close();

            return top3SellingItems;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting top buyers...");
                e.printStackTrace();
            }
        }

        return new ArrayList<String>();
    }

    public static List<HashMap<String, String>> getEarningsPerItem() {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection earningsItemConnection = database.newConnection();

            // Get earning per item
            Statement statement = earningsItemConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT product_id, product_name, bid_amount as earnings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW()\n" +
                            "order by product_id;"
            );

            // Process each earning
            List<HashMap<String, String>> earningsPerItem = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Create Hashmap to store item earnings
                HashMap<String, String> itemEarning = new HashMap<String, String>();

                // Add earning to hashmap
                itemEarning.put("criteria", "#" + resultSet.getInt("product_id") + ", \"" +
                        resultSet.getString("product_name") + "\"");
                itemEarning.put("earning", "$" + resultSet.getDouble("earnings"));

                // Add hashmap to list
                earningsPerItem.add(itemEarning);
            }

            // Close connections
            resultSet.close();
            statement.close();
            earningsItemConnection.close();

            return earningsPerItem;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting earnings per item...");
                e.printStackTrace();
            }
        }

        return new ArrayList<HashMap<String, String>>();
    }

    public static List<HashMap<String, String>> getEarningsPerSeller() {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection earningsSellerConnection = database.newConnection();

            // Get earning per seller
            Statement statement = earningsSellerConnection.createStatement();
            ResultSet resultSet = statement.executeQuery(
                    "SELECT seller_username, round(sum(bid_amount),2) as earnings\n" +
                            "FROM bid\n" +
                            "JOIN (\n" +
                            "    SELECT product_id, MAX(bid_amount) as bid_amount\n" +
                            "    FROM bid\n" +
                            "    GROUP BY product_id\n" +
                            ") max_bids USING (product_id, bid_amount)\n" +
                            "JOIN listing USING (product_id)\n" +
                            "WHERE bid_amount > min_sell_price \n" +
                            "AND close_date_time < NOW()\n" +
                            "Group by seller_username\n" +
                            "order by seller_username;"
            );

            // Process each earning
            List<HashMap<String, String>> earningsPerSeller = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Create Hashmap to store seller earnings
                HashMap<String, String> sellerEarning = new HashMap<String, String>();

                // Add earning to hashmap
                sellerEarning.put("criteria", resultSet.getString("seller_username"));
                sellerEarning.put("earning", "$" + resultSet.getDouble("earnings"));

                // Add hashmap to list
                earningsPerSeller.add(sellerEarning);
            }

            // Close connections
            resultSet.close();
            statement.close();
            earningsSellerConnection.close();

            return earningsPerSeller;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting earnings per seller...");
                e.printStackTrace();
            }
        }

        return new ArrayList<HashMap<String, String>>();
    }
}
