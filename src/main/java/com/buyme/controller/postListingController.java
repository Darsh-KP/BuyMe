package com.buyme.controller;

import com.buyme.database.myDatabase;
import java.sql.*;
import java.time.LocalDateTime;

public class postListingController {
    private postListingController() {}

    public static boolean attemptPost(String productName, String productDescription, String subcategory,
                                      double initialPrice, double minSellPrice, double minBidIncrement,
                                      LocalDateTime listingCloseDateTime, LocalDateTime listingPostDateTime, String sellerUsername) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection postConnection = database.newConnection();

            // Insert posting into database
            PreparedStatement preparedStatement = postConnection.prepareStatement(
            		"INSERT INTO listing (product_nanme, description, subcategory, initial_price, " +
                            "min_sell_price, min_bid_increment, close_date_time, post_date_time, seller_username) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);");
            preparedStatement.setString(1, productName);
            preparedStatement.setString(2, productDescription);
            preparedStatement.setString(3, subcategory);
            preparedStatement.setDouble(4, initialPrice);
            preparedStatement.setDouble(5, minSellPrice);
            preparedStatement.setDouble(6, minBidIncrement);
            preparedStatement.setTimestamp(7, Timestamp.valueOf(listingCloseDateTime));
            preparedStatement.setTimestamp(8, Timestamp.valueOf(listingPostDateTime));
            preparedStatement.setString(9, sellerUsername);
            preparedStatement.executeUpdate();

            // Close connections
            preparedStatement.close();
            postConnection.close();

            // Success
            if (myDatabase.debug) System.out.println("Posted a Listing...");
            return true;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting...");
                e.printStackTrace();
            }
        }

        return false;
    }
}
