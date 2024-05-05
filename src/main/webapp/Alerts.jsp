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

6px 0px rgba(0,0,0,0.2);
    z-index: 1;
    padding: 0; /* Adjusted padding */
    right: 0; /* Align to the right */
    color: #000; /* Black text color */
    border: 1px solid #000; /* Add border */
}

.dropdown-content a {
    display: block;
    padding: 8px 16px;
    text-decoration: none;
    color: inherit; /* Inherit text color */
}

.dropdown-content a:hover {
    background-color: #FCA6A9;
}

.dropdown:hover .dropdown-content {
    display: block;
}

.dropdown:hover .dropbtn {
    background-color: #430F1B;
}



.logout-button {
    padding: 10px 20px;
    background-color: #A14258;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    text-decoration: none;
}

.logout-button:hover {
    background-color: #A14258;
}

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
