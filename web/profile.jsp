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

        <% String role = (String) session.getAttribute("userRole");
            String username = (String) session.getAttribute("username");
            boolean isLoggedIn = (role != null && username != null);
            String successMsg = null;
            String errorMsg = null;
            String email = null;
            String phoneNumber = null;
            if (isLoggedIn) {
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String newEmail = request.getParameter("email");
                    String newPhone = request.getParameter("phone");
                    UserDAO userDAO = new UserDAO();
                    boolean updated = userDAO.updateProfile(username, newEmail, newPhone);
                    if (updated) {
                        session.setAttribute("email", newEmail);
                        session.setAttribute("phoneNumber", newPhone);
                        successMsg = "Profile updated successfully!";
                    } else {
                        errorMsg = "Failed to update profile. Please try again.";
                    }
                }
                    email = (String) session.getAttribute("email");
                    phoneNumber = (String) session.getAttribute("phoneNumber");
                } %>

        <div class="main-container" style="margin-top: 50px;">

            <div style="text-align: center; margin-bottom: 30px;">
                <div class="tab-nav tab-nav-top" style="display: inline-flex;">
                    <a href="Booking.jsp" class="tab"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
                    <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
                    <a href="profile.jsp" class="tab active"><i class="fa-regular fa-user"></i> Profile</a>
                </div>
            </div>

            <% if (!isLoggedIn) { %>




            <div class="trip-card login-required-card">


                <div class="trip-info login-required-body">
                    <i class="fa-solid fa-lock login-required-icon"></i>
                    <h3 class="login-required-title">Login Required</h3>
                    <p class="login-required-text">
                        You need to be logged in to view your profile.
                    </p>

                    <a href="login.html" class="btn-submit btn-login-now">
                        <i class="fa-solid fa-right-to-bracket"></i> Login Now
                    </a>
                </div>
            </div>
            <% } else { %>

            <% if (successMsg != null) {%>
            <div class="trip-card alert-card-success">
                <div class="trip-info">
                    <p>
                        <i class="fa-solid fa-circle-check"></i>
                        <%= successMsg%>
                    </p>
                </div>
            </div>
            <% } %>

            <% if (errorMsg != null) {%>
            <div class="trip-card alert-card-error">
                <div class="trip-info">
                    <p>
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <%= errorMsg%>
                    </p>
                </div>
            </div>
            <% }%>

            <div class="search-card profile-card">
                <h2 class="card-title">
                    <i class="fa-regular fa-user"></i> My Profile
                </h2>

                <!-- Identity strip (read-only) -->
                <div class="trip-card identity-strip">
                    <div class="trip-info">
                        <h3>
                            <%= username%>
                        </h3>
                        <p class="route"><i class="fa-solid fa-shield-halved"></i>
                            <%= role%>
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
                                       value="<%= email != null ? email : ""%>" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-phone"></i>
                                <input type="tel" name="phone" class="form-control"
                                       placeholder="Enter phone number"
                                       value="<%= phoneNumber != null ? phoneNumber : ""%>">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fa-solid fa-floppy-disk"></i> Save Changes
                    </button>
                </form>
            </div>

            <% }%>
        </div>

        <footer class="main-footer">
            &copy; 2026 Sani Express. All rights reserved.
        </footer>
    </body>
</html>