package com.buyme.controller;

import com.buyme.database.myDatabase;
import com.mysql.jdbc.Statement;
import com.buyme.database.*;

import java.sql.*;

public class signUpController {
    private signUpController() {}

    public static boolean attemptSignUp(String firstName, String lastName, String username, String password, String email, String address) {
    	// Check if username provided is admin
        if (username.equalsIgnoreCase("admin")) {
            if (myDatabase.debug) System.out.println("Cannot have admin as username.");
            return false;
        }

        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection SignUpConnection = database.newConnection();

            // Check if the username is taken
            PreparedStatement redundancypreparedStatement = SignUpConnection.prepareStatement(
                    "SELECT COUNT(*) as userExists FROM User WHERE username = ?");
            redundancypreparedStatement.setString(1, username);
            ResultSet resultSet = redundancypreparedStatement.executeQuery();
            if (resultSet.next()) {
                int userExists = resultSet.getInt("userExists");

                if ((userExists) >= 1) {
                    // Username taken
                    if (myDatabase.debug) System.out.println("User already exists.");
                    return false;
                }
            }

            // Get password hash
            String passwordSalt = passwordSecurity.generateSalt();
            String passwordHash = passwordSecurity.hashPassword(password, passwordSalt);

            // Check if password was hashed
            if (passwordHash == null) {
                if (myDatabase.debug) System.out.println("Password hash is null.");
                return false;
            }

            // Insert data into database
            PreparedStatement preparedStatement = SignUpConnection.prepareStatement(
                    "INSERT INTO user (username, password_hash, password_salt, first_name, last_name, email, address) \n"
                    + "VALUES (?, ?, ?, ?, ?, ?, ?);\n"
                    + "");
            	
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, passwordHash);
            preparedStatement.setString(3, passwordSalt);
            preparedStatement.setString(4, firstName);
            preparedStatement.setString(5, lastName);
            preparedStatement.setString(6, email);
            preparedStatement.setString(7, address);
            preparedStatement.executeUpdate();

            // Close connections
            preparedStatement.close();
            SignUpConnection.close();
            resultSet.close();

            // User created
            if (myDatabase.debug) System.out.println("Signing Up... " + username);
            return true;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error Signing Up...");
                e.printStackTrace();
            }
        }

        return false;
    }
    
    public static boolean changePassword(String username, String newPassword){
    	try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection changePassConnection = database.newConnection();

            // Check if the username is taken
            PreparedStatement redundancypreparedStatement = changePassConnection.prepareStatement(
                    "SELECT COUNT(*) as userExists FROM User WHERE username = ?");
            redundancypreparedStatement.setString(1, username);
            ResultSet resultSet = redundancypreparedStatement.executeQuery();
            boolean passwordUpdated = false;
            if (resultSet.next()) {
                int userExists = resultSet.getInt("userExists");

                if ((userExists) >= 1) {
                	String passwordSalt = passwordSecurity.generateSalt();
                    String passwordHash = passwordSecurity.hashPassword(newPassword, passwordSalt);
                    
                    if (passwordHash == null) {
                        if (myDatabase.debug) System.out.println("Password hash is null.");
                        return false;
                    }
                    
                    PreparedStatement preparedStatement = changePassConnection.prepareStatement(
                    		"UPDATE `user`"
                    		+ "SET password_hash = ?, password_salt = ? \n"
                    		+ "WHERE username = ?;"
                    		);
	                    preparedStatement.setString(1, passwordHash);
	                    preparedStatement.setString(2, passwordSalt);
	                    preparedStatement.setString(3, username);
	                    preparedStatement.executeUpdate();
	                    passwordUpdated = true;
                }
            }
            resultSet.close();
            redundancypreparedStatement.close();
            changePassConnection.close();
            
    	
    	
	    	return passwordUpdated;
	    }catch (SQLException e) {
		        if (myDatabase.debug) {
		            System.out.println("Error Signing Up...");
		            e.printStackTrace();
		        }
		    }
    	return false;
    }
}