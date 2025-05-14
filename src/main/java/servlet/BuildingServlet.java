package servlet;

import entity.Building;
import util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.query.Query;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/buildings")
public class BuildingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();

            Query<Building> buildingQuery = session.createQuery("FROM Building", Building.class);
            List<Building> buildings = buildingQuery.list();

            request.setAttribute("buildings", buildings);

            request.getRequestDispatcher("/admin/dashboard.jsp?section=buildings").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách tòa nhà: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}