package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import entity.Manager;
import entity.Message;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import util.HibernateUtil;
import java.io.IOException;
import java.util.List;
import java.util.Base64;
import java.util.Date;

@WebServlet("/chat/history")
public class ChatHistoryServlet extends HttpServlet {
    private SessionFactory sessionFactory;
    private Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String channel = request.getParameter("channel");
        String userId = request.getParameter("userId");
        System.out.println("Loading history for channel: " + channel + ", userId: " + userId);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (channel == null || userId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing channel or userId\"}");
            return;
        }

        try (Session session = sessionFactory.openSession()) {
            List<Message> messages;
            if (channel.startsWith("room_")) {
                String roomId = channel.split("_")[1];
                System.out.println("Querying room messages for roomId: " + roomId);
                messages = session.createQuery(
                        "FROM Message m WHERE m.receiverID = :roomId ORDER BY m.timestamp ASC",
                        Message.class)
                        .setParameter("roomId", roomId)
                        .setMaxResults(20)
                        .getResultList();
            } else {
                System.out.println("Querying private messages between userId: " + userId + " and receiverId: " + channel);
                messages = session.createQuery(
                        "FROM Message m WHERE ((m.senderID = :userId AND m.receiverID = :receiverId) OR " +
                        "(m.senderID = :receiverId AND m.receiverID = :userId)) ORDER BY m.timestamp ASC",
                        Message.class)
                        .setParameter("userId", userId)
                        .setParameter("receiverId", channel)
                        .setMaxResults(20)
                        .getResultList();
            }

            System.out.println("Found " + messages.size() + " messages");
            JsonArray jsonArray = new JsonArray();
            for (Message msg : messages) {
                JsonObject jsonMsg = new JsonObject();
                jsonMsg.addProperty("senderID", msg.getSenderID());
                jsonMsg.addProperty("senderName", getUserName(msg.getSenderID(), session));
                jsonMsg.addProperty("avatarUrl", getUserAvatarUrl(msg.getSenderID(), session, request));
                jsonMsg.addProperty("timestamp", msg.getTimestamp() != null ? msg.getTimestamp().toInstant().toString() : new Date().toInstant().toString());
                jsonMsg.addProperty("message", msg.getMessage());
                jsonMsg.addProperty("type", msg.getType());
                jsonMsg.addProperty("fileName", msg.getFileName() != null ? msg.getFileName() : null);

                if (msg.getFileData() != null) {
                    String base64Data = Base64.getEncoder().encodeToString(msg.getFileData());
                    jsonMsg.addProperty("fileData", base64Data);
                    System.out.println("Encoded file for message ID " + msg.getMessageID() + ", FileName: " + msg.getFileName() + ", Base64 length: " + base64Data.length());
                } else {
                    jsonMsg.addProperty("fileData", (String) null);
                }

                jsonArray.add(jsonMsg);
            }

            String jsonOutput = jsonArray.toString();
            System.out.println("Returning JSON: " + jsonOutput.substring(0, Math.min(jsonOutput.length(), 100)) + "...");
            response.getWriter().write(jsonOutput);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Failed to load chat history: " + e.getMessage() + "\"}");
        }
    }

    private String getUserName(String userId, Session session) {
    	try {
            if (userId.startsWith("admin_")) {
                Manager manager = session.createQuery("FROM Manager WHERE adminID = :id", Manager.class)
                        .setParameter("id", userId)
                        .uniqueResult();
                return manager != null ? manager.getFullName() : "Unknown Admin";
            } else {
                Student student = session.createQuery("FROM Student WHERE idSinhVien = :id", Student.class)
                        .setParameter("id", userId)
                        .uniqueResult();
                return student != null ? student.getFullName() : "Unknown User";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "Unknown User";
        }
    }
    private String getUserAvatarUrl(String userId, Session session, HttpServletRequest request) {
    	try {
    		String contextPath = request.getContextPath();
            if (userId.startsWith("admin_")) {
            	return contextPath + "/images/avt.jpg";
            } else {
                Student student = session.createQuery("FROM Student WHERE idSinhVien = :id", Student.class)
                        .setParameter("id", userId)
                        .uniqueResult();
                if (student != null && student.getAvatar() != null) {
                    return "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(student.getAvatar());
                }
                return contextPath + "/images/avt.jpg";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return request.getContextPath() + "/images/avt.jpg";
        }
    }
}