package servlet;

import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;

import util.HibernateUtil;
import java.io.IOException;
import java.io.InputStream;

@WebServlet("/student/updateAvatar")
@MultipartConfig(maxFileSize = 16 * 1024 * 1024) // 16MB
public class UpdateAvatarServlet extends HttpServlet {
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idSinhVien = request.getParameter("idSinhVien");
        Part filePart = request.getPart("avatar");

        System.out.println("Updating avatar for student: " + idSinhVien);

        if (idSinhVien == null || filePart == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Missing student ID or avatar file\"}");
            return;
        }

        String contentType = filePart.getContentType();
        if (!contentType.equals("image/png") && !contentType.equals("image/jpeg")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Only PNG or JPG files are allowed\"}");
            return;
        }

        try (InputStream inputStream = filePart.getInputStream()) {
            byte[] avatarData = inputStream.readAllBytes();
            System.out.println("Avatar file size: " + avatarData.length + " bytes");

            try (Session session = sessionFactory.openSession()) {
                session.beginTransaction();
                
                Query<Student> query = session.createQuery(
                        "FROM Student WHERE idSinhVien = :idSinhVien", Student.class);
                    query.setParameter("idSinhVien", idSinhVien);
                    Student student = query.uniqueResult();
                    
                if (student == null) {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"success\": false, \"message\": \"Student not found\"}");
                    session.getTransaction().rollback();
                    return;
                }

                student.setAvatar(avatarData);
                session.update(student);
                session.getTransaction().commit();
                request.getSession().setAttribute("student", student);
                System.out.println("Avatar updated successfully for student: " + idSinhVien);
                response.getWriter().write("{\"success\": true}");
            } catch (Exception e) {
                System.err.println("Error updating avatar: " + e.getMessage());
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update avatar: " + e.getMessage() + "\"}");
            }
        } catch (IOException e) {
            System.err.println("Error reading avatar file: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Error reading avatar file\"}");
        }
    }
}