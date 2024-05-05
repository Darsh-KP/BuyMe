<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("adminLoggedIn") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<%
    String criteria = request.getParameter("criteria");
    if (criteria == null) {
        response.sendRedirect("SalesReport.jsp");
    }

    List<HashMap<String, String>> earningsPer = null;
    if (criteria.equals("Item")) {
        earningsPer = salesReportController.getEarningsPerItem();
    } else if (criteria.equals("Seller")) {
        earningsPer = salesReportController.getEarningsPerSeller();
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Earnings Per <%out.print(criteria);%></title>
    <link rel="stylesheet" href="SalesReportPer.css">
</head>
<body>
    <div class="container">
        <h1>Earnings Per <%out.print(criteria);%></h1>
        <table>
            <thead class="tableHeader">
                <tr>
                    <th><%out.print(criteria);%></th>
                    <th>Earnings</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (HashMap<String, String> earnings : earningsPer) {
                        out.print("<tr>\n" +
                                "   <td>" + earnings.get("criteria") + "</td>\n" +
                                "   <td>" + earnings.get("earning") + "</td>\n" +
                                "</tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>

