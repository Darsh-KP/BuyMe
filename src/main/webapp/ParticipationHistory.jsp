<%@ page import="com.buyme.controller.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
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
    <title>Participation History</title>
    <link rel="stylesheet" href="ParticipationHistory.css">
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
        <h1>Participation History</h1>
        <table>
            <thead class="tableHeader">
                <tr>
                    <th>Participated As</th>
                    <th>Listing ID</th>
                    <th>Listing Name</th>
                    <th>Date & Time</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Get logged in user
                    String username = session.getAttribute("user").toString();

                    // Get the user's participation history
                    List<HashMap<String,String>> participationHistory = participationHistoryController.getParticipationHistory(username);

                    // If none are returned, nothing to display
                    if (participationHistory == null) return;

                    // Debug
                    if (myDatabase.debug) System.out.println("Loading user's participation...");

                    // Display each participation
                    for (HashMap<String,String> participation : participationHistory) {
                        out.print("<tr>\n" +
                                "   <td>" + participation.get("participationAs") + "</td>\n" +
                                "   <td>" + participation.get("productId") + "</td>\n" +
                                "   <td>" + participation.get("productName") + "</td>\n" +
                                "   <td>" + participation.get("actionDateTime") + "</td>\n" +
                                "</tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
