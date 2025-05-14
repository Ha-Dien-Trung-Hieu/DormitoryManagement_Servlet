package servlet;

import org.hibernate.Session;
import util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/genderData")
public class GenderDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Session session = HibernateUtil.getSessionFactory().openSession();
        long maleCount = (long) session.createQuery("select count(*) from Student where Gender='Male'").uniqueResult();
        long femaleCount = (long) session.createQuery("select count(*) from Student where Gender='Female'").uniqueResult();
        session.close();

        request.setAttribute("maleCount", maleCount);
        request.setAttribute("femaleCount", femaleCount);
        request.getRequestDispatcher("/admin/genderPieChart.jsp").forward(request, response);
    }
}