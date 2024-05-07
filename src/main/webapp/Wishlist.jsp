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
<%@ page import="com.buyme.database.*" %>

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
    
    
    
    <a href="PostWishlist.jsp" class="add-to-wishlist-link">Add To Wishlist</a>
    
    
    <div class="wishlist-container">
        <%
            List<HashMap<String, String>> allWishlistDisplay = wishlistController.getWishlist(usernameChecker);

            // Display each product
            int i = 1;
            for (HashMap<String, String> wishlistDisplay : allWishlistDisplay) {
                out.print("<div class= \"wishlist-item \">\n" +
                        "<h3>Wish #" + i + "</h3>"+
                        "   <p class=\"SubCategory\">SubCategory: " + wishlistDisplay.get("subcategory") + "</p>\n" +
                        "   <p class=\"ticket-date\">Max Threshold: " + wishlistDisplay.get("price_threshold") + "</p>\n");

                out.print("Date: " + wishlistDisplay.get("date"));
                String rawDate = wishlistDisplay.get("rawDate");
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
                LocalDateTime localDateTime = LocalDateTime.parse(rawDate, formatter);

                List<HashMap<String, String>> allWishlistAttributes = wishlistController.getWishlistAttributes(usernameChecker, localDateTime);
                      for (HashMap<String, String> attribute : allWishlistAttributes) {
                          out.print("<br>" + attribute.get("attributeKey") + ": " + attribute.get("attributeValue"));
                      }

                out.print("<form method=\"post\" action=\"Wishlist.jsp\">\n" +
                        "            <input type=\"submit\" name=\"removeWish\" value=\"Remove\" class=\"remove-button\">\n" +
                        "            <input type=\"hidden\" value=\"" + rawDate + "\" name=\"wishDate\">\n" +
                        "   </form>" +
                        "</div>");

                i++;
            }
        %>
    </div>

<%
    if ((request.getMethod().equalsIgnoreCase("POST")) && (request.getParameter("removeWish") != null)) {
        // Get info to pass
        String rawDateGetter = request.getParameter("wishDate");
        System.out.printf(rawDateGetter);
        DateTimeFormatter formatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
        LocalDateTime dateLocal = LocalDateTime.parse(rawDateGetter, formatter2);

        // Post message
        if (!wishlistController.deleteWishlist(usernameChecker, dateLocal)) {
                %>
                    <script>alert("Unable to delete.")</script>
                <%
                return;
            }

            // Reload the page
            response.sendRedirect("Wishlist.jsp");
        }
%>
</body>
</html>