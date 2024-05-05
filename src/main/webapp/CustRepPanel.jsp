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


<body>
    <div class="container">
        <h2>Customer Representative Panel</h2>
        <div class="form-group">
        <form method = "post" action = "CustRepPanel.jsp" class="bid-info"> 
            <label for="searchListing">Search User:</label>
            <input type="text" id="searchUser" name="searchUser">
           <input type ="submit" value = "Remove Listing" name = "remove_listing" class = "button">
        </form>
            
            
            <a href="EditUser.html"><button>Edit User</button></a>
        </div>
        <div class="form-group">
            <label for="searchBidId">Search BidID:</label>
            <input type="text" id="searchBidId" name="searchBidId">
            <button>Remove Bid</button>
        </div>
        
        <!-- Remove Listing -->
        <form method = "post" action = "CustRepPanel.jsp" class="bid-info"> 
            <label for="searchListing">Search Listing:</label>
            <input type="text" id="searchListing" name="searchListing">
           <input type ="submit" value = "Remove Listing" name = "remove_listing" class = "button">
        </form>
        
        <div class="center">
            <div class="form-group">
                <a href="CustRepTickets.html"><button>View Tickets</button></a>
            </div>
        </div>
    </div>

	<%
	
	if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("remove_listing")!=null)) {
		String productID = request.getParameter("searchListing");
		int product_id = Integer.parseInt(productID);
		
		if(!listingsController.removeListing(product_id)) {
            %>
            <script>alert("Listing could not be removed.")</script>
            <%
            return;
        }
		response.sendRedirect("CustRepPanel.jsp");
		
	}
	
	%>
</body>
</html>
