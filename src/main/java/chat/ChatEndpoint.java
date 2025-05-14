package chat;

import entity.Message;
import entity.Room;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import util.HibernateUtil;

import java.io.*;
import java.net.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChatEndpoint {
    private static final SessionFactory sessionFactory = HibernateUtil.getSessionFactory();
    private static final Map<Integer, ServerSocket> roomServers = new HashMap<>();

    // Khởi động server TCP cho người dùng
    public static void startUserServer(int port) {
        new Thread(() -> {
            try (ServerSocket serverSocket = new ServerSocket(port)) {
                System.out.println("User TCP Server running on port " + port);
                while (!serverSocket.isClosed()) {
                    Socket clientSocket = serverSocket.accept();
                    new Thread(() -> handleClient(clientSocket)).start();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }

    // Khởi động server TCP cho tất cả phòng
    public static void startRoomServers() {
        try (Session session = sessionFactory.openSession()) {
            List<Room> rooms = session.createQuery("FROM Room", Room.class).list();
            String localIp = getLocalIpAddress();
            System.out.println("Local IP address: " + localIp);
            for (Room room : rooms) {
                if (room.getIpAddress() != null && room.getPort() > 0) {
                    startRoomServer(room.getRoomID(), room.getIpAddress(), room.getPort());
                } else {
                    System.out.println("Skipping RoomID " + room.getRoomID() + ": IP or port not configured");
                }
            }
        } catch (Exception e) {
            System.err.println("Error starting room servers: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Khởi động server TCP cho một phòng
    public static void startRoomServer(int roomID, String ipAddress, int port) {
    	new Thread(() -> {
            try {
                // Sử dụng 0.0.0.0 nếu IP cấu hình không khớp với IP cục bộ
                String bindIp = (ipAddress != null && ipAddress.equals(getLocalIpAddress())) ? ipAddress : "0.0.0.0";
                try (ServerSocket serverSocket = new ServerSocket(port, 50, InetAddress.getByName(bindIp))) {
                    roomServers.put(roomID, serverSocket);
                    System.out.println("Room server for RoomID " + roomID + " running at " + bindIp + ":" + port);
                    while (!serverSocket.isClosed()) {
                        Socket clientSocket = serverSocket.accept();
                        new Thread(() -> handleClient(clientSocket)).start();
                    }
                }
            } catch (IOException e) {
                System.err.println("Failed to start room server for RoomID " + roomID + " at " + ipAddress + ":" + port + ": " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }
	 // Lấy IP cục bộ của máy
	    private static String getLocalIpAddress() {
	        try {
	            return InetAddress.getLocalHost().getHostAddress();
	        } catch (UnknownHostException e) {
	            System.err.println("Cannot determine local IP address: " + e.getMessage());
	            return "127.0.0.1";
	        }
	    }
    // Xử lý kết nối từ client
    private static void handleClient(Socket socket) {
        try (DataInputStream in = new DataInputStream(socket.getInputStream())) {
            byte type = in.readByte();
            String senderID = in.readUTF();
            String receiverID = in.readUTF();

            if (type == 0x01) { // Tin nhắn
                int length = in.readInt();
                byte[] messageBytes = new byte[length];
                in.readFully(messageBytes);
                String message = new String(messageBytes, "UTF-8");
                saveMessage(senderID, receiverID, message, "message", null);
            } else if (type == 0x02) { // File
                int nameLength = in.readShort();
                byte[] nameBytes = new byte[nameLength];
                in.readFully(nameBytes);
                String fileName = new String(nameBytes, "UTF-8");
                long fileSize = in.readLong();
                byte[] fileData = new byte[(int) fileSize];
                in.readFully(fileData);
                saveMessage(senderID, receiverID, fileName, "file", fileData);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    // Gửi tin nhắn hoặc file tới máy khác
    public static void send(String ip, int port, String senderID, String receiverID, String content, String type, String fileName, byte[] fileData) {
        try (Socket socket = new Socket(ip, port);
             DataOutputStream out = new DataOutputStream(socket.getOutputStream())) {
            if (type.equals("message")) {
                out.writeByte(0x01);
                out.writeUTF(senderID);
                out.writeUTF(receiverID);
                byte[] messageBytes = content.getBytes("UTF-8");
                out.writeInt(messageBytes.length);
                out.write(messageBytes);
            } else if (type.equals("file")) {
                out.writeByte(0x02);
                out.writeUTF(senderID);
                out.writeUTF(receiverID);
                byte[] nameBytes = fileName.getBytes("UTF-8");
                out.writeShort(nameBytes.length);
                out.write(nameBytes);
                out.writeLong(fileData.length);
                out.write(fileData);
            }
        } catch (IOException e) {
            System.out.println("Failed to send to " + ip + ":" + port + ": " + e.getMessage());
        }
    }

    // Lưu tin nhắn hoặc file vào cơ sở dữ liệu
    private static void saveMessage(String senderID, String receiverID, String content, String type, byte[] fileData) {
        try (Session session = sessionFactory.openSession()) {
            session.beginTransaction();
            Message msg = new Message();
            msg.setSenderID(senderID);
            msg.setReceiverID(receiverID);
            msg.setMessage(content);
            msg.setType(type);
            msg.setFileData(fileData);
            msg.setTimestamp(new java.util.Date());
            msg.setRead(false);
            session.save(msg);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Dừng tất cả server
    public static void stopServers() {
        for (ServerSocket serverSocket : roomServers.values()) {
            try {
                if (serverSocket != null && !serverSocket.isClosed()) {
                    serverSocket.close();
                }
            } catch (IOException e) {
                System.err.println("Error closing server socket: " + e.getMessage());
            }
        }
        roomServers.clear();
    }
}