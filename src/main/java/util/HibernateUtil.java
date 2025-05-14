package util;

import org.hibernate.SessionFactory;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import entity.Building;
import entity.Room;
import entity.Contract;
import entity.Student;
import entity.Invoice;
import entity.Manager;

public class HibernateUtil {
	private static final SessionFactory sessionFactory = buildSessionFactory();
	
	private static SessionFactory buildSessionFactory() {
        try {
        	StandardServiceRegistry registry = new StandardServiceRegistryBuilder()
                    .configure("hibernate.cfg.xml")
                    .build();
        	 MetadataSources sources = new MetadataSources(registry)
                     .addAnnotatedClass(Student.class)
                     .addAnnotatedClass(Building.class)
                     .addAnnotatedClass(Room.class)
                     .addAnnotatedClass(Contract.class)
                     .addAnnotatedClass(Invoice.class)
                     .addAnnotatedClass(Manager.class);
        	 Metadata metadata = sources.getMetadataBuilder().build();
             return metadata.getSessionFactoryBuilder().build();
        } catch (Throwable ex) {
            System.err.println("Initial SessionFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
    	if (sessionFactory != null) {
            sessionFactory.close();
        }    
    }
		
}