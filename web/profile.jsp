<%@page import="dao.UserDAO" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>My Profile - Sani Express</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="style.css" />
        </head>

        <body>
            <jsp:include page="header.jsp" />

            <% String role=(String) session.getAttribute("userRole"); String username=(String)
                session.getAttribute("username"); if (role==null || username==null) {
                response.sendRedirect("login.html"); return; } String successMsg=null; String errorMsg=null; if
                ("POST".equalsIgnoreCase(request.getMethod())) { String newEmail=request.getParameter("email"); String
                newPhone=request.getParameter("phone"); UserDAO userDAO=new UserDAO(); boolean
                updated=userDAO.updateProfile(username, newEmail, newPhone); if (updated) {
                session.setAttribute("email", newEmail); session.setAttribute("phoneNumber", newPhone);
                successMsg="Profile updated successfully!" ; } else {
                errorMsg="Failed to update profile. Please try again." ; } } String email=(String)
                session.getAttribute("email"); String phoneNumber=(String) session.getAttribute("phoneNumber"); %>

                <div class="main-container">

                    <div class="tab-nav" style="margin-top: 20px;">
                        <a href="Booking.jsp" class="tab"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
                        <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                        <a href="profile.jsp" class="tab active"><i class="fa-regular fa-user"></i> Profile</a>
                    </div>

                    <% if (successMsg !=null) { %>
                        <div class="trip-card" style="background:#e8f5e9; border-color:#a5d6a7; margin-top:20px;">
                            <div class="trip-info">
                                <p style="margin:0; color:#2e7d32; font-weight:600;">
                                    <i class="fa-solid fa-circle-check"></i>
                                    <%= successMsg %>
                                </p>
                            </div>
                        </div>
                        <% } %>
                            <% if (errorMsg !=null) { %>
                                <div class="trip-card"
                                    style="background:#fdecea; border-color:#ef9a9a; margin-top:20px;">
                                    <div class="trip-info">
                                        <p style="margin:0; color:#c62828; font-weight:600;">
                                            <i class="fa-solid fa-triangle-exclamation"></i>
                                            <%= errorMsg %>
                                        </p>
                                    </div>
                                </div>
                                <% } %>

                                    <div class="search-card" style="margin-top: 20px;">
                                        <h2 class="card-title">
                                            <i class="fa-regular fa-user"></i> My Profile
                                        </h2>

                                        <!-- Identity strip (read-only) -->
                                        <div class="trip-card" style="margin-bottom: 25px;">
                                            <div class="trip-info">
                                                <h3>
                                                    <%= username %>
                                                </h3>
                                                <p class="route"><i class="fa-solid fa-shield-halved"></i>
                                                    <%= role %>
                                                </p>
                                            </div>
                                            <div class="trip-action">
                                                <span class="status-badge status-confirmed">
                                                    <i class="fa-solid fa-circle-check"></i> Active
                                                </span>
                                            </div>
                                        </div>

                                        <!-- Edit form -->
                                        <form action="profile.jsp" method="POST">

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label>Email Address</label>
                                                    <div class="input-wrapper">
                                                        <i class="fa-regular fa-envelope"></i>
                                                        <input type="email" name="email" class="form-control"
                                                            placeholder="Enter email"
                                                            value="<%= email != null ? email : "" %>" required>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label>Phone Number</label>
                                                    <div class="input-wrapper">
                                                        <i class="fa-solid fa-phone"></i>
                                                        <input type="tel" name="phone" class="form-control"
                                                            placeholder="Enter phone number"
                                                            value="<%= phoneNumber != null ? phoneNumber : "" %>">
                                                    </div>
                                                </div>
                                            </div>

                                            <button type="submit" class="btn-submit">
                                                <i class="fa-solid fa-floppy-disk"></i> Save Changes
                                            </button>

                                        </form>
                                    </div>
                </div>
        </body>

        </html>