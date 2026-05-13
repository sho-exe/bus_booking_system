/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BusDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.Bus;


/**
 *
 * @author sho
 */
public class BusServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private BusDAO busDAO;
    
    public void init() {
        busDAO = new BusDAO();
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BusServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BusServlet at " + request.getContextPath() + "</h1>");
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
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        System.out.println(action);

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "insert":
                insertBus(request, response);
                System.out.println("Inserting");
                break;
            case "delete":
                deleteBus(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "update":
                updateBus(request, response);
                break;
            default:
                listBus(request, response);
                break;
        }
    }

    private void listBus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArrayList<Bus> listBus = busDAO.selectAllBuses();
        request.setAttribute("listBus", listBus);
        request.getRequestDispatcher("busList.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("busForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("busID"));
            Bus existingBus = busDAO.selectBus(id);
            request.setAttribute("bus", existingBus);

        } catch (Exception e) {
            System.out.println(e);
        }

        request.getRequestDispatcher("busForm.jsp").forward(request, response);
    }

    private void insertBus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String busNumber = request.getParameter("busNumber");
        String busType = request.getParameter("busType");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
        System.out.println(busType);

        Bus newBus = new Bus(busNumber, busType, totalSeat);
        busDAO.insertBus(newBus);
        response.sendRedirect("BusServlet?action=list");
    }

    private void updateBus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int busID = Integer.parseInt(request.getParameter("busID"));
        String busNumber = request.getParameter("busNumber");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
        String busType = request.getParameter("busType");

        Bus bus = new Bus(busID, busNumber, busType, totalSeat);
        busDAO.updateBus(bus);
        response.sendRedirect("BusServlet?action=list");
    }

    private void deleteBus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            busDAO.deleteBus(Integer.parseInt(request.getParameter("id")));
        } catch (Exception e) {
            System.out.println(e);
        }

        response.sendRedirect("BusServlet?action=list");
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
        doGet(request, response);
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

