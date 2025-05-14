package servlet;

import entity.Student;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Boolean verified = (Boolean) request.getSession().getAttribute("verified");
        String resetEmail = (String) request.getSession().getAttribute("resetEmail");

        if (verified == null || !verified || resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/student/resetPassword.jsp?error=password_mismatch");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/student/resetPassword.jsp?error=weak_password");
            return;
        }

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            Student student = session.createQuery(
                    "FROM Student s WHERE s.email = :email", Student.class)
                .setParameter("email", resetEmail)
                .uniqueResult();

            if (student != null) {
                String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                student.setPassword(hashedPassword);
                session.update(student);
                tx.commit();
                request.getSession().removeAttribute("resetCode");
                request.getSession().removeAttribute("resetEmail");
                request.getSession().removeAttribute("verified");
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=password_reset");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/resetPassword.jsp?error=database");
            }
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/resetPassword.jsp?error=database");
        } finally {
            session.close();
        }
    }
}