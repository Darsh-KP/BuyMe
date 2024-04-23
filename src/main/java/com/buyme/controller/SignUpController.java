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
            
            // User exists, log them in
            if (MyDatabase.debug) System.out.println("Signing Up...");
            	return true;
        } catch (SQLException e) {
            if (MyDatabase.debug) {
                System.out.println("Error Signing Up...");
                System.out.println(e.printStackTrace();
            }
        }

        return false;
    }