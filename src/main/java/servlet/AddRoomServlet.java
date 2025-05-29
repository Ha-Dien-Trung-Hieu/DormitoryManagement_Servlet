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
import util.HibernateUtil;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/addRoom")
public class AddRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            Session session = sessionFactory.openSession();
            List<Building> buildings = session.createQuery("from Building", Building.class).list();
            session.close();

            request.setAttribute("buildings", buildings);
            request.getRequestDispatcher("/admin/addRoom.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách tòa nhà: " + e.getMessage());
            request.getRequestDispatcher("/admin/addRoom.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String buildingID = request.getParameter("buildingID");
            String floor = request.getParameter("floor");
            String roomNumber = request.getParameter("roomNumber");
            String roomType = request.getParameter("roomType");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            long price = Long.parseLong(request.getParameter("price"));

            // get A, B, C building name
            String buildingPrefix = "";
            switch (Integer.parseInt(buildingID)) {
                case 1: buildingPrefix = "A"; break;
                case 2: buildingPrefix = "B"; break;
                case 3: buildingPrefix = "C"; break;
                default: throw new Exception("BuildingID không hợp lệ!");
            }
            String roomName = buildingPrefix + floor + String.format("%02d", Integer.parseInt(roomNumber));
            
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            if (sessionFactory == null) {
                throw new Exception("SessionFactory is null!");
            }
            Session session = sessionFactory.openSession();
            Transaction transaction = session.beginTransaction();

            Building building = session.get(Building.class, Long.parseLong(buildingID));
            if (building == null) {
                throw new Exception("Tòa nhà không tồn tại!");
            }
            
            Room room = new Room();
            room.setBuilding(building);
            room.setRoomType(roomType);
            room.setCapacity(capacity);
            room.setPrice(price);
            room.setCurrentOccupants(0);
            room.setRoomName(roomName);
            
            session.persist(room);
            transaction.commit();
            session.close();

            response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=rooms");
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ (buildingID hoặc price): " + e.getMessage());
            request.getRequestDispatcher("/admin/addRoom.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi thêm phòng: " + e.getMessage());
            request.getRequestDispatcher("/admin/addRoom.jsp").forward(request, response);
        }
    }
}