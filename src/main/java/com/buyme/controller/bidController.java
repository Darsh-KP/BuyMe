package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;


public class bidController {
    private bidController() {}

    public static boolean postBid (String username, String productID, String bid_amount, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double bid_amt = Double.parseDouble(bid_amount);

        DecimalFormat df = new DecimalFormat("#.##");
        bid_amt = Double.parseDouble(df.format(bid_amt));
        
        boolean bidAllowed = biddingAllowed(prod_id);
        
        if(!bidAllowed) {
        	return false;
        }
        
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

            notificationsController.checkForBidAlerts(Integer.parseInt(productID));
            checkAutoBidEvent(Integer.parseInt(productID));

            return true;
        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error bidding...");
                e.printStackTrace();
            }
        }
        return false;
    }
    
    public static boolean autoBid (String username, String productID, String max_bid_amount, String bid_increment, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double max_bid = Double.parseDouble(max_bid_amount);
        double bid_inc = Double.parseDouble(bid_increment);

        DecimalFormat df = new DecimalFormat("#.##");
        bid_inc = Double.parseDouble(df.format(bid_inc));
        max_bid = Double.parseDouble(df.format(max_bid));
        
        boolean bidAllowed = biddingAllowed(prod_id);
        
        if(!bidAllowed) {
        	return false;
        }
        try {
            myDatabase database = new myDatabase();
            Connection autobidConnection = database.newConnection();
            PreparedStatement statement = autobidConnection.prepareStatement(
                    "INSERT INTO auto_bidder (username, product_id, max_bid, bid_increment, is_anonymous) "
                    + "VALUES (?, ?, ?, ?, ?)"
                    + "ON DUPLICATE KEY UPDATE \n"
                    + "    max_bid = VALUES(max_bid), \n"
                    + "    bid_increment = VALUES(bid_increment), \n"
                    + "    is_anonymous = VALUES(is_anonymous);");
            statement.setString(1, username);
            statement.setInt(2, prod_id);
            statement.setDouble(3, max_bid);
            statement.setDouble(4, bid_inc);
            statement.setBoolean(5, is_anon);
            statement.executeUpdate();
            statement.close();
            autobidConnection.close();

            checkAutoBidEvent(Integer.parseInt(productID));

            return true;
        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error auto bidding...");
                e.printStackTrace();
            }
        }
        return false;
    }

    public static boolean biddingAllowed (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection biddingAllowedConnection = database.newConnection();

            // Get the product
            PreparedStatement statement = biddingAllowedConnection.prepareStatement(
                    "select product_id, start_date_time, close_date_time from listing where product_id = ?;");
            statement.setInt(1, productID);
            ResultSet resultSet = statement.executeQuery();

            // Get the dates to compare
            resultSet.next();
            LocalDateTime startDateTime = resultSet.getTimestamp("start_date_time").toLocalDateTime();
            LocalDateTime closeDateTime = resultSet.getTimestamp("close_date_time").toLocalDateTime();
            LocalDateTime now = LocalDateTime.now();

            // Check the dates
            boolean biddingAllowed = (startDateTime.isBefore(now)) && (closeDateTime.isAfter(now));

            //Close connection
            resultSet.close();
            statement.close();
            biddingAllowedConnection.close();

            // Return the strings to display
            return biddingAllowed;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return false;
    }

    public static void checkAutoBidEvent (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection maxAutobidderConnection = database.newConnection();

            // Query the bids table to find the highest bid on this product
            PreparedStatement statement = maxAutobidderConnection.prepareStatement(
                    "SELECT username, product_id, max_bid, bid_increment, is_anonymous\n" +
                            "FROM auto_bidder WHERE product_id = ?\n" +
                            "AND max_bid > COALESCE((\n" +
                            "    SELECT bid_amount FROM bid WHERE product_id = ? ORDER BY bid_amount DESC LIMIT 1\n" +
                            "), (select initial_price from listing where product_id = ?))\n" +
                            "AND username <> COALESCE((\n" +
                            "    SELECT username FROM bid WHERE product_id = ? ORDER BY bid_amount DESC LIMIT 1), '') \n" +
                            "ORDER BY bid_increment DESC;");
            statement.setInt(1, productID);
            statement.setInt(2, productID);
            statement.setInt(3, productID);
            statement.setInt(4, productID);
            ResultSet resultSet = statement.executeQuery();

            // Query to get the price of the product
            PreparedStatement priceStatement = maxAutobidderConnection.prepareStatement(
                    "SELECT COALESCE(\n" +
                            "    (SELECT bid_amount FROM bid WHERE product_id = ? ORDER BY bid_amount DESC LIMIT 1),\n" +
                            "    (SELECT initial_price FROM listing WHERE product_id = ?)\n" +
                            ") AS price;");
            priceStatement.setInt(1, productID);
            priceStatement.setInt(2, productID);
            ResultSet priceResultSet = priceStatement.executeQuery();
            priceResultSet.next();
            double price = priceResultSet.getDouble("price");

            // Go through each auto-bids and check for valid bids
            while (resultSet.next()) {
                // Check if the auto-bidder bid is less than max bid allowed
                double bidAmount = price + resultSet.getDouble("bid_increment");
                DecimalFormat df = new DecimalFormat("#.##");
                bidAmount = Double.parseDouble(df.format(bidAmount));
                if (!(bidAmount <= resultSet.getDouble("max_bid"))) continue;

                // Try to auto-bid
                if (postBid(resultSet.getString("username"), String.valueOf(resultSet.getInt("product_id")),
                        String.valueOf(bidAmount), resultSet.getBoolean("is_anonymous"))) break;
            }

            //Close connections
            priceResultSet.close();
            priceStatement.close();
            resultSet.close();
            statement.close();
            maxAutobidderConnection.close();

            // If not, return null for no bids
            return;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return;
    }
    
    public static boolean removeBid(String prodID, String username) {
    	int productID = Integer.parseInt(prodID);
    	try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection removeBidConnection = database.newConnection();

            // Query the bids table to find the highest bid on this product
            PreparedStatement statement = removeBidConnection.prepareStatement(
            		"DELETE FROM bid\n"
            		+ "WHERE product_id = ? \n"
            		+ "  AND username = ?\n"
            		+ "  AND bid_amount = (\n"
            		+ "    SELECT max_bid FROM (\n"
            		+ "        SELECT MAX(bid_amount) AS max_bid\n"
            		+ "        FROM bid \n"
            		+ "        WHERE product_id = ?\n"
            		+ "    ) AS subquery\n"
            		+ "  );");
            
            statement.setInt(1, productID);
            statement.setString(2, username);
            statement.setInt(3, productID);
            statement.executeUpdate();
            
            
            statement.close();
            removeBidConnection.close();
            
            return true;
    	}catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error removing bid...");
                e.printStackTrace();
            }
        }

        return false;
    	
    }
}