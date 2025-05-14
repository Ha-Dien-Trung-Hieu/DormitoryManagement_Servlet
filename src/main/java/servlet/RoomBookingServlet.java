package servlet;

import entity.Contract;
import entity.Invoice;
import entity.Room;
import entity.Student;
import org.hibernate.Session;
import org.hibernate.Transaction;

import util.CommonLogger;
import util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.ReentrantLock;

@WebServlet("/student/bookRoom")
public class RoomBookingServlet extends HttpServlet {
	private static final ConcurrentHashMap<Integer, ReentrantLock> roomLocks = new ConcurrentHashMap<>();

	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_authenticated");
            return;
        }

        if (!"NotInDormitory".equals(student.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=already_in_dormitory");
            return;
        }

        int roomId;
        try {
            roomId = Integer.parseInt(request.getParameter("RoomID"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_room_id");
            return;
        }

        ReentrantLock lock = roomLocks.computeIfAbsent(roomId, k -> new ReentrantLock());
        if (!lock.tryLock()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=room_being_booked");
            return;
        }

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            // Kiểm tra hợp đồng đang hoạt động
            List<Contract> activeContracts = session.createQuery(
                    "FROM Contract c WHERE c.student = :student AND c.status = 'Active'", Contract.class)
                .setParameter("student", student)
                .getResultList();
            if (!activeContracts.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=already_has_active_contract");
                return;
            }

            Room room = session.get(Room.class, roomId);
            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=room_not_found");
                return;
            }

            if (room.getCurrentOccupants() >= room.getCapacity()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=room_full");
                return;
            }

            Contract contract = new Contract();
            contract.setStudent(student);
            contract.setRoom(room);
            contract.setStartDate(new Date());
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.YEAR, 1);
            contract.setEndDate(calendar.getTime());
            contract.setStatus("Active");

            room.setCurrentOccupants(room.getCurrentOccupants() + 1);
            student.setStatus("InDormitory");

            session.save(contract);
            
            
            Invoice invoice = new Invoice();
            invoice.setContract(contract);
            invoice.setIssueDate(new Date());
            invoice.setPaymentDate(null); // PaymentDate NULL
            invoice.setAmount(room.getPrice()); 
            invoice.setPaymentStatus("Unpaid"); // Unpaid
            
            session.save(invoice);
            
            session.update(room);
            session.update(student);
            
            // Ghi log
            CommonLogger.logEvent("Sinh viên ID " + student.getIdSinhVien() + " đã đặt phòng " + roomId);

            
            tx.commit();

            response.sendRedirect(request.getContextPath() + "/student/bookRoom.jsp");
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            System.err.println("Booking failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=booking_failed&reason=" + e.getMessage());
        } finally {
            session.close();
            lock.unlock();
            roomLocks.remove(roomId, lock);
        }
    }
}