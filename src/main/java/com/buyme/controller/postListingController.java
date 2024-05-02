package com.buyme.controller;
import com.buyme.database.myDatabase;

import java.io.InputStream;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

public class postListingController {
    private postListingController() {}

    public static boolean attemptPost(String productName, String productDescription, String subcategory,
                                      double initialPrice, double minSellPrice, double minBidIncrement,
                                      LocalDateTime listingCloseDateTime, LocalDateTime listingPostDateTime,
                                      String sellerUsername, InputStream imageBinary, LocalDateTime listingStartDateTime,
                                      HashMap<String, String> listingAttributes, String imageMime) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection postConnection = database.newConnection();

            // Insert posting into database
            PreparedStatement preparedStatement = postConnection.prepareStatement(
            		"INSERT INTO listing (product_name, description, subcategory, initial_price, " +
                            "min_sell_price, min_bid_increment, close_date_time, post_date_time, seller_username, " +
                            "image_data, start_date_time, image_mime) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS);
            preparedStatement.setString(1, productName);
            preparedStatement.setString(2, productDescription);
            preparedStatement.setString(3, subcategory);
            preparedStatement.setDouble(4, initialPrice);
            preparedStatement.setDouble(5, minSellPrice);
            preparedStatement.setDouble(6, minBidIncrement);
            preparedStatement.setTimestamp(7, Timestamp.valueOf(listingCloseDateTime));
            preparedStatement.setTimestamp(8, Timestamp.valueOf(listingPostDateTime));
            preparedStatement.setString(9, sellerUsername);
            preparedStatement.setBlob(10, imageBinary);
            preparedStatement.setTimestamp(11, Timestamp.valueOf(listingStartDateTime));
            preparedStatement.setString(12, imageMime);
            preparedStatement.executeUpdate();

            // Retrieve the auto-generated ID
            ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
            generatedKeys.next();
            int generatedId = generatedKeys.getInt(1);

            // Process attributes
            PreparedStatement preparedStatementAttributes = postConnection.prepareStatement(
                    "INSERT INTO product_attribute (product_id, attribute_key, attribute_value) VALUES (?, ?, ?);"
            );
            for (Map.Entry<String, String> entry : listingAttributes.entrySet()) {
                preparedStatementAttributes.setInt(1, generatedId);
                preparedStatementAttributes.setString(2, entry.getKey());
                preparedStatementAttributes.setString(3, entry.getValue());
                preparedStatementAttributes.executeUpdate();
            }

            // Close connections
            preparedStatement.close();
            preparedStatementAttributes.close();
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
    
    public static List<String> getAllSubCategories() {
        List<String> subCategories = new ArrayList<String>();
    	try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection postConnection = database.newConnection();
            
            PreparedStatement preparedStatement = postConnection.prepareStatement(
            		"Select property_value from properties where property_key LIKE 'sub_category%'");
            ResultSet resultSet = preparedStatement.executeQuery();
            

            boolean hasResults = false;
            while (resultSet.next()) {
                hasResults = true;
                String subCategory = resultSet.getString("property_value");
                subCategories.add(subCategory);
                if (myDatabase.debug) System.out.println("Pulling subcategory name: " + subCategory);
            }

            if (!hasResults && myDatabase.debug) {
                System.out.println("No subcategories found.");
            }
            
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error pulling subcategory names...");
                e.printStackTrace();
            }
        }
        return subCategories;
    }

    public static HashMap<String, ArrayList<String>> getDefaultAttributes() {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection listingsConnection = database.newConnection();

            // Get all attributes
            Statement statement = listingsConnection.createStatement();
            ResultSet resultSet = statement.executeQuery("select * from properties WHERE property_key like 'attribute%' order by property_key");

            // Store the results
            HashMap<String, ArrayList<String>> defaultAttributes = new HashMap<String, ArrayList<String>>();
            String mostRecentKey = "";
            while (resultSet.next()) {
                // If key then add the key to hashmap
                if (resultSet.getString("property_key").contains("key")) {
                    defaultAttributes.put(resultSet.getString("property_value"), null);
                    mostRecentKey = resultSet.getString("property_value");
                    continue;
                }

                // Otherwise, it is a value
                // Check if arraylist is already created
                if(defaultAttributes.get(mostRecentKey) == null) {
                    defaultAttributes.put(mostRecentKey,new ArrayList<String>());
                }
                defaultAttributes.get(mostRecentKey).add(resultSet.getString("property_value"));
            }

            //Close connection
            resultSet.close();
            statement.close();
            listingsConnection.close();

            // Return the strings to display
            return defaultAttributes;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return null;
    }
}
