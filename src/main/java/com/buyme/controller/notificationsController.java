package com.buyme.controller;

import com.buyme.database.myDatabase;
import com.buyme.database.passwordSecurity;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class notificationsController {
    private notificationsController () {}

    public static List<HashMap<String, String>> getUserNotifications (String username) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection userNotificationsConnection = database.newConnection();

            // Get the notifications
            PreparedStatement userNotificationsStatement = userNotificationsConnection.prepareStatement(
                    "select created_at, message from notification where username = ? order by created_at desc;");
            userNotificationsStatement.setString(1, username);
            ResultSet resultSet = userNotificationsStatement.executeQuery();

            // Put all the notifications in the list
            ArrayList<HashMap<String, String>> notificationsList = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Date formatter
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");

                // Get each notification
                HashMap<String, String> notification = new HashMap<String, String>();
                notification.put("dateTime", resultSet.getTimestamp("created_at").toLocalDateTime().format(formatter));
                notification.put("message", resultSet.getString("message"));

                // Add to the list
                notificationsList.add(notification);
            }

            // Close connections
            resultSet.close();
            userNotificationsStatement.close();
            userNotificationsConnection.close();

            return notificationsList;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting user notifications...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static void postAlert (String username, LocalDateTime createdAt, String message) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection alertConnection = database.newConnection();

            // Insert notification in the db
            PreparedStatement preparedStatement = alertConnection.prepareStatement(
                    "INSERT INTO notification (username, created_at, message) VALUES (?, ?, ?);");
            preparedStatement.setString(1, username);
            preparedStatement.setTimestamp(2, Timestamp.valueOf(createdAt));
            preparedStatement.setString(3, message);
            preparedStatement.executeUpdate();

            //Close connection
            preparedStatement.close();
            alertConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting alert...");
                e.printStackTrace();
            }
        }
    }

    public static void checkForBidAlerts (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection checkBidAlertConnection = database.newConnection();

            // Check if there is a second bidder
            String secondBidder = getSecondBidder(productID);
            if (secondBidder == null) return;

            // Get the auto bidder of the second user
            PreparedStatement checkBidAlertStatement = checkBidAlertConnection.prepareStatement(
                    "select max_bid, bid_increment from auto_bidder where product_id = ? and username = ?;");
            checkBidAlertStatement.setInt(1, productID);
            checkBidAlertStatement.setString(2, secondBidder);
            ResultSet resultSet = checkBidAlertStatement.executeQuery();

            // Query to get the price of the product
            PreparedStatement priceStatement = checkBidAlertConnection.prepareStatement(
                    "SELECT COALESCE(\n" +
                            "    (SELECT bid_amount FROM bid WHERE product_id = ? ORDER BY bid_amount DESC LIMIT 1),\n" +
                            "    (SELECT initial_price FROM listing WHERE product_id = ?)\n" +
                            ") AS price;");
            priceStatement.setInt(1, productID);
            priceStatement.setInt(2, productID);
            ResultSet priceResultSet = priceStatement.executeQuery();
            priceResultSet.next();
            double price = priceResultSet.getDouble("price");

            // Check if there is an auto bidder setup
            if (resultSet.next()) {
                // Check if the auto bidder has been beat
                double bidAmount = price + resultSet.getDouble("bid_increment");
                if (!(bidAmount <= resultSet.getDouble("max_bid"))) {
                    // Second alert
                    postAlert(secondBidder, LocalDateTime.now(),
                            "Your auto bidder on Product #" + productID + ", \"" + getProductName(productID) + "\", has been outbid.");
                }
            } else {
                // No auto bidder, manual bid beat
                postAlert(secondBidder, LocalDateTime.now(),
                        "Your manual bid on Product #" + productID + ", \"" + getProductName(productID) + "\", has been outbid.");
            }

            //Close connection
            resultSet.close();
            priceResultSet.close();
            priceStatement.close();
            checkBidAlertStatement.close();
            checkBidAlertConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error checking for bid alerts...");
                e.printStackTrace();
            }
        }
    }

    public static String getSecondBidder (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection secondBidderConnection = database.newConnection();

            // Get the second bidder on the given product id
            PreparedStatement preparedStatement = secondBidderConnection.prepareStatement(
                    "select username from bid where product_id = ? order by bid_amount desc limit 1,1;");
            preparedStatement.setInt(1, productID);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if there is a user or not
            String username = null;
            if (resultSet.next()) {
                username = resultSet.getString("username");
            }

            //Close connection
            resultSet.close();
            preparedStatement.close();
            secondBidderConnection.close();

            return username;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting second bidder...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static String getProductName (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection productNameConnection = database.newConnection();

            // Get the second bidder on the given product id
            PreparedStatement preparedStatement = productNameConnection.prepareStatement(
                    "select product_name from listing where product_id = ?;");
            preparedStatement.setInt(1, productID);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if there is a user or not
            resultSet.next();
            String productName = resultSet.getString("product_name");

            //Close connection
            resultSet.close();
            preparedStatement.close();
            productNameConnection.close();

            return productName;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting product name...");
                e.printStackTrace();
            }
        }

        return null;
    }

    public static void checkListingWinners () {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection checkWinnersConnection = database.newConnection();

            // Get the listings that are expired and has no winner declared yet
            PreparedStatement checkWinnersStatement = checkWinnersConnection.prepareStatement(
                    "select product_id from listing where close_date_time < ? and winner is null;");
            checkWinnersStatement.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            ResultSet checkWinnersResultSet = checkWinnersStatement.executeQuery();

            // Go through each listing
            while (checkWinnersResultSet.next()) {
                // Get productID
                int productID = checkWinnersResultSet.getInt("product_id");

                // Check if listing was bid on
                if (listingsController.getProductHighestBid(productID) == null) {
                    // No winner
                    postWinner(productID, "N/A");
                    continue;
                }

                // Get the last bidder who beat the min sell price
                PreparedStatement getWinnerStatement = checkWinnersConnection.prepareStatement(
                        "select username, close_date_time from listing join bid using (product_id) " +
                                "where product_id = ? and bid_amount > min_sell_price order by bid_amount desc limit 1;");
                getWinnerStatement.setInt(1, productID);
                ResultSet getWinnerResultSet = getWinnerStatement.executeQuery();

                // There is a winner!
                if (getWinnerResultSet.next()) {
                    String winner = getWinnerResultSet.getString("username");
                    postWinner(productID, winner);
                    postAlert(winner, getWinnerResultSet.getTimestamp("close_date_time").toLocalDateTime(),
                            "Congratulations! You have won the bid on Product #" + productID + ", \"" + getProductName(productID) + "\".");
                } else {
                    // No winner
                    postWinner(productID, "N/A");
                }

                // Close temp connections
                getWinnerResultSet.close();
                getWinnerStatement.close();
            }

            // Close connections
            checkWinnersResultSet.close();
            checkWinnersStatement.close();
            checkWinnersConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error checking for winners...");
                e.printStackTrace();
            }
        }
    }

    public static void postWinner (int Product, String winner) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection postWinnersConnection = database.newConnection();

            // Post the winner to the listing
            PreparedStatement postWinnersStatement = postWinnersConnection.prepareStatement(
                    "update listing set winner = ? where product_id = ?;");
            postWinnersStatement.setString(1, winner);
            postWinnersStatement.setInt(2, Product);
            postWinnersStatement.executeUpdate();

            // Close connection
            postWinnersStatement.close();
            postWinnersConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting winner...");
                e.printStackTrace();
            }
        }
    }

    public static void checkWishlistAlerts (int productID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection wishlistAlertConnection = database.newConnection();

            // Get the users with fulfilled wishlist
            PreparedStatement statement = wishlistAlertConnection.prepareStatement(
                    "SELECT DISTINCT u.username\n" +
                            "FROM user u\n" +
                            "JOIN wishlist w ON u.username = w.username\n" +
                            "JOIN listing l ON w.subcategory = l.subcategory\n" +
                            "JOIN product_attribute pa ON l.product_id = pa.product_id\n" +
                            "WHERE w.price_threshold > l.initial_price\n" +
                            "AND l.product_id = ?\n" +
                            "AND NOT EXISTS (\n" +
                            "    SELECT 1\n" +
                            "    FROM wishlist_attribute wa\n" +
                            "    WHERE wa.username = w.username\n" +
                            "    AND wa.date = w.date\n" +
                            "    AND NOT EXISTS (\n" +
                            "        SELECT 1\n" +
                            "        FROM product_attribute pa2\n" +
                            "        WHERE pa2.product_id = l.product_id\n" +
                            "        AND pa2.attribute_key = wa.wishlist_attribute_key\n" +
                            "        AND pa2.attribute_value = wa.wishlist_attribute_value\n" +
                            "    )\n" +
                            ");"
            );
            statement.setInt(1, productID);
            ResultSet resultSet = statement.executeQuery();

            // Alert the users about the new listing
            while (resultSet.next()) {
                // Post alert
                postAlert(resultSet.getString("username"), LocalDateTime.now(),
                        "A product from your wishlist just got posted: #" + productID + ", \"" + getProductName(productID) + "\".");
                System.out.println("Posted a wishlist alert...");
            }

            // Close connection
            wishlistAlertConnection.close();
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error posting winner...");
                e.printStackTrace();
            }
        }
    }
}
