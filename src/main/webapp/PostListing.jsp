<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Listing</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <div class="container">
        <h1>Post Your Item!</h1>
        
        <form action="PostListing.jsp" method="POST" enctype="multipart/form-data" onsubmit="return validatePrices()">
            
        <div class="form-group">
                <label for="productName">Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>
            
            <div class="form-group">
                <label for="productDescription">Description:</label>
                <textarea id="productDescription" name="productDescription" required></textarea>
            </div>
            
             <div class="form-group">
                <label for="subcategory">SubCategory:</label>
                <select id="subcategory" name="subcategory" required>
                    <option value="">--Please choose an option--</option>
                    <option value="SubCat1">temp1</option>
                    <option value="SubCat2">temp2</option>
                    <option value="SubCat3">temp3</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="initialPrice">Initial Price: $</label>
                <input type="number" id="initialPrice" name="initialPrice" required min="0" step="0.01">
            </div>
            
            <div class="form-group">
                <label for="minSellPrice">Minimum Sell Price: $</label>
                <input type="number" id="minSellPrice" name="minSellPrice" required min="0" step="0.01">
            </div>
            
            <div class="form-group">
                <label for="minBidIncrement">Minimum Bid Increment: $</label>
                <input type="number" id="minBidIncrement" name="minBidIncrement" required min="0" step="0.01">
            </div>
            
          <!-- IMAGE IF WE FIGURE IT OUT :DD   
            <div class="form-group">
                <label for="productImages">Upload Images:</label>
                <input type="file" id="productImages" name="productImages[]" accept="image/*" multiple>
            </div>
           -->  
           
            <div class="form-group">
                <label for="listingCloseTime">Listing Close Time:</label>
                <input type="datetime-local" id="listingCloseTime" name="listingCloseTime" required>
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
    
</body>
</html>
<%
    // Check if the form was submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            try {
                String prodName = request.getParameter("productName");
                String prodDesc = request.getParameter("productDescription");
                String subCat = request.getParameter("subcategory");
                Double initialPrice = Double.parseDouble(request.getParameter("initialPrice"));
                Double minSellPrice = Double.parseDouble(request.getParameter("minSellPrice"));
                Double minBidIncrement = Double.parseDouble(request.getParameter("minBidIncrement"));
                String listingCloseTimeString = request.getParameter("listingCloseTime");
                Timestamp listingCloseTime = Timestamp.valueOf(listingCloseTimeString.replace("T", " ") + ":00");
                
                
                if (!PostListingController.attemptPost(prodName, prodDesc, subCat, initialPrice, minSellPrice, minBidIncrement, listingCloseTime)) {
                    %>
                    <script>alert("failed to post listing")</script>
                    <%
                    return;
                }

                // Assuming here you would insert these into your database
                // Example database operation omitted for brevity
            } catch (NumberFormatException e) {
                e.printStackTrace();
            } catch (IllegalArgumentException e) {
            	e.printStackTrace();
            } catch (Exception e) {
            	e.printStackTrace();
            }
            
            
            
        }
    %>
</body>
</html>
  