<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page import="dao.PaymentDAO"%>
<%@page import="model.Payment"%>
<%!
    private int ensureCustomerUser(Connection conn, javax.servlet.http.HttpSession session) throws Exception {
        String passengerIdStr = (String) session.getAttribute("passengerId");
        if (passengerIdStr != null && !passengerIdStr.trim().isEmpty()) {
            return Integer.parseInt(passengerIdStr);
        }

        String bookerName = (String) session.getAttribute("booker_name");
        String bookerPhone = (String) session.getAttribute("booker_phone");
        if (bookerName == null || bookerName.trim().isEmpty()) {
            bookerName = "Guest Customer";
        }
        if (bookerPhone == null || bookerPhone.trim().isEmpty()) {
            bookerPhone = "0100000000";
        }

        PreparedStatement checkPhoneStmt = conn.prepareStatement("SELECT id, username, email FROM users WHERE phone_number = ?");
        checkPhoneStmt.setString(1, bookerPhone);
        ResultSet rsPhone = checkPhoneStmt.executeQuery();
        if (rsPhone.next()) {
            int id = rsPhone.getInt("id");
            session.setAttribute("passengerId", String.valueOf(id));
            session.setAttribute("username", rsPhone.getString("username"));
            session.setAttribute("email", rsPhone.getString("email"));
            session.setAttribute("phoneNumber", bookerPhone);
            session.setAttribute("userRole", "customer");
            rsPhone.close();
            checkPhoneStmt.close();
            return id;
        }
        rsPhone.close();
        checkPhoneStmt.close();

        String cleanName = bookerName.replaceAll("\\s+", "").toLowerCase();
        String email = cleanName + "_" + bookerPhone + "@guest.com";
        String username = bookerName;

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
        int userId = 0;
        if (rsKeys.next()) {
            userId = rsKeys.getInt(1);
        }
        rsKeys.close();
        insertUserStmt.close();

        session.setAttribute("passengerId", String.valueOf(userId));
        session.setAttribute("username", username);
        session.setAttribute("email", email);
        session.setAttribute("phoneNumber", bookerPhone);
        session.setAttribute("userRole", "customer");
        return userId;
    }

    private void insertLeg(Connection conn, String tripIdStr, String[] seats, String[] names, String[] ages,
            int userId, java.util.List<Integer> bookingIds) throws Exception {
        if (tripIdStr == null || seats == null || seats.length == 0) {
            return;
        }

        int tripId = Integer.parseInt(tripIdStr);
        PreparedStatement passengerStmt = conn.prepareStatement(
                "INSERT INTO Passenger (name, age) VALUES (?, ?)", Statement.RETURN_GENERATED_KEYS);
        PreparedStatement bookingStmt = conn.prepareStatement(
                "INSERT INTO Booking (passenger_id, trip_id, seat, user_id) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);

        for (int i = 0; i < seats.length; i++) {
            String name = (names != null && names.length > i) ? names[i] : "Passenger";
            String age = (ages != null && ages.length > i) ? ages[i] : "0";

            passengerStmt.setString(1, name);
            passengerStmt.setString(2, age);
            passengerStmt.executeUpdate();

            ResultSet prs = passengerStmt.getGeneratedKeys();
            if (prs.next()) {
                int passengerId = prs.getInt(1);
                bookingStmt.setInt(1, passengerId);
                bookingStmt.setInt(2, tripId);
                bookingStmt.setInt(3, Integer.parseInt(seats[i].trim()));
                bookingStmt.setInt(4, userId);
                bookingStmt.executeUpdate();

                ResultSet brs = bookingStmt.getGeneratedKeys();
                if (brs.next()) {
                    bookingIds.add(brs.getInt(1));
                }
                brs.close();
            }
            prs.close();
        }
        passengerStmt.close();
        bookingStmt.close();
    }
%>
<%
    String statusId = request.getParameter("status_id");
    String referenceNo = request.getParameter("order_id");
    String transactionId = request.getParameter("transaction_id");
    String billCode = request.getParameter("billcode");

    String expectedBillCode = (String) session.getAttribute("pending_billcode");
    String expectedRef = (String) session.getAttribute("pending_ref");

    if (referenceNo == null || expectedRef == null || billCode == null || expectedBillCode == null
            || !referenceNo.equals(expectedRef) || !billCode.equals(expectedBillCode)) {
        out.println("<h2>Invalid or expired payment response.</h2>");
        return;
    }

    boolean paymentSuccess = "1".equals(statusId);
    boolean bookingSaved = false;
    String saveError = null;
    java.util.List<Integer> savedBookingIds = new java.util.ArrayList<Integer>();

    if (paymentSuccess) {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bus", "root", "");
            conn.setAutoCommit(false);

            int userId = ensureCustomerUser(conn, session);

            insertLeg(conn,
                    (String) session.getAttribute("pending_out_trip_id"),
                    (String[]) session.getAttribute("pending_out_seats"),
                    (String[]) session.getAttribute("pending_out_names"),
                    (String[]) session.getAttribute("pending_out_ages"),
                    userId,
                    savedBookingIds);

            insertLeg(conn,
                    (String) session.getAttribute("pending_return_trip_id"),
                    (String[]) session.getAttribute("pending_return_seats"),
                    (String[]) session.getAttribute("pending_return_names"),
                    (String[]) session.getAttribute("pending_return_ages"),
                    userId,
                    savedBookingIds);

            if (!savedBookingIds.isEmpty()) {
                double totalPaid = Double.parseDouble(String.valueOf(session.getAttribute("total_price")));
                double amountPerBooking = totalPaid / savedBookingIds.size();

                PreparedStatement updateBookingStmt = conn.prepareStatement(
                        "UPDATE Booking SET status = ? WHERE booking_id = ?"
                );

                PreparedStatement paymentStmt = conn.prepareStatement(
                        "INSERT INTO payment "
                        + "(booking_id, amount, bank, transaction_id, bill_code, buyer_email, buyer_name, status) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
                );

                for (Integer bookingId : savedBookingIds) {
                    updateBookingStmt.setString(1, "Confirmed");
                    updateBookingStmt.setInt(2, bookingId);
                    updateBookingStmt.executeUpdate();

                    paymentStmt.setInt(1, bookingId);
                    paymentStmt.setDouble(2, amountPerBooking);
                    paymentStmt.setString(3, "ToyyibPay");
                    paymentStmt.setString(4, transactionId != null ? transactionId : referenceNo);
                    paymentStmt.setString(5, billCode);
                    paymentStmt.setString(6, (String) session.getAttribute("email"));
                    paymentStmt.setString(7, (String) session.getAttribute("username"));
                    paymentStmt.setString(8, "SUCCESS");
                    paymentStmt.executeUpdate();
                }

                paymentStmt.close();
                updateBookingStmt.close();
            }

            conn.commit();
            bookingSaved = true;
            session.setAttribute("last_receipt_booking_ids", savedBookingIds);

        } catch (Exception e) {
            bookingSaved = false;
            saveError = e.getMessage();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignore) {
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception ignore) {
                }
            }
        }
    }

    session.removeAttribute("pending_billcode");
    session.removeAttribute("pending_ref");
    session.removeAttribute("pending_out_trip_id");
    session.removeAttribute("pending_out_seats");
    session.removeAttribute("pending_out_names");
    session.removeAttribute("pending_out_ages");
    session.removeAttribute("pending_out_total");
    session.removeAttribute("pending_return_trip_id");
    session.removeAttribute("pending_return_seats");
    session.removeAttribute("pending_return_names");
    session.removeAttribute("pending_return_ages");
    session.removeAttribute("pending_return_total");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment Result - Sani Express</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="style.css">
        <style>
            .success-actions {
                width: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 14px;
                margin-top: 25px;
            }

            .success-btn {
                width: 100%;
                max-width: 420px;
                box-sizing: border-box;

                padding: 15px 20px;
                border-radius: 10px;

                font-size: 17px;
                font-weight: 700;
                text-decoration: none;

                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;

                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;

                transition: all 0.2s ease;
            }

            .success-btn.primary {
                background: #d71920;
                color: white;
                box-shadow: 0 4px 10px rgba(215, 25, 32, 0.25);
            }

            .success-btn.primary:hover {
                background: #b9151b;
                transform: translateY(-1px);
            }

            .success-btn.secondary {
                background: #f4f5f7;
                color: #374151;
                border: 1px solid #e5e7eb;
            }

            .success-btn.secondary:hover {
                background: #e9ecef;
            }

            @media (max-width: 480px) {
                .success-btn {
                    max-width: 100%;
                    font-size: 15px;
                    padding: 13px 14px;
                }
            }
        </style>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container" style="max-width: 650px; margin: 40px auto; text-align: center; padding: 40px; background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">

            <% if (paymentSuccess && bookingSaved) {%>
            <div style="font-size: 60px; color: #16a34a; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h1 style="color: #16a34a; margin-bottom: 15px;">Payment Successful!</h1>
            <p style="color: #6b7280; margin-bottom: 20px;">Your payment and booking were completed successfully.</p>
            <p style="color: #6b7280; margin-bottom: 30px;">Reference number: <strong><%= referenceNo%></strong></p>

            <div class="success-actions">

                <% if (savedBookingIds != null && !savedBookingIds.isEmpty()) { %>

                <% for (Integer ticketBookingId : savedBookingIds) {%>
                <a href="ReceiptPDFServlet?booking_id=<%= ticketBookingId%>"
                   class="success-btn primary"
                   target="_blank">
                    <i class="fa-solid fa-ticket"></i>
                    View E-Ticket #<%= ticketBookingId%>
                </a>
                <% } %>

                <a href="customer.jsp" class="success-btn secondary">
                    <i class="fa-solid fa-list"></i>
                    Go to My Bookings
                </a>

                <% } else { %>

                <a href="customer.jsp" class="success-btn primary">
                    <i class="fa-solid fa-ticket"></i>
                    View My Bookings
                </a>

                <% } %>

            </div>

            <% } else if (paymentSuccess) {%>
            <div style="font-size: 60px; color: #dc2626; margin-bottom: 20px;">
                <i class="fa-solid fa-triangle-exclamation"></i>
            </div>
            <h1 style="color: #dc2626; margin-bottom: 15px;">Payment Successful, Booking Save Failed</h1>
            <p style="color: #6b7280; margin-bottom: 30px;">Error: <%= saveError != null ? saveError : "Unknown database error"%></p>
            <a href="Booking.jsp" class="btn-payment">Back to Booking</a>

            <% } else { %>
            <div style="font-size: 60px; color: #dc2626; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-xmark"></i>
            </div>
            <h1 style="color: #dc2626; margin-bottom: 15px;">Payment Failed</h1>
            <p style="color: #6b7280; margin-bottom: 30px;">Your transaction could not be completed. No booking was saved.</p>
            <a href="SelectSeat.jsp" class="btn-payment">Try Again</a>
            <% }%>

        </div>

        <footer class="main-footer">
            &copy; 2026 Sani Express. All rights reserved.
        </footer>
    </body>
</html>
