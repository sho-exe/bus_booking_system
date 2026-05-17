<%-- 
    Document   : driver
    Created on : 16 May 2026, 6:52:29 pm
    Author     : Asus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Driver Page</title>
    </head>
    <body>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .header-bg {
                background-color: #E3000F;
                color: white;
            }
            .stat-card {
                border-radius: 10px;
                border: 1px solid #eaeaea;
            }
            .nav-pills .nav-link.active {
                background-color: #f8f9fa;
                color: black;
                border: 1px solid #dee2e6;
                font-weight: bold;
            }
            .nav-pills .nav-link {
                color: #555;
            }
            .table th {
                background-color: white;
                border-bottom: 2px solid #eaeaea;
                color: #333;
            }
            .table td {
                vertical-align: middle;
            }
            .text-gray {
                color: #888;
                font-size: 0.9rem;
            }
            .icon-circle {
                width: 50px;
                height: 50px;
                background-color: #fee2e2;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
        </style>
        <!-- Header -->
        <div class="header-bg p-4 shadow-sm">
            <div class="container d-flex justify-content-between align-items-center">
                <div>
                    <h2 class="mb-0 fw-bold">Sani Express - Driver Portal</h2>
                    <p class="mb-0">Welcome, ${driver.name}</p> <!-- Injected from Session -->
                </div>
                <a href="LogoutServlet" class="btn btn-light px-4">Logout</a>
            </div>
        </div>

                <!--       
        <div class="container mt-5">
            
            <div class="row mb-4">
                <div class="col-md-6 mb-3 mb-md-0">
                    <div class="stat-card bg-white p-4 d-flex justify-content-between align-items-center shadow-sm">
                        <div>
                            <p class="mb-1 text-secondary">My Assigned Trips</p>
                            <h2 class="text-danger fw-bold mb-0">${assignedCount}</h2>
                        </div>
                        <div class="icon-circle">
                            
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#E3000F" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="stat-card bg-white p-4 d-flex justify-content-between align-items-center shadow-sm">
                        <div>
                            <p class="mb-1 text-secondary">Upcoming Trips</p>
                            <h2 class="text-danger fw-bold mb-0">${upcomingCount}</h2>
                        </div>
                        <div class="icon-circle">
                            
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#E3000F" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        </div>
                    </div>
                </div>
            </div>
                        -->
            <!-- Navigation Tabs -->
            <ul class="nav nav-pills mb-4 bg-white p-2 rounded shadow-sm d-inline-flex" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active rounded-pill px-5 d-flex align-items-center gap-2" id="pills-trips-tab" data-bs-toggle="pill" data-bs-target="#pills-trips" type="button" role="tab">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        My Trips
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link rounded-pill px-5 d-flex align-items-center gap-2" id="pills-profile-tab" data-bs-toggle="pill" data-bs-target="#pills-profile" type="button" role="tab">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        Profile
                    </button>
                </li>
            </ul>

            <h3 class="fw-bold mb-3">My Assigned Trips</h3>

            <!-- Tab Content -->
            <div class="tab-content" id="pills-tabContent">

                <!-- TRIPS TAB -->
                <div class="tab-pane fade show active" id="pills-trips" role="tabpanel">
                    <div class="card shadow-sm border-0 rounded-3 p-4">
                        <h5 class="fw-bold mb-4">Trip Schedule</h5>
                        <div class="table-responsive">
                            <table class="table table-borderless border-bottom">
                                <thead>
                                    <tr class="border-bottom">
                                        <th class="pb-3">Date</th>
                                        <th class="pb-3">Route</th>
                                        <th class="pb-3">Departure</th>
                                        <th class="pb-3">Arrival</th>
                                        <th class="pb-3">Bus</th>
                                        <th class="pb-3">Passengers</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Loop through trips fetched from the Database via Servlet -->
                                <c:forEach var="trip" items="${tripList}">
                                    <tr class="border-bottom">
                                        <td class="fw-bold py-3">${trip.tripDate}</td>
                                        <td class="py-3">
                                            <span class="d-block">${trip.origin}</span>
                                            <small class="text-muted d-block my-1">↓</small>
                                            <span class="d-block">${trip.destination}</span>
                                        </td>
                                        <td class="py-3">${trip.departureTime}</td>
                                        <td class="py-3">${trip.arrivalTime}</td>
                                        <td class="py-3">
                                            <span class="d-block">${trip.busId}</span>
                                            <span class="text-gray d-block">${trip.plateNumber}</span>
                                            <span class="text-gray d-block">${trip.busType}</span>
                                        </td>
                                        <td class="py-3">
                                            <span class="fw-bold d-block">${trip.bookedSeats} / ${trip.totalSeats}</span>
                                            <span class="text-gray d-block">${trip.totalSeats - trip.bookedSeats} seats left</span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- PROFILE TAB -->
                <div class="tab-pane fade" id="pills-profile" role="tabpanel">
                    <div class="card shadow-sm border-0 rounded-3 p-4">
                        <h5 class="fw-bold mb-4">Update Profile</h5>
                        <form action="UpdateProfileServlet" method="POST" class="w-50">
                            <input type="hidden" name="driverId" value="${driver.id}">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" class="form-control bg-light" name="name" value="${driver.name}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" class="form-control bg-light" name="email" value="${driver.email}" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="text" class="form-control bg-light" name="phone" value="${driver.phone}" required>
                            </div>
                            <div class="mt-4">
                                <button type="submit" class="btn btn-danger px-4 py-2 fw-semibold">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>

        <!-- Bootstrap JS for Tabs functionality -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
