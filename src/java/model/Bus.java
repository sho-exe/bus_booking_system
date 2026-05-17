/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Asus
 */
public class Bus {
    private int busID;
    private String busNumber;
    private String busType;
    private int totalSeats;

    public Bus() {

    }

    public Bus(int busID, String busNumber, String busType, int totalSeats) {
        this.busID = busID;
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeats = totalSeats;
    }

    public Bus(String busNumber, String busType, int totalSeats) {
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeats = totalSeats;
    }

    public int getBusId() {
        return busID;
    }

    public void setBusId(int busID) {
        this.busID = busID;
    }

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getBusType() {
        return busType;
    }

    public void setBusType(String busType) {
        this.busType = busType;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

}
