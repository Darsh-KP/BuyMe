package com.buyme.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class mySQLDatabase {
	public static void main(String[] args) {
		try {
			Connection connection = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/test",
					"root",
					"etheman63"
					);
			
			Statement statement = connection.createStatement();
			
			ResultSet resultSet = statement.executeQuery("select * from user");
			
			while (resultSet.next()) {
				System.out.println(resultSet.getInt("id"));
				System.out.println(resultSet.getString("name"));
			}
			
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
