<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
<%
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
    <nav>
        <div class="logo">
            <img src="./data/LogoFinal.png" alt="Marketplace Central Logo">
        </div>
        <div class="nav-links">
            <a href="#">Home</a>
            <a href="#">Tickets</a>
            <a href="#">Listings</a>
            <a href="#">Wishlist</a>
        </div>
        <div class="profile">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
            <a href="#">Notifications</a>
            <a href="#" class="logout-button">Log Out</a>
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
            <div class="buttons">
                <button class="button"><span class="heart-icon">&#9825;</span> Add to Wishlist</button>
            </div>
        </div>
    </div>

    <div class="listing-info-container">
        <div class="listing-info">
            <div class="dates-container">
                <div class="listing-dates">
                    <p>Start Date: <%out.print(cardInfo.get("postDate"));%></p>
                    <p>Close Date: <%out.print(cardInfo.get("closeDate"));%></p>
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
					%>>
                    <label for="anonymous-bid">Anonymous Bid:</label>
                    <input type="checkbox" id="normal_anonymous_bid" name="normal_anonymous_bid">
                    <input type ="submit" value = "Place Bid" name = "manual_bid_button">
                    <input type = "hidden" name = "productID" value = <% out.print(id);%> >
                </form>
                
          
                
                <div class="auto-bidding">
                    <label for="max-bid">Max Bid:</label>
                    <input type="number" id="max-bid" name="max-bid" min="20.99" step="1.00">
                    <label for="bid-increment">Bid Increment:</label>
                    <input type="number" id="bid-increment" name="bid-increment" min="1.00" step="1.00">
                    <label for="anonymous-bid">Anonymous Bid:</label>
                    <input type="checkbox" id="auto_anonymous-bid" name="anonymous-bid">
                    <button onclick="autoBid()" class="button">Auto Bid</button>
                </div>
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
            <div class="subcategory-card shirt">
                <img src="./data/RUshirt.jpg" alt="Shirts">
                <div class="subcategory-details">
                    <div class="subcategory-title">Men's Shirts</div>
                    <div class="subcategory-price">$29.99</div>
                </div>
            </div>
            <div class="subcategory-card pant">
                <img src="./data/RUpants.jpg" alt="Pants">
                <div class="subcategory-details">
                    <div class="subcategory-title">Men's Pants</div>
                    <div class="subcategory-price">$39.99</div>
                </div>
            </div>
        </div>
    </div>
    
<%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("manual_bid_button")!=null)) {
        // Get username, password, and other details
        String username = (String) session.getAttribute("user");
        String product_id = id;
        String bid_amount = request.getParameter("bid");
        boolean checkbox = request.getParameter("normal_anonymous_bid") != null;
        System.out.print(bid_amount);
        
        viewListingController.postBid(username, product_id, bid_amount, checkbox);

        // Refresh the page
        out.print("<script>\n" +
                "    // Create form in order to POST id\n" +
                "    var form = document.createElement(\"form\");\n" +
                "    form.setAttribute(\"method\", \"post\");\n" +
                "    form.setAttribute(\"action\", \"ViewListing.jsp\");\n" +
                "\n" +
                "    // Attach productID\n" +
                "    var input = document.createElement(\"input\");\n" +
                "    input.setAttribute(\"type\", \"hidden\");\n" +
                "    input.setAttribute(\"name\", \"productID\");\n" +
                "    input.setAttribute(\"value\", " + id + ");\n" +
                "\n" +
                "    // Submit Form\n" +
                "    form.appendChild(input);\n" +
                "    document.body.appendChild(form);\n" +
                "    form.submit();\n" +
                "</script>");
    }
%>

</body>
</html>
