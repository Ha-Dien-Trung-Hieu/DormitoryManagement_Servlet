package servlet;

import chat.ChatEndpoint;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.HibernateUtil;

@WebListener
public class AppInitializer implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            System.out.println("Starting room servers...");
            ChatEndpoint.startRoomServers();
            System.out.println("Room servers started successfully");
        } catch (Exception e) {
            System.err.println("Failed to start room servers: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            System.out.println("Stopping room servers...");
            ChatEndpoint.stopServers();
            HibernateUtil.shutdown();
            System.out.println("Room servers stopped successfully");
        } catch (Exception e) {
            System.err.println("Failed to stop room servers: " + e.getMessage());
            e.printStackTrace();
        }
    }
}