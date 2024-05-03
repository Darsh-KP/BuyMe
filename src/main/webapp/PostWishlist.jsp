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
            <button type="button" id="addAttribute">Add Attribute</button>
            <button type="submit">Post to Wishlist</button>
        </form>
    </div>
    <script src="script.js"></script>
</body>
</html>
