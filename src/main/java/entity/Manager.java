package entity;

import jakarta.persistence.*;

@Entity
@Table(name = "manager")
public class Manager {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ManagerID")
    private int managerID;

    @Column(name = "AdminID", unique = true, nullable = false)
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
    
    @Column(name = "ipAddress")
    private String ipAddress;

    @Column(name = "port")
    private Integer port;

    // Getters and Setters
    public int getManagerID() { return managerID; }
    public void setManagerID(int managerID) { this.managerID = managerID; }
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
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Integer getPort() { return port; }
    public void setPort(Integer port) { this.port = port; }

}