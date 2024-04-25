package com.buyme.controller;

import com.buyme.database.MyDatabase;
import java.sql.*;

public class PostListingController {
    private PostListingController() {}

    public static boolean attemptPost(String productName, String productDescription, String subcategory, double initialPrice, double minSellPrice, double minBidIncrement, Timestamp listingCloseTime) {
        try {
            // Create connection
            MyDatabase database = new MyDatabase();
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
            preparedStatement.setTimestamp(7, listingCloseTime);
            preparedStatement.executeUpdate();

            // User exists, log them in
            if (MyDatabase.debug) System.out.println("Posted a Listing...");
            return true;
        } catch (SQLException e) {
            if (MyDatabase.debug) {
                System.out.println("Error posting...");
                e.printStackTrace();
            }
        }

        return false;
    }
}
