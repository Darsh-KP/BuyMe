<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation Bar</title>
    <link rel="stylesheet" href="test.css">
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
    <div class="profile">
        <button class="profile-btn">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture" class="profile-img">
        </button>
        <div class="dropdown-content">
            <a href="Alerts.jsp">Notifications</a>
            <a href="ParticipationHistory.jsp">My History</a>
            <a href="#" class="logout-button">Log Out</a>
        </div>
    </div>
</nav>


</body>
</html>
