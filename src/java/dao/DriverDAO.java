/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Driver;
import model.TripDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Asus
 */
public class DriverDAO {

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

    public static void main(String[] args) {
        DriverDAO dao = new DriverDAO();
        try (Connection conn = dao.getConnection()) {
            if (conn != null) {
                System.out.println("SUCCESS: Connected to the database!");
                System.out.println("Database Name: " + conn.getMetaData().getDatabaseProductName());
                System.out.println("Driver Version: " + conn.getMetaData().getDriverVersion());
            } else {
                System.out.println("FAILED: Connection is null.");
            }
        } catch (SQLException e) {
            System.err.println("ERROR: Connection failed! Check your URL, Username, or Password.");
            System.err.println("Message: " + e.getMessage());
        }

    }

    public List<TripDetail> getDriverTrips(int driverId) {
        List<TripDetail> trips = new ArrayList<>();

        
        String sql = "SELECT DATE(t.departure_time) AS trip_date, t.origin, t.destination, "
                + "TIME(t.departure_time) AS departure_time, TIME(t.arrival_time) AS arrival_time, "
                + "b.bus_id AS busID, b.bus_number AS busNumber, b.bus_type AS busType, b.total_seats AS totalSeat, COUNT(bk.booking_id) AS booked_seats "
                + "FROM trip t JOIN bus b ON t.bus_id = b.bus_id "
                + "LEFT JOIN booking bk ON t.trip_id = bk.trip_id AND bk.status = 'Confirmed' "
                + "WHERE t.driver_id = ? "
                + "GROUP BY t.trip_id ORDER BY t.departure_time";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                TripDetail trip = new TripDetail();
                trip.setTripDate(rs.getDate("trip_date"));
                trip.setOrigin(rs.getString("origin"));
                trip.setDestination(rs.getString("destination"));
                trip.setDepartureTime(rs.getTime("departure_time"));
                trip.setArrivalTime(rs.getTime("arrival_time"));
                trip.setBusId(rs.getString("busID"));
                trip.setPlateNumber(rs.getString("busNumber"));
                trip.setBusType(rs.getString("busType"));
                trip.setTotalSeats(rs.getInt("totalSeat"));
                trip.setBookedSeats(rs.getInt("booked_seats")); // Count of confirmed bookings
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    /**
     * Updates the driver's contact and personal information from the Profile
     * tab.
     */
    public boolean updateDriverProfile(Driver driver) {
        // Updated to target the correct table and columns based on your DB screenshot
        String sql = "UPDATE driver SET name = ?, license_number = ?, phone_number = ? WHERE driver_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, driver.getName());
            ps.setString(2, driver.getLicenseNumber());
            ps.setString(3, driver.getPhone());
            ps.setInt(4, driver.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Driver getDriverByName(String name) {
        String sql = "SELECT * FROM driver WHERE LOWER(name) = LOWER(?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Driver d = new Driver();
                d.setId(rs.getInt("driver_id"));
                d.setName(rs.getString("name"));
                d.setLicenseNumber(rs.getString("license_number"));
                d.setPhone(rs.getString("phone_number"));
                return d;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
