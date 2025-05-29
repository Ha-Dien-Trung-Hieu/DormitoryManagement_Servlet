package entity;

import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "student")
public class Student {
    @Id
    @Column(name = "StudentID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer studentID;

    @Column(name = "IDSinhVien", unique = true, nullable = false)
    private String idSinhVien;

    @Column(name = "FullName", nullable = false)
    private String fullName;

    @Column(name = "DateOfBirth")
    @Temporal(TemporalType.DATE)
    private Date dateOfBirth;

    @Column(name = "Gender")
    private String gender;

    @Column(name = "Class")
    private String className;

    @Column(name = "Department")
    private String department;

    @Column(name = "PhoneNumber", nullable = false)
    private String phoneNumber;

    @Column(name = "Email", unique = true, nullable = false)
    private String email;

    @Column(name = "Password", nullable = false)
    private String password;

    @Column(name = "CCCDID", unique = true, nullable = false)
    private String cccdID;

    @Column(name = "Status")
    private String status;
 
    @Column(name = "avatar", columnDefinition = "LONGBLOB")
    private byte[] avatar; 
    
    @OneToOne(mappedBy = "student", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private Contract contract;
    
    // Constructor mặc định (yêu cầu bởi Hibernate)
    public Student() {}

    // Getters và Setters
    public Integer getStudentID() { return studentID; }
    public void setStudentID(Integer studentID) { this.studentID = studentID; }
    
    public String getIdSinhVien() { return idSinhVien; }
    public void setIdSinhVien(String idSinhVien) { this.idSinhVien = idSinhVien; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }
    
    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
    
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getCCCDID() { return cccdID; }
    public void setCCCDID(String cccdID) { this.cccdID = cccdID; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Contract getContract() { return contract; }
    public void setContract(Contract contract) { this.contract = contract; }
    
    public byte[] getAvatar() { return avatar; }
    public void setAvatar(byte[] avatar) { this.avatar = avatar; }
}