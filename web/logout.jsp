<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Clear all session data by invalidating the current session
    if (request.getSession(false) != null) {
        session.invalidate();
    }

    // 2. Redirect the user to page.jsp
    response.sendRedirect("Booking.jsp");
%>