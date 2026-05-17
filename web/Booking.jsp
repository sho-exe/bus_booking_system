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

            <%@ page import="java.util.List" %>
                <%@ page import="model.Trip" %>


                    <% String origin=request.getParameter("origin"); String
                        destination=request.getParameter("destination"); String
                        trip_date=request.getParameter("trip_date"); %>

                        <jsp:include page="header.jsp" />

                        <!--        
        <h1><%=session.getAttribute("username")%></h1>
                <h1><%=session.getAttribute("email")%></h1>
        <h1><%=session.getAttribute("phoneNumber")%></h1>
         <h1><%=session.getAttribute("passengerId")%></h1>-->


                        <div class="main-container">

                            <div class="tab-nav" style="margin-top: 20px;">
                                <a href="#" class="tab active"><i class="fa-solid fa-magnifying-glass"></i> Book
                                    Trip</a>
                                <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                                <a href="profile.jsp" class="tab"><i class="fa-regular fa-user"></i> Profile</a>
                            </div>

                            <div class="search-card" style="margin-top: 20px;">
                                <h2 class="card-title"><i class="fa-solid fa-magnifying-glass"></i> Search Bus Trips
                                </h2>

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

                                    </div>

                                    <button type="submit" class="btn-submit">
                                        <i class="fa-solid fa-magnifying-glass"></i> Search Trips
                                    </button>
                                </form>
                            </div>

                            <% if (origin !=null && !origin.isEmpty()) {%>
                                <div class="results-container">
                                    <h2 class="section-title" style="margin-top: 30px;">Available Trips for <%=
                                            trip_date%>
                                    </h2>


                                </div>
                                <% }%>

                                    <% if (request.getAttribute("trips") !=null && request.getAttribute("busList")
                                        !=null) { List<Trip> trips = (List<Trip>) request.getAttribute("trips");
                                            List<Bus> busList = (List<Bus>) request.getAttribute("busList");

                                                    // Use a counter to stay in sync with the bus list
                                                    for (int i = 0; i < trips.size(); i++) { Trip t=trips.get(i); Bus
                                                        b=busList.get(i); // This gets the matching bus for this trip %>
                                                        <div class="trip-card">
                                                            <div class="trip-info">
                                                                <h3>
                                                                    <%= t.getDepartureTime()%>
                                                                </h3>
                                                                <p class="route">
                                                                    <%= t.getOrigin()%> &rarr; <%= t.getDestination()%>
                                                                </p>

                                                                <p class="bus-type">
                                                                    <%= b.getBusType() %> • <%= b.getBusNumber() %> •
                                                                            <%= b.getTotalSeats() %> Seats Total
                                                                </p>
                                                            </div>

                                                            <div class="trip-action">
                                                                <div class="price">RM <%= t.getPrice()%>
                                                                </div>
                                                                <form action="SelectSeat.jsp" method="POST">
                                                                    <input type="hidden" name="trip_id"
                                                                        value="<%= t.getTripId()%>">
                                                                    <input type="hidden" name="bus_id"
                                                                        value="<%= b.getBusId()%>">
                                                                    <input type="hidden" name="origin"
                                                                        value="<%= t.getOrigin()%>">
                                                                    <input type="hidden" name="destination"
                                                                        value="<%= t.getDestination()%>">
                                                                    <input type="hidden" name="trip_date"
                                                                        value="<%= t.getDepartureTime()%>">
                                                                    <input type="hidden" name="price"
                                                                        value="<%= t.getPrice()%>">
                                                                    <button type="submit" class="btn-select">Select
                                                                        Seat</button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                        <% } } %>
                        </div>

        </body>

        </html>