package servlet;

import entity.Contract;
import entity.Invoice;
import entity.Room;
import entity.Student;

import org.hibernate.LockMode;
import org.hibernate.Session;
import org.hibernate.Transaction;

import util.CommonLogger;
import util.HibernateUtil;
import jakarta.persistence.LockModeType;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

@WebServlet("/student/bookRoom")
public class RoomBookingServlet extends HttpServlet {
    private static final ReentrantLock bookingLock = new ReentrantLock();
	private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
	
    @Override
    public void init() throws ServletException {
        java.util.TimeZone.setDefault(java.util.TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
    }

   
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

        String roomName;
        try {
            roomName = request.getParameter("roomName");
            if (roomName == null || roomName.trim().isEmpty()) {
                throw new Exception("RoomName không hợp lệ!");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_room_name");
            return;
        }
        bookingLock.lock();
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            
            // Xóa hợp đồng Pending cũ
            List<Contract> pendingContracts = session.createQuery(
                    "FROM Contract c WHERE c.student = :student AND c.status = 'Pending'", Contract.class)
                .setParameter("student", student)
                .getResultList();
            for (Contract oldContract : pendingContracts) {
                Room oldRoom = oldContract.getRoom();
                oldRoom.setCurrentOccupants(oldRoom.getCurrentOccupants() - 1);
                session.delete(oldContract);
                session.update(oldRoom);
                CommonLogger.logEvent("Xóa hợp đồng Pending cũ: IDSinhVien=" + student.getIdSinhVien() + ", room=" + oldRoom.getRoomName());
            }
            
            // Kiểm tra hợp đồng Active
            List<Contract> activeContracts = session.createQuery(
                    "FROM Contract c WHERE c.student = :student AND c.status = 'Active'", Contract.class)
                .setParameter("student", student)
                .getResultList();
            if (!activeContracts.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/student/dashboard?error=already_has_active_contract");
                return;
            	}

            Room room = session.createQuery("FROM Room r WHERE r.roomName = :roomName", Room.class)
                    .setParameter("roomName", roomName)
                    .setLockMode(LockModeType.PESSIMISTIC_WRITE)
                    .uniqueResult();
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
            LocalDateTime startDate = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh"));
            contract.setStartDate(startDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            calendar.add(Calendar.YEAR, 1);
            contract.setEndDate(calendar.getTime());
            contract.setStatus("Pending");
            
            room.setCurrentOccupants(room.getCurrentOccupants() + 1);
            student.setStatus("InDormitory");

            session.save(contract);
            
            
            Invoice invoice = new Invoice();
            invoice.setContract(contract);
            invoice.setIssueDate(new Date());
            invoice.setPaymentDate(null); 
            invoice.setAmount(room.getPrice()); 
            invoice.setPaymentStatus("Unpaid"); 
            
            session.save(invoice);
            
            session.update(room);
            session.update(student);
            
            // Ghi log
            CommonLogger.logEvent("Sinh viên ID " + student.getIdSinhVien() + " đã đặt phòng " + roomName);
            tx.commit();

            request.getSession().setAttribute("student", student); 
            CommonLogger.logEvent("Stored student in session: studentID=" + student.getIdSinhVien() + ", sessionID=" + request.getSession().getId());
            response.sendRedirect(request.getContextPath() + "/student/bookRoom.jsp?message=booking_success");
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            System.err.println("Booking failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=booking_failed&reason=" + e.getMessage());
        } finally {
            session.close();
        }
    }
	static {
        scheduler.scheduleAtFixedRate(() -> {
            Session session = HibernateUtil.getSessionFactory().openSession();
            Transaction tx = null;
            try {
                tx = session.beginTransaction();
                List<Contract> expiredContracts = session.createQuery(
                        "FROM Contract c WHERE c.status = 'Pending' AND c.startDate < :threeDaysAgo", Contract.class)
                        .setParameter("threeDaysAgo", LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).minusDays(3))
                        .getResultList();
                for (Contract contract : expiredContracts) {
                    Room room = contract.getRoom();
                    room.setCurrentOccupants(room.getCurrentOccupants() - 1);
                    contract.getStudent().setStatus("NotInDormitory");
                    session.delete(contract);
                    session.update(room);
                    session.update(contract.getStudent());
                    CommonLogger.logEvent("Hủy hợp đồng hết hạn: contractID=" + contract.getContractID() + ", room=" + room.getRoomName());
                }
                tx.commit();
            } catch (Exception e) {
                if (tx != null) tx.rollback();
                CommonLogger.logEvent("Lỗi khi hủy hợp đồng hết hạn: " + e.getMessage());
            } finally {
                session.close();
            }
        }, 0, 1, TimeUnit.HOURS);
    }
}