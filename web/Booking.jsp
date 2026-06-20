<%@page import="model.Bus" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Book Trip - Sani Express</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="style.css" />
        </head>

        <body>
            <div class="bg-bus-icon"><i class="fa-solid fa-bus"></i></div>

            <%@ page import="java.util.List" %>
                <%@ page import="model.Trip" %>


                    <% String origin=request.getParameter("origin"); String
                        destination=request.getParameter("destination"); String
                        trip_date=request.getParameter("trip_date"); String
                        return_date=request.getParameter("return_date");%>

                        <jsp:include page="header.jsp" />

                        <!--        
<h1><%=session.getAttribute("username")%></h1>
<h1><%=session.getAttribute("email")%></h1>
<h1><%=session.getAttribute("phoneNumber")%></h1>
<h1><%=session.getAttribute("passengerId")%></h1>-->


                        <div class="main-container" style="margin-top: 50px;">

                            <div style="text-align: center; margin-bottom: 30px;">
                                <div class="tab-nav" style="margin-top: 20px; display: inline-flex;">
                                    <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book
                                        Trip</a>
                                    <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My
                                        Bookings</a>
                                    <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
                                </div>

                                <div style="margin-top: 25px;">
                                    <h2
                                        style="font-size: 32px; font-weight: 800; color: #1f2937; margin: 0 0 10px 0; letter-spacing: -0.5px;">
                                        Where are you traveling next?</h2>
                                    <p style="color: #6b7280; font-size: 16px; margin: 0;">Find the best routes and book
                                        your bus tickets today!</p>
                                </div>
                            </div>

                            <div class="promo-container">
                                <div class="promo-card senior">
                                    <div class="promo-icon-box">
                                        <i class="fa-solid fa-user-tag"></i>
                                    </div>
                                    <div class="promo-content">
                                        <span class="promo-badge">Senior Promo</span>
                                        <h3 class="promo-title">50% Golden Age Discount</h3>
                                        <p class="promo-desc">Elders (ages 60+) enjoy an automatic 50% discount on every
                                            ticket purchased.</p>
                                    </div>
                                </div>
                                <div class="promo-card return">
                                    <div class="promo-icon-box">
                                        <i class="fa-solid fa-tags"></i>
                                    </div>
                                    <div class="promo-content">
                                        <span class="promo-badge">Round Trip Deal</span>
                                        <h3 class="promo-title">10% Off Returning Trips</h3>
                                        <p class="promo-desc">Book a return journey and enjoy a 10% discount on your
                                            entire booking total!</p>
                                    </div>
                                </div>
                            </div>

                            <div class="search-card">
                                <h2 class="card-title" style="margin-bottom: 25px; color: #cc2525; font-size: 18px;"><i
                                        class="fa-solid fa-magnifying-glass"></i> Search Bus Trips</h2>

                                <form action="booking" method="GET">

                                    <input type="hidden" name="action" value="search">
                                    <div class="form-row">

                                        <div class="form-group">
                                            <label>From</label>
                                            <div class="input-wrapper">
                                                <i class="fa-solid fa-location-dot"></i>
                                                <select name="origin" class="form-control" required>
                                                    <option value="" disabled <%=(origin==null) ? "selected" : "" %>
                                                        >Select origin</option>
                                                    <option value="Kuala Terengganu" <%=("Kuala Terengganu".equals(origin)) ? "selected" : "" %>>Kuala
                                                        Terengganu</option>

                                                    <option value="Kuala Lumpur" <%=("Kuala Lumpur".equals(origin))
                                                        ? "selected" : "" %>>Kuala Lumpur</option>
                                                    <option value="Penang" <%=("Penang".equals(origin)) ? "selected"
                                                        : "" %>>Penang</option>
                                                    <option value="Johor Bahru" <%=("Johor Bahru".equals(origin))
                                                        ? "selected" : "" %>>Johor Bahru</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>To</label>
                                            <div class="input-wrapper">
                                                <i class="fa-solid fa-location-crosshairs"></i>
                                                <select name="destination" class="form-control" required>
                                                    <option value="" disabled <%=(destination==null) ? "selected" : ""
                                                        %>>Select destination</option>
                                                    <option value="Kuala Lumpur" <%=("Kuala Lumpur".equals(destination))
                                                        ? "selected" : "" %>>Kuala Lumpur</option>
                                                    <option value="Penang" <%=("Penang".equals(destination))
                                                        ? "selected" : "" %>>Penang</option>
                                                    <option value="Johor Bahru" <%=("Johor Bahru".equals(destination))
                                                        ? "selected" : "" %>>Johor Bahru</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Date</label>
                                            <div class="input-wrapper">
                                                <i class="fa-regular fa-calendar"></i>
                                                <input type="date" name="trip_date" class="form-control"
                                                    value="<%= (trip_date != null) ? trip_date : ""%>" required>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Returning Date (Optional)</label>
                                            <div class="input-wrapper">
                                                <i class="fa-regular fa-calendar"></i>
                                                <input type="date" name="return_date" class="form-control"
                                                    value="<%= (return_date != null) ? return_date : ""%>">
                                            </div>
                                        </div>

                                    </div>

                                    <button type="submit" class="btn-submit">
                                        <i class="fa-solid fa-magnifying-glass"></i> Search Trips
                                    </button>
                                </form>
                            </div>

                            <% if (origin !=null && !origin.isEmpty()) {%>
                                <form action="SelectSeat.jsp" method="POST" id="tripSelectionForm">
                                    <input type="hidden" name="trip_id" id="out_trip_id">
                                    <input type="hidden" name="bus_id" id="out_bus_id">
                                    <input type="hidden" name="origin" id="out_origin">
                                    <input type="hidden" name="destination" id="out_destination">
                                    <input type="hidden" name="trip_date" id="out_trip_date">
                                    <input type="hidden" name="price" id="out_price">

                                    <input type="hidden" name="return_trip_id" id="ret_trip_id">
                                    <input type="hidden" name="return_bus_id" id="ret_bus_id">
                                    <input type="hidden" name="return_origin" id="ret_origin">
                                    <input type="hidden" name="return_destination" id="ret_destination">
                                    <input type="hidden" name="return_date" id="ret_date">
                                    <input type="hidden" name="return_price" id="ret_price">

                                    <div class="results-container">
                                        <div
                                            style="display:flex; align-items:center; gap:10px; margin-top:36px; margin-bottom:16px;">
                                            <div style="flex:1; height:1px; background:#eee;">
                                            </div>
                                            <span class="trip-pill-bar">
                                                <i class="fa-solid fa-arrow-right"></i>&nbsp;
                                                Outbound Trip
                                            </span>
                                            <div style="flex:1; height:1px; background:#eee;">
                                            </div>
                                        </div>
                                        <h2 class="section-title">Outbound Trips for
                                            <%=trip_date%>
                                        </h2>
                                    </div>
                                    <% }%>

                                        <% if (request.getAttribute("trips") !=null && request.getAttribute("busList")
                                            !=null) { List<Trip> trips = (List<Trip>) request.getAttribute("trips");
                                                List<Bus> busList = (List<Bus>) request.getAttribute("busList");

                                                        if (trips.isEmpty()) { %>
                                                        <div style="text-align:center; padding:32px; background:#fdfdfd; border:1px solid #f0f0f0;
                      border-radius:18px; color:#999; font-size:14px; margin-bottom: 20px;">
                                                            <i class="fa-solid fa-circle-info"
                                                                style="font-size:24px; color:#ddd; display:block; margin-bottom:10px;"></i>
                                                            No outbound trips found for this date.
                                                        </div>
                                                        <% } else { for (int i=0; i < trips.size(); i++) { Trip
                                                            t=trips.get(i); Bus b=busList.get(i); %>
                                                            <div class="trip-card">
                                                                <div class="trip-info">
                                                                    <h3>
                                                                        <%= t.getDepartureTime()%>
                                                                    </h3>
                                                                    <p class="route">
                                                                        <%= t.getOrigin()%> &rarr; <%=
                                                                                t.getDestination()%>
                                                                    </p>

                                                                    <p class="bus-type">
                                                                        <i class="fa-solid fa-bus"></i>
                                                                        <%= b.getBusType()%> • <%= b.getBusNumber()%> •
                                                                                <%= b.getTotalSeats()%> Seats Total
                                                                    </p>
                                                                </div>

                                                                <div class="trip-action">
                                                                    <div class="price">RM <%= t.getPrice()%>
                                                                    </div>
                                                                    <button type="button" class="btn-select out-btn"
                                                                        onclick="selectOutbound('<%= t.getTripId()%>', '<%= b.getBusId()%>', '<%= t.getOrigin()%>', '<%= t.getDestination()%>', '<%= t.getDepartureTime()%>', '<%= t.getPrice()%>', '<%= b.getBusNumber()%>', this)">
                                                                        Select
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <% } } } %>

                                                                <%-- ── RETURN TRIPS SECTION
                                                                    ─────────────────────────────── --%>
                                                                    <% if (request.getAttribute("returnTrips") !=null &&
                                                                        request.getAttribute("returnBusList") !=null) {
                                                                        List<Trip> returnTrips = (List<Trip>)
                                                                            request.getAttribute("returnTrips");
                                                                            List<Bus> returnBusList = (List<Bus>)
                                                                                    request.getAttribute("returnBusList");
                                                                                    String returnDateVal = (String)
                                                                                    request.getAttribute("returnDate");
                                                                                    %>
                                                                                    <div class="results-container">
                                                                                        <div
                                                                                            style="display:flex; align-items:center; gap:10px; margin-top:36px; margin-bottom:16px;">
                                                                                            <div
                                                                                                style="flex:1; height:1px; background:#eee;">
                                                                                            </div>
                                                                                            <span class="trip-pill-bar">
                                                                                                <i
                                                                                                    class="fa-solid fa-rotate-left"></i>&nbsp;
                                                                                                Return Trip
                                                                                            </span>
                                                                                            <div
                                                                                                style="flex:1; height:1px; background:#eee;">
                                                                                            </div>
                                                                                        </div>
                                                                                        <h2 class="section-title">Return
                                                                                            Trips for <%=
                                                                                                returnDateVal%>
                                                                                        </h2>
                                                                                    </div>

                                                                                    <% if (returnTrips.isEmpty()) { %>
                                                                                        <div style="text-align:center; padding:32px; background:#fdfdfd; border:1px solid #f0f0f0;
                     border-radius:18px; color:#999; font-size:14px;">
                                                                                            <i class="fa-solid fa-circle-info"
                                                                                                style="font-size:24px; color:#ddd; display:block; margin-bottom:10px;"></i>
                                                                                            No return trips found for
                                                                                            this date.
                                                                                        </div>
                                                                                        <% } else { for (int i=0; i <
                                                                                            returnTrips.size(); i++) {
                                                                                            Trip rt=returnTrips.get(i);
                                                                                            Bus rb=returnBusList.get(i);
                                                                                            %>
                                                                                            <div class="trip-card">
                                                                                                <div class="trip-info">
                                                                                                    <h3>
                                                                                                        <%=
                                                                                                            rt.getDepartureTime()%>
                                                                                                    </h3>
                                                                                                    <p class="route">
                                                                                                        <%=
                                                                                                            rt.getOrigin()%>
                                                                                                            &rarr; <%=
                                                                                                                rt.getDestination()%>
                                                                                                    </p>
                                                                                                    <p class="bus-type">
                                                                                                        <i
                                                                                                            class="fa-solid fa-bus"></i>
                                                                                                        <%=
                                                                                                            rb.getBusType()%>
                                                                                                            &bull; <%=
                                                                                                                rb.getBusNumber()%>
                                                                                                                &bull;
                                                                                                                <%=
                                                                                                                    rb.getTotalSeats()%>
                                                                                                                    Seats
                                                                                                                    Total
                                                                                                    </p>
                                                                                                </div>
                                                                                                <div
                                                                                                    class="trip-action">
                                                                                                    <div class="price">
                                                                                                        RM <%=
                                                                                                            rt.getPrice()%>
                                                                                                    </div>
                                                                                                    <button
                                                                                                        type="button"
                                                                                                        class="btn-select ret-btn"
                                                                                                        onclick="selectReturn('<%= rt.getTripId()%>', '<%= rb.getBusId()%>', '<%= rt.getOrigin()%>', '<%= rt.getDestination()%>', '<%= rt.getDepartureTime()%>', '<%= rt.getPrice()%>', '<%= rb.getBusNumber()%>', this)">
                                                                                                        Select
                                                                                                    </button>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } } %>
                                                                                                <% } %>

                                                                                                    <% boolean
                                                                                                        isRoundTrip=request.getAttribute("returnTrips")
                                                                                                        !=null;%>

                                                                                                        <div id="proceedContainer"
                                                                                                            style="display: none; align-items: center; justify-content: space-between; margin-top: 30px; padding: 20px; background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); position: sticky; bottom: 20px; z-index: 100;">
                                                                                                            <div id="selectionInfo"
                                                                                                                style="text-align: left; font-size: 14px; color: #555;">
                                                                                                                <!-- Selected trip info will be placed here -->
                                                                                                            </div>

                                                                                                            <button
                                                                                                                type="button"
                                                                                                                class="btn-submit"
                                                                                                                id="proceedBtn"
                                                                                                                onclick="validateAndProceed(<%= isRoundTrip%>)"
                                                                                                                style="width: auto; padding: 15px 40px; font-size: 16px; margin: 0;">
                                                                                                                Proceed
                                                                                                                to Seat
                                                                                                                Selection
                                                                                                                <i class="fa-solid fa-arrow-right"
                                                                                                                    style="margin-left: 10px;"></i>
                                                                                                            </button>
                                                                                                        </div>

                                </form>

                        </div>

                        <script>
                            let outInfoStr = '';
                            let retInfoStr = '';

                            function selectOutbound(tripId, busId, origin, dest, date, price, busNumber, btnElem) {
                                document.getElementById('out_trip_id').value = tripId;
                                document.getElementById('out_bus_id').value = busId;
                                document.getElementById('out_origin').value = origin;
                                document.getElementById('out_destination').value = dest;
                                document.getElementById('out_trip_date').value = date;
                                document.getElementById('out_price').value = price;

                                outInfoStr = `Outbound: ${date} (Bus: ${busNumber})`;

                                document.querySelectorAll('.out-btn').forEach(btn => {
                                    btn.innerHTML = 'Select';
                                    btn.style.backgroundColor = '';
                                    btn.style.color = '';
                                    btn.style.borderColor = '';
                                    btn.closest('.trip-card').style.borderLeft = 'none';
                                });

                                btnElem.innerHTML = '<i class="fa-solid fa-check"></i> Selected';
                                btnElem.style.backgroundColor = '#2e7d32';
                                btnElem.style.color = 'white';
                                btnElem.style.borderColor = '#2e7d32';

                                checkProceedVisibility();
                            }

                            function selectReturn(tripId, busId, origin, dest, date, price, busNumber, btnElem) {
                                document.getElementById('ret_trip_id').value = tripId;
                                document.getElementById('ret_bus_id').value = busId;
                                document.getElementById('ret_origin').value = origin;
                                document.getElementById('ret_destination').value = dest;
                                document.getElementById('ret_date').value = date;
                                document.getElementById('ret_price').value = price;

                                retInfoStr = `Return: ${date} (Bus: ${busNumber})`;

                                document.querySelectorAll('.ret-btn').forEach(btn => {
                                    btn.innerHTML = 'Select';
                                    btn.style.backgroundColor = '';
                                    btn.style.color = '';
                                    btn.style.borderColor = '';
                                });

                                btnElem.innerHTML = '<i class="fa-solid fa-check"></i> Selected';
                                btnElem.style.backgroundColor = '#2e7d32';
                                btnElem.style.color = 'white';
                                btnElem.style.borderColor = '#2e7d32';

                                checkProceedVisibility();
                            }

                            function checkProceedVisibility() {
                                const outTrip = document.getElementById('out_trip_id').value;
                                const retTrip = document.getElementById('ret_trip_id').value;
                                const isRoundTrip = document.querySelector('.ret-btn') !== null;
                                const container = document.getElementById('proceedContainer');
                                const infoDiv = document.getElementById('selectionInfo');

                                let infoHtml = '';
                                if (outTrip) {
                                    //                                    infoHtml += `<div style="font-weight: 600; color: #333;"><i class="fa-solid fa-arrow-right" style="color: #cc2525;"></i> ${outInfoStr}</div>`;
                                }
                                if (retTrip) {
                                    //                                    infoHtml += `<div style="font-weight: 600; color: #333; margin-top: 8px;"><i class="fa-solid fa-arrow-left" style="color: #cc2525;"></i> ${retInfoStr}</div>`;
                                }
                                infoDiv.innerHTML = infoHtml;

                                if (isRoundTrip) {
                                    if (outTrip && retTrip)
                                        container.style.display = 'flex';
                                } else {
                                    if (outTrip)
                                        container.style.display = 'flex';
                                }
                            }

                            function validateAndProceed(isRoundTrip) {
                                const outTrip = document.getElementById('out_trip_id').value;
                                const retTrip = document.getElementById('ret_trip_id').value;

                                if (!outTrip) {
                                    alert('Please select an outbound trip.');
                                    return;
                                }
                                if (isRoundTrip && !retTrip) {
                                    alert('Please select a return trip.');
                                    return;
                                }

                                document.getElementById('tripSelectionForm').submit();
                            }
                        </script>

                        <footer class="main-footer">
                            &copy; 2026 Sani Express. All rights reserved.
                        </footer>
        </body>

        </html>