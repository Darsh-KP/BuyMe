<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>

<%
    // Get username and password
    String username = (request.getParameter("username")).trim();
    String password = (request.getParameter("password")).trim();

    if (!loginController.attemptLogin(username, password)) {
        // User doesn't exist, back to log in
        System.out.println("User does not exists");
        response.sendRedirect("Login.html");
        return;
    }

    // User does exists
    session.setAttribute("user", username);
    response.sendRedirect("Logout.html");
%>