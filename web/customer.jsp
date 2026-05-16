<%-- 
    Document   : customer
    Created on : 22 Apr 2026, 12:16:42 pm
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String role = (String)session.getAttribute("userRole");
            if(role == null){
                response.sendRedirect("login.html");
            }
        %>
        <h1>Welcome Customer</h1>
        <a href="login.html">Logout</a>
    </body>
</html>
