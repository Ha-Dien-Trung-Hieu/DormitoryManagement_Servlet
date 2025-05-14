package entity;

import jakarta.persistence.*; 
import java.util.List;

@Entity
@Table(name = "building")
public class Building {
    @Id
    @Column(name = "BuildingID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer buildingID;

    @Column(name = "Name")
    private String name;

    @Column(name = "Floors")
    private Integer floors;

    @Column(name = "Location")
    private String location;

    @OneToMany(mappedBy = "building", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<Room> rooms;

    // Getters and Setters
    public Integer getBuildingID() { return buildingID; }
    public void setBuildingID(Integer buildingID) { this.buildingID = buildingID; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public Integer getFloors() { return floors; }
    public void setFloors(Integer floors) { this.floors = floors; }
    
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public List<Room> getRooms() { return rooms; }
    public void setRooms(List<Room> rooms) { this.rooms = rooms; }
}