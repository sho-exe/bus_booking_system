<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Trip - Sani Express</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
        body { background-color: #f8f9fa; color: #333; display: flex; flex-direction: column; min-height: 100vh; }
        .admin-header { background-color: #e60000; color: white; padding: 20px 40px; display: flex; justify-content: space-between; align-items: center; }
        .admin-header h1 { font-size: 24px; font-weight: 700; margin-bottom: 5px; }
        .admin-header p { font-size: 14px; opacity: 0.9; }
        .btn-logout { background-color: white; color: #e60000; border: none; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background-color 0.2s; }
        .btn-logout:hover { background-color: #f3f4f6; }
        .admin-container { max-width: 1200px; margin: 40px auto; padding: 0 20px; width: 100%; }
        .auth-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05); border: 1px solid #f3f4f6; }
        .auth-card h2 { font-size: 24px; font-weight: 700; color: #111827; margin-bottom: 8px; }
        .auth-card p { font-size: 15px; color: #6b7280; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #111827; margin-bottom: 8px; }
        .form-input { width: 100%; padding: 12px 16px; background-color: #f3f4f6; border: 1px solid transparent; border-radius: 8px; font-size: 15px; color: #111827; transition: all 0.2s; }
        .form-input:focus { outline: none; border-color: #e60000; background-color: white; box-shadow: 0 0 0 3px rgba(230, 0, 0, 0.1); }
        .btn-primary { width: 100%; padding: 14px; background-color: #e60000; color: white; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background-color 0.2s; text-align: center; text-decoration: none; display: inline-block; }
        .btn-primary:hover { background-color: #cc0000; }
        .main-footer { background-color: #1f2937; color: white; text-align: center; padding: 20px; font-size: 14px; margin-top: auto; }
    </style>
</head>
<body>

<header class="admin-header">
    <div>
        <h1>Sani Express - Staff Portal</h1>
        <p>Add a new trip to the system</p>
    </div>
    <button class="btn-logout" onclick="location.href='TripServlet?action=list'">Back to Dashboard</button>
</header>

<div class="admin-container" style="max-width: 600px; margin-top: 60px;">
    <div class="auth-card">
        <h2>Add New Trip</h2>
        <p>Fill in the trip details below</p>
        
        <form action="TripServlet?action=insert" method="post">
            <div class="form-group">
                <label>Origin</label>
                <input type="text" name="origin" class="form-input" required>
            </div>
            <div class="form-group">
                <label>Destination</label>
                <input type="text" name="destination" class="form-input" required>
            </div>
           
            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>Departure Time</label>
                    <input type="datetime-local" name="departureTime" class="form-input" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Arrival Time</label>
                    <input type="datetime-local" name="arrivalTime" class="form-input" required>
                </div>
            </div>
            <div class="form-group">
                <label>Bus</label>
                <select name="busId" class="form-input" required>
                    <option value="">-- Select Bus --</option>
                    <c:forEach var="bus" items="${busTypes}">
                        <option value="${bus.busId}">
                            ${bus.busNumber} (${bus.busType} - ${bus.totalSeats} Seats)
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Price (RM)</label>
                <input type="number" step="0.01" name="price" class="form-input" required>
            </div>
            
            <button type="submit" class="btn-primary" style="margin-top: 10px;">Save Trip</button>
        </form>
    </div>
</div>

<footer class="main-footer">
    &copy; 2026 Sani Express. All rights reserved.
</footer>

</body>
</html>