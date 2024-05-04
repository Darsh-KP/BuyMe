<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>

<%
    notificationsController.checkListingWinners();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notifications and Alerts</title>
<link rel="stylesheet" href="Notifications.css">
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
    <div class="notification">
      <span class="datetime">May 3, 2024 12:30 PM</span>
      <button class="close-btn">&times;</button>
      <p>An item you are interested in is now available.</p>
    </div>
    <div class="notification alternate">
      <span class="datetime">May 2, 2024 09:45 AM</span>
      <button class="close-btn">&times;</button>
      <p>The price of an item you are watching has dropped.</p>
    </div>
    <div class="notification">
      <span class="datetime">May 1, 2024 04:20 PM</span>
      <button class="close-btn">&times;</button>
      <p>Your bid on an item has been accepted.</p>
    </div>
    <!-- You can add more notifications dynamically -->
  </div>
</div>

</body>
</html>
