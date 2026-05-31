<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Passenger Details - Sani Express</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css" />
    <style>
        .age-warning {
            margin-top: 8px;
            padding: 8px 12px;
            background-color: #fff8e1;
            border-left: 4px solid #f9a825;
            color: #7b5e00;
            border-radius: 4px;
            font-size: 0.875rem;
        }
        .age-discount {
            margin-top: 8px;
            padding: 8px 12px;
            background-color: #e8f5e9;
            border-left: 4px solid #2e7d32;
            color: #1b5e20;
            border-radius: 4px;
            font-size: 0.875rem;
        }
        .seat-price-detail {
            font-size: 0.85rem;
            color: #888;
        }
        .discounted-price {
            color: #2e7d32;
            font-weight: bold;
        }
        .strikethrough {
            text-decoration: line-through;
            color: #aaa;
        }
    </style>
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
    %>

    <div class="main-container">

        <div class="tab-nav">
            <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
            <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
            <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
        </div>

        <br>
        <a href="SelectSeat.jsp" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Seats</a>

        <form action="temp.jsp" method="POST">

            <input type="hidden" name="origin" value="<%= (origin != null) ? origin : "" %>">
            <input type="hidden" name="destination" value="<%= (destination != null) ? destination : "" %>">
            <input type="hidden" name="trip_date" value="<%= (tripDate != null) ? tripDate : "" %>">
            <input type="hidden" name="total_price" id="hidden_total_price" value="<%= (totalPrice != 0.0) ? totalPrice : "" %>">
            <input type="hidden" name="trip_id" value="<%= session.getAttribute("trip_id") %>">

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
                        if (selectedSeats != null && selectedSeats.length > 0) {
                            for (String seat : selectedSeats) {
                    %>
                    <div class="trip-card">
                        <div class="trip-info" style="width: 100%;">
                            <h3 style="margin-bottom: 15px; color: #cc2525;">
                                <i class="fa-regular fa-user"></i> Details for Seat <%= seat %>
                            </h3>

                            <input type="hidden" name="seat_number" value="<%= seat %>">

                            <div class="form-row" style="margin-bottom: 0;">
                                <div class="form-group">
                                    <label>Full Name</label>
                                    <div class="input-wrapper">
                                        <i class="fa-regular fa-id-badge"></i>
                                        <input type="text" name="passenger_name" class="form-control"
                                            placeholder="Enter full name" required>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Age</label>
                                    <div class="input-wrapper">
                                        <i class="fa-solid fa-user"></i>
                                        <input type="number" name="passenger_age" class="form-control"
                                            placeholder="Enter age" min="1" max="120"
                                            data-seat="<%= seat %>"
                                            oninput="handleAgeInput(this)"
                                            required>
                                    </div>
                                    <div id="age-msg-<%= seat %>"></div>
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

                    <%-- Per-seat breakdown injected by JS --%>
                    <div id="seat-breakdown"></div>

                    <div class="divider"></div>

                    <div class="total-row">
                        <span>Total:</span>
                        <span class="total-price" id="display-total">RM <%= String.format("%.2f", totalPrice) %></span>
                    </div>

                    <button type="submit" class="btn-payment">Proceed to Complete Booking</button>
                </div>
            </div>
        </form>

    </div>

    <script>
        const pricePerSeat = <%= pricePerSeat %>;
        const seatAges = {}; // { seatNumber: age }

        function handleAgeInput(input) {
            const seat = input.getAttribute('data-seat');
            const age = parseInt(input.value);
            const msgDiv = document.getElementById('age-msg-' + seat);

            msgDiv.innerHTML = '';

            if (!isNaN(age) && input.value !== '') {
                if (age < 12) {
                    msgDiv.innerHTML = `
                        <div class="age-warning">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            Passenger is a child (below 12). Please bring the child's <strong>IC card</strong> for safety verification during boarding.
                        </div>`;
                    seatAges[seat] = { age: age, discount: false };
                } else if (age >= 60) {
                    msgDiv.innerHTML = `
                        <div class="age-discount">
                            <i class="fa-solid fa-tag"></i>
                            Warga Emas detected (age ${age}). <strong>50% senior citizen discount</strong> applied for this seat.
                        </div>`;
                    seatAges[seat] = { age: age, discount: true };
                } else {
                    seatAges[seat] = { age: age, discount: false };
                }
            } else {
                delete seatAges[seat];
            }

            recalcTotal();
        }

        function recalcTotal() {
            const allAgeInputs = document.querySelectorAll('input[name="passenger_age"]');
            const totalSeats = allAgeInputs.length;

            let total = 0;
            let breakdownHtml = '';

            allAgeInputs.forEach(input => {
                const seat = input.getAttribute('data-seat');
                const data = seatAges[seat];

                if (data && data.discount) {
                    const discounted = pricePerSeat * 0.5;
                    total += discounted;
                    breakdownHtml += `
                        <div class="summary-row seat-price-detail">
                            <span>Seat ${seat}:</span>
                            <span>
                                <span class="strikethrough">RM${pricePerSeat.toFixed(2)}</span>
                                &nbsp;<span class="discounted-price">RM${discounted.toFixed(2)}</span>
                                <span style="color:#2e7d32; font-size:0.8rem;"> (Warga Emas -50%)</span>
                            </span>
                        </div>`;
                } else {
                    total += pricePerSeat;
                    breakdownHtml += `
                        <div class="summary-row seat-price-detail">
                            <span>Seat ${seat}:</span>
                            <span>RM${pricePerSeat.toFixed(2)}</span>
                        </div>`;
                }
            });

            document.getElementById('seat-breakdown').innerHTML = breakdownHtml;
            document.getElementById('display-total').textContent = 'RM ' + total.toFixed(2);
            document.getElementById('hidden_total_price').value = total.toFixed(2);
        }

        // Init breakdown on page load with default prices
        recalcTotal();
    </script>

</body>
</html>