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
    <title>Sales Report</title>
    <link rel="stylesheet" href="SalesReport.css">
</head>
<body>
    <header>
        <h1>Sales Report</h1>
    </header>
    <main>
        <section class="report-section">
            <div class="report total-earnings">
                <h2>Total Earnings</h2>
                <p>$100,000</p>
            </div>
            <button class="report earnings-per-item">
                <h2>Earnings per Item</h2>
                <p>Item 1: $10,000</p>
                <p>Item 2: $20,000</p>
                <p>Item 3: $15,000</p>
            </button>
            <div class="report earnings-per-item-type">
                <h2>Earnings per Item Type</h2>
                <p>Type 1: $30,000</p>
                <p>Type 2: $25,000</p>
                <p>Type 3: $24,000</p>
            </div>
            <button class="report earnings-per-end-user">
                <h2>Earnings per End-user</h2>
                <p>User 1: $20,000</p>
                <p>User 2: $25,000</p>
                <p>User 3: $15,000</p>
            </button>
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
