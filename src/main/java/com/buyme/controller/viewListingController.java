package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class viewListingController {
    private viewListingController() {}

    public static HashMap<String, String> getCardinfo(String productID) {
        try {
        	int prod_id = Integer.parseInt(productID);
            // Create connection
            myDatabase database = new myDatabase();
            Connection cardConnection = database.newConnection();
            
            PreparedStatement statement = cardConnection.prepareStatement(
            		"SELECT product_id, product_name, initial_price, subcategory, description, post_date_time, close_date_time, min_sell_price, min_bid_increment, seller_username FROM listing WHERE product_id = ?");
            		statement.setInt(1, prod_id);
            ResultSet resultSet = statement.executeQuery();
            
            
            HashMap<String, String> cardInfo = new HashMap<String, String>();
            
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> listing = new HashMap<String, String>();
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
                cardInfo.put("postDate", String.valueOf(resultSet.getDate("post_date_time")));
                cardInfo.put("closeDate", String.valueOf(resultSet.getTimestamp("close_date_time")));
                // Format Status
                cardInfo.put("statusDisplay", "Status: " + listingsController.getProductStatus((productHighestBid != null),
                        resultSet.getTimestamp("post_date_time").toLocalDateTime(),
                        resultSet.getTimestamp("close_date_time").toLocalDateTime()));
                
                cardInfo.put("min_sell_price", resultSet.getString("min_sell_price"));
                cardInfo.put("min_bid_increment", resultSet.getString("min_bid_increment"));
                cardInfo.put("seller_username", resultSet.getString("seller_username"));
                
                

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
}
