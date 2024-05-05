package com.buyme.controller;

import com.buyme.database.myDatabase;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class adminController {
    private adminController () {}

    public static boolean setUserPromotion (String username, boolean promoteUser) {
        try {
            // Create connection
            myDatabase database = new myDatabase();
            Connection promoteConnection = database.newConnection();

            // Promote the user
            PreparedStatement statement = promoteConnection.prepareStatement(
                    "update user set is_customer_rep = ? where username = ?;");
            statement.setBoolean(1, promoteUser);
            statement.setString(2, username);
            statement.executeUpdate();

            // Close connections
            statement.close();
            promoteConnection.close();

            return true;
        } catch (SQLException e) {
            if (myDatabase.debug) {
                System.out.println("Error changing user promotion...");
                e.printStackTrace();
            }
        }

        return false;
    }
}
