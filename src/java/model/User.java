package model;

public class User {

    private String id;
    private String username;
    private String email;
    private String password;
    private String role;
    private String phone_number;
        
    public User(String id, String username, String email, String password, String role, String phone_number) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.phone_number = phone_number;

    }

    public User() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String getUsername() {
        return username;
    
    }
public String getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getRole() {
        return role;
    }
    
    public String getPhoneNumber() {
        return phone_number;
    }
}
