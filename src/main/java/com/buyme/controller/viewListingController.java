package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

public class viewListingController {
    private viewListingController() {}

    public static HashMap<String, String> getCardInfo(String productID) {
        try {
        	int prod_id = Integer.parseInt(productID);
            // Create connection
            myDatabase database = new myDatabase();
            Connection cardConnection = database.newConnection();
            
            PreparedStatement statement = cardConnection.prepareStatement(
            		"SELECT product_id, product_name, initial_price, subcategory, description, start_date_time, close_date_time, min_sell_price, min_bid_increment, seller_username, image_data, image_mime FROM listing WHERE product_id = ?");
            		statement.setInt(1, prod_id);
            ResultSet resultSet = statement.executeQuery();

            HashMap<String, String> cardInfo = new HashMap<String, String>();
            
            while (resultSet.next()) {
                // Get each listing
                cardInfo.put("productId", String.valueOf(resultSet.getInt("product_id")));
                cardInfo.put("productName", resultSet.getString("product_name"));
                cardInfo.put("subcategory", resultSet.getString("subcategory"));
                cardInfo.put("description", resultSet.getString("description"));
                
                String productHighestBid = listingsController.getProductHighestBid(resultSet.getInt("product_id"));
                String productPriceDisplay = (productHighestBid == null) ?
                        "Initial Price: $" + resultSet.getDouble("initial_price") :
                        "Current Bid: $" + productHighestBid;
                cardInfo.put("price", productPriceDisplay);

                // Format Date
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                cardInfo.put("startDate", resultSet.getTimestamp("start_date_time").toLocalDateTime().format(formatter));
                cardInfo.put("closeDate", resultSet.getTimestamp("close_date_time").toLocalDateTime().format(formatter));

                // Format Status
                cardInfo.put("statusDisplay", "Status: " + listingsController.getProductStatus((productHighestBid != null),
                        resultSet.getTimestamp("start_date_time").toLocalDateTime(),
                        resultSet.getTimestamp("close_date_time").toLocalDateTime(),
                        listingsController.productHasWinner(prod_id)));
                
                cardInfo.put("min_sell_price", resultSet.getString("min_sell_price"));
                cardInfo.put("min_bid_increment", resultSet.getString("min_bid_increment"));
                cardInfo.put("seller_username", resultSet.getString("seller_username"));

                // Get image to display
                Blob imageData = resultSet.getBlob("image_data");
                byte[] byteArray = imageData.getBytes(1, (int) imageData.length());
                String imageDataString = Base64.getEncoder().encodeToString(byteArray);
                cardInfo.put("imageDataString", imageDataString);

                // Attach image MIME data
                cardInfo.put("imageMime", resultSet.getString("image_mime"));
            }

            //Close connection
            resultSet.close();
            statement.close();
            cardConnection.close();

            // Return the strings to display
            return cardInfo;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting card info...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static List<HashMap<String, String>> getProductAttributes(String productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection attributesConnection = database.newConnection();

            // Get all listings
            PreparedStatement statement = attributesConnection.prepareStatement(
                    "SELECT attribute_key, attribute_value FROM product_attribute WHERE product_id = ?");
            statement.setInt(1, Integer.parseInt(productID));
            ResultSet resultSet = statement.executeQuery();

            // Store the results
            List<HashMap<String, String>> allAttributes = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                HashMap<String, String> attribute = new HashMap<String, String>();
                // Get each attributes
                attribute.put("attributeKey", String.valueOf(resultSet.getString("attribute_key")));
                attribute.put("attributeValue", String.valueOf(resultSet.getString("attribute_value")));

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
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static List<String> getHistoryOfBids(int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection connection = database.newConnection();

            // Get all bids for the product
            PreparedStatement statement = connection.prepareStatement(
                    "select username, bid_amount, is_anonymous, bid_date_time from bid " +
                            "where product_id = ? order by bid_amount desc");
            statement.setInt(1, productID);
            ResultSet resultSet = statement.executeQuery();

            // Process the display strings for history of bids
            List<String> historyList = new ArrayList<String>();
            while (resultSet.next()) {
                // Process the username for anonymous
                boolean isAnonymous = resultSet.getBoolean("is_anonymous");
                String username = resultSet.getString("username");
                username = (isAnonymous ? maskUsername(username) : username);

                // Process date & time to display
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                String bidDateTime = resultSet.getTimestamp("bid_date_time").toLocalDateTime().format(formatter);

                // Format bid amount
                String bidAmount = "$" + resultSet.getString("bid_amount");

                // Add to the list
                historyList.add(username + " - " + bidDateTime + " - " + bidAmount);
            }

            //Close connection
            resultSet.close();
            statement.close();
            connection.close();

            // Return the strings to display
            return historyList;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static String maskUsername(String username) {
        char firstChar = username.charAt(0);
        char lastChar = username.charAt(username.length() - 1);

        return firstChar + "***" + lastChar;
    }

    public static List<HashMap<String, String>> getSimilarListings(String productID, String subCategory, List<String> attributeValues) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection similarItemsConnection = database.newConnection();

            // Create temporary table to get rank similar items
            StringBuilder tempTableQuery = new StringBuilder("create temporary table ranked_similar\n" +
                    "select * from listing join product_attribute using (product_id) \n" +
                    "order by case when subcategory = \"" + subCategory + "\" then 0 else 1 end");
            for (String attributeValue: attributeValues) {
                tempTableQuery.append(",\ncase when attribute_value = \"").append(attributeValue).append("\" then 0 else 1 end");
            }
            tempTableQuery.append(";");
            Statement tempTableStatement = similarItemsConnection.createStatement();
            tempTableStatement.execute(tempTableQuery.toString());

            // Get top 5 similar items
            PreparedStatement topFiveStatement = similarItemsConnection.prepareStatement(
                    "select distinct product_id, product_name, initial_price, image_data, image_mime from ranked_similar " +
                            "where product_id <> ? and close_date_time >= NOW() limit 5;");
            topFiveStatement.setString(1, productID);
            ResultSet resultSet = topFiveStatement.executeQuery();

            // Store the results
            ArrayList<HashMap<String, String>> similarListingsDisplay = new ArrayList<HashMap<String, String>>();
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
                String productHighestBid = listingsController.getProductHighestBid(resultSet.getInt("product_id"));
                String productPriceDisplay = (productHighestBid == null) ?
                        "Initial Price: $" + resultSet.getDouble("initial_price") :
                        "Current Bid: $" + productHighestBid;
                listing.put("priceDisplay", productPriceDisplay);

                // Add listing to arraylist
                similarListingsDisplay.add(listing);
            }

            // Drop the temporary table
            Statement dropStatement = similarItemsConnection.createStatement();
            dropStatement.execute("drop table ranked_similar;");

            //Close connection
            resultSet.close();
            tempTableStatement.close();
            topFiveStatement.close();
            dropStatement.close();
            similarItemsConnection.close();

            // Return the strings to display
            return similarListingsDisplay;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting similar items...");
                e.printStackTrace();
            }
        }

        return null;
    }
}
