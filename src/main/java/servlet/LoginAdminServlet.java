package servlet;

import entity.Manager;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/loginAdmin")
public class LoginAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int DEFAULT_PORT = 12345;
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/loginAdmin.jsp").forward(request, response);
    }
    
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
		String adminID = request.getParameter("AdminID");
		String password = request.getParameter("Password");

		String ipAddress = request.getRemoteAddr();
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isEmpty()) {
            ipAddress = forwardedFor.split(",")[0].trim();
        }

		if (adminID == null || adminID.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/loginAdmin.jsp?error=invalid");
            return;
        }
		
		Session session = HibernateUtil.getSessionFactory().openSession();
		try {
            System.out.println("Executing query: FROM Manager WHERE adminID = :adminID");

			Query<Manager> query = session.createQuery("FROM Manager WHERE adminID = :adminID", Manager.class);
            query.setParameter("adminID", adminID);
            Manager manager = query.uniqueResult();
            System.out.println("Manager found: " + (manager != null));

			if (manager != null && BCrypt.checkpw(password, manager.getPassword())) {
				manager.setIpAddress(ipAddress);
                manager.setPort(DEFAULT_PORT);
                session.beginTransaction();
                session.update(manager);
                session.getTransaction().commit();
                
				request.getSession().setAttribute("manager", manager);
                System.out.println("Password match: true");
                System.out.println("Login - Manager in session: " + request.getSession().getAttribute("manager"));
                String redirectUrl = request.getContextPath() + "/admin/dashboard";
                System.out.println("Redirecting to: " + redirectUrl);

				response.sendRedirect(request.getContextPath() + "/admin/dashboard");
			} else {
                System.out.println("Login failed: " + (manager == null ? "Manager not found" : "Invalid password"));

				response.sendRedirect(request.getContextPath() + "/loginAdmin.jsp?error=invalid_credentials");
			}
		} catch (Exception e) {
			e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/loginAdmin.jsp?error=database");
		} finally {
			session.close();
		}
	}
}