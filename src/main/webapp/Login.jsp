<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.database.*, com.buyme.controller.*"%>

<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <title>Login</title>
    <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
    <link rel="stylesheet" href="Login.css">
</head>
<body>
<img class="logoDisplay" src="./data/LogoFinal.png" alt="Logo">
<div class="loginContainer">
    <form method="post" action="Login.jsp" class="loginForm">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required autofocus maxlength="20">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required maxlength="15">
        <input type="submit" value="Log In">
    </form>
    New here? <a href="SignUp.html">Sign Up</a>

    <%
        // Check if the form was submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Get username and password
            String username = (request.getParameter("username")).trim();
            String password = (request.getParameter("password")).trim();

            if (!loginController.attemptLogin(username, password)) {
                // User doesn't exist, back to log in
                %>
                <script>alert("username or password does not match.")</script>
                <%
                return;
            }

            // User does exists
            session.setAttribute("user", username);
            if (MyDatabase.debug) System.out.println(session.getAttribute("user"));
            response.sendRedirect("Home.jsp");
        }
    %>
</div>
</body>
</html>