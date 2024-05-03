<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Wishlist</title>
    <link rel="stylesheet" href="PostWishlist.css">
</head>
<body>

  <!-- Nav Bar -->

  <nav>
    <div class="logo">
        <img src="./data/LogoFinal.png" alt="BuyMe Logo">
    </div>
    <div class="nav-links">
        <a href="">Home</a>
        <a href="">Tickets</a>
        <a href="Listings.jsp">Listings</a>
        <a href="">Wishlist</a>
    </div>
    <div class="profile">
        <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
        <a href="#">Notifications</a>
        <a href="#" class="logout-button">Log Out</a>
    </div>
</nav>


    <div class="container">
        <h1>New Wishlist</h1>
        <form action="#">
            <div class="form-group">
                <label for="subcategory">Category:</label>
                <select id="subcategory" name="subcategory">
                    <option value="" disabled selected>Select Category</option>
                    <option value="shirt">Shirt</option>
                    <option value="pant">Pant</option>
                    <option value="hat">Hat</option>
                </select>
            </div>
            <div class="form-group">
                <label for="maxThreshold">Max Threshold:</label>
                <input type="number" id="maxThreshold" name="maxThreshold" placeholder="Enter max value">
            </div>
            <div class="form-group" id="attributes">
                <label for="attributes">Attributes:</label>
                <div class="attribute">
                    <select name="size">
                        <option value="" disabled selected>Select Size</option>
                        <option value="XS">XS</option>
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                    </select>
                    <input type="text" name="color" placeholder="Color">
                </div>
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









            <button type="submit">Post to Wishlist</button>
        </form>
    </div>
    <script src="script.js"></script>
</body>
</html>
