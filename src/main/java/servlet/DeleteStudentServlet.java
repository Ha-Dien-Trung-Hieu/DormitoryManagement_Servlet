package servlet;

import entity.Contract;
import entity.Student;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/students")
public class DeleteStudentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentId = request.getParameter("ids");

        if (studentId == null || studentId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sinh viên không hợp lệ");
            return;
        }

        Session session = null;
        Transaction tx = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            Query<Student> studentQuery = session.createQuery(
                    "FROM Student s WHERE s.idSinhVien = :idSinhVien", Student.class);
            studentQuery.setParameter("idSinhVien", studentId);
            Student student = studentQuery.uniqueResult();

            if (student == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sinh viên không tồn tại");
                return;
            }

            Query<Contract> contractQuery = session.createQuery(
                    "FROM Contract c WHERE c.student.idSinhVien = :idSinhVien", Contract.class);
            contractQuery.setParameter("idSinhVien", studentId);
            List<Contract> contracts = contractQuery.list();

            if (!contracts.isEmpty()) {
                for (Contract contract : contracts) {
                    Query<?> invoiceQuery = session.createQuery(
                            "DELETE FROM Invoice i WHERE i.contract.contractID = :contractId");
                    invoiceQuery.setParameter("contractId", contract.getContractID());
                    invoiceQuery.executeUpdate();

                    if (contract.getRoom() != null) {
                        Query<?> updateRoomQuery = session.createQuery(
                                "UPDATE Room r SET r.currentOccupants = r.currentOccupants - 1 " +
                                "WHERE r.roomID = :roomId AND r.currentOccupants > 0");
                        updateRoomQuery.setParameter("roomId", contract.getRoom().getRoomID());
                        updateRoomQuery.executeUpdate();
                    }

                    session.remove(contract);
                }
            }

            session.remove(student);

            tx.commit();

            response.setContentType("text/plain");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Xóa thành công");
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xóa sinh viên: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}