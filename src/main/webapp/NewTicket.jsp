<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Ticket</title>
    <link rel="stylesheet" href="NewTicket.css">
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
        <h1>New Ticket</h1>
        <form action="NewTicket.jsp" method = "post">
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" placeholder="Enter a description of the issue..."></textarea>
            <div class="buttons">
                <input type="submit" class="submit-button" value = "Submit">
                <button onclick="window.location.href='TicketDashboard.jsp';" type="button" class="cancel-button">Cancel</button>
            </div>
        </form>
    </div>
    
    <%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Get username, password, and other details
        String username = (String) session.getAttribute("user");
        String comment = request.getParameter("description");
        LocalDateTime now = LocalDateTime.now();
        
        

        // Attempt sign up
        if (!ticketController.newTicket(username, comment, now)) {
            // Username taken, try again
            %>
            <script>alert("Ticket failed to post.")</script>
            <%
            return;
        }

        // User created, redirect to log in
        response.sendRedirect("TicketDashboard.jsp");
    }
%>
</body>
</html>
