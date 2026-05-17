<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="dao.BusDAO, java.util.*, model.Bus"%>

<%
    ArrayList<Bus> busList = (ArrayList<Bus>) request.getAttribute("listBus");
%>

<div class="table-card">
    <div class="section-header">
        <h2>Bus Management</h2>
        <a href="BusServlet?action=new" class="btn-add">
            <i class="fa-solid fa-plus"></i> Add Bus
        </a>
    </div>

    <h3>All Buses</h3>
    <table class="admin-table">
        <tr>
            <th>ID</th>
            <th>Bus Number</th>
            <th>Bus Type</th>
            <th>Total Seats</th>
            <th>Actions</th>
        </tr>

        <% if (busList != null && !busList.isEmpty()) {
            for (Bus bus : busList) {
                String type = bus.getBusType().toLowerCase();
                String badgeColor = type.contains("double") ? "#eab308" : "#3b82f6";
        %>
        <tr>
            <td><%= bus.getBusId() %></td>
            <td><span class="stack-main"><%= bus.getBusNumber() %></span></td>
            <td>
                <span style="background: <%= badgeColor %>; color: white; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 600;">
                    <%= bus.getBusType() %>
                </span>
            </td>
            <td><%= bus.getTotalSeat() %></td>
            <td>
                <div class="action-btns">
                    <a href="BusServlet?action=edit&busID=<%= bus.getBusId() %>" class="btn-icon">
                        <i class="fa-solid fa-pen"></i>
                    </a>
                    <a href="BusServlet?action=delete&id=<%= bus.getBusId() %>" 
                       class="btn-icon delete"
                       onclick="return confirm('Are you sure you want to delete this bus?')">
                        <i class="fa-solid fa-trash-can"></i>
                    </a>
                </div>
            </td>
        </tr>
        <%  }
        } else { %>
        <tr>
            <td colspan="5" style="text-align:center; padding: 40px; color:#9ca3af;">No buses found in the database.</td>
        </tr>
        <% } %>
    </table>
</div>
