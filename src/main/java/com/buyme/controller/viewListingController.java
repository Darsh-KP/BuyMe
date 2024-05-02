package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.sql.*;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class viewListingController {
    private viewListingController() {}

    public static HashMap<String, String> getCardinfo(String productID) {
        try {
        	int prod_id = Integer.parseInt(productID);
            // Create connection
            myDatabase database = new myDatabase();
            Connection cardConnection = database.newConnection();
            
            PreparedStatement statement = cardConnection.prepareStatement(
            		"SELECT product_id, product_name, initial_price, subcategory, description, post_date_time, close_date_time, min_sell_price, min_bid_increment, seller_username FROM listing WHERE product_id = ?");
            		statement.setInt(1, prod_id);
            ResultSet resultSet = statement.executeQuery();

            HashMap<String, String> cardInfo = new HashMap<String, String>();
            
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> listing = new HashMap<String, String>();
                cardInfo.put("productId", String.valueOf(resultSet.getInt("product_id")));
                cardInfo.put("productName", resultSet.getString("product_name"));
                cardInfo.put("subcategory", resultSet.getString("subcategory"));
                cardInfo.put("description", resultSet.getString("description"));
                
                String productHighestBid = listingsController.getProductHighestBid(resultSet.getInt("product_id"));
                String productPriceDisplay = (productHighestBid == null) ?
                        "Initial Price: $" + resultSet.getDouble("initial_price") :
                        "Current Bid: $" + productHighestBid;
                cardInfo.put("price", productPriceDisplay);

                // Format Date
                cardInfo.put("postDate", String.valueOf(resultSet.getDate("post_date_time")));
                cardInfo.put("closeDate", String.valueOf(resultSet.getTimestamp("close_date_time")));
                // Format Status
                cardInfo.put("statusDisplay", "Status: " + listingsController.getProductStatus((productHighestBid != null),
                        resultSet.getTimestamp("post_date_time").toLocalDateTime(),
                        resultSet.getTimestamp("close_date_time").toLocalDateTime()));
                
                cardInfo.put("min_sell_price", resultSet.getString("min_sell_price"));
                cardInfo.put("min_bid_increment", resultSet.getString("min_bid_increment"));
                cardInfo.put("seller_username", resultSet.getString("seller_username"));
            }

            //Close connection
            resultSet.close();
            statement.close();
            cardConnection.close();

            // Return the strings to display
            return cardInfo;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting card info...");
                e.printStackTrace();
            }
        }

        return null;
    }
    public static void postBid(String username, String productID, String bid_amount, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double bid_amt = Double.parseDouble(bid_amount);

        try {
            myDatabase database = new myDatabase();
            Connection bidConnection = database.newConnection();
            PreparedStatement statement = bidConnection.prepareStatement(
                    "INSERT INTO bid (username, product_id, bid_amount, bid_date_time, is_anonymous) VALUES (?, ?, ?, ?, ?);");
            statement.setString(1, username);
            statement.setInt(2, prod_id);
            statement.setDouble(3, bid_amt);
            statement.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            statement.setBoolean(5, is_anon);
            statement.executeUpdate();
            statement.close();
            bidConnection.close();


        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error bidding...");
                e.printStackTrace();
            }
        }
    }

    public static List<String> getHistoryOfBids(int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection connection = database.newConnection();

            // Get all bids for the product
            PreparedStatement statement = connection.prepareStatement(
                    "select username, bid_amount, bid.is_anonymous, bid.bid_date_time from bid " +
                            "where product_id = ? order by bid_date_time desc");
            statement.setInt(1, productID);
            ResultSet resultSet = statement.executeQuery();

            // Process the display strings for history of bids
            List<String> historyList = new ArrayList<String>();
            while (resultSet.next()) {
                // Process the username for anonymous
                boolean isAnonymous = resultSet.getBoolean("is_anonymous");
                String username = resultSet.getString("username");
                username = (isAnonymous ? maskUsername(username) : username);

                // Process date & time to display
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                String bidDateTime = resultSet.getTimestamp("bid_date_time").toLocalDateTime().format(formatter);

                // Format bid amount
                String bidAmount = "$" + resultSet.getString("bid_amount");

                // Add to the list
                historyList.add(username + " - " + bidDateTime + " - " + bidAmount);
            }

            //Close connection
            resultSet.close();
            statement.close();
            connection.close();

            // Return the strings to display
            return historyList;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static String maskUsername(String username) {
        char firstChar = username.charAt(0);
        char lastChar = username.charAt(username.length() - 1);

        return firstChar + "***" + lastChar;
    }
}
