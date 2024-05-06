package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;

public class ticketController {
    private ticketController() {}

    
    //Gets all tickets for selected user
    public static List<HashMap<String, String>> getAllListingsTicketsDisplayStrings(String username, String criteria) {
    
    	try {
            // Create connection
    		myDatabase database = new myDatabase();
    	    Connection ticketConnection = database.newConnection();

    	    // Prepare the SQL statement for execution
    	    String baseQuery = "SELECT ticket_ID, created_by, comment, created_at FROM tickets WHERE created_by = ? ";
    	    String endQuery = " ;";
    	    String fullQuery= baseQuery + criteria + endQuery;  
    	    
    	    
    	    PreparedStatement statement = ticketConnection.prepareStatement(fullQuery);
    	    statement.setString(1, username);
    	    
    	    // Execute the query
    	    ResultSet resultSet = statement.executeQuery();
            

            // Store the results
            ArrayList<HashMap<String, String>> ticketDisplay = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> ticket = new HashMap<String, String>();
                //ticket ID
                int ticketID = resultSet.getInt("ticket_id");
                ticket.put("ticketID", String.valueOf(ticketID));
                
                
                //created_by 
                ticket.put("created_by", resultSet.getString("created_by"));

                // Comment
                String comment = resultSet.getString("comment");
                if (comment.length() > 25) {
                    comment = comment.substring(0, 22).trim() + "...";
                }
                ticket.put("comment", comment);
                

                // creation DT
                LocalDateTime creationDateTime = resultSet.getTimestamp("created_at").toLocalDateTime();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                String formattedDateTime = creationDateTime.format(formatter);
                ticket.put("creation", formattedDateTime);
                
                ticketDisplay.add(ticket);
            }

            //Close connection
            resultSet.close();
            statement.close();
            ticketConnection.close();

            // Return the strings to display
            return ticketDisplay;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all tickets for user...");
                e.printStackTrace();
            }
        }

        return null;
    }
    
    public static List<HashMap<String, String>> getAllTickets() {
        
    	try {
            // Create connection
    		myDatabase database = new myDatabase();
    	    Connection ticketConnection = database.newConnection();

    	    // Prepare the SQL statement for execution
    	    PreparedStatement statement = ticketConnection.prepareStatement(
    	        "SELECT ticket_ID, created_by, comment, created_at FROM tickets");
    	    
    	    // Execute the query
    	    ResultSet resultSet = statement.executeQuery();
            

            // Store the results
            ArrayList<HashMap<String, String>> ticketDisplay = new ArrayList<HashMap<String, String>>();
            while (resultSet.next()) {
                // Get each listing
                HashMap<String, String> ticket = new HashMap<String, String>();
                //ticket ID
                int ticketID = resultSet.getInt("ticket_id");
                ticket.put("ticketID", String.valueOf(ticketID));
                
                
                //created_by 
                ticket.put("created_by", resultSet.getString("created_by"));

                // Comment
                String comment = resultSet.getString("comment");
                if (comment.length() > 25) {
                    comment = comment.substring(0, 22).trim() + "...";
                }
                ticket.put("comment", comment);
                

                // creation DT
                LocalDateTime creationDateTime = resultSet.getTimestamp("created_at").toLocalDateTime();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy 'at' HH:mm:ss");
                String formattedDateTime = creationDateTime.format(formatter);
                ticket.put("creation", formattedDateTime);
                
                ticketDisplay.add(ticket);
            }

            //Close connection
            resultSet.close();
            statement.close();
            ticketConnection.close();

            // Return the strings to display
            return ticketDisplay;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error getting all tickets...");
                e.printStackTrace();
            }
        }

        return null;
    }
    
    public static boolean newTicket(String username, String comment, LocalDateTime creation){
    	
    	try {
            // Create connection
    		myDatabase database = new myDatabase();
    	    Connection ticketConnection = database.newConnection();

    	    // Prepare the SQL statement for execution
    	    PreparedStatement statement = ticketConnection.prepareStatement(
    	    		"INSERT INTO tickets (created_by, comment, created_at)" +
                            "VALUES (?, ?, ?);");
    	    statement.setString(1, username);
    	    statement.setString(2, comment.trim());
    	    Timestamp timestamp = Timestamp.valueOf(creation);
    	    statement.setTimestamp(3, timestamp);
    	    statement.executeUpdate();
    	    
    	
            //Close connection
            statement.close();
            ticketConnection.close();

	    } catch (SQLException e) {
	        if (myDatabase.debug) {
	            System.out.println("Error getting all tickets...");
	            e.printStackTrace();
	            return false;
	        }
	    }
    	
    	return true;
    	
    }

    public static boolean postMessage(int ticketID, String messageFrom, String message, LocalDateTime creation){
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection wishlistConnection = database.newConnection();

            // Send the message
            PreparedStatement statement = wishlistConnection.prepareStatement(
                    "insert into ticket_reply (ticket_id, message_from, message, message_at) values (?, ?, ?, ?);");
            statement.setInt(1, ticketID);
            statement.setString(2, messageFrom);
            statement.setString(3, message);
            statement.setTimestamp(4, Timestamp.valueOf(creation));
            statement.executeUpdate();

            // Close connections
            statement.close();
            wishlistConnection.close();

            return true;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error sending ticket message...");
                e.printStackTrace();
            }
        }

        return false;
    }

    public static List<HashMap<String, String>> getTicketMessageHistory(int ticketID) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection wishlistConnection = database.newConnection();

            // Get the messages for the ticket
            PreparedStatement statement = wishlistConnection.prepareStatement(
                    "SELECT message, message_from, message_at\n" +
                            "FROM (\n" +
                            "    SELECT comment AS message, created_by AS message_from, created_at AS message_at FROM tickets WHERE ticket_id = ?\n" +
                            "    UNION\n" +
                            "    SELECT message, message_from, message_at FROM ticket_reply WHERE ticket_id = ?\n" +
                            ") AS combined_messages\n" +
                            "ORDER BY message_at;"
            );
            statement.setInt(1, ticketID);
            statement.setInt(2, ticketID);
            ResultSet resultSet = statement.executeQuery();

            // Store the messages in a hashmap
            List<HashMap<String, String>> messageHistory = new ArrayList<HashMap<String,String>>();
            while (resultSet.next()) {
                // Get each message
                HashMap<String, String> message = new HashMap<String,String>();

                // Check if message from user or rep
                message.put("message", resultSet.getString("message"));
                message.put("messageFrom", resultSet.getString("message_from"));
                messageHistory.add(message);
            }

            // Close connection
            resultSet.close();
            statement.close();
            wishlistConnection.close();

            return messageHistory;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error sending ticket message...");
                e.printStackTrace();
            }
        }

        return null;
    }
}