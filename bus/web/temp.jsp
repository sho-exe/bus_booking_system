<%
    String[] seats = request.getParameterValues("seat_number");
    String[] names = request.getParameterValues("passenger_name");
    String[] phones = request.getParameterValues("passenger_phone");

    String total_price = request.getParameter("total_price");

    Double total_price_Double = Double.parseDouble(total_price);

    String origin = (String) session.getAttribute("origin");
    String destination = (String) session.getAttribute("destination");
    String trip_date = (String) session.getAttribute("trip_date");
    String price = (String) session.getAttribute("price");


%>
<%@page contentType = "text/html" pageEncoding = "UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
<!--
        <h1><i>RECEIVE FROM TRIP</i></h1>

        <h2>trip_id</h2>
        <h2>origin</h2>
        <h2>destination</h2>
        <h2>departure_time</h2>
        <h2>arrival_time</h2>
        <h2>price</h2>
        <h2>bus_id</h2>
        <h2>driver_id</h2>

        <h1><i>RECEIVE FROM BUS (to know total seats) </i></h1>

        <h2>bus_id</h2>
        <h2>bus_number</h2>
        <h2>bus_type</h2>
        <h2>total_seats</h2>

        <h1><i>RECEIVE FROM BOOKING (to check seats taken)</i></h1>

        <h2>booking_id</h2>
        <h2>booking_date</h2>
        <h2>status</h2>
        <h2>passenger_id</h2>
        <h2>trip_id</h2>
        <h2>staff_id</h2>
        <h2>seat</h2>

        <h1><i>INSERT TO BOOKING (1person 1seat)</i></h1>

        <h2>booking_id</h2>
        <h2>booking_date</h2>
        <h2>status</h2>
        <h2>passenger_id</h2>
        <h2>trip_id</h2>
        <h2>staff_id</h2>
        <h2>seat</h2>-->


        <h1><i>REDIRECT TO PAYMENT PAGE</i></h1>




        <h1>From "<%=origin%>" to "<%=destination%>" on "<%=trip_date%>" with RM<%=String.format("%.2f", total_price_Double)%></h1>

        <%

            for (int i = 0; i < seats.length; i++) {

        %>
        <h1>"Seat " <%=seats[i]%>" belongs to " <%=names[i]%> " " <%= phones[i]%> "</h1>

        <%
            }
        %>
    </body>
</html>
