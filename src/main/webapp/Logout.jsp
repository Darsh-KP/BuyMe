<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.buyme.database.myDatabase" %>

<%
    if (myDatabase.debug) System.out.println("Logging out user...");
    session.removeAttribute("user");
    response.sendRedirect("Login.jsp");
%>