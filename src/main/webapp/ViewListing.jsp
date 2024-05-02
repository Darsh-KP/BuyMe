<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
<%
String id = request.getParameter("productID");
 HashMap<String, String> cardInfo = viewListingController.getCardinfo(id);
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
        <div class="search">
            <input type="text" placeholder="Search...">
            <button>Search</button>
        </div>
        <div class="profile">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
            <a href="#">View Your Profile</a>
        </div>
    </nav>

    <div class="container">
        <div class="image-container">
            <!-- Placeholder image for candle -->
            <img src="./data/RUhat.jpg" alt="Mainstays Vanilla Scented Single-Wick Large Jar Candle">
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
                <div class="bid-info"> 
                    <label for="bid">Your Bid:</label>
                    <input type="number" id="bid" name="bid" min="20.99" step="1.00">
                    <button onclick="placeBid()" class="button">Place Bid</button>
                </div>
          
                <div class="auto-bidding">
                    <label for="max-bid">Max Bid:</label>
                    <input type="number" id="max-bid" name="max-bid" min="20.99" step="1.00">
                    <label for="bid-increment">Bid Increment:</label>
                    <input type="number" id="bid-increment" name="bid-increment" min="1.00" step="1.00">
                    <label for="anonymous-bid">Anonymous Bid:</label>
                    <input type="checkbox" id="anonymous-bid" name="anonymous-bid">
                </div>
            </div>
        </div>
    </div>





    <!-- History of Bids Section -->
    <div class="history-of-bids">
        <h2>History of Bids</h2>
        <div class="bid-item">
            <p>John Doe - April 28, 2024 - $21.99</p>
        </div>
        <div class="bid-item">
            <p>Jane Smith - April 27, 2024 - $20.99</p>
        </div>
        <div class="bid-item">
            <p>Zeel Patel - April 29, 2024 - $22.99</p>
        </div>
        <div class="bid-item">
            <p>Omar Elhatab - April 30, 2024 - $10.99</p>
        </div>
        <div class="bid-item">
            <p>Darsh Patel - April 27, 2024 - $20.99</p>
        </div>
        <div class="bid-item">
            <p>Sweta Desai - April 28, 2024 - $23.99</p>
        </div>
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

    <div class="product-list-container">
        <!-- individual product card-->
        <div class="trending-product-card">
            <a href="product-page.html">
                <div class="product-title">Name</div>
                <div class="trending-product-image"></div>
                <div class="product-price">Price</div>
            </a>
        </div>
    </div>

</body>
</html>
