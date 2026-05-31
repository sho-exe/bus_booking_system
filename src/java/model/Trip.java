package model;

public class Trip {

    private int tripId;
    private String origin;
    private String destination;
    private String departureTime;
    private String arrivalTime;
    private double price;
    private int busId;
    private int driverId;

    public Trip() {

    }

    public Trip(int tripId, String origin, String destination,
            String departureTime, String arrivalTime,
            double price, int busId, int driverId) {
        this.tripId = tripId;
        this.origin = origin;
        this.destination = destination;
        this.departureTime = departureTime;
        this.arrivalTime = arrivalTime;
        this.price = price;
        this.busId = busId;
        this.driverId = driverId;
    }

    public int getTripId() {
        return tripId;
    }

    public String getOrigin() {
        return origin;
    }

    public String getDestination() {
        return destination;
    }

    public String getDepartureTime() {
        return departureTime;
    }

    public String getArrivalTime() {
        return arrivalTime;
    }

    public double getPrice() {
        return price;
    }

    public int getBusId() {
        return busId;
    }

    public int getDriverId() {
        return driverId;
    }

    public void setTripId(int tripId) {
        this.tripId = tripId;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public void setDepartureTime(String departureTime) {
        this.departureTime = departureTime;
    }

    public void setArrivalTime(String arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public void setDriverId(int driverId) {
        this.driverId = driverId;
    }
}
