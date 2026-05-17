<%@page import="java.util.List" %>
    <%@page import="model.Booking" %>
        <%@page import="dao.BookingDAO" %>
            <%@page contentType="text/html" pageEncoding="UTF-8" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Customer Dashboard - Sani Express</title>
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                    <link rel="stylesheet" href="style.css" />
                </head>

                <body>
                    <jsp:include page="header.jsp" />

                    <% String role=(String) session.getAttribute("userRole"); String username=(String)
                        session.getAttribute("username"); if (role==null || username==null) {
                        response.sendRedirect("login.html"); return; } %>

                        <%  String userId= (String) session.getAttribute("passengerId") ;
                            BookingDAO bookingDAO=new BookingDAO();
                            List<Booking> myBookings = bookingDAO.getBookingsByUser(userId);
                            %>

                            <div class="main-container">

                                <div class="tab-nav" style="margin-top: 20px;">
                                    <a href="Booking.jsp" class="tab"><i class="fa-solid fa-magnifying-glass"></i> Book
                                        Trip</a>
                                    <a href="customer.jsp" class="tab active"><i class="fa-solid fa-ticket"></i> My
                                        Bookings</a>
                                    <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
                                </div>

                                <div class="results-container" style="margin-top: 30px;">
                                    <h2 class="section-title">My Bookings</h2>

                                    <h2>
                                        <%--<%= // session.getAttribute("passengerId")%>--%>
                                    </h2>

                                    <% if (myBookings.isEmpty()) { %>
                                        <p>You have no bookings yet. <a href="Booking.jsp">Search for a trip!</a></p>
                                        <% } else { for (Booking b : myBookings) {%>
                                            <div class="trip-card">
                                                <div class="trip-info">
                                                    <h3>Booking #<%= b.getBookingId()%>
                                                    </h3>
                                                    <p class="route">Seat: <%= b.getSeat()%>
                                                    </p>
                                                    <p class="bus-type">Trip ID: <%= b.getTripId()%>
                                                    </p>
                                                    <p class="bus-type">Passenger ID: <%= b.getPassengerId()%>
                                                    </p>
                                                </div>
                                                <div class="trip-action">
                                                    <span style="color: green; font-weight: bold;">
                                                        <%= b.getStatus()%>
                                                    </span>
                                                </div>
                                            </div>
                                            <% } }%>
                                </div>
                            </div>
                </body>

                </html>