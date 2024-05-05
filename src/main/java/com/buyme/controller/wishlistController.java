package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

public class wishlistController {
    private wishlistController() {}
    
    public static boolean postWishlist(String username, LocalDateTime date, String subcategory, double maxThreshold, 
                                       HashMap<String, String> wishlistAttributes) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection wishlistConnection = database.newConnection();

            // Insert posting into database
            PreparedStatement preparedStatement = wishlistConnection.prepareStatement(
            		"INSERT INTO wishlist (username, date, subcategory, price_threshold)" +
                            "VALUES (?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, username);
            preparedStatement.setTimestamp(2, Timestamp.valueOf(date));
            preparedStatement.setString(3, subcategory);
            preparedStatement.setDouble(4, maxThreshold);
            preparedStatement.executeUpdate();


            // Process attributes
            PreparedStatement preparedStatementAttributes = wishlistConnection.prepareStatement(
                    "INSERT INTO wishlist_attribute (username, date, wishlist_attribute_key, wishlist_attribute_values) VALUES (?, ?, ?, ?);"
            );
            for (Map.Entry<String, String> entry : wishlistAttributes.entrySet()) {
                preparedStatementAttributes.setString(1, username);
                preparedStatement.setTimestamp(2, Timestamp.valueOf(date));
                preparedStatementAttributes.setString(3, entry.getKey());
                preparedStatementAttributes.setString(4, entry.getValue());
                preparedStatementAttributes.executeUpdate();
            }

            // Close connections
            preparedStatement.close();
            preparedStatementAttributes.close();
            wishlistConnection.close();

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