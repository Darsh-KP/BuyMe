package com.buyme.database;

import com.sun.tools.javac.Main;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class mySQLDatabase {
	public static void main(String[] args) {
		try {
			Properties mySQLCredentials = new Properties();
			mySQLCredentials.load(new FileInputStream("./src/main/java/com/buyme/database/mySQL.properties"));

			Connection connection = DriverManager.getConnection(
					mySQLCredentials.getProperty("url"),
					mySQLCredentials.getProperty("username"),
					mySQLCredentials.getProperty("password")
					);

			System.out.println(connection);

			Statement statement = connection.createStatement();
			
			ResultSet resultSet = statement.executeQuery("select * from testlogin");
			
			while (resultSet.next()) {
				System.out.println(resultSet.getString("name"));
				System.out.println(resultSet.getString("password"));
			}
			
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException ioE) {
			ioE.printStackTrace();
		}
	}
}
