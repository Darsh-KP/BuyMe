<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>

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
    <title>New Wishlist</title>
    <link rel="stylesheet" href="PostWishlist.css">
     <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
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
        <h1>New Wishlist</h1>
        <form action="#">
            <div class="form-group">
                <label for="subcategory">Category:</label>
                <select id="subcategory" name="subcategory">
                    <option value="" disabled selected>Select Category</option>
                    <option value="shirt">Shirt</option>
                    <option value="pant">Pant</option>
                    <option value="hat">Hat</option>
                </select>
            </div>
            <div class="form-group">
                <label for="maxThreshold">Max Threshold:</label>
                <input type="number" id="maxThreshold" name="maxThreshold" placeholder="Enter max value">
            </div>
            <div class="form-group" id="attributes">
                <label for="addAtrrubute">Add Attribute:</label>
                <button type="button" id="addAttribute">Add Attribute</button>
                <div class="attribute">
                    <select name="size">
                        <option value="" disabled selected>Select Size</option>
                        <option value="XS">XS</option>
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                    </select>
                    <input type="text" name="color" placeholder="Color">
                    <button type="button" class="remove-attribute">Remove</button>
                </div>
            </div>
            <button type="submit">Post to Wishlist</button>
        </form>
    </div>
    <script src="script.js"></script>
</body>
</html>
