package com.buyme.controller;

import com.buyme.database.myDatabase;
import com.buyme.database.passwordSecurity;

import java.sql.*;

public class loginController {
    private loginController() {}

    public static boolean attemptLogin(String username, String password) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection loginConnection = database.newConnection();

            // Check for credentials in the database
            PreparedStatement preparedStatement = loginConnection.prepareStatement(
                    "SELECT password_hash, password_salt FROM user WHERE username=?;");
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (!resultSet.next()) {
                //Close connection
                resultSet.close();
                preparedStatement.close();
                loginConnection.close();

                // No results, incorrect credentials
                return false;
            }

            // Get stored hash and salt
            String storedPasswordHash = resultSet.getString("password_hash");
            String storedSalt = resultSet.getString("password_salt");

            //Close connection
            resultSet.close();
            preparedStatement.close();
            loginConnection.close();

            // Verify password
            if (!passwordSecurity.verifyPassword(password, storedPasswordHash, storedSalt)) {
                // Passwords don't match
                return false;
            }

            // User exists
            if (myDatabase.debug) System.out.println("Logging in... " + username);
            return true;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error logging in...");
                e.printStackTrace();
            }
        }

        return false;
    }

    public static boolean checkIfCustomerRep (String username) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection customerRepConnection = database.newConnection();

            // Get user
            PreparedStatement preparedStatement = customerRepConnection.prepareStatement(
                    "select is_customer_rep from user where username = ?;");
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if the user is customer rep
            boolean isCustomerRep = false;
            if (resultSet.next()) {
                isCustomerRep = resultSet.getBoolean("is_customer_rep");
            }

            //Close connection
            resultSet.close();
            preparedStatement.close();
            customerRepConnection.close();

            return isCustomerRep;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error checking if customer rep...");
                e.printStackTrace();
            }
        }

        return false;
    }

    public static boolean checkAdminPassword (String password) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection adminConnection = database.newConnection();

            // Get user
            PreparedStatement preparedStatement = adminConnection.prepareStatement(
                    "select property_value from properties where property_key = \"admin_password\" and property_value = ?;");
            preparedStatement.setString(1, password);
            ResultSet resultSet = preparedStatement.executeQuery();

            // Check if the user is customer rep
            boolean isAdmin = resultSet.next();

            //Close connection
            resultSet.close();
            preparedStatement.close();
            adminConnection.close();

            return isAdmin;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error checking if customer rep...");
                e.printStackTrace();
            }
        }

        return false;
    }
}
