package com.buyme.controller;

import com.buyme.database.MyDatabase;
import com.buyme.database.PasswordSecurity;

import java.sql.*;

public class loginController {
    private loginController() {}

    public static boolean attemptLogin(String username, String password) {
        try {
            // Create connection
            MyDatabase database = new MyDatabase();
            Connection loginConnection = database.newConnection();

            // Check for credentials in the database
            PreparedStatement preparedStatement = loginConnection.prepareStatement(
                    "SELECT password_hash, password_salt FROM user WHERE username=?");
            preparedStatement.setString(1, username);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (!resultSet.next()) {
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
            if (!PasswordSecurity.verifyPassword(password, storedPasswordHash, storedSalt)) {
                // Passwords don't match
                return false;
            }

            // User exists, log them in
            if (MyDatabase.debug) System.out.println("Logging in... " + username);
            return true;
        } catch (SQLException e) {
            if (MyDatabase.debug) {
                System.out.println("Error logging in...");
                e.printStackTrace();
            }
        }

        return false;
    }
}
