<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Temp</title>
    </head>
    <body>
        <pre>
=== SESSION DATA ===
TRIP ID: <%= session.getAttribute("trip_id")%>
TOTAL PRICE: <%= session.getAttribute("total_price")%>

=== SELECTED SEATS (from session) ===
            <%
                String[] selectedSeats = (String[]) session.getAttribute("selected_seats");
                if (selectedSeats != null && selectedSeats.length > 0) {
                    for (String seat : selectedSeats) {
                        out.println("Seat: " + seat);
                    }
                } else {
                    out.println("No seats selected.");
                }
            %>

=== BOOKER DETAILS ===
booker_name:  <%= request.getParameter("booker_name")%>
            <%

                session.setAttribute("booker_name", request.getParameter("booker_name"));%>
booker_phone: <%= request.getParameter("booker_phone")%>

            <%
    session.setAttribute("booker_phone", request.getParameter("booker_phone"));%>



=== PASSENGER + BOOKING INSERT RESULT ===
            <%
                String[] seats = request.getParameterValues("seat_number");
                String[] names = request.getParameterValues("passenger_name");
                String[] ages = request.getParameterValues("passenger_phone");
                int tripId = Integer.parseInt((String) session.getAttribute("trip_id"));

                String jdbcURL = "jdbc:mysql://localhost:3306/bus";
                String jdbcUsername = "root";
                String jdbcPassword = "";

                boolean insertSuccess = false;

                if (seats != null) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                        conn.setAutoCommit(false);

                        String insertPassengerSql = "INSERT INTO Passenger (name, age) VALUES (?, ?)";
                        String insertBookingSql = "INSERT INTO Booking (passenger_id, trip_id, seat, user_id) VALUES (?, ?, ?, ?)";

                        PreparedStatement passengerStmt = conn.prepareStatement(insertPassengerSql, Statement.RETURN_GENERATED_KEYS);
                        PreparedStatement bookingStmt = conn.prepareStatement(insertBookingSql, Statement.RETURN_GENERATED_KEYS);
                        for (int i = 0; i < seats.length; i++) {
                            String name = (names != null) ? names[i] : "null";
                            String age = (ages != null) ? ages[i] : "null";
                            String seat = seats[i];

                            out.println("--- Seat: " + seat + " ---");
                            out.println("Name: " + name);
                            out.println("Age:  " + age);

                            try {
                                passengerStmt.setString(1, name);
                                passengerStmt.setString(2, age);
                                passengerStmt.executeUpdate();

                                ResultSet rs = passengerStmt.getGeneratedKeys();
                                if (rs.next()) {
                                    int passengerId = rs.getInt(1);
                                    out.println("Passenger INSERT OK — passenger_id: " + passengerId);

                                    bookingStmt.setInt(1, passengerId);
                                    bookingStmt.setInt(2, tripId);
                                    bookingStmt.setInt(3, Integer.parseInt(seat));
                                    bookingStmt.setInt(4, Integer.parseInt((String) session.getAttribute("passengerId")));

                                    bookingStmt.executeUpdate();

                                    ResultSet bookingRs = bookingStmt.getGeneratedKeys();
                                    if (bookingRs.next()) {
                                        int bookingId = bookingRs.getInt(1);
                                        session.setAttribute("booking_id", String.valueOf(bookingId));
                                        
                                        out.println("Booking INSERT OK — trip_id: " + tripId + ", seat: " + seat + ", booking_id: " + session.getAttribute("booking_id"));
                                    } else {
                                        out.println("Booking INSERT OK but no booking_id returned");
                                    }
                                } else {
                                    out.println("Passenger INSERT FAILED: no generated key");
                                    conn.rollback();
                                }
                            } catch (SQLException ex) {
                                out.println("INSERT FAILED: " + ex.getMessage());
                                conn.rollback();
                            }

                            out.println();
                        }

                        conn.commit();
                        out.println("=== ALL INSERTS COMMITTED ===");

                        passengerStmt.close();
                        bookingStmt.close();
                        conn.close();

                        insertSuccess = true;

                    } catch (Exception e) {
                        out.println("CONNECTION ERROR: " + e.getMessage());
                    }
                } else {
                    out.println("No passenger data found.");
                }
            %>
        </pre>

        <%-- Redirect only after all output is done --%>
        <% if (insertSuccess) { %>
        <!--<script>window.location.href = "createPayment.jsp";</script>-->
        <% }%>
    </body>
</html>