<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Passenger data saved by temp.jsp
    String[] passengerNames  = (String[]) session.getAttribute("checkout_names");
    String[] passengerPhones = (String[]) session.getAttribute("checkout_phones");
    String[] seatNumbers     = (String[]) session.getAttribute("checkout_seats");

    // Booker data — stored as String, not String[]
    String bookerName  = (String) session.getAttribute("booker_name");
    String bookerPhone = (String) session.getAttribute("booker_phone");

    // totalPrice
    Object totalPriceObj = session.getAttribute("total_price");
    String totalPrice = (totalPriceObj != null) ? String.valueOf(totalPriceObj) : "0.00";
    session.setAttribute("checkout_total", totalPrice);

    String origin      = (String) session.getAttribute("origin");
    String destination = (String) session.getAttribute("destination");
    String tripDate    = (String) session.getAttribute("trip_date");

    // Use booker as primary buyer
    String primaryBuyerName  = (bookerName  != null) ? bookerName  : "Customer";
    String primaryBuyerPhone = (bookerPhone != null) ? bookerPhone : "0123456789";
    String primaryBuyerEmail = (String) session.getAttribute("username");
    if (primaryBuyerEmail == null) primaryBuyerEmail = "guest@saniexpress.com";

    // Guard
    if (seatNumbers == null || passengerNames == null) {
        response.sendRedirect("customer.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Checkout - Sani Express</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="style.css"/>
    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="main-container" style="margin-top: 50px;">
            <h2 class="section-title">Order Confirmation</h2>

            <div class="layout-grid">
                <div class="left-col">
                    <div class="trip-card">
                        <h3><i class="fa-solid fa-credit-card"></i> Payment Gateway</h3>
                        <p style="color: #6b7280; margin-top: 10px;">
                            You will be redirected to the secure ToyyibPay gateway to complete your purchase.
                        </p>

                        <form action="createPayment.jsp" method="POST" style="margin-top: 30px;">
                            <input type="hidden" name="buyerName"  value="<%= primaryBuyerName %>">
                            <input type="hidden" name="buyerEmail" value="<%= primaryBuyerEmail %>">
                            <input type="hidden" name="buyerPhone" value="<%= primaryBuyerPhone %>">
                            <input type="hidden" name="totalPrice" value="<%= totalPrice %>">

                            <button type="submit" class="btn-payment" style="font-size: 18px;">
                                Pay RM <%= String.format("%.2f", Double.parseDouble(totalPrice)) %>
                            </button>
                        </form>
                    </div>
                </div>

                <div class="right-col">
                    <h2 class="section-title">Summary</h2>
                    <div class="summary-row bold">
                        <span><i class="fa-solid fa-bus"></i> Route:</span>
                        <span><%= origin %> &rarr; <%= destination %></span>
                    </div>
                    <div class="summary-row">
                        <span>Date:</span>
                        <span><%= tripDate %></span>
                    </div>
                    <div class="summary-row">
                        <span>Booker:</span>
                        <span><%= primaryBuyerName %> (<%= primaryBuyerPhone %>)</span>
                    </div>

                    <div class="divider"></div>

                    <% for (int i = 0; i < seatNumbers.length; i++) { %>
                    <div class="summary-row" style="font-size: 13px;">
                        <span>Seat <%= seatNumbers[i] %>:</span>
                        <span><%= passengerNames[i] %></span>
                    </div>
                    <% } %>

                    <div class="divider"></div>

                    <div class="total-row">
                        <span>Total Amount:</span>
                        <span class="total-price">RM <%= String.format("%.2f", Double.parseDouble(totalPrice)) %></span>
                    </div>
            </div>
        </div>

        <footer class="main-footer">
            &copy; 2026 Sani Express. All rights reserved.
        </footer>
    </body>
</html>