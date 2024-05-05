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
<%@ page import="com.buyme.database.*" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Wishlist</title>
    <link rel="stylesheet" href="PostWishlist.css">
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


    <div class="container">
        <h1>New Wishlist</h1>
        <form action="PostWishlist.jsp" method= "post">
            <div class="form-group">
                <label for="subcategory">Category:</label>
                <select id="subcategory" name="subcategory">
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
            <div class="form-group">
                <label for="maxThreshold">Max Threshold:</label>
                <input type="number" id="maxThreshold" name="maxThreshold" placeholder="Enter max value">
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
            <input type="submit" class="cancel-button" value ="Add to Wishlist">
            </div>
            
            </div>
            
        </form>
    </div>
    <script src="script.js"></script>
    <%
    // Check if the form was submitted
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Get username, password, and other details
        String username = (String) session.getAttribute("user");
        String subcategory = request.getParameter("subcategory").trim();
        double maxThreshold = Double.parseDouble(request.getParameter("maxThreshold"));
        LocalDateTime date = LocalDateTime.now();
        String[] attributeKeys = request.getParameterValues("attributeKey");
        String[] attributeValues = request.getParameterValues("attributeValue");
        HashMap<String, String> listingAttributes = new HashMap<String, String>();
        for (int i = 0; i < attributeKeys.length; i++) {
            listingAttributes.put(attributeKeys[i].trim(), attributeValues[i].trim());
            if (myDatabase.debug) System.out.println(attributeKeys[i] + ": " + attributeValues[i]);
        }
        

        // Attempt sign up
        if (!wishlistController.postWishlist(username, date, subcategory, maxThreshold, listingAttributes)) {
            // Username taken, try again
            %>
            <script>alert("Wishlist failed to post.")</script>
            <%
            return;
        }

        // User created, redirect to log in
        response.sendRedirect("Login.jsp");
    }
%>
    
</body>
</html>
