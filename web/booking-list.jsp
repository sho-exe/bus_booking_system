<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="dao.BookingDAO, java.util.*, model.Booking"%>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>

<div class="table-card">
    <div class="section-header">
        <h2>Booking Management</h2>
    </div>

    <h3>All Bookings</h3>
    <table class="admin-table">
        <tr>
            <th>ID</th>
            <th>Booking Date</th>
            <th>Trip ID</th>
            <th>Seat</th>
            <th>Passenger</th>
            <th>Phone</th>
            <th>Price</th>
            <th>Status</th>
        </tr>

        <% if (bookings != null && !bookings.isEmpty()) {
            for (Booking b : bookings) {
        %>
        <tr>
            <td><%= b.getBookingId() %></td>
            <td><%= b.getBookingDate() %></td>
            <td><span style="font-weight: 600;">#<%= b.getTripId() %></span></td>
            <td><%= b.getSeatNumber() %></td>
            <td>
                <span class="stack-main"><%= b.getPassengerName() %></span>
            </td>
            <td><%= b.getPassengerPhone() %></td>
            <td>RM <%= String.format("%.2f", b.getPrice()) %></td>
            <td>
                <span style="color: <%= "Confirmed".equals(b.getStatus()) ? "#16a34a" : "#ca8a04" %>; font-weight: 600;">
                    <%= b.getStatus() %>
                </span>
            </td>
        </tr>
        <%  }
        } else { %>
        <tr>
            <td colspan="8" style="text-align:center; padding: 40px; color:#9ca3af;">No bookings found in the database.</td>
        </tr>
        <% } %>
    </table>
</div>
