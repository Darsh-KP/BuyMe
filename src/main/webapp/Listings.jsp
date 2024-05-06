<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
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
%>

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

    <div class="content">
        <header>
            <h1>Listings</h1>

            <form class="search-two" method="get" action="Listings.jsp">
                <input type="text" placeholder="Search Keyword..." name="search_keyword">
                <input type="submit" value="Search" name="search_submit_button">
            </form>

        </header>

        <form class="sidebar" method="get" action="Listings.jsp">
            <h2>Filter Options</h2>
            
            <!-- Sort Dropdown -->
            <div class="filter-option">
                <label for="sort">Sort By:</label>
                <select id="sort" name="sort">
                    <option value="name_asc">Name (A-Z)</option>
                    <option value="name_desc">Name (Z-A)</option>
                    <option value="price_asc">Initial Price (Low-High)</option>
                    <option value="price_desc">Initial Price (High-Low)</option>
                </select>
            </div>

            <!-- Category Filter -->
            <div class="filter-option">
                <label>Category:</label>
                <div class="dropdown-fltr">
                    <div class="dropbtn-fltr">&#9660;</div>
                    <div class="dropdown-content-fltr">
                        <%
                            List<String> allSubCategories = postListingController.getAllSubCategories();
                            for (String subCategory : allSubCategories) {
                                out.print("<label><input type=\"checkbox\" name=\"category\" value=\"" + subCategory + "\">" + subCategory + "</label>");
                            }
                        %>
                    </div>
                </div>
            </div>
            
            <!-- Attribute Filter -->
            <%
                HashMap<String, ArrayList<String>> allCurrentAttributes = listingsController.getCurrentAttributes();
                for (String attributeKey : allCurrentAttributes.keySet()) {
                    out.print("<div class=\"filter-option\">\n" +
                            "   <label>" + attributeKey + ":</label>\n" +
                            "   <div class=\"dropdown-fltr\">\n" +
                            "       <div class=\"dropbtn-fltr\">&#9660;</div>\n" +
                            "       <div class=\"dropdown-content-fltr\">");

                    for (String attributeValue : allCurrentAttributes.get(attributeKey)) {
                        out.print("<label><input type=\"checkbox\" name=\"" + attributeKey + "\" value=\"" + attributeValue + "\">" + attributeValue + "</label>");
                    }

                    out.print("     </div>\n" +
                            "   </div>\n" +
                            "</div>");
                }
            %>

            <div class="filter-buttons">
                <button type="button" id="resetButton" class="reset-button" onclick="window.location.href='Listings.jsp';">Reset</button>
                <input type="submit" id="submitButton" class="submit-button" value="Submit" name="filter_submit_button">
            </div>

        </form>

        <!-- main sections  -->
        <div class="main-content">
            <!-- trending card section  -->
            <section>
                <div class="sub-section-hdr">
                    <h2>Trending Items</h2>
                    <img src="./data/TrendingLogo.png" alt="Logo" class="trending-logo">
                </div>

                <div class="trending-product-list-container">
                    <!-- individual product card-->
                    <%
                        // Get all products to display
                        List<HashMap<String, String>> trendingProductDisplays = listingsController.getTrendingListingsDisplayStrings();

                        // If none are returned, nothing to display
                        if (trendingProductDisplays != null) {
                            // Debug
                            if (myDatabase.debug) System.out.println("Loading trending cards...");

                            // Display each product
                            for (HashMap<String, String> productDisplay : trendingProductDisplays) {
                                out.print("<div class=\"trending-product-card\">\n" +
                                        "   <a href=\"ViewListing.jsp?productID=" + productDisplay.get("productId") + "\">\n" +
                                        "       <div class=\"product-title\">" + productDisplay.get("productName") + "</div>\n" +
                                        "       <div class=\"trending-product-image\">\n" +
                                        "           <img src=\"data:" + productDisplay.get("imageMime") + ";base64," + productDisplay.get("imageDataString") + "\">\n" +
                                        "       </div>\n" +
                                        "       <div class=\"product-price\">" + productDisplay.get("priceDisplay") + "</div>\n" +
                                        "   </a>\n" +
                                        "</div>");
                            }
                        }
                    %>
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
                        // String to store filter, if applicable
                        String criteria = "";

                        // Check is a keyword is searched
                        if ((request.getMethod().equalsIgnoreCase("GET")) && (request.getParameter("search_submit_button") != null)) {
                            if (request.getParameter("search_keyword") != null) {
                                if (!request.getParameter("search_keyword").equals("")) {
                                    criteria = "where product_name like \"%" + request.getParameter("search_keyword") + "%\" ";
                                }
                            }
                        }
                        // Check if criteria was passed
                        else if ((request.getMethod().equalsIgnoreCase("GET")) && (request.getParameter("filter_submit_button") != null)) {
                            // Check and add category filter
                            if (request.getParameterValues("category") != null) {
                                criteria += " and (false ";

                                // Get all the selected categories
                                String[] selectedCategories = request.getParameterValues("category");
                                for (String selectedCategory : selectedCategories) {
                                    criteria += "or subcategory = \"" + selectedCategory + "\"";
                                }
                                criteria += " ) ";
                            }

                            // Check for and add each filter option
                            for (String attributeKey : allCurrentAttributes.keySet()) {
                                // Check and add category filter
                                if (request.getParameterValues(attributeKey) != null) {
                                    criteria += " and (false ";

                                    // Get all the selected categories
                                    String[] selectedValues = request.getParameterValues(attributeKey);
                                    for (String selectedValue : selectedValues) {
                                        criteria += "or (attribute_key = \"" + attributeKey + "\" and attribute_value = \"" + selectedValue + "\") ";
                                    }
                                    criteria += " ) ";
                                }
                            }

                            // Check if there is any sorting that is required
                            if (request.getParameter("sort") != null) {
                                switch (request.getParameter("sort")) {
                                    case ("name_asc"):
                                        criteria += " order by product_name asc ";
                                        break;
                                    case ("name_desc"):
                                        criteria += " order by product_name desc ";
                                        break;
                                    case ("price_asc"):
                                        criteria += " order by initial_price asc ";
                                        break;
                                    case ("price_desc"):
                                        criteria += " order by initial_price desc ";
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }

                        // Get all products to display
                        List<HashMap<String, String>> allProductDisplays = listingsController.getAllListingsDisplayStrings(criteria);

                        // If none are returned, nothing to display
                        if (allProductDisplays != null) {
                            // Debug
                            if (myDatabase.debug) System.out.println("Loading product cards...");

                            // Display each product
                            for (HashMap<String, String> productDisplay : allProductDisplays) {
                                out.print("<a class=\"product-card\" href=\"ViewListing.jsp?productID=" + productDisplay.get("productId") + "\">\n" +
                                        "   <div class=\"product-title\">" + productDisplay.get("productName") + "</div>\n" +
                                        "   <div class=\"product-image\">\n" +
                                        "       <img src=\"data:" + productDisplay.get("imageMime") + ";base64," + productDisplay.get("imageDataString") + "\">\n" +
                                        "   </div>\n" +
                                        "   <div class=\"product-price\">" + productDisplay.get("priceDisplay") + "</div>\n" +
                                        "   <div class=\"product-endtime\">" + productDisplay.get("dateDisplay") + "</div>\n" +
                                        "   <div class=\"product-status\">" + productDisplay.get("statusDisplay") + "</div>\n" +
                                        "</a>");
                            }
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

<%
    // Check if the form was submitted
    if ((request.getMethod().equalsIgnoreCase("POST")) && (request.getParameter("post_list_button") != null)) {
        %>
            <script>alert("New Listing Posted!")</script>
        <%
    }
%>
</body>
</html>