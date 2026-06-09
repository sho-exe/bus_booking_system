package controller;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ReceiptPDFServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/bus";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdParam = request.getParameter("booking_id");

        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            showTextError(response, "Booking ID is missing.");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam.trim());
        } catch (NumberFormatException e) {
            showTextError(response, "Invalid booking ID.");
            return;
        }

        String sql =
            "SELECT b.booking_id, b.booking_date, b.status AS booking_status, b.seat, " +
            "p.name AS passenger_name, p.age AS passenger_age, " +
            "t.origin, t.destination, t.departure_time, t.arrival_time, t.price, " +
            "pay.status AS payment_status, pay.transaction_id, pay.bill_code, pay.amount, pay.bank, pay.created_at AS payment_date " +
            "FROM booking b " +
            "LEFT JOIN passenger p ON b.passenger_id = p.passenger_id " +
            "LEFT JOIN trip t ON b.trip_id = t.trip_id " +
            "LEFT JOIN payment pay ON b.booking_id = pay.booking_id " +
            "WHERE b.booking_id = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, bookingId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        showTextError(response, "No booking found for Booking ID: " + bookingId);
                        return;
                    }

                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=receipt-" + bookingId + ".pdf");

                    Document document = new Document();
                    PdfWriter.getInstance(document, response.getOutputStream());
                    document.open();

                    Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 20);
                    Font subtitleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);
                    Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 11);
                    Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11);

                    Paragraph title = new Paragraph("SANI EXPRESS", titleFont);
                    title.setAlignment(Element.ALIGN_CENTER);
                    document.add(title);

                    Paragraph subtitle = new Paragraph("Official Booking Receipt", subtitleFont);
                    subtitle.setAlignment(Element.ALIGN_CENTER);
                    subtitle.setSpacingAfter(20);
                    document.add(subtitle);

                    PdfPTable table = new PdfPTable(2);
                    table.setWidthPercentage(100);
                    table.setWidths(new float[]{35, 65});

                    addRow(table, "Booking ID", rs.getString("booking_id"), boldFont, normalFont);
                    addRow(table, "Booking Date", rs.getString("booking_date"), boldFont, normalFont);
                    addRow(table, "Booking Status", rs.getString("booking_status"), boldFont, normalFont);
                    addRow(table, "Passenger Name", rs.getString("passenger_name"), boldFont, normalFont);
                    addRow(table, "Passenger Age", rs.getString("passenger_age"), boldFont, normalFont);
                    addRow(table, "Seat Number", rs.getString("seat"), boldFont, normalFont);
                    addRow(table, "Route", rs.getString("origin") + " to " + rs.getString("destination"), boldFont, normalFont);
                    addRow(table, "Departure", rs.getString("departure_time"), boldFont, normalFont);
                    addRow(table, "Arrival", rs.getString("arrival_time"), boldFont, normalFont);
                    addRow(table, "Ticket Price", "RM " + rs.getString("price"), boldFont, normalFont);
                    addRow(table, "Payment Status", nullToDash(rs.getString("payment_status")), boldFont, normalFont);
                    addRow(table, "Bank", nullToDash(rs.getString("bank")), boldFont, normalFont);
                    addRow(table, "Transaction ID", nullToDash(rs.getString("transaction_id")), boldFont, normalFont);
                    addRow(table, "Bill Code", nullToDash(rs.getString("bill_code")), boldFont, normalFont);
                    addRow(table, "Amount Paid", rs.getString("amount") != null ? "RM " + rs.getString("amount") : "-", boldFont, normalFont);
                    addRow(table, "Payment Date", nullToDash(rs.getString("payment_date")), boldFont, normalFont);

                    document.add(table);

                    Paragraph thanks = new Paragraph("\nThank you for choosing Sani Express.", normalFont);
                    thanks.setAlignment(Element.ALIGN_CENTER);
                    thanks.setSpacingBefore(20);
                    document.add(thanks);

                    document.close();
                }
            }
        } catch (Exception e) {
            if (!response.isCommitted()) {
                showTextError(response, "Receipt PDF error: " + e.getMessage());
            } else {
                throw new ServletException(e);
            }
        }
    }

    private static String nullToDash(String value) {
        return value == null || value.trim().isEmpty() ? "-" : value;
    }

    private static void showTextError(HttpServletResponse response, String message) throws IOException {
        response.reset();
        response.setContentType("text/plain;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println(message);
        }
    }

    private void addRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        PdfPCell valueCell = new PdfPCell(new Phrase(value != null ? value : "-", valueFont));
        labelCell.setPadding(8);
        valueCell.setPadding(8);
        table.addCell(labelCell);
        table.addCell(valueCell);
    }
}
