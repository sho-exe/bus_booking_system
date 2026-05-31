<%-- driver-assignment-list.jsp --%>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

            <div class="table-card">
                <div class="section-header">
                    <h2>Driver Assignments</h2>
                </div>

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
                                            <span class="driver-assigned">${trip.driverName} -
                                                ${trip.licenseNumber}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="driver-unassigned">Unassigned</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="AdminDriverServlet" method="POST" class="assign-form">
                                        <input type="hidden" name="trip_id" value="${trip.tripId}">
                                        <select name="driver_id" class="driver-select" required>
                                            <option value="" disabled selected>Select Driver</option>
                                            <c:forEach var="driver" items="${driverList}">
                                                <option value="${driver.id}" ${driver.id==trip.driverId ? 'selected'
                                                    : '' }>
                                                    ${driver.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <button type="submit" class="btn-add btn-save">Save</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty tripList}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: #6b7280;">No trips
                                    found in the database.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>