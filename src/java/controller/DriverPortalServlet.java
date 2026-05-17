/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DriverDAO;
import model.Driver;
import model.TripDetail;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Asus
 */
@WebServlet("/DriverPortal")
public class DriverPortalServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DriverDAO driverDAO;

    public void init() {
        driverDAO = new DriverDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet DriverPortalServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DriverPortalServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Driver loggedInDriver = (Driver) session.getAttribute("driver");

        // Failsafe: If driver is not logged in, redirect to login page (mocking for now)
        if (loggedInDriver == null) {
            // For testing purposes, let's create a mock logged-in driver based on your DB insert
            loggedInDriver = new Driver(1, "Ahmad bin Hassan", "ahmad@saniexpress.com", "012-3456789");
            session.setAttribute("driver", loggedInDriver);
            // In a real app, you would do: response.sendRedirect("login.jsp"); return;
        }

        // 1. Get data from Database via DAO
        List<TripDetail> trips = driverDAO.getDriverTrips(loggedInDriver.getId());

        // 2. Calculate summary statistics for the cards
        int assignedCount = trips.size();
        int upcomingCount = 0;

        // Count how many trips are strictly in the future (simple logic)
        long currentTime = System.currentTimeMillis();
        for (TripDetail trip : trips) {
            if (trip.getTripDate().getTime() > currentTime) {
                upcomingCount++;
            }
        }

        // 3. Attach data to the request so the JSP can read it using ${...}
        request.setAttribute("tripList", trips);
        request.setAttribute("assignedCount", assignedCount);
        request.setAttribute("upcomingCount", upcomingCount);

        // 4. Forward the request to the JSP View
        request.getRequestDispatcher("driver_portal.jsp").forward(request, response);

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
