<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
    }
%>


<%
    notificationsController.checkListingWinners();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notifications</title>
<link rel="stylesheet" href="Alerts.css">
</head>
<body>

 <!-- Nav Bar -->
<nav>
    <div class="logo">
        <img src="./data/LogoFinal.png" alt="BuyMe Logo">
    </div>
    <div class="nav-links">
        <a href="">Home</a>
        <a href="">Tickets</a>
        <a href="Listings.jsp">Listings</a>
        <a href="">Wishlist</a>
    </div>
    <div class="profile">
        <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
        <a href="#">Notifications</a>
        <a href="#" class="logout-button">Log Out</a>
    </div>
</nav>

<div class="container">
    <div class="table notifications">
    <h2>Notifications</h2>
    <%
        // Get logged in user
        String username = (String) session.getAttribute("user");

        // Get all the notifications to display
        List<HashMap<String, String>> allNotifications = notificationsController.getUserNotifications(username);
        boolean useAlternativeStyle = false;
        for (HashMap<String, String> notification : allNotifications) {
            out.print("<div class=\"notification" + (useAlternativeStyle ? " alternate" : "") + "\">\n" +
                    "   <span class=\"datetime\">" + notification.get("dateTime") + "</span>\n" +
                    "   <p>" + notification.get("message") + "</p>\n" +
                    "</div>");

            useAlternativeStyle = !useAlternativeStyle;
        }
    %>
  </div>
</div>

</body>
</html>
