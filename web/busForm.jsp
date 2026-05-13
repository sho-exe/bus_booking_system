<%-- 
    Document   : busForm
    Created on : 22 Apr 2026, 11:26:58 am
    Author     : Asus
--%>
<%@ page import="java.util.*, model.Bus" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bus Form</title>

        <link rel="stylesheet" href="style.css">
    </head>
    <body>

        <div class="header">
            <h1>Sani Express</h1>
        </div>

        <%
            Bus bus = (Bus) request.getAttribute("bus");
        %>

        
        <h1 class="editAdd"><%= (bus == null) ? "Add New Bus" : "Edit Bus"%></h1>

        <form class="form" action='BusServlet?action=<%= (bus == null) ? "insert" : "update"%>' method='post'>

            <% if (bus != null) {%>
            <input type="hidden" name="busID" value="<%= bus.getID()%>" />
            <% }%>


            <div class="form-group">
                <label>Bus Number:</label>
                <input type="text" name="busNumber" value="<%= (bus != null) ? bus.getBusNumber() : ""%>" required />
            </div>

            <div class="form-group">
                <label>Bus Type:</label>
                <select name="busType" id="busType" required onchange="setSeat()">
                    <option value="">-- Select Bus Type --</option>
                    <option value="Single Decker"
                            <%= (bus != null && bus.getBusType().equalsIgnoreCase("Single Decker")) ? "selected" : ""%>>
                        Single Decker
                    </option>
                    <option value="Double Decker"
                            <%= (bus != null && bus.getBusType().equalsIgnoreCase("Double Decker")) ? "selected" : ""%>>
                        Double Decker
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label>Total Seat:</label>
                <input type="number" name="totalSeat" id="totalSeat"
                       value="<%= (bus != null) ? bus.getTotalSeat() : ""%>"
                       readonly />
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-save">Save</button>
            </div>
        </form>
        
        <div class="form-actions">    
            <a class="btn-back" href="BusServlet?action=list">Back to List</a>
        </div>


        <script>
            function setSeat() {
                const type = document.getElementById("busType").value;
                const seat = document.getElementById("totalSeat");

                if (type === "Single Decker") {
                    seat.value = 40;
                } else if (type === "Double Decker") {
                    seat.value = 53;
                } else {
                    seat.value = "";
                }
            }
        </script>
    </body>
</html>
