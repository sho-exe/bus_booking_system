<%@page import="java.sql.*" %>
    <%@page import="dao.TripDAO" %>
        <%@page import="dao.BusDAO" %>
            <%@page import="dao.BookingDAO" %>
                <%@page import="dao.AdminDAO" %>
                <%@page contentType="text/html" pageEncoding="UTF-8" %>
                    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                        <!DOCTYPE html>
                        <html>

                        <head>
                            <meta charset="UTF-8">
                            <title>Admin Dashboard - Sani Express</title>
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                            <style>
                                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

                                * {
                                    margin: 0;
                                    padding: 0;
                                    box-sizing: border-box;
                                    font-family: 'Inter', sans-serif;
                                }

                                body {
                                    background-color: #f8f9fa;
                                    color: #333;
                                    display: flex;
                                    flex-direction: column;
                                    min-height: 100vh;
                                }

                                .admin-header {
                                    background-color: #e60000;
                                    color: white;
                                    padding: 20px 40px;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .admin-header h1 {
                                    font-size: 24px;
                                    font-weight: 700;
                                    margin-bottom: 5px;
                                }

                                .admin-header p {
                                    font-size: 14px;
                                    opacity: 0.9;
                                }

                                .btn-logout {
                                    background-color: white;
                                    color: #e60000;
                                    border: none;
                                    padding: 10px 24px;
                                    border-radius: 8px;
                                    font-size: 14px;
                                    font-weight: 600;
                                    cursor: pointer;
                                    transition: background-color 0.2s;
                                }

                                .btn-logout:hover {
                                    background-color: #f3f4f6;
                                }

                                .admin-container {
                                    max-width: 1200px;
                                    margin: 40px auto;
                                    padding: 0 20px;
                                    width: 100%;
                                }

                                .stat-cards {
                                    display: grid;
                                    grid-template-columns: repeat(4, 1fr);
                                    gap: 20px;
                                    margin-bottom: 30px;
                                }

                                .stat-card {
                                    background: white;
                                    padding: 24px;
                                    border-radius: 12px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
                                    border: 1px solid #f3f4f6;
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                }

                                .stat-info h3 {
                                    font-size: 14px;
                                    color: #6b7280;
                                    font-weight: 500;
                                    margin-bottom: 8px;
                                }

                                .stat-info h2 {
                                    font-size: 32px;
                                    font-weight: 700;
                                    color: #e60000;
                                }

                                .stat-icon {
                                    font-size: 40px;
                                    color: #fee2e2;
                                }

                                .admin-tabs {
                                    background-color: #f3f4f6;
                                    display: inline-flex;
                                    padding: 6px;
                                    border-radius: 30px;
                                    margin-bottom: 40px;
                                    gap: 5px;
                                }

                                .admin-tab {
                                    padding: 10px 24px;
                                    border-radius: 24px;
                                    color: #4b5563;
                                    font-size: 14px;
                                    font-weight: 500;
                                    text-decoration: none;
                                    display: flex;
                                    align-items: center;
                                    gap: 8px;
                                    transition: all 0.2s;
                                }

                                .admin-tab i {
                                    font-size: 16px;
                                }

                                .admin-tab:hover {
                                    color: #111827;
                                }

                                .admin-tab.active {
                                    background-color: white;
                                    color: #111827;
                                    font-weight: 600;
                                    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                                }

                                .section-header {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    margin-bottom: 20px;
                                }

                                .section-header h2 {
                                    font-size: 24px;
                                    font-weight: 700;
                                    color: #111827;
                                }

                                .btn-add {
                                    background-color: #e60000;
                                    color: white;
                                    padding: 10px 20px;
                                    border-radius: 8px;
                                    font-size: 14px;
                                    font-weight: 600;
                                    text-decoration: none;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                }

                                .btn-add:hover {
                                    background-color: #cc0000;
                                }

                                .table-card {
                                    background: white;
                                    border-radius: 12px;
                                    padding: 30px;
                                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);
                                    border: 1px solid #f3f4f6;
                                }

                                .table-card h3 {
                                    font-size: 16px;
                                    font-weight: 600;
                                    color: #111827;
                                    margin-bottom: 25px;
                                }

                                .admin-table {
                                    width: 100%;
                                    border-collapse: collapse;
                                }

                                .admin-table th {
                                    text-align: left;
                                    padding: 0 15px 15px 15px;
                                    font-size: 13px;
                                    font-weight: 600;
                                    color: #111827;
                                    border-bottom: 1px solid #e5e7eb;
                                }

                                .admin-table td {
                                    padding: 20px 15px;
                                    font-size: 14px;
                                    color: #4b5563;
                                    border-bottom: 1px solid #f3f4f6;
                                    vertical-align: middle;
                                }

                                .admin-table tr:last-child td {
                                    border-bottom: none;
                                }

                                .stack {
                                    display: flex;
                                    flex-direction: column;
                                    gap: 4px;
                                }

                                .stack-main {
                                    color: #111827;
                                    font-weight: 500;
                                }

                                .stack-sub {
                                    color: #9ca3af;
                                    font-size: 12px;
                                }

                                .action-btns {
                                    display: flex;
                                    gap: 12px;
                                }

                                .btn-icon {
                                    width: 36px;
                                    height: 36px;
                                    border-radius: 50%;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    background: white;
                                    border: 1px solid #e5e7eb;
                                    color: #4b5563;
                                    text-decoration: none;
                                    transition: all 0.2s;
                                }

                                .btn-icon:hover {
                                    background-color: #f9fafb;
                                    color: #111827;
                                }

                                .btn-icon.delete {
                                    color: #e60000;
                                    border-color: #fee2e2;
                                }

                                .btn-icon.delete:hover {
                                    background-color: #fef2f2;
                                }

                                /* ── driver-assignment-list.jsp ── */
                                .driver-assigned {
                                    color: #059669;
                                    font-weight: 600;
                                    background: #d1fae5;
                                    padding: 4px 10px;
                                    border-radius: 20px;
                                    font-size: 12px;
                                }

                                .driver-unassigned {
                                    color: #e60000;
                                    font-weight: 600;
                                    background: #fee2e2;
                                    padding: 4px 10px;
                                    border-radius: 20px;
                                    font-size: 12px;
                                }

                                .assign-form {
                                    display: flex;
                                    gap: 8px;
                                }

                                .driver-select {
                                    padding: 8px;
                                    border-radius: 6px;
                                    border: 1px solid #e5e7eb;
                                    outline: none;
                                    flex-grow: 1;
                                }

                                .btn-save {
                                    padding: 8px 16px;
                                    border: none;
                                    cursor: pointer;
                                }
                            </style>
                        </head>

                        <body>

                            <header class="admin-header">
                                <div>
                                    <h1>Sani Express - Staff Portal</h1>
                                    <p>Welcome, ${sessionScope.username != null ? sessionScope.username : 'Sarah Admin'}
                                    </p>
                                </div>
                                <button class="btn-logout" onclick="location.href = 'login.html'">Logout</button>
                            </header>

                            <% TripDAO tripDAO=new TripDAO(); BusDAO busDAO=new BusDAO(); BookingDAO bookingDAO=new BookingDAO(); AdminDAO adminDAO=new AdminDAO(); 
                                int totalTrips=tripDAO.getAllTrips() !=null ? tripDAO.getAllTrips().size() : 0; 
                                int totalBuses=busDAO.selectAllBuses() !=null ? busDAO.selectAllBuses().size() : 0;
                                int totalBookings=bookingDAO.getAllBookings() !=null ? bookingDAO.getAllBookings().size() : 0; 
                                int totalDrivers=adminDAO.getAllDrivers() !=null ? adminDAO.getAllDrivers().size() : 0; %>

                                <div class="admin-container">
                                    <div class="stat-cards">
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h3>Total Trips</h3>
                                                <h2>
                                                    <%= totalTrips%>
                                                </h2>
                                            </div>
                                            <div class="stat-icon"><i class="fa-solid fa-location-dot"></i></div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h3>Total Buses</h3>
                                                <h2>
                                                    <%= totalBuses%>
                                                </h2>
                                            </div>
                                            <div class="stat-icon"><i class="fa-solid fa-bus"></i></div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h3>Total Drivers</h3>
                                                <h2>
                                                    <%= totalDrivers%>
                                                </h2>
                                            </div>
                                            <div class="stat-icon"><i class="fa-solid fa-user-group"></i></div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-info">
                                                <h3>Total Bookings</h3>
                                                <h2>
                                                    <%= totalBookings%>
                                                </h2>
                                            </div>
                                            <div class="stat-icon"><i class="fa-solid fa-ticket"></i></div>
                                        </div>
                                    </div>

                                    <div class="admin-tabs">
                                        <a href="TripServlet?action=list"
                                            class="admin-tab ${activeTab == 'trips' || empty activeTab ? 'active' : ''}">
                                            <i class="fa-solid fa-location-dot"></i> Trips
                                        </a>
                                        <a href="BusServlet?action=list"
                                            class="admin-tab ${activeTab == 'buses' ? 'active' : ''}">
                                            <i class="fa-solid fa-bus"></i> Buses
                                        </a>
                                        <a href="AdminDriverServlet"
                                            class="admin-tab ${activeTab == 'drivers' ? 'active' : ''}">
                                            <i class="fa-solid fa-user-group"></i> Drivers
                                        </a>
                                        <a href="booking?action=adminList"
                                            class="admin-tab ${activeTab == 'bookings' ? 'active' : ''}">
                                            <i class="fa-solid fa-ticket"></i> Bookings
                                        </a>
                                    </div>

                                    <c:choose>
                                        <c:when test="${activeTab == 'buses'}">
                                            <jsp:include page="busList.jsp" />
                                        </c:when>
                                        <c:when test="${activeTab == 'drivers'}">
                                            <jsp:include page="driver-assignment-list.jsp" />
                                        </c:when>
                                        <c:when test="${activeTab == 'bookings'}">
                                            <jsp:include page="booking-list.jsp" />
                                        </c:when>
                                        <c:otherwise>
                                            <jsp:include page="trip-list.jsp" />
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                        </body>

                        </html>