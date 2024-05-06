<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.buyme.controller.*" %>
<%@ page import="com.buyme.database.myDatabase" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    HttpSession sessionChecker = request.getSession(false); // Passing false to avoid creating a new session if one doesn't exist
    if (sessionChecker == null || sessionChecker.getAttribute("user") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

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
                    String usernameChecker = (String) session.getAttribute("user");
                    if (loginController.checkIfCustomerRep(usernameChecker)) {
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
        <div class="chat-container" id="chatContainer">
            <div class="chat-messages">
                <%
                    // Get message history
                    String username = (String) session.getAttribute("user");
                    List<HashMap<String, String>> messageHistory = ticketController.getTicketMessageHistory(Integer.parseInt(request.getParameter("ticketID")));
                    if (messageHistory != null) {
                        for (HashMap<String, String> message : messageHistory) {
                            if (message.get("messageFrom").equals(username)) {
                                // Message from user
                                out.print("<div class=\"message received\">\n" +
                                        "   <p class=\"sender\">YOU</p>\n" +
                                        "   <p class=\"content\">" + message.get("message") + "</p>\n" +
                                        "</div>");
                            } else {
                                // Message from rep
                                out.print("<div class=\"message sent\">\n" +
                                        "   <p class=\"sender\">Customer Representative</p>\n" +
                                        "   <p class=\"content\">" + message.get("message") + "</p>\n" +
                                        "</div>");
                            }
                        }
                    }
                %>

                <script>
                    // Get the chat container element
                    var chatContainer = document.getElementById('chatContainer');

                    // Scroll to the bottom of the chat container
                    chatContainer.scrollTop = chatContainer.scrollHeight;
                </script>
            </div>
        </div>
        <form class="chat-footer" action="SampleTicket.jsp" method="post">
            <input type="text" placeholder="Type your message here..." name="message">
            <input type="submit" value="Submit" name="post_message_button">
            <input type="hidden" name="ticketID" value=<%out.print(request.getParameter("ticketID"));%>>
        </form>
    </div>

<%
    if ((request.getMethod().equalsIgnoreCase("POST")) && (request.getParameter("post_message_button") != null)) {
        // Get info to pass
        int ticketID = Integer.parseInt(request.getParameter("ticketID"));
        String message = request.getParameter("message");
        if (message.trim().equals("")) return;
        LocalDateTime created = LocalDateTime.now();

        // Post message
        if (!ticketController.postMessage(ticketID, username, message, created)) {
            %>
                <script>alert("Message not posted.")</script>
            <%
            return;
        }

        // Reload the page
        out.print("<script>" +
                "// Get ticketID from the card that was clicked\n" +
                "\n" +
                "// Create form in order to POST id\n" +
                "var form = document.createElement(\"form\");\n" +
                "form.setAttribute(\"method\", \"post\");\n" +
                "form.setAttribute(\"action\", \"SampleTicket.jsp\");\n" +
                "\n" +
                "// Attach ticketID\n" +
                "var input = document.createElement(\"input\");\n" +
                "input.setAttribute(\"type\", \"hidden\");\n" +
                "input.setAttribute(\"name\", \"ticketID\");\n" +
                "input.setAttribute(\"value\", " + ticketID + ");\n" +
                "\n" +
                "// Submit Form\n" +
                "form.appendChild(input);\n" +
                "document.body.appendChild(form);\n" +
                "form.submit();" +
                "</script>");
    }
%>

</body>
</html>
