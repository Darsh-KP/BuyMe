<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.database.*" %>
<%@ page import="com.buyme.controller.*"%>

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
    <title>BuyMe</title>
    <link rel="stylesheet" href="Home.css">
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

    <header>
        <h1>Welcome to BuyMe!</h1>
        <p>Your One-Stop Destination for Buying, Selling, and Resolving!</p>
    </header>

    <section class="features">
        <a href="Listings.jsp" class="feature">
            <h2>Listings</h2>
            <p>Discover a treasure trove of products, neatly categorized for your convenience. From gadgets to fashion, find what you need in just a click!</p>
        </a>
        <a href="Listings.jsp" class="feature">
            <h2>Bidding</h2>
            <p>Experience the adrenaline rush of auctions! Place your bids and compete for the best deals on your favorite items.</p>
        </a>
        <a href="Wishlist.jsp" class="feature">
            <h2>Wishlist</h2>
            <p>Create your dream list! Keep track of must-haves and set alerts for when they hit your desired price.</p>
        </a>
        <a href="TicketDashboard.jsp" class="feature">
            <h2>Tickets</h2>
            <p>Need assistance or want to report an issue? Our dedicated team is here to help! Submit a ticket, and we'll ensure your queries are resolved swiftly.</p>
        </a>
    </section>

    <footer>
        <p>Join the Thriving Community Today!</p>
    </footer>

<%
    if (myDatabase.debug) System.out.println("Home Session: "  + session.getAttribute("user"));
%>
</body>
</html>
