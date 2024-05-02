<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Ticket</title>
    <link rel="stylesheet" href="NewTicket.css">
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
        <h1>New Ticket</h1>
        <form action="#">
            <label for="description">Description:</label>
            <textarea id="description" name="description" rows="4" placeholder="Enter a description of the issue..."></textarea>
            <div class="buttons">
                <button type="submit" class="submit-button">Submit</button>
                <button type="button" class="cancel-button">Cancel</button>
            </div>
        </form>
    </div>
</body>
</html>
