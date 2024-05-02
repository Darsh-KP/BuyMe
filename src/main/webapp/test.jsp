<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
<%
String id = request.getParameter("productID");
HashMap<String, String> cardInfo = viewListingController.getCardinfo(id);
%> 
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%out.print(cardInfo.get("productName"));%></title>
    <link rel="stylesheet" href="test.css">
</head>
<div class="listing-info-container">
    <div class="listing-info">
        <div class="dates-container">
            <div class="listing-dates">
                <p>Start Date: <%out.print(cardInfo.get("postDate"));%></p>
                <p>Close Date: <%out.print(cardInfo.get("closeDate"));%></p>
                <p>Minimum Bidding Increment: US $<%out.print(cardInfo.get("min_bid_increment"));%></p>
            </div>
            <div class="status">
                <div class="circle green"></div>
                <div class="text"><%out.print(cardInfo.get("statusDisplay"));%></div>
            </div>
        </div>
        <div class="bidding-container">
            <div class="bid-info"> 
                <label for="bid">Your Bid:</label>
                <input type="number" id="bid" name="bid" min="20.99" step="1.00">
                <button onclick="placeBid()" class="button">Place Bid</button>
            </div>
      
            <div class="auto-bidding">
                <label for="max-bid">Max Bid:</label>
                <input type="number" id="max-bid" name="max-bid" min="20.99" step="1.00">
                <label for="bid-increment">Bid Increment:</label>
                <input type="number" id="bid-increment" name="bid-increment" min="1.00" step="1.00">
                <label for="anonymous-bid">Anonymous Bid:</label>
                <input type="checkbox" id="anonymous-bid" name="anonymous-bid">
            </div>
        </div>
    </div>
</div>
</body>
</html>
