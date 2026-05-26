/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Bus;

/**
 *
 * @author Asus
 */
public class BusDAO {

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

    public void insertBus(Bus bus) {
        String sql = "INSERT INTO Bus (bus_number, bus_type, total_seats, roadtax, insurance, expiry_date) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setInt(3, bus.getTotalSeat());
            stmt.setString(4, bus.getRoadtax());
            stmt.setString(5, bus.getInsurance());
            stmt.setString(6, bus.getExpiryDate());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Bus> selectAllBuses() {
        ArrayList<Bus> buses = new ArrayList<>();
        String sql = "SELECT * FROM Bus";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                buses.add(new Bus(
                        rs.getInt("bus_id"),
                        rs.getString("bus_number"),
                        rs.getString("bus_type"),
                        rs.getInt("total_seats"),
                        rs.getString("roadtax"),
                        rs.getString("insurance"),
                        rs.getString("expiry_date")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return buses;
    }

    public Bus selectBus(int id) {
        Bus bus = null;
        String sql = "SELECT * FROM Bus WHERE bus_id = ?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                bus = new Bus(
                        rs.getInt("bus_id"),
                        rs.getString("bus_number"),
                        rs.getString("bus_type"),
                        rs.getInt("total_seats"),
                        rs.getString("roadtax"),
                        rs.getString("insurance"),
                        rs.getString("expiry_date")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bus;
    }

    public boolean updateBus(Bus bus) {
        boolean rowUpdated = false;
        String sql = "UPDATE Bus SET bus_Number=?, bus_type=?, total_seats=?, roadtax=?, insurance=?, expiry_date=? WHERE bus_id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bus.getBusNumber());
            stmt.setString(2, bus.getBusType());
            stmt.setInt(3, bus.getTotalSeat());
            stmt.setString(4, bus.getRoadtax());
            stmt.setString(5, bus.getInsurance());
            stmt.setString(6, bus.getExpiryDate());
            stmt.setInt(7, bus.getBusId());
            rowUpdated = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public boolean deleteBus(int id) {
        boolean rowDeleted = false;
        String sql = "DELETE FROM Bus WHERE bus_id=?";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            rowDeleted = stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowDeleted;
    }

}
