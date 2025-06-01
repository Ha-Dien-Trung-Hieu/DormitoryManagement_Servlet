package servlet;

import entity.Building;
import entity.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import util.CommonLogger;
import util.HibernateUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/EditRoomServlet")
public class EditRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roomID = request.getParameter("roomID");
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            Session session = sessionFactory.openSession();

            Room room = session.get(Room.class, Long.parseLong(roomID));
            if (room == null) {
                throw new Exception("Phòng không tồn tại!");
            }

            List<Building> buildings = session.createQuery("from Building", Building.class).list();
            session.close();

            request.setAttribute("room", room);
            request.setAttribute("buildings", buildings);
            request.getRequestDispatcher("/admin/editRoom.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin phòng: " + e.getMessage());
            request.getRequestDispatcher("/admin/editRoom.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roomID = request.getParameter("roomID");
            String buildingID = request.getParameter("buildingID");
            String floor = request.getParameter("floor");
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            long price = Long.parseLong(request.getParameter("price"));

            String buildingPrefix = "";
            switch (Integer.parseInt(buildingID)) {
                case 1: buildingPrefix = "A"; break;
                case 2: buildingPrefix = "B"; break;
                case 3: buildingPrefix = "C"; break;
                default: throw new Exception("BuildingID không hợp lệ!");
            }
            String roomName = buildingPrefix + floor + String.format("%02d", Integer.parseInt(roomNumber));
         
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            Session session = sessionFactory.openSession();
            Transaction transaction = session.beginTransaction();

            Room existingRoom = session.createQuery("FROM Room r WHERE r.roomName = :roomName AND r.roomID != :roomID", Room.class)
                    .setParameter("roomName", roomName)
                    .setParameter("roomID", roomID)
                    .getSingleResultOrNull();
                if (existingRoom != null) {
                    throw new IllegalArgumentException("Phòng " + roomName + " đã tồn tại!");
                }
                
            Room room = session.get(Room.class, Long.parseLong(roomID));
            if (room == null) {
                throw new Exception("Phòng không tồn tại!");
            }

            Building building = session.get(Building.class, Long.parseLong(buildingID));
            if (building == null) {
                throw new Exception("Tòa nhà không tồn tại!");
            }
            
            int capacity = switch (roomType) {
            case "Đơn" -> 1;
            case "Đôi" -> 2;
            case "Tập thể" -> 4;
            default -> throw new IllegalArgumentException("Loại phòng không hợp lệ!");
            };

            room.setBuilding(building);
            room.setRoomType(roomType);
            room.setCapacity(capacity);
            room.setPrice(price);
            room.setRoomName(roomName);
            
            session.merge(room);
            transaction.commit();
            session.close();
            
            CommonLogger.logEvent("Phòng " + roomName + " đã được chỉnh sửa!");

            response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=rooms");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật phòng: " + e.getMessage());
            request.getRequestDispatcher("/admin/editRoom.jsp").forward(request, response);
        }
    }
}