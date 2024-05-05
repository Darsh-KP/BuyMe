<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.*, javax.servlet.*"%>

<%
    session.removeAttribute("adminLoggedIn");
    response.sendRedirect("Login.jsp");
%>