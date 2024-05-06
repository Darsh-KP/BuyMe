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

    String customerRepChecker = (String) session.getAttribute("user");
    if (!loginController.checkIfCustomerRep(customerRepChecker)) {
        response.sendRedirect("Home.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Rep Ticketing Center</title>
    <link rel="stylesheet" href="CRTicketDashboard.css">
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
        <h1>Customer Representative Ticketing Center</h1>


        <div class="ticket-cards">
         	<%
                String username = (String) session.getAttribute("user");

                // Get all products to display
                List<HashMap<String, String>> allTicketDisplay = ticketController.getAllTickets();


                // Display each product
                for (HashMap<String, String> ticketDisplay : allTicketDisplay) {
                    out.print("<div onclick=\"ticketClicked(this)\" class=\"ticket-card\" data-ticket-id = \"" + ticketDisplay.get("ticketID") + "\">\n" +
                            "   <p class=\"ticket-number\">#" + ticketDisplay.get("ticketID") + "</p>\n" +
                            "   <p class=\"ticket-date\">Date Created: " + ticketDisplay.get("creation") + "</p>\n" +
                            "   <p class=\"ticket-description\">" + ticketDisplay.get("comment") + "</p>\n" +
                            "   <p class=\"ticket-user\">" + ticketDisplay.get("created_by") + "</p>\n" +
                            "</div>");
                }
              %>

        </div>
        
    </div>
    
        <script>
        function ticketClicked(element){
            // Get productID from the card that was clicked
            var ticketID = element.getAttribute('data-ticket-id');

            // Create form in order to POST id
            var form = document.createElement("form");
            form.setAttribute("method", "post");
            form.setAttribute("action", "CRTicketView.jsp");

            // Attach productID
            var input = document.createElement("input");
            input.setAttribute("type", "hidden");
            input.setAttribute("name", "ticketID");
            input.setAttribute("value", ticketID);

            // Submit Form
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    </script>
    
</body>
</html>
