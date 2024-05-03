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
    
    public static void autoBid(String username, String productID, String max_bid_amount, String bid_increment, boolean is_anon) {
        int prod_id = Integer.parseInt(productID);
        double max_bid = Double.parseDouble(max_bid_amount);
        double bid_inc = Double.parseDouble(bid_increment);

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


        } catch (SQLException e) {

            if (myDatabase.debug) {
                System.out.println("Error auto bidding...");
                e.printStackTrace();
            }
        }
    }
}