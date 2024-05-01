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


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Listing</title>
    <link rel="stylesheet" href="PostListing.css">
    <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
</head>
<body>
  

  
  
    <div class = "container">
        <h1>Post Your Item!</h1>
        
        <form action="PostListingServlet" method="POST" onsubmit="return validateForm()" enctype="multipart/form-data">
            <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            
            <div>
                <label for="productDescription">Description:</label>
                <textarea id="productDescription" name="productDescription" required></textarea>
            </div>

            <div>
                <label for="productImage">Upload Images:</label>
                <input type="file" id="productImage" name="productImage" accept="image/*" required>
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

            <div>
                <label for="listingStartDateTime">Listing Start Time:</label>
                <input type="datetime-local" id="listingStartDateTime" name="listingStartDateTime" required>
            </div>
           
            <div>
                <label for="listingCloseDateTime">Listing Close Time:</label>
                <input type="datetime-local" id="listingCloseDateTime" name="listingCloseDateTime" required>
            </div>

            <button type="submit">Post Product</button>
        </form>
    </div>
    <script>
        function validateForm() {
            if (!validatePrices()) return false;
            if (!validateDates()) return false;

            return true;
        }

        function validatePrices() {
            var initialPrice = document.getElementById('initialPrice').value;
            var minSellPrice = document.getElementById('minSellPrice').value;
            if (parseFloat(minSellPrice) <= parseFloat(initialPrice)) {
                alert("Minimum Sell Price must be higher than the Initial Price.");
                return false; // Prevent form submission
            }
            return true; // Allow form submission
        }

        function validateDates() {
            var startTime = new Date(document.getElementById("listingStartDateTime").value);
            var closeTime = new Date(document.getElementById("listingCloseDateTime").value);

            if (closeTime <= startTime) {
                alert("Listing Close Time must be after Listing Start Time.");
                return false;
            }
            return true;
        }
    </script>

<%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Get status of posting
        String postStatus = request.getParameter("postStatus");

        // Attempt new post
        if (postStatus.equals("failed")) {
            // Failed to post listing
            %>
            <script>alert("Failed to post listing.")</script>
            <%
            return;
        }

        // Listing created
        %>
        <script>
            // Create form in order to POST success
            var form = document.createElement("form");
            form.setAttribute("method", "post");
            form.setAttribute("action", "Listings.jsp")

            // Submit Form
            document.body.appendChild(form);
            form.submit();
        </script>
        <%
    }
%>
</body>
</html>
  