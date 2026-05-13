<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dao.BusDAO, java.util.*, model.Bus"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Bus List</title>

        <%

            ArrayList<Bus> busList = (ArrayList<Bus>) request.getAttribute("listBus");


        %>

        <link rel="stylesheet" href="style.css">
    </head>
    <body>

        <div class="header">
            <h1>Sani Express</h1>
        </div>


        <div class="container">
            <h1>Bus Inventory</h1>
            <a href="BusServlet?action=new" class="btn-add">Add New Bus</a>
            <br><br>
            <div class="table-card">
                <table border="1">
                    <tr>
                        <th>ID</th>
                        <th>Bus Number</th>
                        <th>Bus Type</th>
                        <th>Total Seat</th>
                        <th>Action</th>
                    </tr>
            </div>
        </div>
        <%      for (Bus bus : busList) {
                out.println("<tr>");

                out.print("<td>" + bus.getID() + "</td>");
                out.print("<td>" + bus.getBusNumber() + "</td>");

                String type = bus.getBusType().toLowerCase();
                String badgeClass = "";

                if (type.contains("double")) {
                    badgeClass = "double";
                } else if (type.contains("single")) {
                    badgeClass = "single";
                }

                out.print("<td><span class='badge " + badgeClass + "'>"
                        + bus.getBusType() + "</span></td>");

                out.print("<td>" + bus.getTotalSeat() + "</td>");

                out.println("<td>");
                out.println("<a class='btn edit' href='BusServlet?action=edit&busID=" + bus.getID() + "'>Edit</a>");
                out.println("<a class='btn delete' href='BusServlet?action=delete&id=" + bus.getID() + "' onclick='return confirmDelete()'>Delete</a>");
                out.println("</td>");

                out.println("</tr>");
            }

        %>


    </table>


    <script>
        function confirmDelete() {
            return confirm("Are you sure you want to delete this bus?");
        }
    </script>
</body>
</html>
