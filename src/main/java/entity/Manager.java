package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "manager")
public class Manager {
	@Id
    @Column(name = "AdminID")
    private String adminID;
    
    @Column(name = "FullName")
    private String fullName;

    @Column(name = "Position")
    private String position;

    @Column(name = "PhoneNumber")
    private String phoneNumber;

    @Column(name = "Email", unique = true)
    private String email;

    @Column(name = "Password")
    private String password;
    
    // Getters and Setters
    public String getAdminID() { return adminID; }
    public void setAdminID(String adminID) { this.adminID = adminID; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}