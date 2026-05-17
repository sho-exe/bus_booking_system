/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Booking;

public class BookingDAO {

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

    public boolean addBooking(Booking booking) {
        String sql = "INSERT INTO Booking (passenger_id, trip_id, user_id, seat) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, booking.getPassengerId());
            stmt.setInt(2, booking.getTripId());
            stmt.setInt(3, booking.getUserId());
            stmt.setInt(4, booking.getSeat());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> getBookedSeatsByTrip(int tripId) {
        List<Integer> bookedSeats = new ArrayList<>();
        String sql = "SELECT seat_number FROM booking WHERE trip_id = ? AND status = 'Confirmed'";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, tripId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                bookedSeats.add(rs.getInt("seat_number"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedSeats;
    }

    public List<Booking> getBookingsByUser(String passengerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT booking_id, booking_date, status, passenger_id, trip_id, staff_id, seat FROM Booking WHERE passenger_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, passengerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking b = new Booking(
                        rs.getInt("booking_id"),
                        rs.getTimestamp("booking_date"),
                        rs.getString("status"),
                        rs.getInt("passenger_id"),
                        rs.getInt("trip_id"),
                        rs.getInt("staff_id"),
                        rs.getInt("seat"));
                bookings.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT booking_id, booking_date, status, passenger_id, trip_id, staff_id, seat FROM Booking ORDER BY booking_date DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking b = new Booking(
                        rs.getInt("booking_id"),
                        rs.getTimestamp("booking_date"),
                        rs.getString("status"),
                        rs.getInt("passenger_id"),
                        rs.getInt("trip_id"),
                        rs.getInt("staff_id"),
                        rs.getInt("seat"));
                bookings.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
