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

            // Check for credentials in the database
            PreparedStatement preparedStatement = postConnection.prepareStatement(
            		"INSERT INTO listing (product_Name, description, subcategory, initialPrice, minSellPrice, minBidIncrement, listingCloseTime) \n"
                    + "VALUES (?, ?, ?, ?, ?, ?);\n"
                    + "");
            preparedStatement.setString(1, productName);
            preparedStatement.setString(2, productDescription);
            preparedStatement.setString(3, subcategory);
            preparedStatement.setDouble(4, initialPrice);
            preparedStatement.setDouble(5, minSellPrice);
            preparedStatement.setDouble(6, minBidIncrement);
            preparedStatement.executeUpdate();

            // User exists, log them in
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
