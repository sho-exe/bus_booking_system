package controller;

import dao.BusDAO;
import dao.TripDAO;
import model.Trip;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Bus;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        if (action.equals("search")) {
            searchTrips(request, response);
        } else if (action.equals("adminList")) {
            dao.BookingDAO bookingDAO = new dao.BookingDAO();
            request.setAttribute("bookings", bookingDAO.getAllBookings());
            request.setAttribute("activeTab", "bookings");
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/Booking.jsp").forward(request, response);
        }
    }

    private void searchTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departure_date = request.getParameter("trip_date");

        // Get data from Trip Table
        List<Trip> trips = new TripDAO().searchTrips(origin, destination, departure_date);
        request.setAttribute("trips", trips);

        List<Bus> busList = new ArrayList<>();
        // Get data from Bus Table
        for (Trip t : trips) {
            Bus b = new BusDAO().selectBus(t.getBusId());
            busList.add(b);
        }
        request.setAttribute("busList", busList);

        request.getRequestDispatcher("/Booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            String[] seats = request.getParameterValues("seat_number");
            String[] names = request.getParameterValues("passenger_name");
            String[] phones = request.getParameterValues("passenger_phone");
            String tripIdStr = request.getParameter("trip_id");

            if (tripIdStr != null && !tripIdStr.isEmpty() && seats != null) {
                int tripId = Integer.parseInt(tripIdStr);
                String passengerIdStr = (String) request.getSession().getAttribute("passengerId");
                int passengerId = (passengerIdStr != null) ? Integer.parseInt(passengerIdStr) : 0;

                dao.BookingDAO bookingDAO = new dao.BookingDAO();

                for (int i = 0; i < seats.length; i++) {
                    model.Booking b = new model.Booking();
                    b.setSeat(Integer.parseInt(seats[i]));
                    b.setTripId(tripId);
                    b.setPassengerId(passengerId);
                    b.setUserId(0);

                    bookingDAO.addBooking(b);
                }
            }

            response.sendRedirect("customer.jsp");
        } else {
            response.sendRedirect("Booking.jsp");
        }
    }
}
