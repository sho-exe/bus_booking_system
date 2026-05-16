<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="table-card">
    <div class="section-header">
        <h2>Trips Management</h2>
        <a href="TripServlet?action=new" class="btn-add">
            <i class="fa-solid fa-plus"></i> Add Trip
        </a>
    </div>

    <h3>All Trips</h3>
    <table class="admin-table">
        <tr>
            <th>Route</th>
            <th>Date</th>
            <th>Time</th>
            <th>Bus</th>
            <th>Driver</th>
            <th>Price</th>
            <th>Available Seats</th>
            <th>Actions</th>
        </tr>

        <c:forEach var="trip" items="${trips}">
        <tr>
            <td>
                <div class="stack">
                    <span class="stack-main"><c:out value="${trip.origin}" /></span>
                    <span class="stack-sub">↓</span>
                    <span class="stack-main"><c:out value="${trip.destination}" /></span>
                </div>
            </td>
            
            <td>
                <div class="stack">
                    <span class="stack-main"><c:out value="${trip.departureTime}" /></span>
                    <span class="stack-sub">to</span>
                    <span class="stack-main"><c:out value="${trip.arrivalTime}" /></span>
                </div>
            </td>
            <td><c:out value="${trip.busId}" /></td>
            <td><c:out value="${trip.driverId}" /></td>
            <td>RM <c:out value="${trip.price}" /></td>
            <td><c:out value="${trip.price}" /></td>
            <td>
                <div class="action-btns">
                    <a href="TripServlet?action=edit&id=${trip.tripId}" class="btn-icon">
                        <i class="fa-solid fa-pen"></i>
                    </a>
                    <a href="TripServlet?action=delete&id=${trip.tripId}" 
                       class="btn-icon delete"
                       onclick="return confirm('Are you sure to delete this trip?')">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </div>
            </td>
        </tr>
        </c:forEach>

        <c:if test="${empty trips}">
        <tr>
            <td colspan="8" style="text-align:center; padding: 40px; color:#9ca3af;">No trips found in the database.</td>
        </tr>
        </c:if>
    </table>
</div>