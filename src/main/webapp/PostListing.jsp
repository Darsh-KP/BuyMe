<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Listing</title>
    <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
</head>
<body>
    <div>
        <h1>Post Your Item!</h1>
        
        <form action="PostListing.jsp" method="POST" onsubmit="return validatePrices()">
            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            
            <div>
                <label for="productDescription">Description:</label>
                <textarea id="productDescription" name="productDescription" required></textarea>
            </div>
            
             <div>
			    <label for="subcategory">SubCategory:</label>
			    <select id="subcategory" name="subcategory" required>
			        <option value="">--Please choose an option--</option>
			        <% 
			            List<String> subCategories = postListingController.getAllSubCategories();
			            for(String subCategory : subCategories) { 
			        %>
			                <option value="<%= subCategory %>"><%= subCategory %></option>
			        <%
			            }
			        %>
			    </select>
			</div>
            
            <div>
                <label for="initialPrice">Initial Price: $</label>
                <input type="number" id="initialPrice" name="initialPrice" required min="0" step="0.01">
            </div>
            
            <div>
                <label for="minSellPrice">Minimum Sell Price: $</label>
                <input type="number" id="minSellPrice" name="minSellPrice" required min="0" step="0.01">
            </div>
            
            <div>
                <label for="minBidIncrement">Minimum Bid Increment: $</label>
                <input type="number" id="minBidIncrement" name="minBidIncrement" required min="0" step="0.01">
            </div>
            
          <!-- IMAGE IF WE FIGURE IT OUT :DD   
            <div class="form-group">
                <label for="productImages">Upload Images:</label>
                <input type="file" id="productImages" name="productImages[]" accept="image/*" multiple>
            </div>
           -->  
           
            <div>
                <label for="listingCloseDateTime">Listing Close Time:</label>
                <input type="datetime-local" id="listingCloseDateTime" name="listingCloseDateTime" required>
            </div>
            
            <button type="submit">Post Product</button>
        </form>
    </div>

    <script>
    function validatePrices() {
        var initialPrice = document.getElementById('initialPrice').value;
        var minSellPrice = document.getElementById('minSellPrice').value;
        if (parseFloat(minSellPrice) <= parseFloat(initialPrice)) {
            alert("Minimum Sell Price must be higher than the Initial Price.");
            return false; // Prevent form submission
        }
        return true; // Allow form submission
    }
    </script>

<%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Get listing information from form
        String productName = request.getParameter("productName").trim();
        String productDescription = request.getParameter("productDescription").trim();
        String subcategory = request.getParameter("subcategory").trim();
        double initialPrice = Double.parseDouble(request.getParameter("initialPrice"));
        double minSellPrice = Double.parseDouble(request.getParameter("minSellPrice"));
        double minBidIncrement = Double.parseDouble(request.getParameter("minBidIncrement"));
        String listingCloseDateTimeString = request.getParameter("listingCloseDateTime");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
        LocalDateTime listingCloseDateTime = LocalDateTime.parse(listingCloseDateTimeString, formatter);

        // Get derived information
        LocalDateTime listingPostDateTime = LocalDateTime.now();
        String sellerUsername = session.getAttribute("user").toString();

        // Attempt new post
        if (!postListingController.attemptPost(productName, productDescription, subcategory, initialPrice,
                minSellPrice, minBidIncrement, listingCloseDateTime, listingPostDateTime, sellerUsername)) {
            // Failed to post listing
            %>
            <script>alert("Failed to post listing.")</script>
            <%
            return;
        }

        // Listing created
        %>
        <script>alert("New Listing Posted!")</script>
        <%
        }
%>
</body>
</html>
  