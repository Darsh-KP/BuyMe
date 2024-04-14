<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>

<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.database.*"%>
<%@ page import="java.sql.*" %>

<%
    System.out.println("Starting...");
    // Get username and password
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    System.out.println(username + " " + password);
    try {
        // Create connection
        MyDatabase database = new MyDatabase();
        Connection loginConnection = database.newConnection();

        System.out.println("Connection made!");

        // Check for credentials
        PreparedStatement preparedStatement = loginConnection.prepareStatement("SELECT COUNT(*) AS userExists FROM testlogin WHERE name=? AND password=?");
        preparedStatement.setString(1, username);
        preparedStatement.setString(2, password);

        ResultSet resultSet = preparedStatement.executeQuery();

        System.out.println("Executed Query");

        resultSet.next();
        if (resultSet.getInt("userExists") <= 0) {
            // User doesn't exists/incorrect credentials
            System.out.println("User does not exists");
            response.sendRedirect("Login.html");
        } else {
            // User exists, log them in
            System.out.println("Logging in...");
            response.sendRedirect("loginpage.jsp");
        }

        //Close connection
        resultSet.close();
        preparedStatement.close();
        loginConnection.close();
    } catch (SQLException e) {
        System.out.println(e.getMessage());
    }
%>