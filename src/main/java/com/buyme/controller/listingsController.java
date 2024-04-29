package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class listingsController {
    private listingsController () {}

    public static List<HashMap<String, String>> getAllListingsDisplayStrings () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection listingsConnection = database.newConnection();

            // Get all listings
            Statement statement = listingsConnection.createStatement();
            ResultSet resultSet = statement.executeQuery("select product_id, product_name, initial_price, post_date_time, close_date_time from listing");

            // Store the results
            ArrayList<HashMap<String, String>> listingsDisplay = new ArrayList<>();
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> listing = new HashMap<>();
                listing.put("productId", String.valueOf(resultSet.getInt("product_id")));
                listing.put("productName", resultSet.getString("product_name"));

                // Format Pricing
                String productHighestBid = getProductHighestBid(resultSet.getInt("product_id"));
                String productPriceDisplay = (productHighestBid == null) ?
                        "Initial Price: " + resultSet.getDouble("initial_price") :
                        "Current Bid: " + productHighestBid;
                listing.put("priceDisplay", productPriceDisplay);

                // Format Status
                listing.put("statusDisplay", getProductStatus((productHighestBid != null),
                        resultSet.getTimestamp("post_date_time").toLocalDateTime(),
                        resultSet.getTimestamp("close_date_time").toLocalDateTime()));

                // Add listing to arraylist
                listingsDisplay.add(listing);
            }

            //Close connection
            resultSet.close();
            statement.close();
            listingsConnection.close();

            // Return the strings to display
            return listingsDisplay;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static String getProductHighestBid (int productId) {
        // Check if the product has been bid on

        // If not, return null for no bids
        return null;
    }

    public static String getProductStatus (boolean isBiddedOn, LocalDateTime productStartDateTime, LocalDateTime productEndDateTime) {
        // Get current DateTime
        LocalDateTime currentDateTime = LocalDateTime.now();

        // If start date is not reached, status = upcoming
        
        // If product has no bids placed, status = new

        // If product has bids placed and end date has not yet been passed, status = open

        // If product has passed end date and no bids, status = expired

        // If product has passed end date with bids, status = sold

        return null;
    }
}
