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

    @Column(name = "RoomName", unique = true) //, nullable = false
    private String roomName;
    
    @Column(name = "RoomType")
    private String roomType;

    @Column(name = "Capacity")
    private Integer capacity;

    @Column(name = "CurrentOccupants")
    private Integer currentOccupants;

    @Column(name = "Price")
    private Long price;
    
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
    
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    
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

}