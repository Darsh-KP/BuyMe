package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

public class listingsController {
    private listingsController () {}

    public static List<HashMap<String, String>> getAllListingsDisplayStrings (String criteria) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection listingsConnection = database.newConnection();

            // Get all listings
            String baseQuery = "select distinct product_id, product_name, initial_price, start_date_time, " +
                    "close_date_time, image_data, image_mime from listing join product_attribute using (product_id) " +
                    "where true ";
            String endQuery = " ;";
            String fullQuery = baseQuery + criteria + endQuery;
            PreparedStatement statement = listingsConnection.prepareStatement(fullQuery);
            ResultSet resultSet = statement.executeQuery();

            // Store the results
            ArrayList<HashMap<String, String>> listingsDisplay = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> listing = new HashMap<String, String>();
                int productID = resultSet.getInt("product_id");
                listing.put("productId", String.valueOf(productID));
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
                        resultSet.getTimestamp("close_date_time").toLocalDateTime(),
                        productHasWinner(productID)));

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
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection highestBidConnection = database.newConnection();

            // Query the bids table to find the highest bid on this product
            PreparedStatement statement = highestBidConnection.prepareStatement(
                    "select bid_amount from bid where product_id = ? order by bid_amount desc limit 1");
            statement.setInt(1, productId);
            ResultSet resultSet = statement.executeQuery();

            // Check if the product has been bid on
            String productHighestBid = null;
            if (resultSet.next()) {
                productHighestBid = String.valueOf(resultSet.getDouble("bid_amount"));
            }

            //Close connection
            resultSet.close();
            statement.close();
            highestBidConnection.close();

            // If not, return null for no bids
            return productHighestBid;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

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

    public static String getProductStatus (boolean isBiddedOn, LocalDateTime productStartDateTime, LocalDateTime productEndDateTime, boolean hasWinner) {
        // Get current DateTime
        LocalDateTime currentDateTime = LocalDateTime.now();

        // If start date is not reached, status = upcoming
        if (currentDateTime.isBefore(productStartDateTime)) return "Upcoming";

        // If product has no bids placed, status = new
        if (!isBiddedOn && currentDateTime.isBefore(productEndDateTime)) return "New";

        // If product has bids placed and end date has not yet been passed, status = open
        if (isBiddedOn && currentDateTime.isBefore(productEndDateTime)) return "Bidded On";

        // If product has passed end date with a winner, status = sold
        if (hasWinner && currentDateTime.isAfter(productEndDateTime)) return "Sold";

        // If product has passed end date and no bids, status = expired
        if (currentDateTime.isAfter(productStartDateTime)) return "Expired";

        return null;
    }

    public static boolean productHasWinner (int productId) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection checkWinnerConnection = database.newConnection();

            // Get the winner of the product
            PreparedStatement checkWinnerStatement = checkWinnerConnection.prepareStatement(
                    "select winner from listing where product_id = ?");
            checkWinnerStatement.setInt(1, productId);
            ResultSet resultSet = checkWinnerStatement.executeQuery();

            // Get the name of winner
            String winner = null;
            if (resultSet.next()) {
                winner = resultSet.getString("winner");
            }

            // Close connection
            resultSet.close();
            checkWinnerStatement.close();
            checkWinnerConnection.close();

            // Check if winner is not null or "N/A"
            if (winner == null) return false;
            return !winner.equals("N/A");
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting product winner boolean...");
                e.printStackTrace();
            }
        }

        return false;
    }
    
    public static boolean removeListing(int productId) {
    	//DELETE FROM listing WHERE product_id = 33;
    	
    	try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection removeListing = database.newConnection();

            // Get the winner of the product
            PreparedStatement statement = removeListing.prepareStatement(
                    "DELETE FROM listing WHERE product_id = ?;");
            statement.setInt(1, productId);
            statement.executeUpdate();

            // Get the name of winner
            // Close connection
            statement.close();
            removeListing.close();



	    } catch (SQLException e) {
	        if (myDatabase.debug) {
	            System.out.println("Error removing Listing...");
	            e.printStackTrace();
	            return false;
	        }
	    }
    	
    	return true;
    	
    }

    public static HashMap<String, ArrayList<String>> getCurrentAttributes() {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection attibutesConnection = database.newConnection();

            // Get all attributes
            Statement statement = attibutesConnection.createStatement();
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
            attibutesConnection.close();

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
