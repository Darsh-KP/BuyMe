<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product List</title>
    <link rel="stylesheet" href="Listings.css">
    <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
</head>
<body>
    <nav>
        <div class="logo">
            <img src="./data/LogoFinal.png" alt="Marketplace Central Logo">
        </div>
        <div class="nav-links">
            <a href="Home.jsp">Home</a>
            <a href="">Tickets</a>
            <a href="">Listings</a>
            <a href="">Wishlist</a>
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

    <div class="content">
        <header>
            <h1>Listings</h1>
        </header>

        <!-- Side Filter Panel -->
        <div class="sidebar">
            <h2>Filter Options</h2>
            <div class="filter-option">
                <div class="filter-title">
                    <label for="category">Category: Clothes</label>
                </div>
                
                <div>
                    <input type="checkbox" id="category1" name="category1">
                    <label for="category1">Shirts</label><br>
                    <input type="checkbox" id="category2" name="category2">
                    <label for="category2">Pants</label><br>
                    <input type="checkbox" id="category3" name="category3">
                    <label for="category3">Hats</label>
                </div>
            </div>
            <div class="filter-option">
                <label for="price">Price:</label>
                <select id="price">
                    <option value="asc">Low to High</option>
                    <option value="desc">High to Low</option>
                </select>

                <div class="price-inputs">
                    <span class="currency">$</span>
                    <input type="text" id="minPrice" name="minPrice" placeholder="Min">
                    <span class="dash">-</span>
                    <span class="currency">$</span>
                    <input type="text" id="maxPrice" name="maxPrice" placeholder="Max">
                </div>
            </div>
            <div class="filter-option">
                <label for="status">Status:</label>
                <select id="status">
                    <option value="all">All</option>
                    <option value="available">In Progress</option>
                    <option value="sold">Sold</option>
                    <!-- Add more status options here -->
                </select>
            </div>

            <div class="filter-buttons">
                <button type="button" id="resetButton" class="reset-button">Reset</button>
                <button type="submit" id="submitButton" class="submit-button">Submit ></button>
            </div>

        </div>

        <!-- main sections  -->
        <div class="main-content">
            <!-- trending card section  -->
            <section>
                <div class="sub-section-hdr">
                    <h2>Trending Items</h2>
                    <img src="./data/TrendingLogo.png" alt="Logo" class="trending-logo">
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

                    <!-- individual product card-->
                    <div class="trending-product-card">
                        <a href="product-page.html">
                            <div class="product-title">Name</div>
                            <div class="trending-product-image"></div>
                            <div class="product-price">Price</div>
                        </a>
                    </div>
                </div>
            </section>

            <!-- all product card section-->
            <section>
                <div class="sub-section-hdr">
                    <h2>All Items</h2>
                </div>


                <!-- Section that displays all product card-->
                <div class="product-list-container">
                    <!-- Populate all listings from the database-->
                    <%
                        // Get all products to display
                        List<HashMap<String, String>> allProductDisplays = listingsController.getAllListingsDisplayStrings();

                        // If none are returned, nothing to display
                        if (allProductDisplays == null) return;

                        // Debug
                        if (myDatabase.debug) System.out.println("Loading product cards...");
                        
                        // Display each product
                        for (HashMap<String, String> productDisplay : allProductDisplays) {
                            out.print("<div class=\"product-card\" data-product-id=\"" + productDisplay.get("productId") + "\" onclick=\"productCardClicked()\">\n" +
                                    "   <div class=\"product-title\">" + productDisplay.get("productName") + "</div>\n" +
                                    "   <div class=\"product-image\"></div>\n" +
                                    "   <div class=\"product-price\">" + productDisplay.get("priceDisplay") + "</div>\n" +
                                    "   <div class=\"product-endtime\">" + productDisplay.get("dateDisplay") + "</div>\n" +
                                    "   <div class=\"product-status\">" + productDisplay.get("statusDisplay") + "</div>\n" +
                                    "</div>");
                        }
                    %>

                    <!-- button to add a new product -->
                    <a href="PostListing.jsp">
                        <button class="add-product-button">Create a Listing</button>
                    </a>
                </div>
            </section>
        </div>
    </div>
</body>
</html>