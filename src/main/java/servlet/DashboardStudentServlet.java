package servlet;
 
import entity.Student;
import entity.Building;
import entity.Contract;
import entity.Invoice;
import entity.Room;
import entity.Manager;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/dashboard")
public class DashboardStudentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_authenticated");
            return;
        }
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;

        try {
            tx = session.beginTransaction();
            Student fullStudent = session.createQuery("SELECT s FROM Student s LEFT JOIN FETCH s.contract c LEFT JOIN FETCH c.room r "
            		+ "WHERE s.idSinhVien = :idSinhVien",Student.class)
                .setParameter("idSinhVien", student.getIdSinhVien())
                .uniqueResult();

            if (fullStudent == null) {
                System.out.println("Error: Student not found for IDSinhVien: " + student.getIdSinhVien());
                response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=not_authenticated");
                return;
            }
            request.setAttribute("student", fullStudent);
            
            Query<Invoice> invoiceQuery = session.createQuery(
                    "FROM Invoice i WHERE i.contract.student = :student AND i.paymentStatus = :status", Invoice.class);
            invoiceQuery.setParameter("student", fullStudent);
            invoiceQuery.setParameter("status", "Unpaid");
            List<Invoice> unpaidInvoices = invoiceQuery.getResultList();
            request.setAttribute("unpaidInvoices", unpaidInvoices);
            System.out.println("Hóa đơn chưa thanh toán: " + unpaidInvoices.size());
            
            List<Student> roommates = new ArrayList<>();
            if (fullStudent.getContract() != null && "Active".equals(fullStudent.getContract().getStatus()) && fullStudent.getContract().getRoom() != null) {
                roommates = session.createQuery(
                        "SELECT s FROM Contract c JOIN c.student s " +
                        "WHERE c.room = :room AND s.idSinhVien != :idSinhVien AND c.status = 'Active'",
                        Student.class)
                    .setParameter("room", fullStudent.getContract().getRoom())
                    .setParameter("idSinhVien", fullStudent.getIdSinhVien())
                    .getResultList();
                System.out.println("Roommates found: " + roommates.size());
            } else {
                System.out.println("No active contract or room for roommates");
            }
            
            request.setAttribute("roommates", roommates);
            
            // Lấy danh sách building
            List<Building> buildings = session.createQuery(
                    "FROM Building b",
                    Building.class)
                .getResultList();
            System.out.println("Buildings found: " + buildings.size());
            for (Building building : buildings) {
                System.out.println("Building: " + building.getName());
            }
            request.setAttribute("buildings", buildings);
            
            // Lấy danh sách sinh viên
            Query<Student> studentQuery = session.createQuery("FROM Student", Student.class);
            List<Student> students = studentQuery.list();
            request.setAttribute("allStudents", students);

            // Lấy danh sách quản lý
            Query<Manager> managerQuery = session.createQuery("FROM Manager", Manager.class);
            List<Manager> managers = managerQuery.list();
            request.setAttribute("allManagers", managers);

            // Lấy thông tin phòng (nếu sinh viên có hợp đồng)
            Room roomServer = null;
            if (student.getContract() != null && student.getContract().getRoom() != null) {
                roomServer = session.createQuery("FROM Room WHERE roomID = :id", Room.class)
                        .setParameter("id", student.getContract().getRoom().getRoomID())
                        .uniqueResult();
            }
            request.setAttribute("roomServer", roomServer);
            System.out.println("Loaded student: " + student.getIdSinhVien() + 
                    ", Avatar size: " + (student.getAvatar() != null ? student.getAvatar().length : 0));
            
            
            tx.commit();
        } catch (Exception e) {
        	if (tx != null && tx.isActive()) {
                tx.rollback();
            }
        	e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());

            request.setAttribute("error", "server_error");
            request.setAttribute("roommates", new ArrayList<Student>());
            request.setAttribute("availableRooms", new ArrayList<Room>());
        } finally {
            session.close();
        }
        request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);

    }
}