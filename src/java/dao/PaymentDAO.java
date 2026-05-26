package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Payment;

public class PaymentDAO {

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

    public boolean insertPayment(Payment payment) throws SQLException {

        boolean success = false;

        try {
            Connection conn = getConnection();

            String sql
                    = "INSERT INTO payment "
                    + "(booking_id, amount, bank, transaction_id, bill_code, buyer_email, buyer_name, status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, payment.getBookingId()); 
            ps.setDouble(2, payment.getAmount()); //
            ps.setString(3, payment.getBank()); //
            ps.setString(4, payment.getTransactionId()); //
            ps.setString(5, payment.getBillCode()); //
            ps.setString(6, payment.getBuyerEmail()); //
            ps.setString(7, payment.getBuyerName()); //
            ps.setString(8, payment.getStatus()); //

            success = ps.executeUpdate() > 0;

            ps.close();
            conn.close();

        } catch (SQLException e) {
            e.getMessage();
        }

        return success;
    }
}
