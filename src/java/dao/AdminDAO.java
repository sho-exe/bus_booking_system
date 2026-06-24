/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import model.Driver;
import model.TripDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Asus
 */
public class AdminDAO {

    private String jdbcURL = "jdbc:mysql://localhost:3306/bus";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

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
        BusDAO dao = new BusDAO();
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

    // 1. Fetch all trips and their assigned drivers
    public List<TripDetail> getAllTripsWithDrivers() {
        List<TripDetail> trips = new ArrayList<>();
        String sql = "SELECT t.trip_id, t.origin, t.destination, t.departure_time, "
                + "b.bus_number, d.driver_id, d.name AS driver_name, d.license_number AS driver_license "
                + "FROM trip t "
                + "JOIN bus b ON t.bus_id = b.bus_id "
                + "LEFT JOIN driver d ON t.driver_id = d.driver_id "
                + "ORDER BY t.departure_time DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TripDetail trip = new TripDetail();
                trip.setTripId(rs.getInt("trip_id")); // Make sure you have this in your model!
                trip.setOrigin(rs.getString("origin"));
                trip.setDestination(rs.getString("destination"));
                trip.setDepartureTime(rs.getTime("departure_time"));
                trip.setPlateNumber(rs.getString("bus_number"));
                trip.setDriverId(rs.getInt("driver_id")); // Will be 0 if NULL
                trip.setDriverName(rs.getString("driver_name")); // Will be null if no driver
                trip.setLicenseNumber(rs.getString("driver_license")); // Will be null if no driver
                trips.add(trip);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trips;
    }

    // 2. Assign or reassign a driver to a trip
    public boolean assignDriverToTrip(int tripId, int driverId) {
        String sql = "UPDATE trip SET driver_id = ? WHERE trip_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ps.setInt(2, tripId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 3. Fetch all drivers (to populate the dropdown menu in the JSP)
    public List<Driver> getAllDrivers() {
        List<Driver> drivers = new ArrayList<>();
        String sql = "SELECT * FROM driver";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Driver d = new Driver();
                d.setId(rs.getInt("driver_id"));
                d.setName(rs.getString("name"));
                drivers.add(d);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return drivers;
    }

}
