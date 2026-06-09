<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%
    request.setCharacterEncoding("UTF-8");

    String[] seats = request.getParameterValues("seat_number");
    String[] names = request.getParameterValues("passenger_name");
    String[] ages  = request.getParameterValues("passenger_age");

    String bookerName  = request.getParameter("booker_name");
    String bookerPhone = request.getParameter("booker_phone");
    if (bookerName != null) session.setAttribute("booker_name", bookerName);
    if (bookerPhone != null) session.setAttribute("booker_phone", bookerPhone);

    String reqTotalStr = request.getParameter("total_price");
    double currentTotal = 0.0;
    try {
        currentTotal = (reqTotalStr != null && !reqTotalStr.trim().isEmpty()) ? Double.parseDouble(reqTotalStr) : 0.0;
    } catch (NumberFormatException e) {
        currentTotal = 0.0;
    }

    String currentTripId = String.valueOf(session.getAttribute("trip_id"));
    if (currentTripId == null || "null".equals(currentTripId) || seats == null || seats.length == 0) {
        out.println("<h2>Missing booking details.</h2>");
        out.println("<p>Please select your seat again.</p>");
        out.println("<a href='Booking.jsp'>Back to booking</a>");
        return;
    }

    /*
       If this is the first leg of a round trip, do NOT create payment yet.
       Save outbound details in session, then redirect user to choose return seats.
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
       One-way trip OR final return trip.
       Store booking details in session. Actual DB insert happens in success.jsp only after payment success.
    */
    Double outboundTotal = (Double) session.getAttribute("pending_out_total");
    if (outboundTotal != null) {
        session.setAttribute("pending_return_trip_id", currentTripId);
        session.setAttribute("pending_return_seats", seats);
        session.setAttribute("pending_return_names", names);
        session.setAttribute("pending_return_ages", ages);
        session.setAttribute("pending_return_total", currentTotal);

        double finalTotal = (outboundTotal + currentTotal) * 0.90; // 10% round-trip discount
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

    // ToyyibPay API details
    String secretKey = "18v1vjgx-wk1v-6vvm-9dob-a0vi50we9sp3";
    String categoryCode = "2mnt69lt";

    Object totalObj = session.getAttribute("total_price");
    if (totalObj == null) {
        response.sendRedirect("Booking.jsp");
        return;
    }

    double totalPrice = Double.parseDouble(String.valueOf(totalObj));
    int totalSen = (int) Math.round(totalPrice * 100);
    String referenceNo = "ORD-" + System.currentTimeMillis();

    String returnUrl = "http://localhost:8080/bus/success.jsp";
    String callbackUrl = "http://localhost:8080/bus/callback.jsp";

    String buyerName = (String) session.getAttribute("username");
    String buyerEmail = (String) session.getAttribute("email");
    String buyerPhone = (String) session.getAttribute("booker_phone");

    if (buyerName == null || buyerName.trim().isEmpty()) buyerName = (String) session.getAttribute("booker_name");
    if (buyerEmail == null || buyerEmail.trim().isEmpty()) buyerEmail = "guest" + System.currentTimeMillis() + "@guest.com";
    if (buyerPhone == null || buyerPhone.trim().isEmpty()) buyerPhone = "0100000000";

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
        BufferedReader br = new BufferedReader(new InputStreamReader(
                responseCode >= 200 && responseCode < 300 ? conn.getInputStream() : conn.getErrorStream(), "UTF-8"));

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
