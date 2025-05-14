package servlet;

import entity.Building;
import entity.Room;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        try {
            SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
            if (sessionFactory == null) {
                throw new Exception("SessionFactory is null!");
            }
            session = sessionFactory.openSession();

            String section = request.getParameter("section");
            request.setAttribute("section", section != null ? section : "rooms"); // Mặc định là "rooms" nếu không có section

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