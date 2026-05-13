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
    
    public Bus(){
        
    }
    
    
    public Bus(int busID, String busNumber, String busType, int totalSeat){
        this.busID = busID;
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeat = totalSeat;
    }
    
    public Bus(String busNumber, String busType, int totalSeat){
        this.busNumber = busNumber;
        this.busType = busType;
        this.totalSeat = totalSeat;
    }
    
    
    public int getID(){
        return busID;
    }
    
    public void setID(int busID){
        this.busID = busID;
    }
    
    public String getBusNumber(){
        return busNumber;
    }
    
    public void setBusNumber(String busNumber){
        this.busNumber = busNumber;
    }
    
    public String getBusType(){
        return busType;
    }
    
    public void setBusType(String busType){
        this.busType = busType;
    }
    
    public int getTotalSeat(){
        return totalSeat;
    }
    
    public void setTotalSeat(int totalSeat){
        this.totalSeat = totalSeat;
    }
    
  
}

