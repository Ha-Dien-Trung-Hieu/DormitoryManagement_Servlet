package servlet;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import util.HibernateUtil;

@WebListener
public class AppInitializer implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            HibernateUtil.shutdown();
        } catch (Exception e) {
            System.err.println("Failed to shutdown Hibernate: " + e.getMessage());
            e.printStackTrace();
        }
    }
}