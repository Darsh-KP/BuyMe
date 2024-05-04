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
    public static List<HashMap<String, String>> getAllListingsTicketsDisplayStrings(String username) {
    
    	try {
            // Create connection
    		myDatabase database = new myDatabase();
    	    Connection ticketConnection = database.newConnection();

    	    // Prepare the SQL statement for execution
    	    PreparedStatement statement = ticketConnection.prepareStatement(
    	        "SELECT ticket_ID, created_by, resolved_by, comment, creation FROM tickets WHERE created_by = ?");
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
                ticket.put("resolved_by", resultSet.getString("resolved_by"));
                

                // Comment
                ticket.put("comment", resultSet.getString("comment"));
                

                // creation DT
                LocalDateTime creationDateTime = resultSet.getTimestamp("creation").toLocalDateTime();
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
    	    		"INSERT INTO tickets (created_by, comment, creation)" +
                            "VALUES (?, ?, ?);");
    	    statement.setString(1, username);
    	    statement.setString(2, comment);
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
    
    
    

}