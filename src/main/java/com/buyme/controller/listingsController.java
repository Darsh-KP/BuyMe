package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
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
            ResultSet resultSet = statement.executeQuery("select product_id, product_name, initial_price, " +
                    "start_date_time, close_date_time, image_data, image_mime from listing");

            // Store the results
            ArrayList<HashMap<String, String>> listingsDisplay = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> listing = new HashMap<String, String>();
                listing.put("productId", String.valueOf(resultSet.getInt("product_id")));
                listing.put("productName", resultSet.getString("product_name"));

                // Get image to display
                Blob imageData = resultSet.getBlob("image_data");
                byte[] byteArray = imageData.getBytes(1, (int) imageData.length());
                String imageDataString = Base64.getEncoder().encodeToString(byteArray);
                listing.put("imageDataString", imageDataString);

                // Attach image MIME data
                listing.put("imageMime", resultSet.getString("image_mime"));

                // Format Pricing
                String productHighestBid = getProductHighestBid(resultSet.getInt("product_id"));
                String productPriceDisplay = (productHighestBid == null) ?
                        "Initial Price: $" + resultSet.getDouble("initial_price") :
                        "Current Bid: $" + productHighestBid;
                listing.put("priceDisplay", productPriceDisplay);

                // Format Date
                listing.put("dateDisplay", getProductTimeDisplay(resultSet.getTimestamp("start_date_time").toLocalDateTime(),
                        resultSet.getTimestamp("close_date_time").toLocalDateTime()));

                // Format Status
                listing.put("statusDisplay", "Status: " + getProductStatus((productHighestBid != null),
                        resultSet.getTimestamp("start_date_time").toLocalDateTime(),
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
        // Query the bids table to find this info

        // If not, return null for no bids
        return null;
    }

    public static String getProductTimeDisplay (LocalDateTime productStateDateTime, LocalDateTime productEndDateTime) {
        // Get current DateTime
        LocalDateTime currentDateTime = LocalDateTime.now();

        // Date formatter
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");

        // If not started, starts on...
        if (currentDateTime.isBefore(productStateDateTime)) return "Starts on: " + productStateDateTime.format(formatter);

        // If ended already, ended on...
        if (currentDateTime.isAfter(productEndDateTime)) return "Ended on: " + productEndDateTime.format(formatter);

        // Else, ongoing
        return "Ends on: " + productEndDateTime.format(formatter);
    }

    public static String getProductStatus (boolean isBiddedOn, LocalDateTime productStartDateTime, LocalDateTime productEndDateTime) {
        // Get current DateTime
        LocalDateTime currentDateTime = LocalDateTime.now();

        // If start date is not reached, status = upcoming
        if (currentDateTime.isBefore(productStartDateTime)) return "Upcoming";

        // If product has no bids placed, status = new
        if (!isBiddedOn && currentDateTime.isBefore(productEndDateTime)) return "New";

        // If product has bids placed and end date has not yet been passed, status = open
        if (isBiddedOn && currentDateTime.isBefore(productEndDateTime)) return "Bidded On";

        // If product has passed end date and no bids, status = expired
        if (!isBiddedOn && currentDateTime.isAfter(productStartDateTime)) return "Expired";

        // If product has passed end date with bids, status = sold
        if (isBiddedOn && currentDateTime.isAfter(productEndDateTime)) return "Sold";

        return null;
    }
}
