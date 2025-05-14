package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import entity.Message;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;

@WebServlet("/chat/history")
public class ChatHistoryServlet extends HttpServlet {
    private static final SessionFactory sessionFactory = new Configuration().configure().buildSessionFactory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String channel = request.getParameter("channel");
        if (channel == null || channel.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Session session = sessionFactory.openSession()) {
            List<Message> messages = session.createQuery("FROM Message WHERE receiverID = :channel ORDER BY timestamp", Message.class)
                    .setParameter("channel", channel)
                    .getResultList();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            new Gson().toJson(messages, response.getWriter());
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
        }
    }
}