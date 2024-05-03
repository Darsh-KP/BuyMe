package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

public class participationHistoryController {
    private participationHistoryController() {}

    public static List<HashMap<String, String>> getParticipationHistory(String username) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection participationHistoryController = database.newConnection();

            // Get all participation
            PreparedStatement statement = participationHistoryController.prepareStatement(
                    "select * from (" +
                        "select 'seller' AS participation_as, product_id, product_name, post_date_time as action_date_time\n" +
                        "from listing where seller_username = ?\n" +
                        "union\n" +
                        "select 'buyer' AS participation_as, product_id, product_name, bid_date_time as action_date_time\n" +
                        "from bid join listing using(product_id) where username = ?" +
                        ") as subquery order by action_date_time desc;"
            );
            statement.setString(1, username);
            statement.setString(2, username);
            ResultSet resultSet = statement.executeQuery();

            // Store the results
            ArrayList<HashMap<String, String>> participationHistoryDisplay = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Store each value
                HashMap<String, String> participation = new HashMap<String, String>();
                participation.put("participationAs", resultSet.getString("participation_as"));
                participation.put("productId", String.valueOf(resultSet.getInt("product_id")));
                participation.put("productName", resultSet.getString("product_name"));

                // Date formatter
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                participation.put("actionDateTime", resultSet.getTimestamp("action_date_time").toLocalDateTime().format(formatter));

                // Add listing to arraylist
                participationHistoryDisplay.add(participation);
            }

            //Close connection
            resultSet.close();
            statement.close();
            participationHistoryController.close();

            // Return the strings to display
            return participationHistoryDisplay;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all listings...");
                e.printStackTrace();
            }
        }

        return null;
    }
}
