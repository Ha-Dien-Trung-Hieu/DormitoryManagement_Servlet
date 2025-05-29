package chat;

import jakarta.websocket.*; 
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import entity.Manager;
import entity.Message;
import entity.Student;
import org.hibernate.SessionFactory;
import util.HibernateUtil;
import java.util.Base64;

@ServerEndpoint("/chat/{roomId}/{userId}")
public class ChatWebSocketEndpoint {
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    private static final SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
    private static final String CONTEXT_PATH = "/Dormitory_Management_Servlet"; 
    
    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") String roomId, @PathParam("userId") String userId) {
    	session.setMaxTextMessageBufferSize(10 * 1024 * 1024); // 10MB
        session.setMaxBinaryMessageBufferSize(10 * 1024 * 1024); 
    	session.getUserProperties().put("userId", userId);
        sessions.put(session.getId(), session);
        System.out.println("User " + userId + " connected to RoomID: " + roomId);
        broadcastToRoom(roomId, gson.toJson(new MessageObj(userId, getUserName(userId), getUserAvatarUrl(userId), new Date(), "User " + userId + " joined the room.", "message")));  
        }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("roomId") String roomId) {
        System.out.println("Received client message: " + message);
        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            String senderId = json.get("senderID").getAsString();
            String senderName = getUserName(senderId); 
            String avatarUrl = getUserAvatarUrl(senderId);
            String type = json.get("type").getAsString();
            String receiverId = json.has("receiverID") ? json.get("receiverID").getAsString() : null;
            String sentMessage;
            Date timestamp = new Date();
            
            if (type.equals("message")) {
                String msg = json.get("message").getAsString();
                System.out.println("Saving message - Sender: " + senderId + ", Message: " + msg + ", Receiver: " + receiverId);
                saveMessage(senderId, senderName, avatarUrl, receiverId != null ? receiverId : roomId, msg, type, null, null, timestamp);
                sentMessage = gson.toJson(new MessageObj(senderId, senderName, avatarUrl, timestamp, msg, type));
                if (receiverId != null) {
                    sendPrivateMessage(senderId, receiverId, sentMessage);
                } else {
                    broadcastToRoom(roomId, sentMessage);
                }
            } else if (type.equals("file")) {
                String fileName = json.get("fileName").getAsString();
                String fileData = json.get("fileData").getAsString();
                System.out.println("Processing file - Sender: " + senderId + ", File: " + fileName + ", Data length: " + fileData.length());
                byte[] fileBytes = Base64.getDecoder().decode(fileData);
                System.out.println("Decoded file bytes length: " + fileBytes.length);
                saveMessage(senderId, senderName, avatarUrl, receiverId != null ? receiverId : roomId, fileName, type, fileBytes, fileName, timestamp);
                sentMessage = gson.toJson(new MessageObj(senderId, senderName, avatarUrl, timestamp, fileName, type, fileData, fileName));
                if (receiverId != null) {
                    sendPrivateMessage(senderId, receiverId, sentMessage);
                } else {
                    broadcastToRoom(roomId, sentMessage);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session, @PathParam("roomId") String roomId) {
        String userId = (String) session.getUserProperties().get("userId");
        sessions.remove(session.getId());
        System.out.println("User " + userId + " disconnected from RoomID: " + roomId);
        broadcastToRoom(roomId, gson.toJson(new MessageObj(userId, getUserName(userId), getUserAvatarUrl(userId), new Date(), "User " + userId + " left the room.", "message")));
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("Error: " + throwable.getMessage());
    }

    private void broadcastToRoom(String roomId, String message) {
        sessions.values().stream()
            .filter(s -> s.isOpen() && roomId.equals(s.getPathParameters().get("roomId")))
            .forEach(s -> {
                try {
                    s.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
    }

    private void sendPrivateMessage(String senderId, String receiverId, String message) {
        sessions.values().stream()
            .filter(s -> s.isOpen() && (receiverId.equals(s.getUserProperties().get("userId")) || 
                                        senderId.equals(s.getUserProperties().get("userId"))))
            .forEach(s -> {
                try {
                    s.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
    }

    private void saveMessage(String senderId, String senderName, String avatarUrl, String receiverId, String message, String type, byte[] fileData, String fileName, Date timestamp) {
        try (org.hibernate.Session session = sessionFactory.openSession()) {
            session.beginTransaction();
            Message msg = new Message();
            msg.setSenderID(senderId);
            msg.setSenderName(senderName); 
            msg.setAvatarUrl(avatarUrl); 
            msg.setReceiverID(receiverId);
            if (type.equals("message")) {
                msg.setMessage(message);
            } else if (type.equals("file")) {
                msg.setMessage(fileName != null ? fileName : "[No file name]");
                msg.setFileName(fileName);
            }
            msg.setType(type);
            msg.setFileData(fileData);
            msg.setTimestamp(timestamp);
            msg.setRead(false);
            session.persist(msg);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getUserName(String userId) {
        try (org.hibernate.Session session = sessionFactory.openSession()) {
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

    private String getUserAvatarUrl(String userId) {
        try (org.hibernate.Session session = sessionFactory.openSession()) {
            if (userId.startsWith("admin_")) {
                return CONTEXT_PATH + "/images/avt.jpg";
            } else {
	            Student student = session.createQuery("FROM Student WHERE idSinhVien = :id", Student.class)
	                    .setParameter("id", userId)
	                    .uniqueResult();
	            if (student != null && student.getAvatar() != null) {
	                return "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(student.getAvatar());
	            }
            return CONTEXT_PATH + "/images/avt.jpg";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return CONTEXT_PATH + "/images/avt.jpg";
        }
    }

    private static class MessageObj {
        String senderID;
        String senderName;
        String avatarUrl;
        Date timestamp;
        String message;
        String type;
        String fileData;
        String fileName;

        MessageObj(String senderID, String senderName, String avatarUrl, Date timestamp, String message, String type) {
            this.senderID = senderID;
            this.senderName = senderName;
            this.avatarUrl = avatarUrl;
            this.timestamp = timestamp;
            this.message = message;
            this.type = type;
        }

        MessageObj(String senderID, String senderName, String avatarUrl, Date timestamp, String message, String type, String fileData, String fileName) {
            this.senderID = senderID;
            this.senderName = senderName;
            this.avatarUrl = avatarUrl;
            this.timestamp = timestamp;
            this.message = message;
            this.type = type;
            this.fileData = fileData;
            this.fileName = fileName;
        }
    }
}