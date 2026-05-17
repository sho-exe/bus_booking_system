/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class Booking {
    private int bookingId;
    private Timestamp bookingDate;
    private String status;
    private String passengerName;
    private String passengerPhone;
    private int tripId;
    private int seatNumber;
    private String username;
    private double price;

    public Booking() {}

    public Booking(int bookingId, Timestamp bookingDate, String status, String passengerName, 
                   String passengerPhone, int tripId, int seatNumber, String username, double price) {
        this.bookingId = bookingId;
        this.bookingDate = bookingDate;
        this.status = status;
        this.passengerName = passengerName;
        this.passengerPhone = passengerPhone;
        this.tripId = tripId;
        this.seatNumber = seatNumber;
        this.username = username;
        this.price = price;
    }

    // Getters and Setters
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPassengerName() { return passengerName; }
    public void setPassengerName(String passengerName) { this.passengerName = passengerName; }

    public String getPassengerPhone() { return passengerPhone; }
    public void setPassengerPhone(String passengerPhone) { this.passengerPhone = passengerPhone; }

    public int getTripId() { return tripId; }
    public void setTripId(int tripId) { this.tripId = tripId; }

    public int getSeatNumber() { return seatNumber; }
    public void setSeatNumber(int seatNumber) { this.seatNumber = seatNumber; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
