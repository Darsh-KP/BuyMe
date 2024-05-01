<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to our Ticketing Center</title>
    <link rel="stylesheet" href="TicketPage.css">
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
        <div class="search">
            <input type="text" placeholder="Search...">
            <button>Search</button>
        </div>
        <div class="profile">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
            <a href="#">View Your Profile</a>
            <a href="#" class="logout-button">Log Out</a>
        </div>
    </nav>





   
    <div class="container">
        <h1>Welcome to our Ticketing Center</h1>

                <!-- Search Bar -->
                <div class="search-bar">
                    <input type="text" id="ticket-search" placeholder="Enter Ticket Number">
                    <button onclick="searchTicket()">Search</button>
                </div>

        <div class="ticket-cards">
            <a href="#" class="ticket-card">
                <p class="ticket-number">#1234</p>
                <p class="ticket-date">Date Created: April 30, 2024</p>
                <p class="ticket-description">Short Description: Lorem ipsum dolor sit amet</p>
                <p class="ticket-status">Status: Open</p>
            </a>
            <a href="#" class="ticket-card">
                <p class="ticket-number">#5678</p>
                <p class="ticket-date">Date Created: April 29, 2024</p>
                <p class="ticket-description">Short Description: Consectetur adipiscing elit</p>
                <p class="ticket-status">Status: In Progress</p>
            </a>
            <a href="#" class="ticket-card">
                <p class="ticket-number">#91011</p>
                <p class="ticket-date">Date Created: April 28, 2024</p>
                <p class="ticket-description">Short Description: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</p>
                <p class="ticket-status">Status: Closed</p>
            </a>
        </div>
        <button class="create-ticket-button">+ Create a new ticket</button>
    </div>
</body>
</html>
