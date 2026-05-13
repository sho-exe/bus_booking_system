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
//        String sql = "SELECT * FROM Trip WHERE origin LIKE ? OR destination LIKE ?";
        String sql = "SELECT * FROM Trip WHERE origin = ? AND destination = ? ";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, origin);
            ps.setString(2, destination);

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

//    JUST TO TEST
//
//    public static void main(String[] args) {
//        TripDAO dao = new TripDAO();
//        List<Trip> trips = dao.searchTrips("1", "2", "3");
//
//        
//        
//        
//        for (Trip t : trips) {
//            System.out.println(
//                    t.getTripId() + " | "
//                    + t.getOrigin() + " | "
//                    + t.getDestination() + " | "
//                    + t.getDepartureTime() + " | "
//                    + t.getArrivalTime() + " | "
//                    + t.getPrice() + " | "
//                    + t.getBusId() + " | "
//                    + t.getDriverId()
//            );
//        }
//    }
}
