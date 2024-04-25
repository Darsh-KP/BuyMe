<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>Sign Up</title>
    <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
    <link rel="stylesheet" href="SignUp.css">
</head>
<body>
<div class="signUpContainer">
    <form method="post" action="SignUp.jsp" class="signUpForm">
        <label for="firstName">First Name</label>
        <label for="lastName">Last Name</label>
        <input type="text" id="firstName" name="firstName" required autofocus maxlength="20">
        <input type="text" id="lastName" name="lastName" required maxlength="20">
        <label for="email">Email</label>
        <label for="address">Address</label>
        <input type="email" id="email" name="email" required maxlength="50">
        <input type="text" id="address" name="address" required maxlength="100">
        <label for="username">Username</label>
        <label for="password">Password</label>
        <input type="text" id="username" name="username" required minlength="5" maxlength="20">
        <input type="password" id="password" name="password" required minlength="8" maxlength="255">
        <input type="submit" value="Sign Up">
    </form>
    Already have an account? <a href="Login.jsp">Log In</a>
</div>
<%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
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
    }
%>
</body>
</html>

  