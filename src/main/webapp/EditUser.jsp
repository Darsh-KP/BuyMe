<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
    <link rel="stylesheet" href="EditUser.css">
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
    <h2>Edit User</h2>
    <form action="#" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" value="UrMom" required>
        
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" value="123 Avenue, City, Country" required>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" value="********" required>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="urmom@example.com" required>
        
        <input type="submit" value="Save Changes">
    </form>
</div>

</body>
</html>