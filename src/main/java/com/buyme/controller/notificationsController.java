package com.buyme.controller;

import com.buyme.database.myDatabase;
import com.buyme.database.passwordSecurity;

import java.sql.*;
import java.time.LocalDateTime;

public class notificationsController {
    private notificationsController () {}

    public static void postAlert (String username, LocalDateTime createdAt, String message) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection alertConnection = database.newConnection();

            // Insert notification in the db
            PreparedStatement preparedStatement = alertConnection.prepareStatement(
                    "INSERT INTO notification (username, created_at, message) VALUES (?, ?, ?);");
            preparedStatement.setString(1, username);
            preparedStatement.setTimestamp(2, Timestamp.valueOf(createdAt));
            preparedStatement.setString(3, message);
            preparedStatement.executeUpdate();

            //Close connection
            preparedStatement.close();
            alertConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting alert...");
                e.printStackTrace();
            }
        }
    }

    public static void checkForBidAlerts (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection checkBidAlertConnection = database.newConnection();

            // Check if there is a second bidder
            String secondBidder = getSecondBidder(productID);
            if (secondBidder == null) return;

            // Get the auto bidder of the second user
            PreparedStatement checkBidAlertStatement = checkBidAlertConnection.prepareStatement(
                    "select max_bid, bid_increment from auto_bidder where product_id = ? and username = ?;");
            checkBidAlertStatement.setInt(1, productID);
            checkBidAlertStatement.setString(2, secondBidder);
            ResultSet resultSet = checkBidAlertStatement.executeQuery();

            // Query to get the price of the product
            PreparedStatement priceStatement = checkBidAlertConnection.prepareStatement(
                    "SELECT COALESCE(\n" +
                            "    (SELECT bid_amount FROM bid WHERE product_id = ? ORDER BY bid_amount DESC LIMIT 1),\n" +
                            "    (SELECT initial_price FROM listing WHERE product_id = ?)\n" +
                            ") AS price;");
            priceStatement.setInt(1, productID);
            priceStatement.setInt(2, productID);
            ResultSet priceResultSet = priceStatement.executeQuery();
            priceResultSet.next();
            double price = priceResultSet.getDouble("price");

            // Check if there is an auto bidder setup
            if (resultSet.next()) {
                // Check if the auto bidder has been beat
                double bidAmount = price + resultSet.getDouble("bid_increment");
                if (!(bidAmount <= resultSet.getDouble("max_bid"))) {
                    // Second alert
                    postAlert(secondBidder, LocalDateTime.now(),
                            "Your auto bidder on Product #" + productID + ", \"" + getProductName(productID) + "\", has been outbid.");
                }
            } else {
                // No auto bidder, manual bid beat
                postAlert(secondBidder, LocalDateTime.now(),
                        "Your manual bid on Product #" + productID + ", \"" + getProductName(productID) + "\", has been outbid.");
            }

            //Close connection
            resultSet.close();
            priceResultSet.close();
            priceStatement.close();
            checkBidAlertStatement.close();
            checkBidAlertConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error checking for bid alerts...");
                e.printStackTrace();
            }
        }
    }

    public static String getSecondBidder (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection secondBidderConnection = database.newConnection();

            // Get the second bidder on the given product id
            PreparedStatement preparedStatement = secondBidderConnection.prepareStatement(
                    "select username from bid where product_id = ? order by bid_amount desc limit 1,1;");
            preparedStatement.setInt(1, productID);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if there is a user or not
            String username = null;
            if (resultSet.next()) {
                username = resultSet.getString("username");
            }

            //Close connection
            resultSet.close();
            preparedStatement.close();
            secondBidderConnection.close();

            return username;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting second bidder...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static String getProductName (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection productNameConnection = database.newConnection();

            // Get the second bidder on the given product id
            PreparedStatement preparedStatement = productNameConnection.prepareStatement(
                    "select product_name from listing where product_id = ?;");
            preparedStatement.setInt(1, productID);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if there is a user or not
            resultSet.next();
            String productName = resultSet.getString("product_name");

            //Close connection
            resultSet.close();
            preparedStatement.close();
            productNameConnection.close();

            return productName;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting product name...");
                e.printStackTrace();
            }
        }

        return null;
    }
}
