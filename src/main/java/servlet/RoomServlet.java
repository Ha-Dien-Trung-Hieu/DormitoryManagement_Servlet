package servlet;

import entity.Building;
import entity.Room;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet({"/rooms", "/student/getRooms"})
public class RoomServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
        if (sessionFactory == null) {
            throw new ServletException("SessionFactory is null!");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/student/getRooms".equals(servletPath)) {
            handleGetRoomsJson(request, response);
        } else if ("/rooms".equals(servletPath)) {
            handleGetRoomsForAdmin(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid endpoint");
        }
    }

    // Lấy danh sách phòng cho admin dashboard
    private void handleGetRoomsForAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        try {
            session = sessionFactory.openSession();

            String section = request.getParameter("section");
            request.setAttribute("section", section != null ? section : "rooms");

            // Chỉ lấy dữ liệu phòng nếu section là "rooms"
            if ("rooms".equalsIgnoreCase(section)) {
                Query<Room> roomQuery = session.createQuery("FROM Room", Room.class);
                List<Room> rooms = roomQuery.list();

                Query<Building> buildingQuery = session.createQuery("FROM Building", Building.class);
                List<Building> buildings = buildingQuery.list();

                request.setAttribute("rooms", rooms);
                request.setAttribute("buildings", buildings);
            }

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lấy dữ liệu phòng và tòa nhà: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    // Lấy danh sách phòng dưới dạng JSON cho student dashboard
    private void handleGetRoomsJson(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String building = request.getParameter("building");
        String floorPrefix = request.getParameter("floor");

        if (building == null || floorPrefix == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing building or floor parameter\"}");
            return;
        }

        Session session = null;
        try {
            session = sessionFactory.openSession();

            Query<Room> query = session.createQuery(
                "FROM Room r JOIN r.building b WHERE b.name = :building AND r.roomName LIKE :floorPrefix",
                Room.class
            );
            query.setParameter("building", building);
            query.setParameter("floorPrefix", floorPrefix + "%");
            List<Room> rooms = query.getResultList();

            // Chuyển đổi dữ liệu thành JSON cho dashboard
            List<Map<String, Object>> roomData = rooms.stream().map(room -> {
                Map<String, Object> map = new HashMap<>();
                map.put("roomName", room.getRoomName() != null && !room.getRoomName().isEmpty() ? room.getRoomName() : "Không xác định");
                map.put("roomType", room.getRoomType() != null && !room.getRoomType().isEmpty() ? room.getRoomType() : "Không xác định");
                map.put("price", room.getPrice() != null ? room.getPrice() : 0L);
                map.put("capacity", room.getCapacity() != null ? room.getCapacity() : 0);
                map.put("currentOccupants", room.getCurrentOccupants() != null ? room.getCurrentOccupants() : 0);
                System.out.println("Room data: " + map);
                return map;
            }).collect(Collectors.toList());
            
            // Gửi JSON về client
            response.getWriter().write(new Gson().toJson(roomData));
            System.out.println("Sent JSON response with " + roomData.size() + " rooms");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Server error: " + e.getMessage() + "\"}");
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            if (sessionFactory == null) {
                throw new ServletException("SessionFactory is null!");
            }
            Session session = sessionFactory.openSession();
            Transaction transaction = null;

            try {
                transaction = session.beginTransaction();
                handleDeleteRoom(request, session);
                transaction.commit();
                response.sendRedirect(request.getContextPath() + "/rooms?section=rooms"); 
            } catch (IllegalArgumentException e) {
                if (transaction != null) transaction.rollback();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            } catch (IllegalStateException e) {
                if (transaction != null) transaction.rollback();
                response.sendError(HttpServletResponse.SC_CONFLICT, e.getMessage());
            } catch (Exception e) {
                if (transaction != null) transaction.rollback();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xóa phòng: " + e.getMessage());
            } finally {
                session.close();
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ!");
        }
    }

    private void handleDeleteRoom(HttpServletRequest request, Session session) throws IOException {
        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("RoomID không hợp lệ");
        }
        Integer roomId = Integer.parseInt(roomIdStr);

        Room room = session.get(Room.class, roomId);
        if (room == null) {
            throw new IllegalArgumentException("Phòng không tồn tại: " + roomId);
        }

        if (room.getCurrentOccupants() > 0) {
            throw new IllegalStateException("Không thể xóa phòng đang có người ở");
        }

        session.remove(room);
    }
}