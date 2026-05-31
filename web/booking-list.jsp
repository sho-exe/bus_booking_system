<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@page import="dao.BookingDAO, java.util.*, model.Booking" %>

            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                    %>

                    <div class="table-card">
                        <div class="section-header">
                            <h2>Booking Management</h2>
                        </div>

                        <h3>All Bookings</h3>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Booking Date</th>
                                    <th>Trip ID</th>
                                    <th>Seat</th>
                                    <th>Passenger</th>
                                    <th>Age</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (bookings !=null && !bookings.isEmpty()) { for (Booking b : bookings) { String
                                    statusClass="status-pending" ; if ("Confirmed".equalsIgnoreCase(b.getStatus())) {
                                    statusClass="status-confirmed" ; } else if
                                    ("Cancelled".equalsIgnoreCase(b.getStatus())) { statusClass="status-cancelled" ; }
                                    %>
                                    <tr>
                                        <td>
                                            <%= b.getBookingId() %>
                                        </td>
                                        <td>
                                            <%= b.getBookingDate() !=null ? b.getBookingDate().toString().substring(0,
                                                10) : "-" %>
                                        </td>
                                        <td><span class="stack-main">#<%= b.getTripId() %></span></td>
                                        <td>
                                            <%= b.getSeat() %>
                                        </td>
                                        <td>
                                            <span class="stack-main">
                                                <%= b.getPassengerName() !=null ? b.getPassengerName() : "-" %>
                                            </span>
                                        </td>
                                        <td>
                                            <%= b.getPassengerAge()> 0 ? b.getPassengerAge() : "-" %>
                                        </td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= b.getStatus() !=null ? b.getStatus() : "Pending" %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } } else { %>
                                        <tr>
                                            <td colspan="7" style="text-align:center; padding: 40px; color:#9ca3af;">No
                                                bookings found in the database.</td>
                                        </tr>
                                        <% } %>
                            </tbody>
                        </table>
                    </div>