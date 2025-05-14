package servlet;

import entity.Student;
import util.CommonLogger;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

@WebServlet("/student/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private static final List<String> CLASSES = Arrays.asList("24IT1", "24IT2", "24GIT1", "24GIC", "24GCE", "24DA", "24NS", "24EL");
    private static final List<String> DEPARTMENTS = Arrays.asList("Khoa học Máy tính", "Kinh tế số & TMĐT", "Kỹ thuật máy tính và Điện tử");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=not_authenticated");
            return;
        }
        Integer studentID = student.getStudentID();
        if (studentID == null) {
            System.out.println("StudentID is null or empty");
            response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=invalid_student_id");
            return;
        }
        
        	Session session = null;
        try {
        	session = HibernateUtil.getSessionFactory().openSession();
        	System.out.println("Opened Hibernate session for studentID: " + studentID);
            // Lấy student đầy đủ từ database
            Student fullStudent = session.get(Student.class, student.getStudentID());
            if (fullStudent == null) {
                response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=not_authenticated");
                return;
            }
            request.setAttribute("student", fullStudent);
            request.setAttribute("classes", CLASSES);
            request.setAttribute("departments", DEPARTMENTS);
            request.getRequestDispatcher("/student/updateProfile.jsp").forward(request, response);
        } catch (Exception e) {
        	System.out.println("Lỗi trong doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "server_error");
            request.setAttribute("classes", CLASSES);
            request.setAttribute("departments", DEPARTMENTS);
            request.getRequestDispatcher("/student/updateProfile.jsp").forward(request, response);
        } finally {
        	if (session != null && session.isOpen()) {
                session.close();
                System.out.println("Closed Hibernate session");
        	}
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/student/login.jsp?error=not_authenticated");
            return;
        }

        Session session = HibernateUtil.getSessionFactory().openSession();
        Transaction tx = null;
        try {
            tx = session.beginTransaction();

            // Lấy student từ database
            Student fullStudent = session.get(Student.class, student.getStudentID());
            if (fullStudent == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_authenticated");
                return;
            }

            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            String className = request.getParameter("className");
            String department = request.getParameter("department");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");

            // Xác thực dữ liệu
            if (fullName == null || fullName.trim().isEmpty()) {
                throw new IllegalArgumentException("invalid_input");
            }

            Date dateOfBirth = null;
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                dateOfBirth = sdf.parse(dateOfBirthStr);
            } catch (Exception e) {
                throw new IllegalArgumentException("invalid_date");
            }

            if (!Arrays.asList("Nam", "Nữ", "Khác").contains(gender)) {
                throw new IllegalArgumentException("invalid_input");
            }

            if (!CLASSES.contains(className) || !DEPARTMENTS.contains(department)) {
                throw new IllegalArgumentException("invalid_input");
            }

            if (!phoneNumber.matches("\\d{10,11}")) {
                throw new IllegalArgumentException("invalid_phone");
            }

            if (!email.equals(fullStudent.getEmail())) {
                if (!email.matches("^[a-zA-Z0-9._%+-]+@vku\\.udn\\.vn")) {
                    throw new IllegalArgumentException("invalid_email");
                }
                Query<Long> emailQuery = session.createQuery(
                        "SELECT COUNT(*) FROM Student s WHERE s.email = :email AND s.studentID != :studentID",
                        Long.class);
                emailQuery.setParameter("email", email);
                emailQuery.setParameter("studentID", fullStudent.getStudentID());
                if (emailQuery.uniqueResult() > 0) {
                    throw new IllegalArgumentException("invalid_email");
                }
            }

            // Cập nhật thông tin
            fullStudent.setFullName(fullName);
            fullStudent.setDateOfBirth(dateOfBirth);
            fullStudent.setGender(gender);
            fullStudent.setClassName(className);
            fullStudent.setDepartment(department);
            fullStudent.setPhoneNumber(phoneNumber);
            fullStudent.setEmail(email);

            session.update(fullStudent);
            request.getSession().setAttribute("student", fullStudent);

         // Ghi log
            CommonLogger.logEvent("Sinh viên ID " + fullStudent.getIdSinhVien() + " đã thay đổi thông tin");

            tx.commit();
            response.sendRedirect(request.getContextPath() + "/student/dashboard?message=update_success");
        } catch (IllegalArgumentException e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            request.setAttribute("error", e.getMessage());
            request.setAttribute("student", student);
            request.setAttribute("classes", CLASSES);
            request.setAttribute("departments", DEPARTMENTS);
            request.getRequestDispatcher("/student/updateProfile.jsp").forward(request, response);
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            request.setAttribute("error", "server_error");
            request.setAttribute("student", student);
            request.setAttribute("classes", CLASSES);
            request.setAttribute("departments", DEPARTMENTS);
            request.getRequestDispatcher("/student/updateProfile.jsp").forward(request, response);
        } finally {
            session.close();
        }
    }
}