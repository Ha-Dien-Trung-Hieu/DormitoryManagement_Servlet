package entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "room")
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RoomID")
    private Integer roomID;

    @Column(name = "RoomType")
    private String roomType;

    @Column(name = "Capacity")
    private Integer capacity;

    @Column(name = "CurrentOccupants")
    private Integer currentOccupants;

    @Column(name = "Price")
    private Long price;
    
    @Column(name = "ipAddress")
    private String ipAddress;

    @Column(name = "port")
    private Integer port;

    @Version
    private int version;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BuildingID")
    private Building building;

    @OneToMany(mappedBy = "room", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Contract> contracts;

    // Getters and Setters
    public Integer getRoomID() { return roomID; }
    public void setRoomID(Integer roomID) { this.roomID = roomID; }
    
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    
    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }
    
    public Integer getCurrentOccupants() { return currentOccupants; }
    public void setCurrentOccupants(Integer currentOccupants) { this.currentOccupants = currentOccupants; }
    
    public Long getPrice() { return price; }
    public void setPrice(Long price) { this.price = price; }
    
    public Building getBuilding() { return building; }
    public void setBuilding(Building building) { this.building = building; }
    
    public List<Contract> getContracts() { return contracts; }
    public void setContracts(List<Contract> contracts) { this.contracts = contracts; }
    
    public int getVersion() { return version; }
    public void setVersion(int version) { this.version = version; }
    
    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Integer getPort() { return port; }
    public void setPort(Integer port) { this.port = port; }
}