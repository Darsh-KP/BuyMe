<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notifications and Alerts</title>
<link rel="stylesheet" href="notifications.css">
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
  <div class="table notifications">
    <h2>Notifications</h2>
    <div class="notification">
      <p>An item you are interested in is now available.</p>
    </div>
    <div class="notification alternate">
      <p>The price of an item you are watching has dropped.</p>
    </div>
    <div class="notification">
      <p>Your bid on an item has been accepted.</p>
    </div>
    <!-- You can add more notifications dynamically -->
  </div>
  <div class="table alerts">
    <h2>Alerts</h2>
    <div class="alert">
      <p>A higher bid has been placed on an item you are interested in.</p>
    </div>
    <div class="alert alternate">
      <p>An item you are watching is about to end soon.</p>
    </div>
    <div class="alert">
      <p>You have been outbid on an item you are bidding on.</p>
    </div>
    <!-- You can add more alerts dynamically -->
  </div>
</div>
</body>
</html>
