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
    <title>My Wishlist</title>
    <link rel="stylesheet" href="WishlistStyling.css">
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

    <header>
        <h1>My Wishlist</h1>
    </header>
    <a href="PostWishlist.jsp">Add To Wishlist</a>
    
    <div class="wishlist-container">

        <div class="wishlist-item">
            <h3>Wish #1</h3>
            <p>Category: Hats</p>
            <p>Max Threshold: $50</p>
            <p>Size: Medium</p>
            <p>Color: Blue</p>
            <button class="remove-btn">Remove</button>
        </div>

        <div class="wishlist-item">
            <%
            
            List<HashMap<String, String>> allWishlistDisplay = wishlistController.getWishlist(usernameChecker);


            // Display each product
            for (HashMap<String, String> wishlistDisplay : allWishlistDisplay) {
          	  out.print("<div class= \"wishlist-item \">\n" +
                        "   <p class=\"Category\">#" + wishlistDisplay.get("subcategory") + "</p>\n" +
                        "   <p class=\"ticket-date\">Date Created: " + wishlistDisplay.get("price_threshold") + "</p>\n" +
                        		"<button class=\"remove-btn\">Remove</button>" +
                        "</div>");
            }
            
            
            %>
        </div>
        
    </div>

</body>
</html>