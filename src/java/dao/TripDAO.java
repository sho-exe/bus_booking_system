package dao;

import model.Trip;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TripDAO {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/bus";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    private Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    

    private Trip mapRow(ResultSet rs) throws SQLException {
        return new Trip(
                rs.getInt("trip_id"),
                rs.getString("origin"),
                rs.getString("destination"),
                rs.getString("departure_time"),
                rs.getString("arrival_time"),
                rs.getDouble("price"),
                rs.getInt("bus_id"),
                rs.getInt("driver_id")
        );
    }

    public List<Trip> getAllTrips() {
        List<Trip> list = new ArrayList<>();
        String sql = "SELECT * FROM Trip";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Trip> searchTrips(String origin, String destination, String departure_time) {
        List<Trip> list = new ArrayList<>();

        // 1. Use t.* to get all Trip columns so mapRow doesn't crash
        String sql = "SELECT t.* "
                + "FROM Trip t "
                + "WHERE t.origin LIKE ? "
                + "AND t.destination LIKE ? "
                + "AND DATE(t.departure_time) = ?";

        // 2. Use try-with-resources to ensure the connection ALWAYS closes
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + origin + "%");
            ps.setString(2, "%" + destination + "%");
            ps.setString(3, departure_time);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Now mapRow gets all the trip data it expects + the extra bus data
                    list.add(mapRow(rs));
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            // This will print the error to your console
            e.printStackTrace();
        }

        return list;
    }

    public Trip getTripById(int id) {
        Trip trip = null;
        String sql = "SELECT * FROM trip WHERE trip_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    trip = new Trip();
                    trip.setTripId(rs.getInt("trip_id"));
                    trip.setOrigin(rs.getString("origin"));
                    trip.setDestination(rs.getString("destination"));
                    trip.setDepartureTime(rs.getString("departure_time"));
                    trip.setArrivalTime(rs.getString("arrival_time"));
                    trip.setPrice(rs.getDouble("price"));
                    trip.setBusId(rs.getInt("bus_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return trip;
    }

    public void addTrip(Trip trip) {
        String sql = "INSERT INTO trip (origin, destination, departure_time, arrival_time, bus_id, price) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trip.getOrigin());
            ps.setString(2, trip.getDestination());
            ps.setString(3, trip.getDepartureTime());
            ps.setString(4, trip.getArrivalTime());
            ps.setInt(5, trip.getBusId());
            ps.setDouble(6, trip.getPrice());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateTrip(Trip trip) {
        String sql = "UPDATE trip SET origin=?, destination=?, "
                + "departure_time=?, arrival_time=?, bus_id=?, price=? "
                + "WHERE trip_id=?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trip.getOrigin());
            ps.setString(2, trip.getDestination());
            ps.setString(3, trip.getDepartureTime());
            ps.setString(4, trip.getArrivalTime());
            ps.setInt(5, trip.getBusId());
            ps.setDouble(6, trip.getPrice());
            ps.setInt(7, trip.getTripId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteTrip(int id) {
        String sql = "DELETE FROM trip WHERE trip_id=?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<String> getDistinctOrigins() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT origin FROM trip WHERE origin IS NOT NULL AND origin != '' ORDER BY origin ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("origin"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getDistinctDestinations() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT destination FROM trip WHERE destination IS NOT NULL AND destination != '' ORDER BY destination ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("destination"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
