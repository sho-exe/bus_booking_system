<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="dao.BookingDAO"%>
<%@page import="model.Booking"%>
<%
    // ToyyibPay API Details (Provided by user's Payment module)
    String secretKey = "18v1vjgx-wk1v-6vvm-9dob-a0vi50we9sp3";
    String categoryCode = "2mnt69lt";

    String passenger_name = request.getParameter("passenger_name");
    BookingDAO dao = new BookingDAO();
//    Booking booking = dao.getBookingsByUser(passenger_name);

    String totalPrice = String.valueOf(session.getAttribute("total_price"));
//    String totalPrice = "50";

    if (totalPrice == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int totalSen = (int) Math.round(Double.parseDouble(totalPrice) * 100);
    String referenceNo = "ORD-" + System.currentTimeMillis();

    String returnUrl = "http://localhost:8080/bus/success.jsp";
    String callbackUrl = "http://localhost:8080/bus/callback.jsp";

    String buyerName = (String) session.getAttribute("username");
    String buyerEmail = (String) session.getAttribute("email");
    String buyerPhone = (String) session.getAttribute("booker_phone");

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

    URL url = new URL("https://dev.toyyibpay.com/index.php/api/createBill");
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("POST");
    conn.setDoOutput(true);
    conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

    OutputStream os = conn.getOutputStream();
    os.write(params.getBytes("UTF-8"));
    os.flush();
    os.close();

    int responseCode = conn.getResponseCode();
    BufferedReader br;

    if (responseCode >= 200 && responseCode < 300) {
        br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    } else {
        br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
    }

    String responseData = br.readLine();
    br.close();

    if (responseCode != 200 || responseData == null || !responseData.contains("BillCode")) {
        out.println("<h2>ToyyibPay Error</h2>");
        out.println("<pre>" + responseData + "</pre>");
        return;
    }

    String billCode = responseData.split(":\"")[1].split("\"")[0];

    // Save billcode and reference to session for validation upon return
    session.setAttribute("pending_billcode", billCode);
    session.setAttribute("pending_ref", referenceNo);

    // Redirect to ToyyibPay Payment Page
    response.sendRedirect("https://dev.toyyibpay.com/" + billCode);
%>
