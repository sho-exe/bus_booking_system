package dao;

import java.sql.*;
import model.User;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO {

    private String jdbcURL = "jdbc:mysql://localhost:3307/bus";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    // Method untuk mendapatkan sambungan Database
    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    public boolean register(User user) {

        UserDAO dao = new UserDAO();

        String sql = "INSERT INTO users(username,email,password,role) VALUES(?,?,?,?)";

        try (Connection conn = dao.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User login(String usernameOrEmail, String password) {

        UserDAO dao = new UserDAO();

        String sql = "SELECT * FROM users WHERE (username=? OR email=?) AND password=?";

        try (Connection conn = dao.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("phone_number"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getAllUsers() {

        UserDAO dao = new UserDAO();

        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";

        // Declare Connection, PreparedStatement, and ResultSet in the
        // try-with-resources block
        try (Connection conn = dao.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) { // Executing the query gives you the ResultSet

            while (rs.next()) {
                User user = new User(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("phone_number"));

                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean updateProfile(String username, String email, String phone) {
        String sql = "UPDATE users SET email = ?, phone_number = ? WHERE username = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, phone);
            ps.setString(3, username);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
