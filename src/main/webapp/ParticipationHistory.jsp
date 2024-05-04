<%@ page import="com.buyme.controller.participationHistoryController" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="com.buyme.database.myDatabase" %>

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
