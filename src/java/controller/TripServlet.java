package controller;

import dao.BusDAO;
import dao.TripDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Bus;
import model.Trip;

@WebServlet(name = "TripServlet", urlPatterns = {"/TripServlet"})
public class TripServlet extends HttpServlet {

    private TripDAO tripDAO;
    private BusDAO busDAO;

    @Override
    public void init() {
        tripDAO = new TripDAO();
        busDAO = new BusDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteTrip(request, response);
                break;
            case "list":
            default:
                listTrips(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "insert":
                insertTrip(request, response);
                break;
            case "update":
                updateTrip(request, response);
                break;
            default:
                listTrips(request, response);
                break;
        }
    }

    private void listTrips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Trip> listTrips = tripDAO.getAllTrips();
        request.setAttribute("trips", listTrips);
        request.setAttribute("activeTab", "trips");
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Bus> busTypes = busDAO.selectAllBuses();
        request.setAttribute("busTypes", busTypes);
        RequestDispatcher dispatcher = request.getRequestDispatcher("trip-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Trip existingTrip = tripDAO.getTripById(id);
        
        if (existingTrip != null) {
            if (existingTrip.getDepartureTime() != null) {
                existingTrip.setDepartureTime(existingTrip.getDepartureTime().replace(" ", "T"));
            }
            if (existingTrip.getArrivalTime() != null) {
                existingTrip.setArrivalTime(existingTrip.getArrivalTime().replace(" ", "T"));
            }
        }
        
        List<Bus> busTypes = busDAO.selectAllBuses();
        
        request.setAttribute("trip", existingTrip);
        request.setAttribute("busTypes", busTypes);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("trip-edit.jsp");
        dispatcher.forward(request, response);
    }

    private void insertTrip(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        
        if (departureTime != null) departureTime = departureTime.replace("T", " ");
        if (arrivalTime != null) arrivalTime = arrivalTime.replace("T", " ");
        
        int busId = Integer.parseInt(request.getParameter("busId"));
        double price = Double.parseDouble(request.getParameter("price"));

        Trip newTrip = new Trip();
        newTrip.setOrigin(origin);
        newTrip.setDestination(destination);
        newTrip.setDepartureTime(departureTime);
        newTrip.setArrivalTime(arrivalTime);
        newTrip.setBusId(busId);
        newTrip.setPrice(price);

        tripDAO.addTrip(newTrip);
        response.sendRedirect("TripServlet?action=list");
    }

    private void updateTrip(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("trip_id"));
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String departureTime = request.getParameter("departureTime");
        String arrivalTime = request.getParameter("arrivalTime");
        
        if (departureTime != null) departureTime = departureTime.replace("T", " ");
        if (arrivalTime != null) arrivalTime = arrivalTime.replace("T", " ");
        
        int busId = Integer.parseInt(request.getParameter("busId"));
        double price = Double.parseDouble(request.getParameter("price"));

        Trip trip = new Trip();
        trip.setTripId(id);
        trip.setOrigin(origin);
        trip.setDestination(destination);
        trip.setDepartureTime(departureTime);
        trip.setArrivalTime(arrivalTime);
        trip.setBusId(busId);
        trip.setPrice(price);

        tripDAO.updateTrip(trip);
        response.sendRedirect("TripServlet?action=list");
    }

    private void deleteTrip(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        tripDAO.deleteTrip(id);
        response.sendRedirect("TripServlet?action=list");
    }
}
