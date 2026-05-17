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
import java.sql.Statement;

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

    public int addPassenger(Connection conn, Booking booking) throws SQLException {
        String insertPassengerSql = "INSERT INTO Passenger (name, age) VALUES (?, ?)";
        try (PreparedStatement passengerStmt = conn.prepareStatement(insertPassengerSql,
                Statement.RETURN_GENERATED_KEYS)) {
            passengerStmt.setString(1, booking.getPassengerName());
            passengerStmt.setString(2, booking.getPassengerPhone());
            passengerStmt.executeUpdate();

            ResultSet rs = passengerStmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            } else {
                throw new SQLException("Failed to retrieve passenger ID.");
            }
        }
    }

    public boolean addBooking(Booking booking) {
        String insertBookingSql = "INSERT INTO Booking (passenger_id, trip_id, staff_id, seat) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            System.out.println("Inserting passenger: " + booking.getPassengerName() + ", " + booking.getPassengerPhone());
            int passengerId = addPassenger(conn, booking);
            System.out.println("Passenger inserted, ID: " + passengerId);

            System.out.println("Inserting booking: passenger_id=" + passengerId + ", trip_id=" + booking.getTripId()
                    + ", seat=" + booking.getSeatNumber());
            try (PreparedStatement bookingStmt = conn.prepareStatement(insertBookingSql)) {
                bookingStmt.setInt(1, passengerId);
                bookingStmt.setInt(2, booking.getTripId());
                bookingStmt.setInt(3, 0);
                bookingStmt.setInt(4, booking.getSeatNumber());
                bookingStmt.executeUpdate();
            }
            System.out.println("Booking inserted successfully.");

            conn.commit();
            return true;

        } catch (SQLException e) {
            System.out.println("SQL Error: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
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

    public List<Booking> getBookingsByUser(String username) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE username = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking b = new Booking(
                        rs.getInt("booking_id"),
                        rs.getTimestamp("booking_date"),
                        rs.getString("status"),
                        rs.getString("passenger_name"),
                        rs.getString("passenger_phone"),
                        rs.getInt("trip_id"),
                        rs.getInt("seat_number"),
                        rs.getString("username"),
                        rs.getDouble("price"));
                bookings.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM booking ORDER BY booking_date DESC";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Booking b = new Booking(
                        rs.getInt("booking_id"),
                        rs.getTimestamp("booking_date"),
                        rs.getString("status"),
                        rs.getString("passenger_name"),
                        rs.getString("passenger_phone"),
                        rs.getInt("trip_id"),
                        rs.getInt("seat_number"),
                        rs.getString("username"),
                        rs.getDouble("price"));
                bookings.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}
