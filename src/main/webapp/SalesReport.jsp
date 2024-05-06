<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="java.util.List" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("adminLoggedIn") == null) {
        response.sendRedirect("Login.jsp");
        return;
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
        <button class="back-btn" onclick="window.location.href='admin.jsp';">Go Back</button>
        <h1 class="title">Sales Report</h1>
    </header>
    <main>
        <section class="report-section">
            <div class="report total-earnings">
                <h2>Total Earnings</h2>
                <p><%out.print(salesReportController.getTotalEarnings());%></p>
            </div>
            <a class="report earnings-per-item" href="SalesReportPer.jsp?criteria=Item">
                <h2>Earnings per Item</h2>
                <p>Click to view full report.</p>
            </a>
            <div class="report earnings-per-item-type">
                <h2>Earnings per Item Subcategory</h2>
                <%
                    // Get and display earning per subcategory
                    List<String> earningsPerSubcategory = salesReportController.getEarningsPerSubcategory();
                    for (String earningsPerItem : earningsPerSubcategory) {
                        out.print("<p>" + earningsPerItem + "</p>");
                    }
                %>
            </div>
            <a class="report earnings-per-end-user" href="SalesReportPer.jsp?criteria=Seller">
                <h2>Earnings per Seller</h2>
                <p>Click to view full report.</p>
            </a>
            <div class="report best-selling-items">
                <h2>Best-selling Items</h2>
                <%
                    // Get and display top 3 selling items
                    List<String> top3SellingItems = salesReportController.getTop3SellingItems();
                    for (String item : top3SellingItems) {
                        out.print("<p>" + item + "</p>");
                    }
                %>
            </div>
            <div class="report best-buyers">
                <h2>Best Buyers</h2>
                <%
                    // Get and display top 3 selling items
                    List<String> top3Buyers = salesReportController.getTop3Buyers();
                    for (String buyer : top3Buyers) {
                        out.print("<p>" + buyer + "</p>");
                    }
                %>
            </div>
        </section>
    </main>
</body>
</html>