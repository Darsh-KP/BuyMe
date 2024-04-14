package com.buyme.database;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;


// Class used to make connection to the database
public class MyDatabase {
	public MyDatabase() {}

	public Connection newConnection() {
		// To store the connection
		Connection connection = null;
		try {
			// Load the driver
			Class.forName("com.mysql.jdbc.Driver");

			// Load the mySQL credentials
			Properties mySQLCredentials = new Properties();
			InputStream inputStream = getClass().getResourceAsStream("/com/buyme/database/mySQL.properties");
			mySQLCredentials.load(inputStream);

			// Make the connection
			connection = DriverManager.getConnection(
					mySQLCredentials.getProperty("url"),
					mySQLCredentials.getProperty("username"),
					mySQLCredentials.getProperty("password")
					);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException ioE) {
			System.out.println("Couldn't read database credentials.");
			//ioE.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.out.println("Couldn't load database driver.");
        }

		// Return the connection
        return connection;
	}
	
	public static void main(String[] args) throws SQLException {
		// To test if connection to database works
		MyDatabase db = new MyDatabase();
		Connection con = db.newConnection();
		System.out.println(con);
		con.close();
	}
}
