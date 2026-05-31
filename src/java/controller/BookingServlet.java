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

        String origin       = request.getParameter("origin");
        String destination  = request.getParameter("destination");
        String departure_date = request.getParameter("trip_date");
        String return_date  = request.getParameter("return_date");

        // ── Outbound trips ──────────────────────────────────────────
        List<Trip> trips = new TripDAO().searchTrips(origin, destination, departure_date);
        request.setAttribute("trips", trips);

        List<Bus> busList = new ArrayList<>();
        for (Trip t : trips) {
            Bus b = new BusDAO().selectBus(t.getBusId());
            busList.add(b);
        }
        request.setAttribute("busList", busList);

        // ── Return trips (only if return_date was provided) ─────────
        if (return_date != null && !return_date.trim().isEmpty()) {
            // Swap origin <-> destination for the return leg
            List<Trip> returnTrips = new TripDAO().searchTrips(destination, origin, return_date);
            request.setAttribute("returnTrips", returnTrips);

            List<Bus> returnBusList = new ArrayList<>();
            for (Trip t : returnTrips) {
                Bus b = new BusDAO().selectBus(t.getBusId());
                returnBusList.add(b);
            }
            request.setAttribute("returnBusList", returnBusList);
            request.setAttribute("returnDate", return_date);
        }

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
                String userIdStr = (String) request.getSession().getAttribute("passengerId");
                int userId = (userIdStr != null) ? Integer.parseInt(userIdStr) : 0;

                dao.BookingDAO bookingDAO = new dao.BookingDAO();

                for (int i = 0; i < seats.length; i++) {
                    model.Booking b = new model.Booking();
                    b.setSeat(Integer.parseInt(seats[i]));
                    b.setTripId(tripId);

                    // b.setPassengerId(passengerId);
                    // b.setUserId(0);

                    b.setPassengerId(userId); // passenger_id = logged-in user id
                    b.setUserId(userId); // user_id = logged-in user id

                    bookingDAO.addBooking(b);
                }
            }

            // ── After outbound booking: redirect to return trip seat selection if round-trip ──
            String returnTripId   = request.getParameter("return_trip_id");
            String returnBusId    = request.getParameter("return_bus_id");
            String returnOrigin   = request.getParameter("return_origin");
            String returnDest     = request.getParameter("return_destination");
            String returnDate     = request.getParameter("return_date");
            String returnPrice    = request.getParameter("return_price");

            if (returnTripId != null && !returnTripId.isEmpty()) {
                // Clear return trip from session so it doesn't persist into future bookings
                request.getSession().removeAttribute("return_trip_id");

                // Redirect to SelectSeat.jsp pre-filled with the return trip details
                int reqSeats = (seats != null) ? seats.length : 0;
                String redirectUrl = "SelectSeat.jsp"
                        + "?trip_id="     + returnTripId
                        + "&bus_id="      + returnBusId
                        + "&origin="      + java.net.URLEncoder.encode(returnOrigin, "UTF-8")
                        + "&destination=" + java.net.URLEncoder.encode(returnDest,   "UTF-8")
                        + "&trip_date="   + java.net.URLEncoder.encode(returnDate,   "UTF-8")
                        + "&price="       + returnPrice
                        + "&is_return=true"
                        + "&req_seats="   + reqSeats;
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect("customer.jsp");
            }
        } else {
            response.sendRedirect("Booking.jsp");
        }
    }
}
