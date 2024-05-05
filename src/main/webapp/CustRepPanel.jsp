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
    <title>Customer Rep Panel</title>
    <link rel="stylesheet" href="CustRepPanel.css">
</head>

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

<body>
    <div class="container">
        <h2>Customer Representative Panel</h2>
        <div class="form-group">
        <!-- Edit User -->
        <form method = "post" action = "CustRepPanel.jsp" class="user-info"> 
            <label for="searchUser">Search User:</label>
            <input type="text" id="searchUser" name="searchUser">
           <input type ="submit" value = "Edit User" name = "edit_user" class = "button">
        </form>
        
        <form method = "post" action = "CustRepPanel.jsp" class="user-info"> 
            <label for="searchBidId">Change User's Password:</label>
            <input type="text" id="change_user" name="change_user" placeholder="Enter username">
            <input type="text" id="new_pass" name="new_pass" placeholder="Enter New Password">
           <input type ="submit" value = "Change password" name = "passChange" class = "button">
       	</form>
            
        </div>
        <!-- Remove Bid -->
        <div class="form-group">
        <form method = "post" action = "CustRepPanel.jsp" class="bid-info"> 
            <label for="searchBidId">Remove Bid:</label>
            <input type="text" id="bidUser" name="bidUser" placeholder="Enter username">
            <input type="text" id="listingID" name="listingID" placeholder="Enter ListingID">
           <input type ="submit" value = "Remove Bid" name = "removeBid" class = "button">
       	</form>
        </div>
        
        <!-- Remove Listing -->
        <form method = "post" action = "CustRepPanel.jsp" class="bid-info"> 
            <label for="searchListing">Search Listing:</label>
            <input type="text" id="searchListing" name="searchListing">
           <input type ="submit" value = "Remove Listing" name = "remove_listing" class = "button">
        </form>
        
        
        <div class="center">
            <div class="form-group">
                <button onclick="window.location.href='CRTicketDashboard.jsp';" type="button" class="cancel-button">View Tickets</button>
            </div>
        </div>
    </div>

	<%
	
	if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("remove_listing")!=null)) {
		String productID = request.getParameter("searchListing").trim();
		int product_id = Integer.parseInt(productID);
		
		if(!listingsController.removeListing(product_id)) {
            %>
            <script>alert("Listing could not be removed.")</script>
            <%
            return;
        }
		response.sendRedirect("CustRepPanel.jsp");
		
	}
	
	if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("edit_user")!=null)) {
		String username = request.getParameter("searchUser").trim();
		
		
		if(!loginController.userExists(username)) {
            %>
            <script>alert("User does not exist.")</script>
            <%
            return;
        }
		out.print("<script>\n" +
                "   // Create link to be clicked\n" +
                "   var link = document.createElement('a');\n" +
                "   link.href = \"EditUser.jsp?username=" + username + "\";\n" +
                "   document.body.appendChild(link)\n" +
                "   link.click()\n" +
                "</script>");
		
	}
	
	if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("removeBid")!=null)) {
		String username = request.getParameter("bidUser").trim();
		String listingID = request.getParameter("listingID").trim();
		
		
		if(!bidController.removeBid(listingID, username)) {
            %>
            <script>alert("Invalid bid removal.")</script>
            <%
            return;
        }
		
		response.sendRedirect("CustRepPanel.jsp");
	}
	
	
	if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("passChange")!=null)) {
		String username = request.getParameter("change_user").trim();
		String newPassword = request.getParameter("new_pass").trim();
		
		
		if(!signUpController.changePassword(username, newPassword)) {
            %>
            <script>alert("Invalid password change.")</script>
            <%
            return;
        }
		
		response.sendRedirect("CustRepPanel.jsp");
	}
	
	%>
</body>
</html>
