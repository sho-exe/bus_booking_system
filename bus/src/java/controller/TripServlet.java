package controller;

import dao.TripDAO;
import model.Trip;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class TripServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            listTrips(request, response);
        } else if (action.equals("search")) {
            searchTrips(request, response);
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
        String keyword = request.getParameter("keyword");
        List<Trip> trips = new TripDAO().searchTrips(keyword);
        request.setAttribute("trips", trips);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/Booking.jsp").forward(request, response);
    }
}
