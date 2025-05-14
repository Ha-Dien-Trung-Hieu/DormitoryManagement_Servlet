package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import util.HibernateUtil;
import entity.Invoice;

import java.io.IOException;
import java.util.Date;

@WebServlet("/admin/EditInvoiceServlet")
public class EditInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Session session = sessionFactory.openSession()) {
            String invoiceID = request.getParameter("invoiceID");
            if (invoiceID == null || invoiceID.isEmpty()) {
                request.setAttribute("errorMessage", "InvoiceID không hợp lệ.");
                request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
                return;
            }

            Invoice invoice = session.get(Invoice.class, Integer.parseInt(invoiceID));
            if (invoice == null) {
                request.setAttribute("errorMessage", "Hóa đơn không tồn tại.");
                request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
                return;
            }

            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải thông tin hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Session session = sessionFactory.openSession()) {
            String invoiceID = request.getParameter("invoiceID");
            String paymentStatus = request.getParameter("paymentStatus");

            if (invoiceID == null || paymentStatus == null || (!paymentStatus.equals("Paid") && !paymentStatus.equals("Unpaid"))) {
                request.setAttribute("errorMessage", "Dữ liệu không hợp lệ.");
                request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
                return;
            }

            Transaction transaction = session.beginTransaction();
            Invoice invoice = session.get(Invoice.class, Integer.parseInt(invoiceID));
            if (invoice == null) {
                transaction.rollback();
                request.setAttribute("errorMessage", "Hóa đơn không tồn tại.");
                request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
                return;
            }

            invoice.setPaymentStatus(paymentStatus);
            if (paymentStatus.equals("Paid")) {
                invoice.setPaymentDate(new Date());
            } else {
                invoice.setPaymentDate(null);
            }

            session.merge(invoice);
            transaction.commit();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?section=invoices");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi cập nhật hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("/admin/editInvoice.jsp").forward(request, response);
        }
    }
}