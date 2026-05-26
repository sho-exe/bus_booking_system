<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Passenger Details - Sani Express</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="style.css" />
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <% String[] selectedSeats=request.getParameterValues("selected_seats");
            request.getSession().setAttribute("selected_seats", selectedSeats); String origin=(String)
            session.getAttribute("origin"); String destination=(String) session.getAttribute("destination"); String
            tripDate=(String) session.getAttribute("trip_date"); String price=(String) session.getAttribute("price");
            int seatCount=(selectedSeats !=null) ? selectedSeats.length : 0; double
            pricePerSeat=Double.parseDouble(price); double totalPrice=seatCount * pricePerSeat;
            session.setAttribute("total_price", totalPrice); %>

            <div class="main-container">

                <div class="tab-nav">
                    <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
                    <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                    <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
                </div>

                <br>
                <a href="SelectSeat.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Seats</a>

                <!--<form action="booking?action=insert" method="POST">-->
                <form action="temp.jsp" method="POST">

                    <input type="hidden" name="origin" value="<%= (origin != null) ? origin : ""%>">
                    <input type="hidden" name="destination" value="<%= (destination != null) ? destination : ""%>">
                    <input type="hidden" name="trip_date" value="<%= (tripDate != null) ? tripDate : ""%>">
                    <input type="hidden" name="total_price" value="<%= (totalPrice != 0.0) ? totalPrice : ""%>">
                    <input type="hidden" name="trip_id" value="<%= session.getAttribute(" trip_id")%>">


                    <div class="layout-grid">

                        <div class="left-col">
                            <h2 class="section-title">Fill Passenger Details</h2>


                            <%-- Booker details card --%>
                                <div class="trip-card">
                                    <div class="trip-info" style="width: 100%;">
                                        <h3 style="margin-bottom: 15px; color: #cc2525;">
                                            <i class="fa-regular fa-user"></i> Booker Details
                                        </h3>
                                        <div class="form-row" style="margin-bottom: 0;">
                                            <div class="form-group">
                                                <label>Full Name</label>
                                                <div class="input-wrapper">
                                                    <i class="fa-regular fa-id-badge"></i>
                                                    <input type="text" name="booker_name" class="form-control"
                                                        placeholder="Enter full name" 
                                                        value="<%=session.getAttribute("username")%>" required>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label>Contact Number</label>
                                                <div class="input-wrapper">
                                                    <i class="fa-solid fa-phone"></i>
                                                    <input type="tel" name="booker_phone" class="form-control"
                                                        placeholder="Enter phone number"
                                                        value="<%=session.getAttribute("phoneNumber")%>" required>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- Separator --%>
                                    <div style="border-top: 2px dashed #e0e0e0; margin: 30px 0;"></div>
                                    <h2 class="section-title">Passenger Details</h2>
                                    <% // Only loop if seats were actually selected 
                                        if (selectedSeats !=null && selectedSeats.length> 0) {
                                        for (String seat : selectedSeats) {
                                        %>
                                        <div class="trip-card">
                                            <div class="trip-info" style="width: 100%;">

                                                <h3 style="margin-bottom: 15px; color: #cc2525;">
                                                    <i class="fa-regular fa-user"></i> Details for Seat <%= seat%>
                                                </h3>

                                                <input type="hidden" name="seat_number" value="<%= seat%>">

                                                <div class="form-row" style="margin-bottom: 0;">
                                                    <div class="form-group">
                                                        <label>Full Name</label>
                                                        <div class="input-wrapper">
                                                            <i class="fa-regular fa-id-badge"></i>
                                                            <input type="text" name="passenger_name"
                                                                class="form-control" placeholder="Enter full name"
                                                                required>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label>Age</label>
                                                        <div class="input-wrapper">
                                                            <i class="bi bi-person-arms-up"></i>
                                                            <input type="number" name="passenger_phone"
                                                                class="form-control" placeholder="Enter age" required>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                                        <% } // End of for loop } else { %>
                                            <!--<p style="color: red;">No seats were selected. Please go back.</p>-->
                                            <% }%>

                        </div>


                        <div class="right-col">
                            <h2 class="section-title">Booking Summary</h2>


                            <div class="summary-row bold">
                                <span>Route:</span>
                                <span>
                                    <%=session.getAttribute("trip_id")%>
                                </span>
                            </div>
                            <div class="summary-row bold">
                                <span>Route:</span>
                                <span>
                                    <%= (origin !=null) ? origin : "" %> &rarr; <%= (destination !=null) ? destination
                                            : "" %>
                                </span>
                            </div>
                            <div class="summary-row">
                                <span>Date:</span>
                                <span>
                                    <%= (tripDate !=null) ? tripDate : "" %>
                                </span>
                            </div>
                            <div class="summary-row">
                                <span>Departure:</span>
                                <span>09:00</span>
                            </div>

                            <div class="divider"></div>

                            <div class="summary-row">
                                <span>Selected Seats:</span>
                                <span>
                                    <%= seatCount%>
                                </span>
                            </div>
                            <div class="summary-row">
                                <span>Price per seat:</span>
                                <span>RM<%= String.format("%.2f", pricePerSeat)%></span>
                            </div>

                            <div class="divider"></div>

                            <div class="total-row">
                                <span>Total:</span>
                                <span class="total-price">RM <%= String.format("%.2f", totalPrice)%></span>
                            </div>

                            <button type="submit" class="btn-payment">Proceed to Complete Booking</button>
                        </div>
                    </div>
                </form>

            </div>
    </body>

    </html>