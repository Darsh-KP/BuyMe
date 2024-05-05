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
<%@ page import="java.util.HashMap" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
    }
%>

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
                <input type="file" id="productImage" name="productImage" accept="image/png, image/jpeg, image/jpg" required>
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

            <div>
                <label>Attributes:</label>
                <button onclick="addAttribute()">Add New</button><br>

                <div id="attributeInputs">
                    <%
                        // Get default attributes
                        HashMap<String, ArrayList<String>> defaultAttributes = postListingController.getDefaultAttributes();

                        for (String attributeKey : defaultAttributes.keySet()) {
                            // Print an input box for attribute key which is disabled
                            out.print("<input type=\"text\" name=\"attributeKey\" value=\"" + attributeKey + "\" disabled>");

                            // If there are no values for this key, have an input box
                            if (defaultAttributes.get(attributeKey) == null) {
                                out.print("<input type=\"text\" name=\"attributeValue\" placeholder=\"Value\" required maxlength=\"100\">");
                                continue;
                            }

                            // Otherwise create a dropdown with the values
                            out.print("<select type=\"text\" name=\"attributeValue\" required>");
                            out.print("<option value=\"\">--Choose an option--</option>");

                            // Autofill the dropdown options
                            for (String attributeValue : defaultAttributes.get(attributeKey)) {
                                out.print("<option value=\"" + attributeValue + "\">" + attributeValue + "</option>");
                            }

                            out.print("</select>");
                        }
                    %>
                </div>

                <script>
                    function addAttribute() {
                        const attributeInputs = document.getElementById('attributeInputs');

                        // Create container div for new attribute input
                        const inputContainer = document.createElement('div');

                        // Create input for attribute key
                        const keyInput = document.createElement('input');
                        keyInput.type = 'text';
                        keyInput.name = "attributeKey";
                        keyInput.placeholder = 'Attribute Key';
                        keyInput.required = true;
                        keyInput.maxLength = 100;

                        // Create input for attribute value
                        const valueInput = document.createElement('input');
                        valueInput.type = 'text';
                        valueInput.name = "attributeValue";
                        valueInput.placeholder = 'Attribute Value';
                        valueInput.required = true;
                        keyInput.maxLength = 100;

                        // Create button to remove this input
                        const removeButton = document.createElement('button');
                        removeButton.textContent = 'Remove';
                        removeButton.onclick = function() {
                            removeAttribute(removeButton);
                        };

                        // Append inputs and remove button to container div
                        inputContainer.appendChild(keyInput);
                        inputContainer.appendChild(valueInput);
                        inputContainer.appendChild(removeButton);

                        // Append container div to main container
                        attributeInputs.appendChild(inputContainer);
                    }

                    function removeAttribute(button) {
                        const inputContainer = button.parentElement;
                        inputContainer.remove();
                    }
                </script>
            </div>

            <button type="submit" name="post_list_button">Post Product</button>
        </form>
    </div>
    <script>
        function validateForm() {
            if (!validatePrices()) return false;
            if (!validateDates()) return false;
            enableKeyInputs();

            return true;
        }

        function validatePrices() {
            var initialPrice = document.getElementById('initialPrice').value;
            var minSellPrice = document.getElementById('minSellPrice').value;
            if (parseFloat(minSellPrice) < parseFloat(initialPrice)) {
                alert("Minimum Sell Price must be higher than or equal to the Initial Price.");
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

        function enableKeyInputs () {
            var keyInputs = document.getElementsByName("attributeKey");
            for (var i = 0; i < keyInputs.length; i++) {
                keyInputs[i].disabled = false;
            }
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
  