package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
                    "INSERT INTO wishlist_attribute (username, date, wishlist_attribute_key, wishlist_attribute_value) VALUES (?, ?, ?, ?);"
            );
            for (Map.Entry<String, String> entry : wishlistAttributes.entrySet()) {
                preparedStatementAttributes.setString(1, username);
                preparedStatementAttributes.setTimestamp(2, Timestamp.valueOf(date));
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
    
    public static List<HashMap<String, String>> getWishlist(String username) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection attributesConnection = database.newConnection();

            // Get all listings
            PreparedStatement statement = attributesConnection.prepareStatement(
                    "SELECT date, subcategory, price_threshold FROM wishlist WHERE username = ?");
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
            
            
            // Store the results
            List<HashMap<String, String>> allAttributes = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                HashMap<String, String> attribute = new HashMap<String, String>();
                attribute.put("date", resultSet.getTimestamp("date").toLocalDateTime().format(formatter));
                attribute.put("rawDate", resultSet.getTimestamp("date").toString());
                attribute.put("subcategory", resultSet.getString("subcategory"));
                attribute.put("price_threshold", resultSet.getString("price_threshold"));

                // Add to list
                allAttributes.add(attribute);
            }

            //Close connection
            resultSet.close();
            statement.close();
            attributesConnection.close();

            // Return the strings to display
            return allAttributes;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all attributes...");
                e.printStackTrace();
            }
        }

        return null;
    }

    
    
    public static List<HashMap<String, String>> getWishlistAttributes(String username, LocalDateTime date) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection attributesConnection = database.newConnection();

            // Get all listings
            PreparedStatement statement = attributesConnection.prepareStatement(
                    "SELECT wishlist_attribute_key, wishlist_attribute_value FROM wishlist_attribute WHERE username = ? and date = ");
            statement.setString(1, username);
            statement.setTimestamp(2, Timestamp.valueOf(date));
            ResultSet resultSet = statement.executeQuery();

            // Store the results
            List<HashMap<String, String>> allAttributes = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                HashMap<String, String> attribute = new HashMap<String, String>();
                // Get each attributes
                attribute.put("attributeKey", String.valueOf(resultSet.getString("wishlist_attribute_key")));
                attribute.put("attributeValue", String.valueOf(resultSet.getString("wishlist_attribute_value")));

                // Add to list
                allAttributes.add(attribute);
            }

            //Close connection
            resultSet.close();
            statement.close();
            attributesConnection.close();

            // Return the strings to display
            return allAttributes;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all attributes...");
                e.printStackTrace();
            }
        }

        return null;
    }


}