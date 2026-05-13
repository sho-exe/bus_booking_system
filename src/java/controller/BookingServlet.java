package controller;

import dao.TripDAO;
import model.Trip;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") != null ? request.getParameter("action") : "";

        if (action.equals("search")) {
            searchTrips(request, response);
        } else {
            request.getRequestDispatcher("/Booking.jsp").forward(request, response);
        }
    }

    private void listTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Trip> trips = new TripDAO().getAllTrips();
        request.setAttribute("trips", trips);
        request.getRequestDispatcher("/Booking.jsp").forward(request, response);
    }

    private void searchTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departure_date = request.getParameter("departure_date");

        List<Trip> trips = new TripDAO().searchTrips(origin, destination, departure_date);
        request.setAttribute("trips", trips);
//        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/Booking.jsp").forward(request, response);
    }
}
