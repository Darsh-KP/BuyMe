<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.buyme.controller.*"%>

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
    <title>Create Customer Representative</title>
    <link rel="stylesheet" href="CreateCustRep.css">
</head>
<body>
    <header>
        <h1>Create Customer Representative</h1>
    </header>
    <main>
        <section class="form-section">
            <form method="post" action="CreateCustRep.jsp">
                <div class="form-group">
                    <label for="firstName">First Name:</label>
                    <input type="text" id="firstName" name="firstName" required autofocus maxlength="20">
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name:</label>
                    <input type="text" id="lastName" name="lastName" required maxlength="20">
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required maxlength="50">
                </div>
                <div class="form-group">
                    <label for="address">Address:</label>
                    <textarea id="address" name="address" rows="4" required maxlength="100"></textarea>
                </div>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" required minlength="5" maxlength="20">
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" required minlength="8" maxlength="255">
                </div>
                <button onclick="window.location.href='admin.jsp';" class="back-btn">Go Back</button>
                <input type="submit" class="submit-btn" value="Create Representative">
            </form>
        </section>
    </main>

    <%
        // Check if the form was submitted
        if (request.getMethod().equalsIgnoreCase("POST")) {
            // Get username, password, and other details
            String username = request.getParameter("username").trim();
            String password = request.getParameter("password").trim();
            String firstName = request.getParameter("firstName").trim();
            String lastName = request.getParameter("lastName").trim();
            String address = request.getParameter("address").trim();
            String email = request.getParameter("email").trim();

            // Attempt sign up
            if (!signUpController.attemptSignUp(firstName, lastName, username, password, email, address)) {
                // Username taken, try again
                %>
                <script>alert("Username taken. Choose a different username.")</script>
                <%
                return;
            }

            // User created, promote to customer rep
            if(adminController.setUserPromotion(username, true)) {
                %>
                    <script>alert("Successfully created customer rep.")</script>
                <%
            } else {
                %>
                    <script>alert("User created. However, error promoting user!")</script>
                <%
            }
        }
    %>
</body>
</html>
