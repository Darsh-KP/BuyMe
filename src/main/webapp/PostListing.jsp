

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
                <input type="number" id="initialPrice" name="initialPrice" required min="0" step="1.00" required autofocus maxlength="20">

            </div>
            
            <div>
                <label for="minSellPrice">Minimum Sell Price: $</label>
                <input type="number" id="minSellPrice" name="minSellPrice" required min="0" step="1.00">
            </div>
            
            <div>
                <label for="minBidIncrement">Minimum Bid Increment: $</label>
                <input type="number" id="minBidIncrement" name="minBidIncrement" required min="0" step="1.00">
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

</body>
</html>
  