<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<%
    notificationsController.checkListingWinners();
    String id = request.getParameter("productID");
    HashMap<String, String> cardInfo = viewListingController.getCardInfo(id);
 %> 

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%out.print(cardInfo.get("productName"));%></title>
    <link rel="stylesheet" href="ViewListing.css">

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
        <div class="image-container">
            <!-- Placeholder image for candle -->
            <%
                out.print("<img src=\"data:" + cardInfo.get("imageMime") + ";base64," + cardInfo.get("imageDataString") + "\">");
            %>
        </div>
        <div class="product-details">
            <div class="title"><%out.print(cardInfo.get("productName"));%></div> 
            <div class="description"><%out.print(cardInfo.get("description"));%></div>
            <div class="seller-info">
                <span><%out.print(cardInfo.get("seller_username"));%></span><br>
            </div>
            <div class="price"><%out.print(cardInfo.get("price"));%></div>
            <div>
                Attributes:
                <%
                    List<HashMap<String, String>> productAttributes = viewListingController.getProductAttributes(id);
                    for (HashMap<String, String> attribute : productAttributes) {
                        out.print("<br>" + attribute.get("attributeKey") + ": " + attribute.get("attributeValue"));
                    }
                %>
            </div>
        </div>
    </div>

    <div class="listing-info-container">
        <div class="listing-info">
            <div class="dates-container">
                <div class="listing-dates">
                    <p>Start: <%out.print(cardInfo.get("startDate"));%></p>
                    <p>Close: <%out.print(cardInfo.get("closeDate"));%></p>
                    <p>Minimum Bidding Increment: US $<%out.print(cardInfo.get("min_bid_increment"));%></p>
                </div>
                <div class="status">
                    <div class="circle green"></div>
                    <div class="text"><%out.print(cardInfo.get("statusDisplay"));%></div>
                </div>
            </div>

            <div class="bidding-container">
                <form method = "post" action = "ViewListing.jsp" class="bid-info"> 
                    <label for="bid">Your Bid:</label>
                    <input type="number" id="bid" name="bid" step="0.01" min = <%
                    int dollarIndex = cardInfo.get("price").indexOf("$");
					double highestBid = Double.parseDouble(cardInfo.get("price").substring(dollarIndex + 1).trim());
					highestBid +=  Double.parseDouble(cardInfo.get("min_bid_increment"));
					out.print(highestBid);
					%> required>
                    <label for="anonymous-bid">Anonymous Bid:</label>
                    <input type="checkbox" id="normal_anonymous_bid" name="normal_anonymous_bid">
                    <input type ="submit" value = "Place Bid" name = "manual_bid_button" class = "button">
                    <input type = "hidden" name = "productID" value = <% out.print(id);%> >
                </form>
                
          
                
                <form method = "post" action = "ViewListing.jsp" class="auto-bidding">
                    <label for="max-bid">Max Bid:</label>
                    <input type="number" id="auto-bid" name="auto-bid" step="0.01" min = <%
                    int autoDollarIndex = cardInfo.get("price").indexOf("$");
					double autoHighestBid = Double.parseDouble(cardInfo.get("price").substring(autoDollarIndex + 1).trim());
					autoHighestBid +=  Double.parseDouble(cardInfo.get("min_bid_increment"));
					out.print(autoHighestBid);
					%> required>
                    <label for="bid-increment">Bid Increment:</label>
                    <input type="number" id="auto-bid-increment" name="auto-bid-increment" step="0.01" min = <%
					double autoIncrementBid = Double.parseDouble(cardInfo.get("min_bid_increment"));
					out.print(autoIncrementBid);
					%> required>
                    <label for="anonymous-bid">Anonymous Bid:</label>
                    <input type="checkbox" id="auto_anonymous_bid" name="auto_anonymous_bid">
                    <input type ="submit" value = "Auto Bid" name = "auto_bid_button" class = "button">
                    <input type = "hidden" name = "productID" value = <% out.print(id);%> >
                </form>
            </div>
        </div>
    </div>

    <!-- History of Bids Section -->
    <div class="history-of-bids">
        <h2>History of Bids</h2>
        <%
            List<String> bidHistoryList = viewListingController.getHistoryOfBids(Integer.parseInt(id));
            for(String bid : bidHistoryList) {
                out.print("<div class=\"bid-item\">\n" +
                          "   <p>" + bid + "</p>\n" +
                          "</div>");
            }
        %>
    </div>

    <!-- Place this code after the main container and before the closing body tag -->
    <div class="subcategories-section">
        <h2 class="subcategories-title">Similar Items</h2>
        <div class="subcategories-container">
            <%
                // Get all attribute values
                List<String> attributeValues = new ArrayList<String>();
                for (HashMap<String, String> attribute : productAttributes) {
                    attributeValues.add(attribute.get("attributeValue"));
                }

                // Get similar items
                List<HashMap<String, String>> similarListings = viewListingController.getSimilarListings(id, cardInfo.get("subcategory"), attributeValues);

                // Display similar products
                for (HashMap<String, String> similarProduct : similarListings) {
                    out.print("<a class=\"subcategory-card shirt\" href=\"ViewListing.jsp?productID=" + similarProduct.get("productId") + "\">\n" +
                            "   <img src=\"data:" + similarProduct.get("imageMime") + ";base64," + similarProduct.get("imageDataString") + "\">\n" +
                            "   <div class=\"subcategory-details\">\n" +
                            "       <div class=\"subcategory-title\">" + similarProduct.get("productName") + "</div>\n" +
                            "       <div class=\"subcategory-price\">" + similarProduct.get("priceDisplay") + "</div>\n" +
                            "   </div>\n" +
                            "</a>");
                }
            %>
        </div>
    </div>

    <%
	//Manual Bidder
    if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("manual_bid_button")!=null)) {
        // Get username, password, and other details
        String username = (String) session.getAttribute("user");
        String product_id = id;
        String bid_amount = request.getParameter("bid");
        boolean checkbox = request.getParameter("normal_anonymous_bid") != null;
        
        if(username.equals(cardInfo.get("seller_username"))){
        	 %>
             <script>alert("Invalid Bid! Cannot Bid on your own Product.")</script>
             <%
        } else{
	        
	        if(!bidController.postBid(username, product_id, bid_amount, checkbox)) {
	            %>
	            <script>alert("Invalid Bid! Check start and end times.")</script>
	            <%
	        }

	        // Refresh the page
	        out.print("<script>\n" +
                    "   // Create link to be clicked\n" +
                    "   var link = document.createElement('a');\n" +
                    "   link.href = \"ViewListing.jsp?productID=" + product_id + "\";\n" +
                    "   document.body.appendChild(link)\n" +
                    "   link.click()\n" +
                    "</script>");
    	} 
 	}
	//Auto Bidder
    else if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("auto_bid_button")!=null)) {
        // Get username, password, and other details
        String username = (String) session.getAttribute("user");
        String product_id = id;
        String max_bid_amount = request.getParameter("auto-bid");
        String bid_increment = request.getParameter("auto-bid-increment");
        boolean checkbox = request.getParameter("auto_anonymous_bid") != null;
        
        
       if(username.equals(cardInfo.get("seller_username"))){
       	 %>
            <script>alert("Invalid Bid! Cannot Bid on your own Product.")</script>
            <%
       } else{
    	   
       
        if(!bidController.autoBid(username, product_id, max_bid_amount, bid_increment, checkbox)) {
            %>
            <script>alert("Invalid Bid! Check start and end times.")</script>
            <%
        }

        // Refresh the page
        out.print("<script>\n" +
                "   // Create link to be clicked\n" +
                "   var link = document.createElement('a');\n" +
                "   link.href = \"ViewListing.jsp?productID=" + product_id + "\";\n" +
                "   document.body.appendChild(link)\n" +
                "   link.click()\n" +
                "</script>");
       }
    }
%>

</body>
</html>
