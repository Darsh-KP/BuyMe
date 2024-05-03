package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;


public class bidController {
    private bidController() {}

    public static boolean postBid(String username, String productID, String bid_amount, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double bid_amt = Double.parseDouble(bid_amount);
        
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
            return true;


        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error bidding...");
                e.printStackTrace();
            }
        }
        return false;
    }
    
    public static boolean autoBid(String username, String productID, String max_bid_amount, String bid_increment, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double max_bid = Double.parseDouble(max_bid_amount);
        double bid_inc = Double.parseDouble(bid_increment);
        
        boolean bidAllowed = biddingAllowed(prod_id);
        
        if(!bidAllowed) {
        	return false;
        }
        try {
            myDatabase database = new myDatabase();
            Connection autobidConnection = database.newConnection();
            PreparedStatement statement = autobidConnection.prepareStatement(
                    "INSERT INTO autoBid (username, product_id, max_bid, bid_increment, is_anonymous) "
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
            return true;


        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error auto bidding...");
                e.printStackTrace();
            }
        }
        return false;
    }

    public static boolean biddingAllowed(int productID) {
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
}