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
}
