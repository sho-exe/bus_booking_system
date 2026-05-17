<%@page import="dao.UserDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Profile - Sani Express</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css" />
</head>

<body>
    <jsp:include page="header.jsp" />

    <%
        String role     = (String) session.getAttribute("userRole");
        String username = (String) session.getAttribute("username");
        if (role == null || username == null) {
            response.sendRedirect("login.html");
            return;
        }

        String successMsg = null;
        String errorMsg   = null;

        // Handle POST — update profile
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

        // Read from session (may have just been updated above)
        String email       = (String) session.getAttribute("email");
        String phoneNumber = (String) session.getAttribute("phoneNumber");
    %>

    <div class="main-container">

        <div class="tab-nav" style="margin-top: 20px;">
            <a href="Booking.jsp" class="tab"><i class="fa-solid fa-magnifying-glass"></i> Book Trip</a>
            <a href="customer.jsp" class="tab"><i class="fa-solid fa-ticket"></i> My Bookings</a>
            <a href="profile.jsp" class="tab active"><i class="fa-regular fa-user"></i> Profile</a>
        </div>

        <div class="results-container" style="margin-top: 30px;">
            <h2 class="section-title">My Profile</h2>

            <% if (successMsg != null) { %>
                <div style="background:#e6f9ee; border:1px solid #a3d9b1; color:#276243; padding:12px 18px;
                            border-radius:6px; margin-bottom:20px; font-size:14px;">
                    <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
                </div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div style="background:#fdecea; border:1px solid #f5c6cb; color:#842029; padding:12px 18px;
                            border-radius:6px; margin-bottom:20px; font-size:14px;">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= errorMsg %>
                </div>
            <% } %>

            <form action="profile.jsp" method="POST">
                <div class="search-card">

                    <!-- Avatar / Identity -->
                    <div style="display:flex; align-items:center; gap:20px; margin-bottom:30px;
                                padding-bottom:25px; border-bottom:1px solid #eee;">
                        <div style="width:70px; height:70px; border-radius:50%; background:#cc2525;
                                    display:flex; align-items:center; justify-content:center;">
                            <i class="fa-regular fa-user" style="font-size:28px; color:white;"></i>
                        </div>
                        <div>
                            <div style="font-size:20px; font-weight:bold; color:#333;"><%= username %></div>
                            <div style="font-size:13px; color:#888; margin-top:3px;"><%= role %></div>
                        </div>
                    </div>

                    <!-- Fields -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>Username</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-id-badge"></i>
                                <input type="text" class="form-control" value="<%= username %>" disabled
                                       style="background:#f4f4f4; color:#888; cursor:not-allowed;">
                            </div>
                            <span style="font-size:12px; color:#aaa;">Username cannot be changed.</span>
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-shield-halved"></i>
                                <input type="text" class="form-control" value="<%= role %>" disabled
                                       style="background:#f4f4f4; color:#888; cursor:not-allowed;">
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Email Address</label>
                            <div class="input-wrapper">
                                <i class="fa-regular fa-envelope"></i>
                                <input type="email" name="email" class="form-control"
                                       placeholder="Enter email"
                                       value="<%= (email != null ? email : "") %>" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Phone Number</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-phone"></i>
                                <input type="tel" name="phone" class="form-control"
                                       placeholder="Enter phone number"
                                       value="<%= (phoneNumber != null ? phoneNumber : "") %>">
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="btn-submit" style="margin-top:10px;">
                        <i class="fa-solid fa-floppy-disk"></i> Save Changes
                    </button>

                </div>
            </form>
        </div>
    </div>

</body>
</html>
