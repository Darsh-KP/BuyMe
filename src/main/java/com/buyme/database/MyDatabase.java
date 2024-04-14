package com.buyme.database;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class MyDatabase {
	public MyDatabase() {}

	public Connection newConnection() {
		Connection connection = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");

			Properties mySQLCredentials = new Properties();

			InputStream inputStream = getClass().getResourceAsStream("/com/buyme/database/mySQL.properties");
			mySQLCredentials.load(inputStream);

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

        return connection;
	}

	public static void main(String[] args) throws SQLException {
		MyDatabase db = new MyDatabase();
		Connection con = db.newConnection();
		System.out.println(con);
		con.close();
	}
}
