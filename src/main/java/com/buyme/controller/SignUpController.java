package com.buyme.controller;

import com.buyme.database.MyDatabase;
import java.sql.*;

public class SignUpController {
    private SignUpController() {}

    public static boolean attemptSignUpController(String firstName, String lastName, String username, String password, String email, String address) {

    	try {
            // Create connection//
            MyDatabase database = new MyDatabase();
            Connection SignUpConnection = database.newConnection();
            
            PreparedStatement redundancypreparedStatement = SignUpConnection.prepareStatement(
                    "SELECT COUNT(*) as userExists FROM User WHERE username = ?");
            redundancypreparedStatement.setString(1, username);
            ResultSet resultSet = redundancypreparedStatement.executeQuery();
            resultSet.next();
            int userExists = resultSet.getInt("userExists");

	        if ((userExists) >= 1) {
	            // User doesn't exists/incorrect credentials
	            if (MyDatabase.debug) System.out.println("User already exists.");
	            return false;
	        }
	
            PreparedStatement preparedStatement = SignUpConnection.prepareStatement(
                    "INSERT INTO User (username, password, fName, lName, address, email) \n"
                    + "VALUES (?, ?, ?, ?, ?, ?);\n"
                    + "");
            	
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            preparedStatement.setString(3, firstName);
            preparedStatement.setString(4, lastName);
            preparedStatement.setString(5, address);
            preparedStatement.setString(6, email);
            preparedStatement.executeUpdate();
            
   
            preparedStatement.close();
            SignUpConnection.close();
            resultSet.close();
      
            if (MyDatabase.debug) System.out.println("Signing Up... " + username);
            return true;
        } catch (SQLException e) {
            if (MyDatabase.debug) {
                System.out.println("Error Signing Up...");
                e.printStackTrace();
            }
        }

        return false;
    }
}