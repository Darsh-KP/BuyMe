

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat Logs</title>
    <link rel="stylesheet" href="SampleTicket.css">
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
                <%
                    String username = (String) session.getAttribute("user");
                    if (loginController.checkIfCustomerRep(username)) {
                        out.print("<label><a href=\"CustRepPanel.jsp\">Customer Rep</a></label>");
                    }
                %>
                <label><a href="Logout.jsp">Log Out</a></label>
            </div>
        </div>
    </nav>
    
    <div class="chatbox">
        <div class="chat-header">
            <h1> Chat Logs </h1>
        </div>
        <div class="chat-container">
            <div class="chat-messages">
                <div class="message sent">
                    <p class="sender">Customer Representative</p>
                    <p class="content">Hello! How can I help you? </p>
                </div>
                <div class="message received">
                    <p class="sender">YOU</p>
                    <p class="content">I would like to return an item.</p>
                </div>
                <div class="message sent">
                    <p class="sender">Customer Representative</p>
                    <p class="content">Sure, please provide an order number. </p>
                </div>
                <div class="message received">
                  <p class="sender">YOU</p>
                  <p class="content">Item number 5p28748p75. </p>
              </div>
              <div class="message sent">
                <p class="sender">Customer Representative</p>
                <p class="content">What is the reason for your return? </p>
            </div>
            <div class="message received">
              <p class="sender">YOU</p>
              <p class="content">I just simply don't want it. </p>
          </div>
          <div class="message sent">
            <p class="sender">Customer Representative</p>
            <p class="content">Unfortunately, thats not a valid reason. </p>
        </div>
            </div>
        </div>
        <div class="chat-footer">
            <input type="text" placeholder="Type your message here...">
            <button>Submit</button>
        </div>
    </div>
</body>
</html>
