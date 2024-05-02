<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Rep Panel</title>
    <link rel="stylesheet" href="CustRepPanel.css">
</head>

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


<body>
    <div class="container">
        <h2>Customer Representative Panel</h2>
        <div class="form-group">
            <label for="searchUser">Search User:</label>
            <input type="text" id="searchUser" name="searchUser">
            <button>Delete User</button>
            <a href="EditUser.html"><button>Edit User</button></a>
        </div>
        <div class="form-group">
            <label for="searchBidId">Search BidID:</label>
            <input type="text" id="searchBidId" name="searchBidId">
            <button>Remove Bid</button>
        </div>
        <div class="form-group">
            <label for="searchListing">Search Listing:</label>
            <input type="text" id="searchListing" name="searchListing">
            <button>Remove Listing</button>
        </div>
        <div class="center">
            <div class="form-group">
                <a href="CustRepTickets.html"><button>View Tickets</button></a>
            </div>
        </div>
    </div>

</body>
</html>
