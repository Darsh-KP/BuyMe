<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ticketing System</title>
<link rel="stylesheet" href="tickets.css">
</head>
<body>
  <nav>
    <div class="logo">
        <img src="./data/LogoFinal.png" alt="Marketplace Central Logo">
    </div>
    <div class="nav-links">
        <a href="#">Home</a>
        <a href="#">Tickets</a>
        <a href="#">Listings</a>
        <a href="#">Wishlist</a>
    </div>
    <div class="search">
        <input type="text" placeholder="Search...">
        <button>Search</button>
    </div>
    <div class="profile">
        <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
        <a href="#">View Your Profile</a>
    </div>
</nav>
<div class="container">
  <h1>Welcome to our Ticketing System</h1>
  <button id="createTicketBtn">Create Ticket</button>
</div>

<div id="chatBox" class="chat-box">
  <div id="messages"></div>
  <textarea id="messageInput" placeholder="Type your message..."></textarea>
  <button id="saveChatBtn">Save Chat</button>
  <button id="sendMessageBtn">Send</button>
</div>

<script src="tickets.js"></script>
<script src="socket.io.js"></script>


</body>
</html>
