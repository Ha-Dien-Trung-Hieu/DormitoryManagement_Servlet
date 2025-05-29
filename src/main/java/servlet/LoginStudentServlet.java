package servlet;

import entity.Student; 
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import util.HibernateUtil;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginStudentServlet extends HttpServlet {
	private static final SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	 request.setCharacterEncoding("UTF-8");
         String idSinhVien = request.getParameter("IDSinhVien");
         String password   = request.getParameter("Password");

         String ipAddress = request.getRemoteAddr();
         String forwardedFor = request.getHeader("X-Forwarded-For");
         if (forwardedFor != null && !forwardedFor.isEmpty()) {
             ipAddress = forwardedFor.split(",")[0].trim();
         }

         System.out.println("Login attempt: studentID=" + idSinhVien + ", IP=" + ipAddress);   
         
         System.out.println("Login attempt: studentID=" + idSinhVien);

         if (idSinhVien == null || idSinhVien.isEmpty() ||
                 password   == null || password.isEmpty()) {
                 response.sendRedirect(request.getContextPath() + "/login.jsp?error=empty_fields");
                 return;
        }
         Session session = HibernateUtil.getSessionFactory().openSession();

         Transaction tx = null;
         try {
             tx = session.beginTransaction();

             Student student = session.createQuery(
                     "FROM Student s WHERE s.idSinhVien = :id", Student.class)
                 .setParameter("id", idSinhVien)
                 .uniqueResult();

             if (student != null && BCrypt.checkpw(password, student.getPassword())) {
                 System.out.println("Login successful: IDSinhVien=" + idSinhVien);
            	 HttpSession ses = request.getSession();
            	 ses.setAttribute("student", student);
                 tx.commit();
                 response.sendRedirect(request.getContextPath() + "/student/dashboard");
             } else {
                 System.out.println("Invalid credentials for IDSinhVien=" + idSinhVien);
                 tx.commit();
                 response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalid_credentials");
             }
             System.out.println("idSinhVien: " + idSinhVien);
             if (student != null) {
                 System.out.println("Stored password: " + student.getPassword());
                 System.out.println("Password check: " + BCrypt.checkpw(password, student.getPassword()));
             } else {
                 System.out.println("Student not found");
             }
         } catch (Exception e) {
             if (tx != null) tx.rollback();
             log("Lỗi khi login student:", e);
             response.sendRedirect(request.getContextPath() + "/login.jsp?error=database");
         } finally {
             session.close();
         }
     }
 }