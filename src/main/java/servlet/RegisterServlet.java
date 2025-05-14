package servlet;

import java.io.File; 
import java.io.FileWriter;  
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.mindrot.jbcrypt.BCrypt;
import entity.Student;
import util.CommonLogger;
import util.HibernateUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Hiển thị trang đăng ký
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // Lấy dữ liệu từ form
        String idSinhVien 	= request.getParameter("IDSinhVien");
        String fullName 	= request.getParameter("FullName");
        String phoneNumber 	= request.getParameter("PhoneNumber");
        String email 		= request.getParameter("Email");
        String cccdId 		= request.getParameter("CCCDID");
        String password 	= request.getParameter("Password");

        // Kiểm tra dữ liệu đầu vào
        if (idSinhVien == null || fullName == null || phoneNumber == null || email == null || cccdId == null || password == null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=missing_fields");
            return;
        }
        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();
            // HashPw
	        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
	
	        // Create student
	        Student student = new Student();
	        student.setIdSinhVien(idSinhVien);
	        student.setFullName(fullName);
	        student.setPhoneNumber(phoneNumber);
	        student.setEmail(email);
	        student.setCCCDID(cccdId);
	        student.setPassword(hashedPassword);
	        student.setStatus("NotInDormitory");

	        session.persist(student);
            tx.commit();
            // Ghi log
            CommonLogger.logEvent("Sinh viên ID " + idSinhVien + " đã được đăng ký");
            response.sendRedirect("login.jsp?message=registration_success");
        } catch (Exception e) {
        	if (tx != null && tx.isActive()) {
                tx.rollback();
        	}
        	e.printStackTrace();
            log("Lỗi khi lưu Student: ", e);
            response.sendRedirect("register.jsp?error=registration_failed");
        } finally {
            session.close();
        }
    }
}



