package servlet;

import jakarta.servlet.ServletException; 
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.hibernate.Transaction;

import chat.ChatEndpoint;
import entity.Building;
import entity.Contract;
import entity.Invoice;
import entity.Manager;
import entity.Room;
import entity.Student;
import util.HibernateUtil; 
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@WebServlet("/admin/dashboard")
public class DashboardAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;
    private static final int DEFAULT_PORT = 12345;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {	
        Manager manager = (Manager) request.getSession().getAttribute("manager");
        if (manager == null) {
            response.sendRedirect(request.getContextPath() + "/loginAdmin.jsp?error=not_authenticated");
            return;
        }
        
        // Cập nhật IP động
    	String ipAddress = request.getRemoteAddr();
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isEmpty()) {
            ipAddress = forwardedFor.split(",")[0].trim();
        }
        
        String section = request.getParameter("section");
        if (section == null || section.isEmpty()) {
            section = "home";
        }
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();     
            
            // 1. Count ALL Student
            Query<Long> studentCountQuery = session.createQuery("SELECT COUNT(*) FROM Student", Long.class);
            Long totalStudents = studentCountQuery.getSingleResult();

            // 2. Count Student have room
            Query<Long> studentsWithRoomsQuery = session.createQuery(
                "SELECT COUNT(DISTINCT c.student) FROM Contract c WHERE c.status = :status", Long.class);
            studentsWithRoomsQuery.setParameter("status", "Active");
            Long studentsWithRooms = studentsWithRoomsQuery.getSingleResult();

            // 3. Count Empty Room
            Query<Long> vacantRoomsQuery = session.createQuery(
                "SELECT COUNT(*) FROM Room r WHERE r.currentOccupants = 0", Long.class);
            Long vacantRooms = vacantRoomsQuery.getSingleResult();

            // 4. Count Building
            Query<Long> buildingCountQuery = session.createQuery("SELECT COUNT(*) FROM Building", Long.class);
            Long totalBuildings = buildingCountQuery.getSingleResult();

            // 5. Revenue per Years
            int currentYear = LocalDate.now().getYear();
            Query<Long> revenueQuery = session.createQuery(
                "SELECT COALESCE(SUM(i.amount), 0) FROM Invoice i WHERE YEAR(i.paymentDate) = :year AND i.paymentStatus = :status", Long.class);
            revenueQuery.setParameter("year", currentYear);
            revenueQuery.setParameter("status", "Paid");
            Long annualRevenue = revenueQuery.getSingleResult();

            // 6. Unpaid
            Query<Long> pendingInvoicesQuery = session.createQuery(
                "SELECT COUNT(*) FROM Invoice i WHERE i.paymentStatus = :status", Long.class);
            pendingInvoicesQuery.setParameter("status", "Unpaid");
            Long pendingInvoices = pendingInvoicesQuery.getSingleResult();

            // Xử lý 'Students'
            if ("students".equals(section)) {
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");
                String filter = request.getParameter("filter");

                String hql = "FROM Student s";
                if (filter != null && "withRooms".equals(filter)) {
                    hql += " WHERE EXISTS (FROM Contract c WHERE c.student = s AND c.status = 'Active')";
                }
                if (search != null && !search.isEmpty()) {
                    hql += (hql.contains("WHERE") ? " AND" : " WHERE") + 
                           " (s.idSinhVien LIKE :search OR s.fullName LIKE :search OR s.phoneNumber LIKE :search)";
                }
                if (sort != null && "IDSinhVien".equals(sort)) {
                    hql += " ORDER BY s.idSinhVien";
                }

                Query<Student> query = session.createQuery(hql, Student.class);
                if (search != null && !search.isEmpty()) {
                    query.setParameter("search", "%" + search + "%");
                }
                List<Student> students = query.getResultList();
                request.setAttribute("students", students);
            }
            if ("contracts".equals(section)) {
                Query<Contract> contractQuery = session.createQuery("FROM Contract c", Contract.class);
                List<Contract> contracts = contractQuery.getResultList();
                request.setAttribute("contracts", contracts);
            }	
            if ("invoices".equals(section)) {
                Query<Invoice> invoiceQuery = session.createQuery("FROM Invoice i", Invoice.class);
                List<Invoice> invoices = invoiceQuery.getResultList();
                request.setAttribute("invoices", invoices);
            }
            
            // set Attribute
            request.setAttribute("manager", manager);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("studentsWithRooms", studentsWithRooms);
            request.setAttribute("vacantRooms", vacantRooms);
            request.setAttribute("totalBuildings", totalBuildings);
            request.setAttribute("annualRevenue", annualRevenue);
            request.setAttribute("pendingInvoices", pendingInvoices);

            Query<Room> roomQuery = session.createQuery("FROM Room", Room.class);
            List<Room> rooms = roomQuery.list();

            Query<Building> buildingQuery = session.createQuery("FROM Building", Building.class);
            List<Building> buildings = buildingQuery.list();

            request.setAttribute("rooms", rooms);
            request.setAttribute("buildings", buildings);
            
            // Tỉ lệ sinh viên nam và nữ
            Query<Long> maleStudentsQuery = session.createQuery(
                "SELECT COUNT(*) FROM Student WHERE LOWER(gender) = 'Male'", Long.class);
            Long maleStudents = maleStudentsQuery.getSingleResult();

            Query<Long> femaleStudentsQuery = session.createQuery(
                "SELECT COUNT(*) FROM Student WHERE LOWER(gender) = 'Female'", Long.class);
            Long femaleStudents = femaleStudentsQuery.getSingleResult();
            
            
            // Tỉ lệ sinh viên đã có phòng và chưa có phòng
            Long studentsWithoutRooms = totalStudents - studentsWithRooms;

            // Doanh thu từng tháng
            // Giả sử bạn muốn doanh thu của 12 tháng gần nhất
            List<Object[]> monthlyRevenue = new ArrayList<>();
            for (int i = 0; i < 12; i++) {
                LocalDate date = LocalDate.now().minusMonths(i);
                int year = date.getYear();
                int month = date.getMonthValue();
                Query<Long> revenueQuery2 = session.createQuery(
                	    "SELECT COALESCE(SUM(i.amount), 0) FROM Invoice i WHERE i.paymentDate IS NOT NULL AND YEAR(i.paymentDate) = :year AND MONTH(i.paymentDate) = :month AND i.paymentStatus = :status", Long.class);
                	revenueQuery2.setParameter("year", year);
                	revenueQuery2.setParameter("month", month);
                	revenueQuery2.setParameter("status", "Paid");
                	Long revenue = revenueQuery2.getSingleResult();
                monthlyRevenue.add(new Object[]{date.getMonth().getDisplayName(TextStyle.SHORT, Locale.getDefault()) + " " + year, revenue});
            }

            // Tỉ lệ phòng còn trống và phòng đã đầy
            
            Query<Long> fullRoomsQuery = session.createQuery(
                "SELECT COUNT(*) FROM Room r WHERE r.currentOccupants = r.capacity", Long.class);
            Long fullRooms = fullRoomsQuery.getSingleResult();

            // Đặt thuộc tính vào request
            request.setAttribute("maleStudents", maleStudents);
            request.setAttribute("femaleStudents", femaleStudents);
            request.setAttribute("studentsWithRooms", studentsWithRooms);
            request.setAttribute("studentsWithoutRooms", studentsWithoutRooms);
            request.setAttribute("monthlyRevenue", monthlyRevenue);
            request.setAttribute("vacantRooms", vacantRooms);
            request.setAttribute("fullRooms", fullRooms);
            
            //Web socket
            Query<Student> studentQuery = session.createQuery("FROM Student", Student.class);
            request.setAttribute("allStudents", studentQuery.list());

            Query<Manager> managerQuery = session.createQuery("FROM Manager", Manager.class);
            request.setAttribute("allManagers", managerQuery.list());
            request.setAttribute("allRooms", roomQuery.list());
            
            // Cập nhật IP và cổng cho quản lý
            manager.setIpAddress(ipAddress);
            manager.setPort(DEFAULT_PORT);
            session.merge(manager);

            // Lấy danh sách sinh viên
            List<Student> students = studentQuery.list();
            request.setAttribute("allStudents", students);

            request.setAttribute("allRooms", rooms);

            tx.commit();
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            if (!response.isCommitted()) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + e.getMessage());
            } else {
                e.printStackTrace();
            }
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String id = request.getParameter("ids");
            try (Session session = sessionFactory.openSession()) {
                session.beginTransaction();
                Student student = session.get(Student.class, id);
                if (student != null) {
                    Query<Invoice> invoiceQuery = session.createQuery("FROM Invoice i WHERE i.contract.student = :student", Invoice.class);
                    invoiceQuery.setParameter("student", student);
                    List<Invoice> invoices = invoiceQuery.getResultList();
                    for (Invoice invoice : invoices) {
                        session.delete(invoice);
                    }

                    Query<Contract> contractQuery = session.createQuery("FROM Contract c WHERE c.student = :student", Contract.class);
                    contractQuery.setParameter("student", student);
                    List<Contract> contracts = contractQuery.getResultList();
                    for (Contract contract : contracts) {
                        Room room = contract.getRoom();
                        if (room != null) {
                            room.setCurrentOccupants(room.getCurrentOccupants() - 1);
                            session.update(room);
                        }
                        session.delete(contract);
                    }

                    session.delete(student);
                }
                session.getTransaction().commit();
                response.sendRedirect("?section=students");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xóa sinh viên");
            }
        } else if ("deleteRoom".equals(action)) {
            String roomId = request.getParameter("roomId");
            try (Session session = sessionFactory.openSession()) {
                session.beginTransaction();
                Room room = session.get(Room.class, Long.parseLong(roomId));
                session.refresh(room);
                if (room != null && room.getCurrentOccupants() == 0) {
                    session.delete(room);
                    session.getTransaction().commit();
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Không thể xóa phòng đang có người ở hoặc phòng không tồn tại.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi xóa phòng: " + e.getMessage());
            }
        }
    }
}