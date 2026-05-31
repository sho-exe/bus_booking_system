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
    private int passengerId;
    private int tripId;
    private int userId;
    private int seat;
    // Extra fields populated by admin JOIN query
    private String passengerName;
    private int    passengerAge;

    public Booking() {
    }

    public Booking(int bookingId, Timestamp bookingDate, String status,
            int passengerId, int tripId, int userId, int seat) {
        this.bookingId = bookingId;
        this.bookingDate = bookingDate;
        this.status = status;
        this.passengerId = passengerId;
        this.tripId = tripId;
        this.userId = userId;
        this.seat = seat;
    }

    // Getters and Setters
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getPassengerId() {
        return passengerId;
    }

    public void setPassengerId(int passengerId) {
        this.passengerId = passengerId;
    }

    public int getTripId() {
        return tripId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int staffId) {
        this.userId = staffId;
    }

    public int getSeat() {
        return seat;
    }

    public void setSeat(int seat) {
        this.seat = seat;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public int getPassengerAge() {
        return passengerAge;
    }

    public void setPassengerAge(int passengerAge) {
        this.passengerAge = passengerAge;
    }
}
