<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist</title>
    <link rel="stylesheet" href="WishlistStyling.css">
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

    <header>
        <h1>My Wishlist</h1>
    </header>
    
    <div class="wishlist-container">

        <div class="wishlist-item">
            <h3>Wish #1</h3>
            <p>Category: Hats</p>
            <p>Max Threshold: $50</p>
            <p>Size: Medium</p>
            <p>Color: Blue</p>
            <button class="remove-btn">Remove</button>
        </div>

        <div class="wishlist-item">
            <h3>Wish #2</h3>
            <p>Category: Pants</p>
            <p>Max Threshold: $200</p>
            <p>Size: N/A</p>
            <p>Color: Black</p>
            <button class="remove-btn">Remove</button>
        </div>
        
    </div>

</body>
</html>