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
        body { background-color: #f4f5f7; color: #1f2937; display: flex; flex-direction: column; min-height: 100vh; }
        .admin-header { background: linear-gradient(135deg, #cc2525 0%, #b01e1e 100%); color: white; padding: 20px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 12px rgba(204, 37, 37, 0.2); }
        .admin-header h1 { font-size: 24px; font-weight: 700; margin-bottom: 5px; display: flex; align-items: center; gap: 10px; }
        .admin-header p { font-size: 14px; opacity: 0.9; }
        .btn-logout { background-color: white; color: #cc2525; border: none; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .btn-logout:hover { background-color: #f9fafb; transform: translateY(-1px); }
        .admin-container { max-width: 900px; margin: 40px auto; padding: 0 20px; width: 100%; }
        
        /* Premium Card Design */
        .auth-card { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05); border: 1px solid #e5e7eb; position: relative; overflow: hidden; }
        .auth-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 6px; background: linear-gradient(90deg, #cc2525, #f87171); }
        .card-header { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid #f3f4f6; }
        .header-icon { width: 50px; height: 50px; background-color: #fee2e2; color: #cc2525; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .card-title h2 { font-size: 24px; font-weight: 700; color: #111827; margin-bottom: 4px; }
        .card-title p { font-size: 14px; color: #6b7280; }

        /* Form Grid Layout */
        .form-row { display: flex; gap: 24px; margin-bottom: 24px; flex-wrap: wrap; }
        .form-col { flex: 1; min-width: 200px; }
        
        .form-group label { display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        
        /* Input Styling */
        .input-wrapper { position: relative; }
        .input-wrapper i { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #9ca3af; font-size: 15px; z-index: 2; transition: color 0.2s; pointer-events: none; }
        
        .form-input { width: 100%; padding: 14px 16px 14px 45px !important; background-color: #f9fafb; border: 1px solid #e5e7eb; border-radius: 10px; font-size: 15px; color: #111827; transition: all 0.2s ease; box-shadow: inset 0 1px 2px rgba(0,0,0,0.01); }
        .form-input:focus { outline: none; border-color: #cc2525; background-color: white; box-shadow: 0 0 0 4px rgba(204, 37, 37, 0.1); }
        .form-input:focus ~ i, .input-wrapper:focus-within i { color: #cc2525; }
        
        /* Readonly State */
        .form-input[readonly] { background-color: #f3f4f6; border-color: #e5e7eb; color: #6b7280; font-weight: 500; cursor: not-allowed; }
        
        /* Select Input specific padding */
        select.form-input { padding-left: 45px; appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%236b7280'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 15px center; background-size: 15px; }

        /* Primary Button */
        .btn-primary { width: 100%; padding: 16px; background: linear-gradient(135deg, #cc2525 0%, #b01e1e 100%); color: white; border: none; border-radius: 10px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: 10px; margin-top: 10px; box-shadow: 0 4px 6px rgba(204, 37, 37, 0.2); }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 15px rgba(204, 37, 37, 0.3); }
        .btn-primary:active { transform: translateY(0); }
        
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

<div class="admin-container">
    <div class="auth-card">
        <div class="card-header">
            <div class="header-icon"><i class="fa-solid fa-route"></i></div>
            <div class="card-title">
                <h2>Create a New Trip</h2>
                <p>Define the route, schedule, and assigned bus</p>
            </div>
        </div>
        
        <form action="TripServlet?action=insert" method="post">
            <!-- Row 1: Route -->
            <div class="form-row">
                <div class="form-col">
                    <div class="form-group">
                        <label>Origin</label>
                        <div class="input-wrapper">
                            <input type="text" name="origin" class="form-input" placeholder="e.g. Kuala Lumpur" required>
                            <i class="fa-solid fa-location-dot"></i>
                        </div>
                    </div>
                </div>
                <div class="form-col">
                    <div class="form-group">
                        <label>Destination</label>
                        <div class="input-wrapper">
                            <input type="text" name="destination" class="form-input" placeholder="e.g. Penang" required>
                            <i class="fa-solid fa-map-pin"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Row 2: Schedule -->
            <div class="form-row">
                <div class="form-col">
                    <div class="form-group">
                        <label>Departure Time</label>
                        <div class="input-wrapper">
                            <input type="datetime-local" name="departureTime" class="form-input" required>
                            <i class="fa-solid fa-calendar-days"></i>
                        </div>
                    </div>
                </div>
                <div class="form-col">
                    <div class="form-group">
                        <label>Arrival Time</label>
                        <div class="input-wrapper">
                            <input type="datetime-local" name="arrivalTime" class="form-input" required>
                            <i class="fa-solid fa-flag-checkered"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Row 3: Assignment & Pricing -->
            <div class="form-row">
                <div class="form-col" style="flex: 2;">
                    <div class="form-group">
                        <label>Assign Bus</label>
                        <div class="input-wrapper">
                            <select name="busId" class="form-input" required>
                                <option value="">-- Select Available Bus --</option>
                                <c:forEach var="bus" items="${busTypes}">
                                    <option value="${bus.busId}">
                                        ${bus.busNumber} (${bus.busType} - ${bus.totalSeats} Seats)
                                    </option>
                                </c:forEach>
                            </select>
                            <i class="fa-solid fa-bus"></i>
                        </div>
                    </div>
                </div>
                <div class="form-col" style="flex: 1;">
                    <div class="form-group">
                        <label>Ticket Price (RM)</label>
                        <div class="input-wrapper">
                            <input type="number" step="0.01" min="0" name="price" class="form-input" placeholder="0.00" required>
                            <i class="fa-solid fa-money-bill-wave"></i>
                        </div>
                    </div>
                </div>
            </div>
            
            <button type="submit" class="btn-primary">
                <i class="fa-solid fa-check"></i> Save Trip Details
            </button>
        </form>
    </div>
</div>

<footer class="main-footer">
    &copy; 2026 Sani Express. All rights reserved.
</footer>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const departureInput = document.querySelector('input[name="departureTime"]');
        const arrivalInput = document.querySelector('input[name="arrivalTime"]');
        const form = document.querySelector('form');

        if (departureInput.value) {
            arrivalInput.min = departureInput.value;
        }

        departureInput.addEventListener('change', function() {
            arrivalInput.min = this.value;
            arrivalInput.setCustomValidity('');
        });

        arrivalInput.addEventListener('change', function() {
            arrivalInput.setCustomValidity('');
        });

        form.addEventListener('submit', function(event) {
            if (departureInput.value && arrivalInput.value) {
                const dep = new Date(departureInput.value);
                const arr = new Date(arrivalInput.value);
                
                if (arr <= dep) {
                    event.preventDefault();
                    arrivalInput.setCustomValidity('Arrival time must be after departure time.');
                    arrivalInput.reportValidity();
                }
            }
        });
    });
</script>
</body>
</html>