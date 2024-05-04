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
    <div class="dropdown">
        <button class="dropbtn">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture" class="profile-img">
        </button>
        <div class="dropdown-content">
            <label><a href="Alerts.jsp">Notifications</a></label>
            <label><a href="ParticipationHistory.jsp">My History</a></label>
            <label><a href="#">Log Out</a></label>
        </div>
    </div>
</nav>



</body>
</html>
