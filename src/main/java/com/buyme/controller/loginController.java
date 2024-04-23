package com.buyme.controller;

import com.buyme.database.MyDatabase;
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
                    "SELECT COUNT(*) AS userExists FROM testlogin WHERE name=? AND password=?");
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            ResultSet resultSet = preparedStatement.executeQuery();

            resultSet.next();
            int userExists = resultSet.getInt("userExists");

            //Close connection
            resultSet.close();
            preparedStatement.close();
            loginConnection.close();

            if ((userExists) <= 0) {
                // User doesn't exists/incorrect credentials
                if (MyDatabase.debug) System.out.println("User does not exists.");
                return false;
            }

            // User exists, log them in
            if (MyDatabase.debug) System.out.println("Logging in...");
            return true;
        } catch (SQLException e) {
            if (MyDatabase.debug) {
                System.out.println("Error logging in...");
                System.out.println(e.printStackTrace();
            }
        }

        return false;
    }
}
