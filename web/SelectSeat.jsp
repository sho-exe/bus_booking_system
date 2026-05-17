<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Select Seats - Sani Express</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="style.css">

    </head>
    <body>

        <%
            String trip_id = (String) session.getAttribute("trip_id");
            String origin = request.getParameter("origin");
            String destination = request.getParameter("destination");
            String trip_date = request.getParameter("trip_date");
            String price = request.getParameter("price");

            if (origin != null) {

                session.setAttribute("origin", origin);
                session.setAttribute("destination", destination);
                session.setAttribute("trip_date", trip_date);
                session.setAttribute("price", price);

            }

        %>
        <jsp:include page="header.jsp" />

        <div class="main-container">

            <div class="tab-nav">
                <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
                <a href="#" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                <a href="#" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
            </div>

            <br>
            <a href="booking" class="back-btn"><i class="fa-solid fa-arrow-left"></i> Back to Search</a>

                        <form action="PassengerDetails.jsp" method="POST">

            <!--<form action="temp.jsp" method="POST">-->
                <div class="layout-grid">

                    <div class="left-col">
                        <h2 class="section-title">Select Your Seats</h2>

                        <div class="legend">
                            <div class="legend-item"><div class="box available"></div> Available</div>
                            <div class="legend-item"><div class="box selected"></div> Selected</div>
                            <div class="legend-item"><div class="box booked"></div> Booked</div>
                        </div>


                        <!-- 
                        <div class="bus-container">
                            <div class="driver-area">DRIVER</div>

                            <div class="seat-row">
                                <input type="checkbox" id="seat-1" name="selected_seats" value="1" class="seat-checkbox">
                                <label for="seat-1" class="seat-label">1</label>

                                <input type="checkbox" id="seat-2" name="selected_seats" value="2" class="seat-checkbox">
                                <label for="seat-2" class="seat-label">2</label>

                                <div class="aisle"></div>

                                <input type="checkbox" id="seat-3" name="selected_seats" value="3" class="seat-checkbox">
                                <label for="seat-3" class="seat-label">3</label>

                                <input type="checkbox" id="seat-4" name="selected_seats" value="4" class="seat-checkbox">
                                <label for="seat-4" class="seat-label">4</label>
                            </div>

                            <div class="seat-row">
                                <input type="checkbox" id="seat-5" name="selected_seats" value="5" class="seat-checkbox" disabled>
                                <label for="seat-5" class="seat-label">5</label>

                                <input type="checkbox" id="seat-6" name="selected_seats" value="6" class="seat-checkbox" disabled>
                                <label for="seat-6" class="seat-label">6</label>

                                <div class="aisle"></div>

                                <input type="checkbox" id="seat-7" name="selected_seats" value="7" class="seat-checkbox">
                                <label for="seat-7" class="seat-label">7</label>

                                <input type="checkbox" id="seat-8" name="selected_seats" value="8" class="seat-checkbox">
                                <label for="seat-8" class="seat-label">8</label>
                            </div>

                            <div class="seat-row">
                                <input type="checkbox" id="seat-9" name="selected_seats" value="9" class="seat-checkbox">
                                <label for="seat-9" class="seat-label">9</label>

                                <input type="checkbox" id="seat-10" name="selected_seats" value="10" class="seat-checkbox">
                                <label for="seat-10" class="seat-label">10</label>

                                <div class="aisle"></div>

                                <input type="checkbox" id="seat-11" name="selected_seats" value="11" class="seat-checkbox">
                                <label for="seat-11" class="seat-label">11</label>

                                <input type="checkbox" id="seat-12" name="selected_seats" value="12" class="seat-checkbox">
                                <label for="seat-12" class="seat-label">12</label>
                            </div>

                            <div class="seat-row">
                                <input type="checkbox" id="seat-13" name="selected_seats" value="13" class="seat-checkbox">
                                <label for="seat-13" class="seat-label">13</label>

                                <input type="checkbox" id="seat-14" name="selected_seats" value="14" class="seat-checkbox">
                                <label for="seat-14" class="seat-label">14</label>

                                <div class="aisle"></div>

                                <input type="checkbox" id="seat-15" name="selected_seats" value="15" class="seat-checkbox">
                                <label for="seat-15" class="seat-label">15</label>

                                <input type="checkbox" id="seat-16" name="selected_seats" value="16" class="seat-checkbox">
                                <label for="seat-16" class="seat-label">16</label>
                            </div>

                        </div>
                        
                        -->

                        <%@ page import="java.util.List" %>
                        <%@ page import="dao.BookingDAO" %>
                        <%                            
                            String tripIdStr = request.getParameter("trip_id");
                            if (tripIdStr != null) {
                                session.setAttribute("trip_id", tripIdStr);
                            } else {
                                tripIdStr = (String) session.getAttribute("trip_id");
                            }

                            int totalSeats = 31;
                            List<Integer> bookedList = new java.util.ArrayList<>();
                            if (tripIdStr != null && !tripIdStr.isEmpty()) {
                                int tripId = Integer.parseInt(tripIdStr);
                                bookedList = new BookingDAO().getBookedSeatsByTrip(tripId);
                            }
                            
                            java.util.Set<String> bookedSet = new java.util.HashSet<>();
                            for(Integer seat : bookedList) {
                                bookedSet.add(String.valueOf(seat));
                            }
                        %>

                        <div class="bus-container">
                            <div class="driver-area">DRIVER</div>

                            <%
                                for (int i = 1; i <= totalSeats; i += 4) {
                                    int[] rowSeats = {i, i + 1, i + 2, i + 3};
                            %>
                            <div class="seat-row">
                                <%
                                    for (int j = 0; j < 4; j++) {
                                        int seatNum = rowSeats[j];
                                        boolean isBooked = bookedSet.contains(String.valueOf(seatNum));
                                        String disabledAttr = isBooked ? "disabled" : "";
                                %>

                                <% if (j == 2) { %>
                                <div class="aisle"></div>
                                <% }%>

                                <input type="checkbox" id="seat-<%=seatNum%>" name="selected_seats"
                                       value="<%=seatNum%>" class="seat-checkbox" <%=disabledAttr%>>
                                <label for="seat-<%=seatNum%>" class="seat-label"><%=seatNum%></label>

                                <% } %>
                            </div>
                            <% }%>
                        </div>
                    </div>

                    <div class="right-col">
                        <h2 class="section-title">Booking Summary</h2>

                        
                        <div class="summary-row bold">
                            <span>Route:</span>
                            <span><%=session.getAttribute("trip_id")%></span>
                        </div>
                        <div class="summary-row bold">
                            <span>Route:</span>
                            <span><%=session.getAttribute("origin")%> &rarr; <%=session.getAttribute("destination")%></span>
                        </div>
                        <div class="summary-row">
                            <span>Date:</span>
                            <span><%= session.getAttribute("trip_date")%></span>
                        </div>
                        <div class="summary-row">
                            <span>Departure:</span>
                            <span>09:00</span>
                        </div>

                        <div class="divider"></div>

                        <div class="summary-row">
                            <span>Selected Seats:</span>
                            <span id="seat-count">1</span>
                        </div>
                        <div class="summary-row">
                            <span>Price per seat:</span>
                            <span>RM<%=session.getAttribute("price")%>.00</span>
                        </div>

                        <div class="divider"></div>

                        <div class="total-row">
                            <span>Total:</span>
                            <span class="total-price" id="total-price">RM<%=session.getAttribute("price")%>.00</span>
                        </div>

                        <button type="submit" class="btn-payment" onclick="alertSeats()">Fill Passengers Details</button>
                    </div>

                </div>
            </form>

        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const pricePerSeat = <%= session.getAttribute("price")%>;

                const seatCountDisplay = document.getElementById('seat-count');
                const totalPriceDisplay = document.getElementById('total-price');

                const seatCheckboxes = document.querySelectorAll('.seat-checkbox:not([disabled])');

                function updateTotals() {
                    const selectedSeats = document.querySelectorAll('.seat-checkbox:checked');
                    const count = selectedSeats.length;

                    const total = count * pricePerSeat;

                    seatCountDisplay.textContent = count;
                    totalPriceDisplay.textContent = 'RM ' + total.toFixed(2);
                }

                seatCheckboxes.forEach(function (checkbox) {
                    checkbox.addEventListener('change', updateTotals);
                });

                updateTotals();
            });

        </script>
    </body>
</html>