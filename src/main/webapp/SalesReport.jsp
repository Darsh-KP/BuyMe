<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>
    <link rel="stylesheet" href="SalesReport.css">
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
                    String usernameChecker = (String) session.getAttribute("user");
                    if (loginController.checkIfCustomerRep(usernameChecker)) {
                        out.print("<label><a href=\"CustRepPanel.jsp\">Customer Rep</a></label>");
                    }
                %>
                <label><a href="Logout.jsp">Log Out</a></label>
            </div>
        </div>
    </nav>

    <header>
        <h1>Sales Report</h1>
    </header>
    <main>
        <section class="report-section">
            <div class="report total-earnings">
                <h2>Total Earnings</h2>
                <p>$100,000</p>
            </div>
            <div class="report earnings-per-item">
                <h2>Earnings per Item</h2>
                <p>Item 1: $10,000</p>
                <p>Item 2: $20,000</p>
                <p>Item 3: $15,000</p>
                
            </div>
            <div class="report earnings-per-item-type">
                <h2>Earnings per Item Type</h2>
                <p>Type 1: $30,000</p>
                <p>Type 2: $25,000</p>
            </div>
            <div class="report earnings-per-end-user">
                <h2>Earnings per End-user</h2>
                <p>User 1: $20,000</p>
                <p>User 2: $25,000</p>
                <p>User 3: $15,000</p>
            </div>
            <div class="report best-selling-items">
                <h2>Best-selling Items</h2>
                <ol>
                    <li>Item A</li>
                    <li>Item B</li>
                    <li>Item C</li>
                </ol>
            </div>
            <div class="report best-buyers">
                <h2>Best Buyers</h2>
                <ol>
                    <li>Buyer X</li>
                    <li>Buyer Y</li>
                    <li>Buyer Z</li>
                </ol>
            </div>
        </section>
    </main>
</body>
</html>
