<%-- 
    Document   : driver-assignment-list
    Created on : 28 May 2026, 12:04:46 pm
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Assign Driver</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        </style>
    </head>
    <body>
        <div class="section-header">
            <h2>Driver Assignments</h2>
        </div>

        <div class="table-card">
            <h3>Assign Drivers to Trips</h3>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Trip ID</th>
                        <th>Route Info</th>
                        <th>Departure</th>
                        <th>Bus Plate</th>
                        <th>Current Driver</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="trip" items="${tripList}">
                        <tr>
                            <td class="stack-main">#${trip.tripId}</td>
                            <td>
                                <div class="stack">
                                    <span class="stack-main">${trip.origin}</span>
                                    <span class="stack-sub">to ${trip.destination}</span>
                                </div>
                            </td>
                            <td class="stack-main">${trip.departureTime}</td>
                            <td class="stack-main">${trip.plateNumber}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty trip.driverName}">
                                        <span style="color: #059669; font-weight: 600; background: #d1fae5; padding: 4px 10px; border-radius: 20px; font-size: 12px;">
                                            ${trip.driverName}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #e60000; font-weight: 600; background: #fee2e2; padding: 4px 10px; border-radius: 20px; font-size: 12px;">
                                            Unassigned
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <form action="AdminDriverServlet" method="POST" style="display: flex; gap: 8px;">
                                    <input type="hidden" name="trip_id" value="${trip.tripId}">
                                    <select name="driver_id" style="padding: 8px; border-radius: 6px; border: 1px solid #e5e7eb; outline: none; flex-grow: 1;" required>
                                        <option value="" disabled selected>Select Driver</option>
                                        <c:forEach var="driver" items="${driverList}">
                                            <option value="${driver.id}" ${driver.id == trip.driverId ? 'selected' : ''}>
                                                ${driver.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <button type="submit" class="btn-add" style="padding: 8px 16px; border: none; cursor: pointer;">Save</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty tripList}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px; color: #6b7280;">No trips found in the database.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </body>
</html>
