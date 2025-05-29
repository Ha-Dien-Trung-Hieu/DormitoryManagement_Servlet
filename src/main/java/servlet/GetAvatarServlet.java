package servlet;

import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import util.HibernateUtil;
import java.io.IOException;
import java.util.Base64;

@WebServlet("/student/getAvatar")
public class GetAvatarServlet extends HttpServlet {
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idSinhVien = request.getParameter("idSinhVien");
        System.out.println("Fetching avatar for student: " + idSinhVien);

        if (idSinhVien == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing student ID\"}");
            return;
        }

        try (Session session = sessionFactory.openSession()) {
            Query<Student> query = session.createQuery(
                "FROM Student WHERE idSinhVien = :idSinhVien", Student.class);
            query.setParameter("idSinhVien", idSinhVien);
            Student student = query.uniqueResult();

            if (student == null || student.getAvatar() == null) {
                System.out.println("No avatar found for student: " + idSinhVien);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"avatar\": null}");
                return;
            }

            String avatarBase64 = Base64.getEncoder().encodeToString(student.getAvatar());
            System.out.println("Avatar Base64 length: " + avatarBase64.length());
            response.getWriter().write("{\"avatar\": \"" + avatarBase64 + "\", \"mimeType\": \"image/jpeg\"}");
        } catch (Exception e) {
            System.err.println("Error fetching avatar for student " + idSinhVien + ": " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to fetch avatar: " + e.getMessage() + "\"}");
        }
    }
}