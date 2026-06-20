<%@page import="java.util.List" %>
<%@page import="model.Booking" %>
<%@page import="dao.BookingDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Bookings - Sani Express</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="style.css" />
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <%
            String role = (String) session.getAttribute("userRole");
            String username = (String) session.getAttribute("username");
            String userId = (String) session.getAttribute("passengerId");
            BookingDAO bookingDAO = new BookingDAO();
            List<Booking> myBookings = (userId != null)
                    ? bookingDAO.getBookingsByUser(userId)
                    : new java.util.ArrayList<>();
        %>

        <div class="main-container" style="margin-top: 50px;">

            <div style="text-align: center; margin-bottom: 30px;">
                <div class="tab-nav tab-nav-top" style="display: inline-flex;">
                    <a href="Booking.jsp" class="tab"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
                    <a href="customer.jsp" class="tab active"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                    <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
                </div>
            </div>

            <div class="results-container">

                <% if (myBookings.isEmpty()) { %>

                <div class="trip-card no-bookings-card">
                    <i class="fa-solid fa-ticket-simple"></i>
                    <p>You have no bookings yet. <a href="Booking.jsp">Search for a trip</a></p>
                </div>

                <% } else {
                    for (Booking b : myBookings) {
                        String statusClass = "status-pending";
                        String statusIcon = "fa-clock";
                        if ("Confirmed".equalsIgnoreCase(b.getStatus())) {
                            statusClass = "status-confirmed";
                            statusIcon = "fa-circle-check";
                        } else if ("Cancelled".equalsIgnoreCase(b.getStatus())) {
                            statusClass = "status-cancelled";
                            statusIcon = "fa-circle-xmark";
                        }
                %>

                <div class="trip-card">
                    <div class="trip-info">
                        <h3>Booking #<%= b.getBookingId()%></h3>
                        <p class="route">
                            <i class="fa-solid fa-chair"></i> Seat <%= b.getSeat()%>
                            &nbsp;&bull;&nbsp;
                            <i class="fa-solid fa-route"></i> Trip #<%= b.getTripId()%>
                        </p>
                        <p class="bus-type">
                            <% if (b.getBookingDate() != null) {%>
                            <i class="fa-regular fa-calendar"></i>
                            <%= b.getBookingDate().toString().substring(0, 10)%>
                            <% }%>
                        </p>
                    </div>
                    <div class="trip-action">
                        <span class="status-badge <%= statusClass%>">
                            <i class="fa-solid <%= statusIcon%>"></i>
                            <%= b.getStatus() != null ? b.getStatus() : "Pending"%>
                        </span>
                        <br>
                        <a href="ReceiptPDFServlet?booking_id=<%= b.getBookingId()%>" 
                           class="receipt-btn" 
                           target="_blank">
                            <span class="receipt-icon">
                                <i class="fa-solid fa-file-pdf"></i>
                            </span>
                            <span class="receipt-text">
                                Download Receipt
                            </span>
                        </a>
                    </div>
                </div>

                <% }
                    }%>

            </div><!-- /.results-container -->
        </div><!-- /.main-container -->

        <footer class="main-footer">
            &copy; 2026 Sani Express. All rights reserved.
        </footer>
    </body>
</html>