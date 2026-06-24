package controller;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import java.awt.Color;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
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

    private static final Color BRAND_RED = new Color(204, 37, 37);
    private static final Color DARK_TEXT = new Color(17, 24, 39);
    private static final Color MUTED_TEXT = new Color(107, 114, 128);
    private static final Color LIGHT_GREY = new Color(249, 250, 251);
    private static final Color BORDER_GREY = new Color(229, 231, 235);
    private static final Color SUCCESS_GREEN = new Color(22, 163, 74);
    private static final Color WARNING_ORANGE = new Color(217, 119, 6);

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
                "bus.bus_number, bus.bus_type, " +
                "pay.status AS payment_status, pay.transaction_id, pay.bill_code, " +
                "pay.amount, pay.bank, pay.created_at AS payment_date " +
                "FROM Booking b " +
                "LEFT JOIN Passenger p ON b.passenger_id = p.passenger_id " +
                "LEFT JOIN Trip t ON b.trip_id = t.trip_id " +
                "LEFT JOIN Bus bus ON t.bus_id = bus.bus_id " +
                "LEFT JOIN payment pay ON b.booking_id = pay.booking_id " +
                "WHERE b.booking_id = ? " +
                "ORDER BY pay.created_at DESC " +
                "LIMIT 1";

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

                    String formattedBookingId = formatBookingId(bookingId);
                    String ticketCode = createTicketCode(bookingId);
                    String pdfFileName = "SaniExpress_E-Ticket_Receipt_" + formattedBookingId + ".pdf";

                    response.setContentType("application/pdf");
                    response.setHeader("Content-Disposition", "attachment; filename=\"" + pdfFileName + "\"");
                    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");

                    Document document = new Document(PageSize.A4, 36, 36, 36, 36);
                    PdfWriter.getInstance(document, response.getOutputStream());

                    document.open();
                    document.addAuthor("Sani Express");
                    document.addTitle("Sani Express E-Ticket Receipt");

                    Font brandFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, Font.BOLD, BRAND_RED);
                    Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 15, Font.BOLD, DARK_TEXT);
                    Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Font.BOLD, DARK_TEXT);
                    Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Font.BOLD, MUTED_TEXT);
                    Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, DARK_TEXT);
                    Font valueBoldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD, DARK_TEXT);
                    Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, MUTED_TEXT);
                    Font whiteFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD, Color.WHITE);

                    addReceiptHeader(document, brandFont, titleFont, smallFont, formattedBookingId);
                    addStatusSummary(document, rs, whiteFont, smallFont);
                    addTicketSection(document, rs, sectionFont, labelFont, valueFont, valueBoldFont, ticketCode);
                    addPaymentSection(document, rs, sectionFont, labelFont, valueFont, valueBoldFont);
                    addFooterNote(document, smallFont);

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

    private void addReceiptHeader(Document document, Font brandFont, Font titleFont,
                                  Font smallFont, String formattedBookingId) throws Exception {

        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{65, 35});
        headerTable.setSpacingAfter(18);

        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        leftCell.setPadding(0);

        Paragraph brand = new Paragraph("SANI EXPRESS", brandFont);
        brand.setSpacingAfter(4);
        leftCell.addElement(brand);

        Paragraph subtitle = new Paragraph("Official E-Ticket & Payment Receipt", titleFont);
        subtitle.setSpacingAfter(4);
        leftCell.addElement(subtitle);

        Paragraph description = new Paragraph("Please present this e-ticket during boarding or verification.", smallFont);
        leftCell.addElement(description);

        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        rightCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        rightCell.setVerticalAlignment(Element.ALIGN_TOP);
        rightCell.setPadding(0);

        Paragraph receiptLabel = new Paragraph("RECEIPT NO.", smallFont);
        receiptLabel.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(receiptLabel);

        Paragraph receiptNo = new Paragraph(formattedBookingId, titleFont);
        receiptNo.setAlignment(Element.ALIGN_RIGHT);
        rightCell.addElement(receiptNo);

        headerTable.addCell(leftCell);
        headerTable.addCell(rightCell);

        document.add(headerTable);
    }

    private void addStatusSummary(Document document, ResultSet rs, Font whiteFont,
                                  Font smallFont) throws Exception {

        String bookingStatus = nullToDash(rs.getString("booking_status"));
        String paymentStatus = nullToDash(rs.getString("payment_status"));
        String seat = nullToDash(rs.getString("seat"));

        PdfPTable statusTable = new PdfPTable(3);
        statusTable.setWidthPercentage(100);
        statusTable.setWidths(new float[]{33, 33, 34});
        statusTable.setSpacingAfter(18);

        statusTable.addCell(statusBox("Booking Status", bookingStatus, getStatusColor(bookingStatus), whiteFont));
        statusTable.addCell(statusBox("Payment Status", paymentStatus, getStatusColor(paymentStatus), whiteFont));
        statusTable.addCell(statusBox("Seat Number", seat, BRAND_RED, whiteFont));

        document.add(statusTable);
    }

    private PdfPCell statusBox(String label, String value, Color backgroundColor, Font valueFont) {
        PdfPCell cell = new PdfPCell();
        cell.setBackgroundColor(backgroundColor);
        cell.setBorderColor(backgroundColor);
        cell.setPadding(12);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);

        Paragraph labelParagraph = new Paragraph(
                label.toUpperCase(),
                FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, Color.WHITE)
        );
        labelParagraph.setAlignment(Element.ALIGN_CENTER);
        labelParagraph.setSpacingAfter(4);

        Paragraph valueParagraph = new Paragraph(value, valueFont);
        valueParagraph.setAlignment(Element.ALIGN_CENTER);

        cell.addElement(labelParagraph);
        cell.addElement(valueParagraph);

        return cell;
    }

    private void addTicketSection(Document document, ResultSet rs, Font sectionFont,
                                  Font labelFont, Font valueFont, Font valueBoldFont,
                                  String ticketCode) throws Exception {

        addSectionTitle(document, "Passenger & Trip Details", sectionFont);

        PdfPTable mainTable = new PdfPTable(2);
        mainTable.setWidthPercentage(100);
        mainTable.setWidths(new float[]{65, 35});
        mainTable.setSpacingAfter(18);

        PdfPCell detailsCell = new PdfPCell();
        detailsCell.setBorderColor(BORDER_GREY);
        detailsCell.setPadding(12);
        detailsCell.setBackgroundColor(Color.WHITE);

        PdfPTable detailsTable = new PdfPTable(2);
        detailsTable.setWidthPercentage(100);
        detailsTable.setWidths(new float[]{36, 64});

        addDetailRow(detailsTable, "Booking ID", formatBookingId(rs.getInt("booking_id")), labelFont, valueBoldFont);
        addDetailRow(detailsTable, "Passenger Name", nullToDash(rs.getString("passenger_name")), labelFont, valueFont);
        addDetailRow(detailsTable, "Passenger Age", nullToDash(rs.getString("passenger_age")), labelFont, valueFont);
        addDetailRow(detailsTable, "Route", buildRoute(rs), labelFont, valueBoldFont);
        addDetailRow(detailsTable, "Departure", nullToDash(rs.getString("departure_time")), labelFont, valueFont);
        addDetailRow(detailsTable, "Arrival", nullToDash(rs.getString("arrival_time")), labelFont, valueFont);
        addDetailRow(detailsTable, "Bus Number", nullToDash(rs.getString("bus_number")), labelFont, valueFont);
        addDetailRow(detailsTable, "Bus Type", nullToDash(rs.getString("bus_type")), labelFont, valueFont);
        addDetailRow(detailsTable, "Ticket Price", formatCurrency(rs, "price"), labelFont, valueBoldFont);

        detailsCell.addElement(detailsTable);

        PdfPCell ticketCell = new PdfPCell();
        ticketCell.setBorderColor(BORDER_GREY);
        ticketCell.setPadding(14);
        ticketCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        ticketCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        ticketCell.setBackgroundColor(LIGHT_GREY);

        Paragraph ticketTitle = new Paragraph("E-TICKET CODE", sectionFont);
        ticketTitle.setAlignment(Element.ALIGN_CENTER);
        ticketTitle.setSpacingAfter(10);
        ticketCell.addElement(ticketTitle);

        Paragraph ticketCodeText = new Paragraph(
                ticketCode,
                FontFactory.getFont(FontFactory.COURIER_BOLD, 13, Font.BOLD, DARK_TEXT)
        );
        ticketCodeText.setAlignment(Element.ALIGN_CENTER);
        ticketCodeText.setSpacingAfter(10);
        ticketCell.addElement(ticketCodeText);

        Paragraph instruction = new Paragraph(
                "Show this ticket code to the staff during boarding.",
                FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, MUTED_TEXT)
        );
        instruction.setAlignment(Element.ALIGN_CENTER);
        ticketCell.addElement(instruction);

        mainTable.addCell(detailsCell);
        mainTable.addCell(ticketCell);

        document.add(mainTable);
    }

    private void addPaymentSection(Document document, ResultSet rs, Font sectionFont,
                                   Font labelFont, Font valueFont, Font valueBoldFont) throws Exception {

        addSectionTitle(document, "Payment Information", sectionFont);

        PdfPTable paymentTable = new PdfPTable(2);
        paymentTable.setWidthPercentage(100);
        paymentTable.setWidths(new float[]{35, 65});
        paymentTable.setSpacingAfter(16);

        addDetailRow(paymentTable, "Amount Paid", formatCurrency(rs, "amount"), labelFont, valueBoldFont);
        addDetailRow(paymentTable, "Payment Method", nullToDash(rs.getString("bank")), labelFont, valueFont);
        addDetailRow(paymentTable, "Transaction ID", nullToDash(rs.getString("transaction_id")), labelFont, valueFont);
        addDetailRow(paymentTable, "Bill Code", nullToDash(rs.getString("bill_code")), labelFont, valueFont);
        addDetailRow(paymentTable, "Payment Date", nullToDash(rs.getString("payment_date")), labelFont, valueFont);

        document.add(paymentTable);
    }

    private void addFooterNote(Document document, Font smallFont) throws Exception {
        PdfPTable footer = new PdfPTable(1);
        footer.setWidthPercentage(100);
        footer.setSpacingBefore(8);

        PdfPCell cell = new PdfPCell();
        cell.setBorderColor(BORDER_GREY);
        cell.setBackgroundColor(LIGHT_GREY);
        cell.setPadding(12);

        Paragraph note = new Paragraph(
                "Important: This receipt is computer-generated and does not require a signature. "
                + "The e-ticket is valid only when the booking status is Confirmed and the payment status is SUCCESS.",
                smallFont
        );
        note.setAlignment(Element.ALIGN_CENTER);

        Paragraph thanks = new Paragraph(
                "Thank you for choosing Sani Express.",
                FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD, BRAND_RED)
        );
        thanks.setAlignment(Element.ALIGN_CENTER);
        thanks.setSpacingBefore(8);

        cell.addElement(note);
        cell.addElement(thanks);
        footer.addCell(cell);

        document.add(footer);
    }

    private void addSectionTitle(Document document, String title, Font sectionFont) throws Exception {
        Paragraph paragraph = new Paragraph(title, sectionFont);
        paragraph.setSpacingBefore(4);
        paragraph.setSpacingAfter(8);
        document.add(paragraph);
    }

    private void addDetailRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label.toUpperCase(), labelFont));
        labelCell.setPadding(8);
        labelCell.setBackgroundColor(LIGHT_GREY);
        labelCell.setBorderColor(BORDER_GREY);

        PdfPCell valueCell = new PdfPCell(new Phrase(nullToDash(value), valueFont));
        valueCell.setPadding(8);
        valueCell.setBorderColor(BORDER_GREY);

        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private String buildRoute(ResultSet rs) throws Exception {
        return nullToDash(rs.getString("origin")) + " to " + nullToDash(rs.getString("destination"));
    }

    private Color getStatusColor(String status) {
        if (status == null) {
            return WARNING_ORANGE;
        }

        String clean = status.trim().toLowerCase();

        if (clean.equals("confirmed") || clean.equals("success") || clean.equals("successful")) {
            return SUCCESS_GREEN;
        }

        if (clean.equals("cancelled") || clean.equals("failed")) {
            return BRAND_RED;
        }

        return WARNING_ORANGE;
    }

    private String formatBookingId(int bookingId) {
        return String.format("BKG-%06d", bookingId);
    }

    private String createTicketCode(int bookingId) {
        return String.format("SE-TICKET-%06d", bookingId);
    }

    private String formatCurrency(ResultSet rs, String columnName) throws Exception {
        BigDecimal amount = rs.getBigDecimal(columnName);

        if (amount == null) {
            return "-";
        }

        return "RM " + String.format("%.2f", amount.doubleValue());
    }

    private static String nullToDash(String value) {
        return value == null || value.trim().isEmpty() ? "-" : value;
    }

    private static void showTextError(HttpServletResponse response, String message) throws IOException {
        if (!response.isCommitted()) {
            response.reset();
        }

        response.setContentType("text/plain;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println(message);
        }
    }
}