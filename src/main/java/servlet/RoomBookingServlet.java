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
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

@WebServlet("/student/bookRoom")
public class RoomBookingServlet extends HttpServlet {
	private static final ConcurrentHashMap<String, Date> roomLockTimes = new ConcurrentHashMap<>();
	private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
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
            roomName = request.getParameter("RoomName");
            if (roomName == null || roomName.trim().isEmpty()) {
                throw new Exception("RoomName không hợp lệ!");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard?error=invalid_room_name");
            return;
        }

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            // Kiểm tra hợp đồng hoạt động
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
                    .uniqueResult();
                if (room == null) {
                    response.sendRedirect(request.getContextPath() + "/student/dashboard?error=room_not_found");
                    return;
                }
                
                Date lockTime = roomLockTimes.get(roomName);
                if (lockTime != null) {
                    long timeElapsed = new Date().getTime() - lockTime.getTime();
                    if (timeElapsed < TimeUnit.DAYS.toMillis(3) && room.getCurrentOccupants() >= room.getCapacity()) {
                        long remainingDays = 3 - TimeUnit.MILLISECONDS.toDays(timeElapsed);
                        request.setAttribute("lockRemainingTime", remainingDays);
                        response.sendRedirect(request.getContextPath() + "/student/dashboard?error=room_locked");
                        return;
                    } else {
                        roomLockTimes.remove(roomName); // Open nếu quá 3 ngày or phòng k đầy
                    }
                }

                if (room.getCurrentOccupants() >= room.getCapacity()) {
                    // Khóa lại nếu đầy phòng
                    roomLockTimes.put(roomName, new Date());
                    scheduler.schedule(() -> roomLockTimes.remove(roomName), 3, TimeUnit.DAYS);
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
            contract.setStatus("Pending");
            
            room.setCurrentOccupants(room.getCurrentOccupants() + 1);
            student.setStatus("Pending");

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

            response.sendRedirect(request.getContextPath() + "/student/bookRoom.jsp");
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
}