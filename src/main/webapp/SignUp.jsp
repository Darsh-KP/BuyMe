<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>

<%
    // Get username and password
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String address = request.getParameter("address");
    String email = request.getParameter("email");

 // User being created
    if (!SignUpController.attemptSignUpController(firstName, lastName, username, password, email, address)) {
        System.out.println("User does not exists");
        response.sendRedirect("Login.html");
    }

    // User does exists
    session.setAttribute("user", username);
    response.sendRedirect("Logout.html");
%>

  