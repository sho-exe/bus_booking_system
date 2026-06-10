<%-- 
    Document   : driver
    Created on : 16 May 2026, 6:52:29 pm
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sani Express - Driver Portal</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f4f6f9;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            /* Header mimicking Image 2 */
            .header-bg {
                background-color: #d80000; /* Sani Express Red */
                color: white;
                padding: 15px 20px;
            }
            .logout-btn {
                background-color: white;
                color: #d80000;
                font-weight: bold;
                border-radius: 6px;
                padding: 6px 20px;
                text-decoration: none;
                border: none;
            }
            .logout-btn:hover {
                background-color: #f8f9fa;
                color: #b30000;
            }
            /* Pill Navigation matching the "Buses" toggle in Image 2 */
            .nav-pills-custom {
                background-color: #f0f2f5;
                border-radius: 30px;
                padding: 5px;
                display: inline-flex;
                gap: 5px;
            }
            .nav-pills-custom .nav-link {
                color: #6c757d;
                border-radius: 25px;
                padding: 8px 24px;
                font-weight: 600;
                border: none;
                background: transparent;
            }
            .nav-pills-custom .nav-link.active {
                background-color: white;
                color: #212529;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            /* Clean Card Style */
            .card-custom {
                background: white;
                border-radius: 12px;
                border: none;
                padding: 30px;
            }
            /* Clean Table Style */
            .table-custom th {
                color: #000;
                font-weight: 600;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 15px;
                font-size: 0.95rem;
            }
            .table-custom td {
                padding: 18px 0;
                vertical-align: middle;
                border-bottom: 1px solid #f0f2f5;
                font-size: 0.95rem;
            }
            .btn-red {
                background-color: #d80000;
                color: white;
                font-weight: 600;
                border-radius: 6px;
            }
            .btn-red:hover {
                background-color: #b30000;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="header-bg shadow-sm d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-0 fw-bold">Sani Express - Staff Portal</h4>
                <small>Welcome, ${driver.name}</small>
            </div>
            <a href="logout.jsp" class="logout-btn">Logout</a>
        </div>

        <div class="container mt-5">
            <div class="nav-pills-custom mb-4" role="tablist">
                <button class="nav-link active d-flex align-items-center gap-2" id="trips-tab" data-bs-toggle="pill" data-bs-target="#trips" type="button" role="tab">
                    My Trips
                </button>
                <button class="nav-link d-flex align-items-center gap-2" id="profile-tab" data-bs-toggle="pill" data-bs-target="#profile" type="button" role="tab">
                    Profile
                </button>
            </div>

            <div class="tab-content">

                <div class="tab-pane fade show active" id="trips" role="tabpanel">
                    <div class="card-custom shadow-sm">
                        <h4 class="fw-bold mb-4">Trip Schedule</h4>
                        <div class="table-responsive">
                            <table class="table table-borderless table-custom">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Route</th>
                                        <th>Departure</th>
                                        <th>Arrival</th>
                                        <th>Bus</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="trip" items="${tripList}">
                                        <tr>
                                            <td class="fw-semibold">${trip.tripDate}</td>
                                            <td>
                                                <span class="d-block fw-semibold">${trip.origin}</span>
                                                <small class="text-muted">to ${trip.destination}</small>
                                            </td>
                                            <td>${trip.departureTime}</td>
                                            <td>${trip.arrivalTime}</td>
                                            <td>
                                                <span class="d-block fw-semibold">${trip.plateNumber}</span>
                                                <span class="badge bg-secondary">${trip.busType}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty tripList}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">No trips assigned yet.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="profile" role="tabpanel">
                    <div class="card-custom shadow-sm">
                        <h4 class="fw-bold mb-4">Update Profile</h4>
                        <form action="UpdateProfileServlet" method="POST" class="w-50">
                            <input type="hidden" name="driverId" value="${driver.id}">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" class="form-control" name="name" value="${driver.name}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">License Number</label>
                                <input type="text" class="form-control" name="license_number" value="${driver.licenseNumber}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="text" class="form-control" name="phone_number" value="${driver.phone}" required>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-red px-4 py-2">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
