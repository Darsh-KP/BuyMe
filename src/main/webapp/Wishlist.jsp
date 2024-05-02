<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist</title>
    <link rel="stylesheet" href="Wishlist.css">
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
    <div class="wishlist">

        <!-- individual product cards -->
        <div class=product-card>
            <a href=product-page.html>
                <div class=product-title>Name</div>
                <div class=product-image></div>
                <div class=product-price>Price</div>
                <div class=product-endtime>Time</div>
                <div class=product-status>Status</div>
            </a>
            <button class="close-icon">X</button>
        </div>

        <div class=product-card>
            <a href=product-page.html>
                <div class=product-title>Name</div>
                <div class=product-image></div>
                <div class=product-price>Price</div>
                <div class=product-endtime>Time</div>
                <div class=product-status>Status</div>
            </a>
            <button class="close-icon">X</button>
        </div>

        <div class=product-card>
            <a href=product-page.html>
                <div class=product-title>Name</div>
                <div class=product-image></div>
                <div class=product-price>Price</div>
                <div class=product-endtime>Time</div>
                <div class=product-status>Status</div>
            </a>
            <button class="close-icon">X</button>
        </div>

    </div>
</body>
</html>