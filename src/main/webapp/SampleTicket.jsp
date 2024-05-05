<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Logs</title>
    <link rel="stylesheet" href="SampleTicket.css">
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
    
    <div class="chatbox">
        <div class="chat-header">
            <h1> Chat Logs </h1>
        </div>
        <div class="chat-container">
            <div class="chat-messages">
                <div class="message received">
                    <p class="sender">YOU</p>
                    <p class="content">I would like to remove a bid.</p>
                </div>
                <div class="message sent">
                    <p class="sender">Customer Representative</p>
                    <p class="content">Sure, please provide a listing number. </p>
                </div>
                <div class="message received">
                  <p class="sender">YOU</p>
                  <p class="content">The listing number is 30. </p>
              </div>
              <div class="message sent">
                <p class="sender">Customer Representative</p>
                <p class="content">What is the reason to delete the bid? </p>
            </div>
            <div class="message received">
              <p class="sender">YOU</p>
              <p class="content">My dog clicked my computer and bidded for me. I cannot afford a $2000 fur coat, even if it is Kendrick Lamar's. </p>
          </div>
          <div class="message sent">
            <p class="sender">Customer Representative</p>
            <p class="content"> Alright, I'll get on it!. </p>
        </div>
            </div>
        </div>
        <div class="chat-footer">
            <input type="text" placeholder="Type your message here...">
            <button>Submit</button>
        </div>
    </div>
</body>
</html>
