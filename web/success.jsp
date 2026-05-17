<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.PaymentDAO"%>
<%@page import="model.Payment"%>

<%
    String statusId = request.getParameter("status_id");
    String referenceNo = request.getParameter("order_id");
    String transactionId = request.getParameter("transaction_id");
    String billCode = request.getParameter("billcode");

    String expectedBillCode = (String) session.getAttribute("pending_billcode");
    String expectedRef = (String) session.getAttribute("pending_ref");

    if (referenceNo == null || !referenceNo.equals(expectedRef) || !billCode.equals(expectedBillCode)) {
        out.println("<h2>Invalid or expired payment response.</h2>");
        return;
    }

    // Validate ToyyibPay status
    boolean paymentSuccess = "1".equals(statusId);

   if (paymentSuccess) {
    Payment payment = new Payment();
    payment.setBookingId(referenceNo);
    payment.setAmount((Double) session.getAttribute("total_price"));
    payment.setBank("ToyyibPay");
    payment.setTransactionId(transactionId);
    payment.setBillCode(billCode);
    payment.setBuyerEmail((String) session.getAttribute("email"));
    payment.setBuyerName((String) session.getAttribute("username"));
    payment.setStatus("SUCCESS");

    try {
        boolean saved = new PaymentDAO().insertPayment(payment);
        if (saved) {
            out.println("Payment recorded successfully.");
        } else {
            out.println("Payment insert returned false — check DAO.");
        }
    } catch (Exception e) {
        out.println("Payment INSERT FAILED: " + e.getMessage());
        e.printStackTrace();
    }
}
    // Clear pending tokens
    session.removeAttribute("pending_billcode");
    session.removeAttribute("pending_ref");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment Result - Sani Express</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container" style="max-width: 600px; margin: 40px auto; text-align: center; padding: 40px; background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">

            <% if (paymentSuccess) {%>
            <div style="font-size: 60px; color: #16a34a; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-check"></i>
            </div>
            <h1 style="color: #16a34a; margin-bottom: 15px;">Payment Successful!</h1>
            <p style="color: #6b7280; margin-bottom: 30px;">Your transaction was completed successfully. Your reference number is <strong><%= referenceNo%></strong>.</p>

            <!-- Automatically submit the booking details to the servlet -->
            <form id="insertBookingForm" action="booking?action=insert" method="POST">
                <%
                    String[] names = (String[]) session.getAttribute("checkout_names");
                    String[] phones = (String[]) session.getAttribute("checkout_phones");
                    String[] seats = (String[]) session.getAttribute("checkout_seats");
                    String tripIdStr = (String) session.getAttribute("trip_id");

                    if (names != null && seats != null) {
                        for (int i = 0; i < seats.length; i++) {
                %>
                <input type="hidden" name="seat_number" value="<%= seats[i]%>">
                <input type="hidden" name="passenger_name" value="<%= names[i]%>">
                <input type="hidden" name="passenger_phone" value="<%= phones[i]%>">
                <%      }
                    }
                %>
                <input type="hidden" name="trip_id" value="<%= tripIdStr%>">

                <button type="submit" class="btn-payment">Finalize Booking & View Tickets</button>
            </form>

            <script>
                // Auto submit to finalize booking
                document.getElementById('insertBookingForm').submit();
            </script>

            <% } else { %>
            <div style="font-size: 60px; color: #dc2626; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-xmark"></i>
            </div>
            <h1 style="color: #dc2626; margin-bottom: 15px;">Payment Failed</h1>
            <p style="color: #6b7280; margin-bottom: 30px;">Your transaction could not be completed. No charges were made.</p>

            <a href="SelectSeat.jsp" class="btn-payment">Try Again</a>
            <% }%>

        </div>
    </body>
</html>
