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
    <link rel="stylesheet" href="admin.css">
</head>
<body>
    <header>
        <h1>Admin Panel</h1>
    </header>
    <main>
        <div class="container">
            <button class="create-rep-btn" onclick="window.location.href='CreateCustomerRep.jsp';">Create Customer Representative</button>
            <button class="create-rep-btn" onclick="window.location.href='UpgradeRep.jsp';">Upgrade Customer Representative</button>
            <button class="generate-report-btn" onclick="window.location.href='SalesReport.jsp';">Generate Sales Report</button>
            <button class="create-rep-btn" onclick="window.location.href='LogoutAdmin.jsp';">Log Out</button>
        </div>
    </main>
</body>
</html>
