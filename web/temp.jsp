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
                String[] ages = request.getParameterValues("passenger_age");
                int tripId = Integer.parseInt((String) session.getAttribute("trip_id"));

                String jdbcURL = "jdbc:mysql://localhost:3306/bus";
                String jdbcUsername = "root";
                String jdbcPassword = "";

                boolean insertSuccess = false;

                if (seats != null) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

                        // If user is not logged in, add user info first
                        String passengerIdStr = (String) session.getAttribute("passengerId");
                        if (passengerIdStr == null || passengerIdStr.trim().isEmpty()) {
                            String bookerName = request.getParameter("booker_name");
                            String bookerPhone = request.getParameter("booker_phone");
                            if (bookerName != null && bookerPhone != null) {
                                bookerName = bookerName.trim();
                                bookerPhone = bookerPhone.trim();

                                // 1. Check if user already exists with this phone number
                                PreparedStatement checkPhoneStmt = conn.prepareStatement("SELECT id, username, email FROM users WHERE phone_number = ?");
                                checkPhoneStmt.setString(1, bookerPhone);
                                ResultSet rsPhone = checkPhoneStmt.executeQuery();
                                if (rsPhone.next()) {
                                    passengerIdStr = String.valueOf(rsPhone.getInt("id"));
                                    session.setAttribute("passengerId", passengerIdStr);
                                    session.setAttribute("username", rsPhone.getString("username"));
                                    session.setAttribute("email", rsPhone.getString("email"));
                                    session.setAttribute("phoneNumber", bookerPhone);
                                    session.setAttribute("userRole", "customer");
                                }
                                rsPhone.close();
                                checkPhoneStmt.close();
                            }

                            if (passengerIdStr == null || passengerIdStr.trim().isEmpty()) {
                                // 2. Generate unique username and email
                                String email = bookerName.replaceAll("\\s+", "").toLowerCase() + "_" + bookerPhone + "@guest.com";
                                String username = bookerName;

                                PreparedStatement checkUserStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE username = ?");
                                checkUserStmt.setString(1, username);
                                ResultSet rsUser = checkUserStmt.executeQuery();
                                if (rsUser.next() && rsUser.getInt(1) > 0) {
                                    username = bookerName + "_" + bookerPhone;
                                }
                                rsUser.close();
                                checkUserStmt.close();

                                PreparedStatement checkEmailStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE email = ?");
                                checkEmailStmt.setString(1, email);
                                ResultSet rsEmail = checkEmailStmt.executeQuery();
                                if (rsEmail.next() && rsEmail.getInt(1) > 0) {
                                    email = bookerName.replaceAll("\\s+", "").toLowerCase() + "_" + System.currentTimeMillis() + "@guest.com";
                                }
                                rsEmail.close();
                                checkEmailStmt.close();

                                // 3. Insert new user record
                                PreparedStatement insertUserStmt = conn.prepareStatement(
                                    "INSERT INTO users (username, email, password, role, phone_number) VALUES (?, ?, ?, ?, ?)",
                                    Statement.RETURN_GENERATED_KEYS
                                );
                                insertUserStmt.setString(1, username);
                                insertUserStmt.setString(2, email);
                                insertUserStmt.setString(3, "123456");
                                insertUserStmt.setString(4, "customer");
                                insertUserStmt.setString(5, bookerPhone);

                                insertUserStmt.executeUpdate();
                                ResultSet rsKeys = insertUserStmt.getGeneratedKeys();
                                if (rsKeys.next()) {
                                    passengerIdStr = String.valueOf(rsKeys.getInt(1));
                                    session.setAttribute("passengerId", passengerIdStr);
                                    session.setAttribute("username", username);
                                    session.setAttribute("email", email);
                                    session.setAttribute("phoneNumber", bookerPhone);
                                    session.setAttribute("userRole", "customer");
                                }
                                rsKeys.close();
                                insertUserStmt.close();
                            }
                        }

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
                    <script>window.location.href = "createPayment.jsp";</script>
                    <% }%>
        </body>

        </html>