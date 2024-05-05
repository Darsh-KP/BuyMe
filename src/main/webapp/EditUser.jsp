<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.HashMap" %>



<% String userSearch = (String) request.getParameter("username");%>

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

<%
	HashMap<String, String> userInfo = new HashMap<String, String>();
	userInfo = loginController.getUserInfo(userSearch);

%>


<div class="container">
    <h2>Edit User: <%out.print(userInfo.get("username")); %></h2>
    <form action="#" method="post">
        <label for="First Name">First Name:</label>
        <input type="text" id="firstName" name="firstName" value="<%out.print(userInfo.get("fName")); %>" required>
        
        <label for="Last Name">Last Name:</label>
        <input type="text" id="lastName" name="lastName" value="<%out.print(userInfo.get("lName")); %>" required>
        
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" value= "<%out.print(userInfo.get("address")); %>" required>
        
        <label for="email">Email:</label>
        <input type="text" id="email" name="email" value="<%out.print(userInfo.get("email")); %>" required>
        <input type="submit" value="Save Changes">
    </form>
</div>

<%
//Check if the form was submitted
if (request.getMethod().equalsIgnoreCase("POST")) {
    // Get username, password, and other details
    String username = userSearch;
    String fname = request.getParameter("firstName").trim();
    String lname = request.getParameter("lastName").trim();
    String address = request.getParameter("address").trim();
    String email = request.getParameter("email").trim();

    // Attempt sign up
    if (!loginController.editUser(username, fname, lname, address, email)) {
        // Username taken, try again
        %>
        <script>alert("Could not update user.")</script>
        <%
        return;
    }

    // User created, redirect to log in
    response.sendRedirect("CustRepPanel.jsp");
}

%>



</body>
</html>