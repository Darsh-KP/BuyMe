<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("adminLoggedIn") == null) {
        response.sendRedirect("Login.jsp");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="UpgradeRep.css">
</head>
<body>
    <div class="container">
        <button class="back-btn" onclick="window.location.href='admin.jsp';">Go Back</button>
        <h1 class="title">Upgrade User to Customer Representative</h1>
        <form method="post" action="UpgradeRep.jsp">
            <div class="input-container">
                <input type="text" placeholder="User Input" name="usernameInput" minlength="5" maxlength="20">
            </div>
            <div class="button-container">
                <input type="submit" class="remove-button" name="demote" value="Demote">
                <input type="submit" class="upgrade-button" name="promote" value="Promote">
            </div>
        </form>
    </div>

<%
    // Promote User Clicked
    if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("promote")!=null)) {
        String usernameProvided = request.getParameter("usernameInput");

        if(adminController.setUserPromotion(usernameProvided, true)) {
            %>
                <script>alert("Successfully promoted user.")</script>
            <%
        } else {
            %>
                <script>alert("Error promoting user!")</script>
            <%
        }
    }
    // Demote User Clicked
    else if (request.getMethod().equalsIgnoreCase("POST") && (request.getParameter("demote")!=null)) {
            String usernameProvided = request.getParameter("usernameInput");

            if(adminController.setUserPromotion(usernameProvided, false)) {
                %>
                    <script>alert("Successfully demoted user.")</script>
                <%
            } else {
                %>
                    <script>alert("Error demoting user!")</script>
                <%
            }
    }
%>

</body>
</html>
