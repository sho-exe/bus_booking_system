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
    private int totalSeat;
    private String roadtax;
    private String insurance;
    private String expiryDate;

    public Bus() {

    }

    public Bus(int busID, String busNumber, String busType, int totalSeat, String roadtax, String insurance, String expiryDate) {
        this.busID = busID;
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeat = totalSeat;
        this.roadtax = roadtax;
        this.insurance = insurance;
        this.expiryDate = expiryDate;
    }

    public Bus(String busNumber, String busType, int totalSeat, String roadtax, String insurance, String expiryDate) {
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeat = totalSeat;
        this.roadtax = roadtax;
        this.insurance = insurance;
        this.expiryDate = expiryDate;
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

    public int getTotalSeat() {
        return totalSeat;
    }

    public void setTotalSeat(int totalSeat) {
        this.totalSeat = totalSeat;
    }

    public String getRoadtax() {
        return roadtax;
    }

    public void setRoadtax(String roadtax) {
        this.roadtax = roadtax;
    }

    public String getInsurance() {
        return insurance;
    }

    public void setInsurance(String insurance) {
        this.insurance = insurance;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

}
