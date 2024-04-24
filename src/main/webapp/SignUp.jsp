<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>

<%
    // Get username and password
    String username = request.getParameter("username").trim();
    String password = request.getParameter("password").trim();
    String firstName = request.getParameter("firstName").trim();
    String lastName = request.getParameter("lastName").trim();
    String address = request.getParameter("address").trim();
    String email = request.getParameter("email").trim();

 // User already exists
    if (!SignUpController.attemptSignUpController(firstName, lastName, username, password, email, address)) {
    	%>
        <script>alert("username taken.")</script>
        <%  
        return;
    }

    // User created
    session.setAttribute("user", username);
    response.sendRedirect("Login.jsp");
%>

  