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

    <%
        String[] selectedSeats = request.getParameterValues("selected_seats");
        request.getSession().setAttribute("selected_seats", selectedSeats);
        String origin = (String) session.getAttribute("origin");
        String destination = (String) session.getAttribute("destination");
        String tripDate = (String) session.getAttribute("trip_date");
        String price = (String) session.getAttribute("price");
        int seatCount = (selectedSeats != null) ? selectedSeats.length : 0;
        double pricePerSeat = Double.parseDouble(price);
        double totalPrice = seatCount * pricePerSeat;
        session.setAttribute("total_price", totalPrice);
        Double accumulatedPrice = (Double) session.getAttribute("accumulated_price");
    %>

    <div class="main-container">

        <div class="tab-nav">
            <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
            <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
            <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
        </div>

        <br>
        <a href="SelectSeat.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Seats</a>

        <form action="createPayment.jsp" method="POST">

            <input type="hidden" name="origin" value="<%= (origin != null) ? origin : "" %>">
            <input type="hidden" name="destination" value="<%= (destination != null) ? destination : "" %>">
            <input type="hidden" name="trip_date" value="<%= (tripDate != null) ? tripDate : "" %>">
            <input type="hidden" name="total_price" id="hidden_total_price" value="<%= totalPrice %>">
            <input type="hidden" name="trip_id" value="<%= session.getAttribute("trip_id") %>">
            <%-- Forward return trip id so BookingServlet can redirect to return seat selection --%>
            <% String sessionRetTripId = (String) session.getAttribute("return_trip_id"); %>
            <% if (sessionRetTripId != null && !sessionRetTripId.isEmpty()) { %>
            <input type="hidden" name="return_trip_id"    value="<%= sessionRetTripId %>">
            <input type="hidden" name="return_bus_id"     value="<%= session.getAttribute("return_bus_id") %>">
            <input type="hidden" name="return_origin"     value="<%= session.getAttribute("return_origin") %>">
            <input type="hidden" name="return_destination" value="<%= session.getAttribute("return_destination") %>">
            <input type="hidden" name="return_date"       value="<%= session.getAttribute("return_date") %>">
            <input type="hidden" name="return_price"      value="<%= session.getAttribute("return_price") %>">
            <% } %>

            <div class="layout-grid">

                <div class="left-col">
                    <h2 class="section-title">Fill Passenger Details</h2>

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
                                            value="<%= session.getAttribute("username") != null ? session.getAttribute("username") : "" %>"
                                            required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Contact Number</label>
                                    <div class="input-wrapper">
                                        <i class="fa-solid fa-phone"></i>
                                        <input type="tel" name="booker_phone" class="form-control"
                                            placeholder="Enter phone number"
                                            value="<%= session.getAttribute("phoneNumber") != null ? session.getAttribute("phoneNumber") : "" %>"
                                            required>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div style="border-top: 2px dashed #e0e0e0; margin: 30px 0;"></div>
                    <h2 class="section-title">Passenger Details</h2>

                    <%
                        String[] outNames = (String[]) session.getAttribute("outbound_passenger_names");
                        String[] outAges = (String[]) session.getAttribute("outbound_passenger_ages");

                        if (selectedSeats != null && selectedSeats.length > 0) {
                            for (int i = 0; i < selectedSeats.length; i++) {
                                String seat = selectedSeats[i];
                                String prefillName = (outNames != null && outNames.length > i && outNames[i] != null) ? outNames[i] : "";
                                String prefillAge = (outAges != null && outAges.length > i && outAges[i] != null) ? outAges[i] : "";
                    %>
                    <div class="trip-card">
                        <div class="trip-info" style="width: 100%;">
                            <h3 style="margin-bottom: 15px; color: #cc2525;">
                                <i class="fa-regular fa-user"></i> Details for Seat <%= seat.trim() %>
                            </h3>

                            <input type="hidden" name="seat_number" value="<%= seat.trim() %>">

                            <div class="form-row" style="margin-bottom: 0;">
                                <div class="form-group">
                                    <label>Full Name</label>
                                    <div class="input-wrapper">
                                        <i class="fa-regular fa-id-badge"></i>
                                        <input type="text" name="passenger_name" class="form-control"
                                            placeholder="Enter full name" value="<%= prefillName %>" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Age</label>
                                    <div class="input-wrapper">
                                        <i class="fa-solid fa-user"></i>
                                        <input type="number" name="passenger_age" class="form-control"
                                            placeholder="Enter age" min="1" max="120"
                                            data-seat='<%= seat.trim() %>'
                                            oninput="handleAgeInput(this)"
                                            value="<%= prefillAge %>"
                                            required>
                                    </div>
                                    <div id='age-msg-<%= seat.trim() %>'></div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>

                <div class="right-col">
                    <h2 class="section-title">Booking Summary</h2>

                    <div class="summary-row bold">
                        <span>Trip ID:</span>
                        <span><%= session.getAttribute("trip_id") %></span>
                    </div>
                    <div class="summary-row bold">
                        <span>Route:</span>
                        <span><%= (origin != null) ? origin : "" %> &rarr; <%= (destination != null) ? destination : "" %></span>
                    </div>
                    <div class="summary-row">
                        <span>Date:</span>
                        <span><%= (tripDate != null) ? tripDate : "" %></span>
                    </div>
                    <div class="summary-row">
                        <span>Departure:</span>
                        <span>09:00</span>
                    </div>

                    <div class="divider"></div>

                    <div class="summary-row">
                        <span>Selected Seats:</span>
                        <span><%= seatCount %></span>
                    </div>
                    <div class="summary-row">
                        <span>Price per seat:</span>
                        <span>RM<%= String.format("%.2f", pricePerSeat) %></span>
                    </div>

                    <div class="divider"></div>

                    <% if (selectedSeats != null) {
                        for (String seat : selectedSeats) { %>
                    <div class="summary-row seat-price-detail">
                        <span>Seat <%= seat.trim() %>:</span>
                        <span id='price-<%= seat.trim() %>'>RM<%= String.format("%.2f", pricePerSeat) %></span>
                    </div>
                    <% } } %>

                    <div class="divider"></div>

                    <% if (accumulatedPrice != null) { %>
                    <div class="summary-row" style="font-weight: 600;">
                        <span>Outbound Trip Total:</span>
                        <span>RM<%= String.format("%.2f", accumulatedPrice) %></span>
                    </div>
                    <div class="summary-row">
                        <span>Return Trip Subtotal:</span>
                        <span id="display-return-subtotal">RM<%= String.format("%.2f", totalPrice) %></span>
                    </div>
                    <div class="summary-row" style="color: #2e7d32; font-weight: 600;">
                        <span>Round Trip Discount (10%):</span>
                        <span id="display-discount">-RM<%= String.format("%.2f", (accumulatedPrice + totalPrice) * 0.1) %></span>
                    </div>
                    <div class="divider"></div>
                    <% } %>

                    <div class="total-row">
                        <span>Final Total:</span>
                        <span class="total-price" id="display-total">RM<%= String.format("%.2f", accumulatedPrice != null ? (accumulatedPrice + totalPrice) * 0.9 : totalPrice) %></span>
                    </div>

                    <button type="submit" class="btn-payment">
                        <%= (sessionRetTripId != null && !sessionRetTripId.isEmpty()) ? "Next: Choose Return Seats" : "Proceed to Payment" %>
                    </button>
                </div>
            </div>
        </form>

    </div>

    <script>
const pricePerSeat = parseFloat("<%= pricePerSeat %>");
const seatAges = {};

        function handleAgeInput(input) {
            const seat = input.getAttribute('data-seat').trim();
            const age = parseInt(input.value);
            const msgDiv = document.getElementById('age-msg-' + seat);
            const priceSpan = document.getElementById('price-' + seat);

            msgDiv.innerHTML = '';

            if (!isNaN(age) && input.value !== '') {
                if (age < 12) {
                    msgDiv.innerHTML = `
                        <div class="age-warning">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Passenger is a child (below 12). Please bring the child's <strong>IC card</strong> for safety verification during boarding.
                        </div>`;
                    seatAges[seat] = { age: age, discount: false };
                    priceSpan.innerHTML = 'RM<%= String.format("%.2f", pricePerSeat) %>';
                } else if (age >= 60) {
                    msgDiv.innerHTML = `
                        <div class="age-discount">
                            <i class="fa-solid fa-tag"></i>
                            <strong>50% senior citizen discount</strong> applied for this seat.
                        </div>`;
                    seatAges[seat] = { age: age, discount: true };
                    const discounted = pricePerSeat * 0.5;
                    priceSpan.innerHTML = `
                        <span class="strikethrough">RM <%=pricePerSeat%></span>
                        &nbsp;<span class="discounted-price">RM <%=pricePerSeat /2%></span>
                        <span style="color:#2e7d32; font-size:0.8rem;"> (Warga Emas -50%)</span>`;
                } else {
                    seatAges[seat] = { age: age, discount: false };
                    priceSpan.innerHTML = 'RM<%= String.format("%.2f", pricePerSeat) %>';
                }
            } else {
                delete seatAges[seat];
                priceSpan.innerHTML = 'RM<%= String.format("%.2f", pricePerSeat) %>';
            }

            recalcTotal();
        }

        function recalcTotal() {
            let total = 0;
            document.querySelectorAll('input[name="passenger_age"]').forEach(input => {
                const seat = input.getAttribute('data-seat').trim();
                const data = seatAges[seat];
                total += (data && data.discount) ? pricePerSeat * 0.5 : pricePerSeat;
            });
            
            const hasAccumulated = <%= accumulatedPrice != null %>;
            if (hasAccumulated) {
                const accumulated = <%= accumulatedPrice != null ? accumulatedPrice : 0.0 %>;
                document.getElementById('display-return-subtotal').textContent = 'RM' + total.toFixed(2);
                
                const discount = (accumulated + total) * 0.1;
                document.getElementById('display-discount').textContent = '-RM' + discount.toFixed(2);
                
                const finalTotal = (accumulated + total) * 0.9;
                document.getElementById('display-total').textContent = 'RM' + finalTotal.toFixed(2);
            } else {
                document.getElementById('display-total').textContent = 'RM' + total.toFixed(2);
            }
            
            document.getElementById('hidden_total_price').value = total.toFixed(2);
        }

        // Trigger validation on load to apply any pre-filled discounts
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('input[name="passenger_age"]').forEach(input => {
                if (input.value) {
                    handleAgeInput(input);
                }
            });
        });
    </script>

</body>
</html>