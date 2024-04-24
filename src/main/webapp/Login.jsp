<%@ page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page import="com.buyme.database.*"%>
<%@ page import="com.buyme.controller.*"%>
<%@ page import="java.sql.*" %>

<%
    // Get username and password
    String username = (request.getParameter("username")).trim();
    String password = (request.getParameter("password")).trim();

    if (!loginController.attemptLogin(username, password)) {
        // User doesn't exist, back to log in
        out.println("<script type=\"text/javascript\">");
        out.println("alert('Username or password does not match.');");
        out.println("location='Login.html';");
        out.println("</script>");
        return;
    }

    // User does exists
    session.setAttribute("user", username);
    if (MyDatabase.debug) System.out.println(session.getAttribute("user"));
    response.sendRedirect("Logout.html");
%>