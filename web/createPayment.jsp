<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="java.sql.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    String[] seats = request.getParameterValues("seat_number");
    if (seats == null) {
        seats = request.getParameterValues("selected_seats");
    }

    String[] names = request.getParameterValues("passenger_name");
    if (names == null || names.length == 0) {
        names = (String[]) session.getAttribute("pending_out_names");
    }

    String[] ages = request.getParameterValues("passenger_age");
    if (ages == null || ages.length == 0) {
        ages = (String[]) session.getAttribute("pending_out_ages");
    }

    String bookerName = request.getParameter("booker_name");
    String bookerPhone = request.getParameter("booker_phone");
    String bookerEmail = request.getParameter("booker_email");

    if (bookerName != null && !bookerName.trim().isEmpty()) {
        session.setAttribute("booker_name", bookerName.trim());
    }

    if (bookerPhone != null && !bookerPhone.trim().isEmpty()) {
        session.setAttribute("booker_phone", bookerPhone.trim());
    }

    if (bookerEmail != null && !bookerEmail.trim().isEmpty()) {
        session.setAttribute("booker_email", bookerEmail.trim());
        session.setAttribute("email", bookerEmail.trim());
    }

    String reqTotalStr = request.getParameter("total_price");
    double currentTotal = 0.0;

    try {
        if (reqTotalStr != null && !reqTotalStr.trim().isEmpty()) {
            currentTotal = Double.parseDouble(reqTotalStr);
        }
    } catch (NumberFormatException e) {
        currentTotal = 0.0;
    }

    if (currentTotal == 0.0 && seats != null) {
        double pricePerSeat = 0.0;

        Object priceAttr = session.getAttribute("price");
        if (priceAttr != null) {
            pricePerSeat = Double.parseDouble(String.valueOf(priceAttr));
        }

        for (int i = 0; i < seats.length; i++) {
            double seatPrice = pricePerSeat;

            if (ages != null && ages.length > i && ages[i] != null && !ages[i].trim().isEmpty()) {
                try {
                    int age = Integer.parseInt(ages[i].trim());

                    if (age >= 60) {
                        seatPrice = pricePerSeat * 0.5;
                    }

                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
            }

            currentTotal += seatPrice;
        }
    }

    String currentTripId = String.valueOf(session.getAttribute("trip_id"));

    if (currentTripId == null || "null".equals(currentTripId) || seats == null || seats.length == 0) {
        out.println("<h2>Missing booking details.</h2>");
        out.println("<p>Please select your seat again.</p>");
        out.println("<a href='Booking.jsp'>Back to booking</a>");
        return;
    }

    /*
       ROUND TRIP FIRST LEG
       If return_trip_id exists, save outbound booking first.
       Payment will only happen after return seat is selected.
    */
    String returnTripId = request.getParameter("return_trip_id");

    if (returnTripId != null && !returnTripId.trim().isEmpty()) {
        session.setAttribute("pending_out_trip_id", currentTripId);
        session.setAttribute("pending_out_seats", seats);
        session.setAttribute("pending_out_names", names);
        session.setAttribute("pending_out_ages", ages);
        session.setAttribute("pending_out_total", currentTotal);

        session.setAttribute("accumulated_price", currentTotal);
        session.setAttribute("outbound_passenger_names", names);
        session.setAttribute("outbound_passenger_ages", ages);
        session.removeAttribute("return_trip_id");

        String returnBusId = request.getParameter("return_bus_id");
        String returnOrigin = request.getParameter("return_origin");
        String returnDest = request.getParameter("return_destination");
        String returnDate = request.getParameter("return_date");
        String returnPrice = request.getParameter("return_price");
        int reqSeats = seats.length;

        String redirectUrl = "SelectSeat.jsp"
                + "?trip_id=" + URLEncoder.encode(returnTripId, "UTF-8")
                + "&bus_id=" + URLEncoder.encode(returnBusId != null ? returnBusId : "", "UTF-8")
                + "&origin=" + URLEncoder.encode(returnOrigin != null ? returnOrigin : "", "UTF-8")
                + "&destination=" + URLEncoder.encode(returnDest != null ? returnDest : "", "UTF-8")
                + "&trip_date=" + URLEncoder.encode(returnDate != null ? returnDate : "", "UTF-8")
                + "&price=" + URLEncoder.encode(returnPrice != null ? returnPrice : "", "UTF-8")
                + "&is_return=true"
                + "&req_seats=" + reqSeats;

        response.sendRedirect(redirectUrl);
        return;
    }

    /*
       ONE WAY TRIP OR FINAL RETURN TRIP
       Save booking data into session.
       Actual booking insert happens in success.jsp after payment success.
    */
    Double outboundTotal = (Double) session.getAttribute("pending_out_total");

    if (outboundTotal != null) {
        session.setAttribute("pending_return_trip_id", currentTripId);
        session.setAttribute("pending_return_seats", seats);
        session.setAttribute("pending_return_names", names);
        session.setAttribute("pending_return_ages", ages);
        session.setAttribute("pending_return_total", currentTotal);

        double finalTotal = (outboundTotal + currentTotal) * 0.90;
        session.setAttribute("total_price", finalTotal);

    } else {
        session.setAttribute("pending_out_trip_id", currentTripId);
        session.setAttribute("pending_out_seats", seats);
        session.setAttribute("pending_out_names", names);
        session.setAttribute("pending_out_ages", ages);
        session.setAttribute("pending_out_total", currentTotal);
        session.setAttribute("total_price", currentTotal);
    }

    session.removeAttribute("accumulated_price");
    session.removeAttribute("outbound_passenger_names");
    session.removeAttribute("outbound_passenger_ages");

    Object totalObj = session.getAttribute("total_price");

    if (totalObj == null) {
        response.sendRedirect("Booking.jsp");
        return;
    }

    double totalPrice = Double.parseDouble(String.valueOf(totalObj));
    int totalSen = (int) Math.round(totalPrice * 100);
    String referenceNo = "ORD-" + System.currentTimeMillis();

    /*
       CUSTOMER DETAILS FOR TOYYIBPAY
    */
    String buyerName = (String) session.getAttribute("username");
    String buyerEmail = (String) session.getAttribute("email");
    String buyerPhone = (String) session.getAttribute("phoneNumber");

    String sessionBookerName = (String) session.getAttribute("booker_name");
    String sessionBookerPhone = (String) session.getAttribute("booker_phone");
    String sessionBookerEmail = (String) session.getAttribute("booker_email");

    if (buyerName == null || buyerName.trim().isEmpty()) {
        buyerName = sessionBookerName;
    }

    if (buyerEmail == null || buyerEmail.trim().isEmpty()) {
        buyerEmail = sessionBookerEmail;
    }

    if (buyerPhone == null || buyerPhone.trim().isEmpty()) {
        buyerPhone = sessionBookerPhone;
    }

    if (buyerName == null || buyerName.trim().isEmpty()) {
        buyerName = "Guest Customer";
    }

    if (buyerPhone == null || buyerPhone.trim().isEmpty()) {
        buyerPhone = "0100000000";
    }

    /*
       Create or find customer before ToyyibPay.
       This prevents createPayment.jsp from rejecting new customers.
    */
    Connection dbConn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        dbConn = DriverManager.getConnection("jdbc:mysql://localhost:3306/bus", "root", "");

        String passengerIdStr = (String) session.getAttribute("passengerId");

        /*
           1. If passengerId exists, get latest user info from database.
        */
        if (passengerIdStr != null && !passengerIdStr.trim().isEmpty()) {
            PreparedStatement psUser = dbConn.prepareStatement(
                    "SELECT id, username, email, phone_number FROM users WHERE id = ? LIMIT 1"
            );
            psUser.setString(1, passengerIdStr);

            ResultSet rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                String dbUsername = rsUser.getString("username");
                String dbEmail = rsUser.getString("email");
                String dbPhone = rsUser.getString("phone_number");

                if (dbUsername != null && !dbUsername.trim().isEmpty()) {
                    buyerName = dbUsername;
                }

                if (dbEmail != null && !dbEmail.trim().isEmpty()) {
                    buyerEmail = dbEmail;
                }

                if (dbPhone != null && !dbPhone.trim().isEmpty()) {
                    buyerPhone = dbPhone;
                }

                session.setAttribute("passengerId", rsUser.getString("id"));
                session.setAttribute("username", buyerName);
                session.setAttribute("email", buyerEmail);
                session.setAttribute("phoneNumber", buyerPhone);
                session.setAttribute("userRole", "customer");
            }

            rsUser.close();
            psUser.close();
        }

        /*
           2. If no passengerId or no email, find customer by phone number.
        */
        if ((buyerEmail == null || buyerEmail.trim().isEmpty())
                && buyerPhone != null && !buyerPhone.trim().isEmpty()) {

            PreparedStatement psPhone = dbConn.prepareStatement(
                    "SELECT id, username, email, phone_number FROM users WHERE phone_number = ? LIMIT 1"
            );
            psPhone.setString(1, buyerPhone);

            ResultSet rsPhone = psPhone.executeQuery();

            if (rsPhone.next()) {
                String dbUsername = rsPhone.getString("username");
                String dbEmail = rsPhone.getString("email");
                String dbPhone = rsPhone.getString("phone_number");

                if (dbUsername != null && !dbUsername.trim().isEmpty()) {
                    buyerName = dbUsername;
                }

                if (dbEmail != null && !dbEmail.trim().isEmpty()) {
                    buyerEmail = dbEmail;
                }

                if (dbPhone != null && !dbPhone.trim().isEmpty()) {
                    buyerPhone = dbPhone;
                }

                session.setAttribute("passengerId", rsPhone.getString("id"));
                session.setAttribute("username", buyerName);
                session.setAttribute("email", buyerEmail);
                session.setAttribute("phoneNumber", buyerPhone);
                session.setAttribute("userRole", "customer");
            }

            rsPhone.close();
            psPhone.close();
        }

        /*
           3. If customer exists but email is still empty, generate one and update user.
        */
        String existingPassengerId = (String) session.getAttribute("passengerId");

        if ((buyerEmail == null || buyerEmail.trim().isEmpty())
                && existingPassengerId != null && !existingPassengerId.trim().isEmpty()) {

            String cleanName = buyerName.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
            String cleanPhone = buyerPhone.replaceAll("[^0-9]", "");

            if (cleanName.trim().isEmpty()) {
                cleanName = "guest";
            }

            if (cleanPhone.trim().isEmpty()) {
                cleanPhone = String.valueOf(System.currentTimeMillis());
            }

            buyerEmail = cleanName + "_" + cleanPhone + "@guest.com";

            PreparedStatement psUpdateEmail = dbConn.prepareStatement(
                    "UPDATE users SET email = ? WHERE id = ?"
            );
            psUpdateEmail.setString(1, buyerEmail);
            psUpdateEmail.setString(2, existingPassengerId);
            psUpdateEmail.executeUpdate();
            psUpdateEmail.close();

            session.setAttribute("email", buyerEmail);
        }

        /*
           4. If customer still does not exist, create new guest customer.
        */
        if (session.getAttribute("passengerId") == null
                || String.valueOf(session.getAttribute("passengerId")).trim().isEmpty()) {

            String cleanName = buyerName.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
            String cleanPhone = buyerPhone.replaceAll("[^0-9]", "");

            if (cleanName.trim().isEmpty()) {
                cleanName = "guest";
            }

            if (cleanPhone.trim().isEmpty()) {
                cleanPhone = String.valueOf(System.currentTimeMillis());
            }

            if (buyerEmail == null || buyerEmail.trim().isEmpty()) {
                buyerEmail = cleanName + "_" + cleanPhone + "@guest.com";
            }

            String generatedUsername = buyerName;

            /*
               Avoid duplicate username.
            */
            PreparedStatement psCheckUsername = dbConn.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE username = ?"
            );
            psCheckUsername.setString(1, generatedUsername);

            ResultSet rsCheckUsername = psCheckUsername.executeQuery();

            if (rsCheckUsername.next() && rsCheckUsername.getInt(1) > 0) {
                generatedUsername = buyerName + "_" + cleanPhone;
            }

            rsCheckUsername.close();
            psCheckUsername.close();

            /*
               Avoid duplicate email.
            */
            PreparedStatement psCheckEmail = dbConn.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE email = ?"
            );
            psCheckEmail.setString(1, buyerEmail);

            ResultSet rsCheckEmail = psCheckEmail.executeQuery();

            if (rsCheckEmail.next() && rsCheckEmail.getInt(1) > 0) {
                buyerEmail = cleanName + "_" + System.currentTimeMillis() + "@guest.com";
            }

            rsCheckEmail.close();
            psCheckEmail.close();

            PreparedStatement psInsertUser = dbConn.prepareStatement(
                    "INSERT INTO users (username, email, password, role, phone_number) VALUES (?, ?, ?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS
            );

            psInsertUser.setString(1, generatedUsername);
            psInsertUser.setString(2, buyerEmail);
            psInsertUser.setString(3, "123456");
            psInsertUser.setString(4, "customer");
            psInsertUser.setString(5, buyerPhone);

            psInsertUser.executeUpdate();

            ResultSet rsKeys = psInsertUser.getGeneratedKeys();

            if (rsKeys.next()) {
                String newUserId = String.valueOf(rsKeys.getInt(1));

                buyerName = generatedUsername;

                session.setAttribute("passengerId", newUserId);
                session.setAttribute("username", buyerName);
                session.setAttribute("email", buyerEmail);
                session.setAttribute("phoneNumber", buyerPhone);
                session.setAttribute("userRole", "customer");
            }

            rsKeys.close();
            psInsertUser.close();
        }

    } catch (Exception e) {
        out.println("<h2>Error preparing customer for payment.</h2>");
        out.println("<pre>" + e.getMessage() + "</pre>");
        return;

    } finally {
        if (dbConn != null) {
            try {
                dbConn.close();
            } catch (Exception ignore) {
            }
        }
    }

    /*
       Final fallback.
       This should rarely happen, but prevents payment crash.
    */
    if (buyerEmail == null || buyerEmail.trim().isEmpty()) {
        String cleanName = buyerName.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        String cleanPhone = buyerPhone.replaceAll("[^0-9]", "");

        if (cleanName.trim().isEmpty()) {
            cleanName = "guest";
        }

        if (cleanPhone.trim().isEmpty()) {
            cleanPhone = String.valueOf(System.currentTimeMillis());
        }

        buyerEmail = cleanName + "_" + cleanPhone + "@guest.com";
        session.setAttribute("email", buyerEmail);
    }

    if (buyerName == null || buyerName.trim().isEmpty()) {
        buyerName = "Guest Customer";
        session.setAttribute("username", buyerName);
    }

    if (buyerPhone == null || buyerPhone.trim().isEmpty()) {
        buyerPhone = "0100000000";
        session.setAttribute("phoneNumber", buyerPhone);
    }

    /*
       TOYYIBPAY API DETAILS
    */
    String secretKey = "18v1vjgx-wk1v-6vvm-9dob-a0vi50we9sp3";
    String categoryCode = "2mnt69lt";

    String returnUrl = "http://localhost:8080/bus/success.jsp";
    String callbackUrl = "";

    String params
            = "userSecretKey=" + URLEncoder.encode(secretKey, "UTF-8")
            + "&categoryCode=" + URLEncoder.encode(categoryCode, "UTF-8")
            + "&billName=" + URLEncoder.encode("Sani Express Ticket", "UTF-8")
            + "&billDescription=" + URLEncoder.encode("Ticket Payment " + referenceNo, "UTF-8")
            + "&billPriceSetting=1"
            + "&billPayorInfo=1"
            + "&billAmount=" + totalSen
            + "&billReturnUrl=" + URLEncoder.encode(returnUrl, "UTF-8")
            + "&billCallbackUrl=" + URLEncoder.encode(callbackUrl, "UTF-8")
            + "&billExternalReferenceNo=" + URLEncoder.encode(referenceNo, "UTF-8")
            + "&billTo=" + URLEncoder.encode(buyerName, "UTF-8")
            + "&billEmail=" + URLEncoder.encode(buyerEmail, "UTF-8")
            + "&billPhone=" + URLEncoder.encode(buyerPhone, "UTF-8");

    try {
        URL url = new URL("https://dev.toyyibpay.com/index.php/api/createBill");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);
        conn.setReadTimeout(15000);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            os.write(params.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();

        BufferedReader br = new BufferedReader(
                new InputStreamReader(
                        responseCode >= 200 && responseCode < 300
                                ? conn.getInputStream()
                                : conn.getErrorStream(),
                        "UTF-8"
                )
        );

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        br.close();

        String responseData = sb.toString();

        if (responseCode != 200 || responseData == null || !responseData.contains("BillCode")) {
            out.println("<h2>ToyyibPay Error</h2>");
            out.println("<pre>" + responseData + "</pre>");
            return;
        }

        String billCode = responseData.split(":\\\"")[1].split("\\\"")[0];

        session.setAttribute("pending_billcode", billCode);
        session.setAttribute("pending_ref", referenceNo);

        response.sendRedirect("https://dev.toyyibpay.com/" + billCode);

    } catch (UnknownHostException e) {
        out.println("<h2>Cannot connect to ToyyibPay sandbox.</h2>");
        out.println("<p>Your server cannot resolve dev.toyyibpay.com. Try another DNS, another WiFi, or phone hotspot.</p>");

    } catch (Exception e) {
        out.println("<h2>Payment connection error.</h2>");
        out.println("<pre>" + e.getMessage() + "</pre>");
    }
%>