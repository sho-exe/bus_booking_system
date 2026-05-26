package controller;

import dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import model.User;

public class LoginServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = dao.login(username, password);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("username", user.getUsername());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("phoneNumber", user.getPhoneNumber());
            session.setAttribute("passengerId", user.getId());
            


            if ("System Admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("BusServlet?action=list");
            } else {
                response.sendRedirect("Booking.jsp");
            }

        } else {
            response.sendRedirect("login.html?error=1");
        }
    }
}