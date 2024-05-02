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

            <div class="search-two">
                <input type="text" placeholder="Search Listing...">
                <button>Submit</button>
            </div>

        </header>

        <div class="sidebar">
            <h2>Filter Options</h2>
            
            <!-- Sort Dropdown -->
            <div class="filter-option">
                <label for="sort">Sort By:</label>
                <select id="sort">
                    <option value="price_asc">Price (Low to High)</option>
                    <option value="price_desc">Price (High to Low)</option>
                    <option value="name_asc">Name (A-Z)</option>
                    <option value="name_desc">Name (Z-A)</option>
                    <option value="earliest_close">Earliest Close Date</option>
                    <option value="nearest_start">Nearest Start Date</option>
                </select>
            </div>
            
            <!-- Size Filter -->
            <div class="filter-option">
                <label>Size:</label>
                <div class="dropdown">
                    <button class="dropbtn">&#9660;</button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="size" value="S"> Small</label>
                        <label><input type="checkbox" name="size" value="M"> Medium</label>
                        <label><input type="checkbox" name="size" value="L"> Large</label>
                    </div>
                </div>
            </div>
            
            <!-- Color Filter -->
            <div class="filter-option">
                <label>Color:</label>
                <div class="dropdown">
                    <button class="dropbtn">&#9660;</button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="color" value="red"> Red</label>
                        <label><input type="checkbox" name="color" value="blue"> Blue</label>
                        <label><input type="checkbox" name="color" value="black"> Black</label>
                    </div>
                </div>
            </div>
            
            <!-- Category Filter -->
            <div class="filter-option">
                <label>Category:</label>
                <div class="dropdown">
                    <button class="dropbtn">&#9660;</button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="category" value="shirt"> Shirt</label>
                        <label><input type="checkbox" name="category" value="pant"> Pant</label>
                        <label><input type="checkbox" name="category" value="hat"> Hat</label>
                    </div>
                </div>
            </div>
            
            <!-- Material Filter -->
            <div class="filter-option">
                <label>Material:</label>
                <div class="dropdown">
                    <button class="dropbtn">&#9660;</button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="material" value="cotton"> Cotton</label>
                        <label><input type="checkbox" name="material" value="synthetic"> Synthetic</label>
                    </div>
                </div>
            </div>
            
            <!-- Status Filter -->
            <div class="filter-option">
                <label>Status:</label>
                <div class="dropdown">
                    <button class="dropbtn">&#9660;</button>
                    <div class="dropdown-content">
                        <label><input type="checkbox" name="status" value="available"> Available</label>
                        <label><input type="checkbox" name="status" value="in_progress"> In Progress</label>
                        <label><input type="checkbox" name="status" value="closed"> Closed</label>
                    </div>
                </div>
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
                            out.print("<div class=\"product-card\" data-product-id=\"" + productDisplay.get("productId") + "\" onclick=\"productCardClicked(this)\">\n" +
                                    "   <div class=\"product-title\">" + productDisplay.get("productName") + "</div>\n" +
                                    "   <div class=\"product-image\">\n" +
                                    "       <img src=\"data:" + productDisplay.get("imageMime") + ";base64," + productDisplay.get("imageDataString") + "\">\n" +
                                    "   </div>\n" +
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

    <script>
        function productCardClicked(element) {
            // Get productID from the card that was clicked
            var productID = element.getAttribute('data-product-id');

            // Create form in order to POST id
            var form = document.createElement("form");
            form.setAttribute("method", "post");
            form.setAttribute("action", "ViewListing.jsp");

            // Attach productID
            var input = document.createElement("input");
            input.setAttribute("type", "hidden");
            input.setAttribute("name", "productID");
            input.setAttribute("value", productID);

            // Submit Form
            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    </script>

<%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        %>
            <script>alert("New Listing Posted!")</script>
        <%
    }
%>
</body>
</html>