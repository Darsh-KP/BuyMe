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

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
    }
%>

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
            <a href="Home.jsp">Home</a>
            <a href="TicketDashboard.jsp">Tickets</a>
            <a href="Listings.jsp">Listings</a>
            <a href="Wishlist.jsp">Wishlist</a>
        </div>
        <div class="dropdown">
            <button class="dropbtn">
                <img src="./data/Defaultpfp.jpg" alt="Profile Picture" class="profile-img">
            </button>
            <div class="dropdown-content">
                <label><a href="Alerts.jsp">Notifications</a></label>
                <label><a href="ParticipationHistory.jsp">My History</a></label>
                <%
                    String usernameChecker = (String) session.getAttribute("user");
                    if (loginController.checkIfCustomerRep(usernameChecker)) {
                        out.print("<label><a href=\"CustRepPanel.jsp\">Customer Rep</a></label>");
                    }
                %>
                <label><a href="Logout.jsp">Log Out</a></label>
            </div>
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
