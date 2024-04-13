package com.buyme.database;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class mySQLDatabase {
	public mySQLDatabase() {}

	public Connection newConnection() {
		Connection connection = null;
		try {
			Properties mySQLCredentials = new Properties();
			mySQLCredentials.load(new FileInputStream("./src/main/java/com/buyme/database/mySQL.properties"));

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
		}

		return connection;
	}

	public void CloseConnection(Connection connection) {
		try {
			connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
