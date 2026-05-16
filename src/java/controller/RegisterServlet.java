package controller;

import dao.UserDAO;
import model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private UserDAO userDao;

    public void init() {
        userDao = new UserDAO(); // Initialize the DAO once
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 1. Pack data into a Model
        User newUser = new User(username, email, password, "customer");

        // 2. Send Model to DAO
        boolean isRegistered = userDao.register(newUser);

        // 3. Route the user based on the result
        if (isRegistered) {
            response.sendRedirect("login.html");
        } else {
            response.sendRedirect("register.html?error=1");
        }
    }
}