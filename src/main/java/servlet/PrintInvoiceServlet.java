package servlet;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.logging.Logger;

import javax.imageio.ImageIO;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Image;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

import entity.Invoice;
import entity.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.HibernateUtil;

@WebServlet("/student/printInvoice")
public class PrintInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SessionFactory sessionFactory;
    private static final Logger LOGGER = Logger.getLogger(PrintInvoiceServlet.class.getName());

    @Override
    public void init() throws ServletException {
        sessionFactory = HibernateUtil.getSessionFactory();
        LOGGER.info("PrintInvoiceServlet initialized with SessionFactory");
        LOGGER.info("Classpath: " + System.getProperty("java.class.path"));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("Received request for /student/printInvoice with contractID: " + request.getParameter("contractID"));

        // Kiểm tra sinh viên đăng nhập
        Student student = (Student) request.getSession().getAttribute("student");
        if (student == null) {
            LOGGER.warning("No student session found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=not_authenticated");
            return;
        }

        // Lấy contractID
        String contractID = request.getParameter("contractID");
        if (contractID == null || contractID.isEmpty()) {
            LOGGER.severe("Invalid contractID: " + contractID);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ContractID không hợp lệ.");
            return;
        }

        try (Session session = sessionFactory.openSession()) {
            LOGGER.info("Querying invoice for contractID: " + contractID);
            // Lấy hóa đơn mới nhất
            Invoice invoice = session.createQuery(
                    "FROM Invoice i WHERE i.contract.contractID = :contractID ORDER BY i.issueDate DESC", Invoice.class)
                    .setParameter("contractID", Integer.parseInt(contractID))
                    .setMaxResults(1)
                    .getSingleResult();

            if (invoice == null) {
                LOGGER.severe("No invoice found for contractID: " + contractID);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Hóa đơn không tồn tại.");
                return;
            }

            // Thiết lập response PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=invoice_" + invoice.getInvoiceID() + ".pdf");
            LOGGER.info("Set response headers for PDF, filename: invoice_" + invoice.getInvoiceID() + ".pdf");

            // Tạo PDF
            PdfWriter writer = new PdfWriter(response.getOutputStream());
            PdfDocument pdf = new PdfDocument(writer);
            pdf.addNewPage(); 
            Document document = new Document(pdf, com.itextpdf.kernel.geom.PageSize.A4);

            // Vẽ viền trang
            PdfCanvas canvas = new PdfCanvas(pdf.getFirstPage());
            Rectangle rect = new Rectangle(20, 20, com.itextpdf.kernel.geom.PageSize.A4.getWidth() - 40, com.itextpdf.kernel.geom.PageSize.A4.getHeight() - 40);
            canvas.setLineWidth(2);
            canvas.setStrokeColor(new DeviceRgb(64, 64, 64)); // DARK_GRAY
            canvas.rectangle(rect);
            canvas.stroke();

            // Định nghĩa font với Arial Unicode
            PdfFont font = PdfFontFactory.createFont("C:/Windows/Fonts/arial.ttf", "Identity-H", PdfFontFactory.EmbeddingStrategy.PREFER_EMBEDDED);
            com.itextpdf.kernel.colors.Color titleColor = new DeviceRgb(0, 123, 255); // #007bff
            com.itextpdf.kernel.colors.Color labelColor = new DeviceRgb(51, 153, 255); // #e9ecef
            com.itextpdf.kernel.colors.Color valueColor = new DeviceRgb(255, 51, 51); // #f1f1f1
            com.itextpdf.kernel.colors.Color statusColor = invoice.getPaymentStatus().equals("Paid") ? 
                DeviceRgb.GREEN : DeviceRgb.RED;
            com.itextpdf.kernel.colors.Color footerColor = new DeviceRgb(94, 139, 183); // GRAY

            // Thêm logo (nếu có)
            InputStream pngStream = getClass().getResourceAsStream("/images/logo.png");
            if (pngStream != null) {
                LOGGER.info("Loading logo.png from resources");
                byte[] pngBytes = readInputStreamToBytes(pngStream);
                pngStream.close();
                Image logo = new Image(ImageDataFactory.create(pngBytes));
                logo.scaleToFit(100, 100);
                logo.setTextAlignment(TextAlignment.CENTER);
                document.add(logo);
            } else {
                LOGGER.warning("Logo file not found: /images/logo.png");
            }

            // Tiêu đề
            Paragraph title = new Paragraph(new Text("HÓA ĐƠN PHÒNG KÝ TÚC XÁ").setFont(font).setFontSize(24).setFontColor(titleColor));
            title.setTextAlignment(TextAlignment.CENTER);
            title.setMarginBottom(20);
            document.add(title);

            // Bảng hóa đơn
            Table table = new Table(UnitValue.createPercentArray(new float[]{1, 2}));
            table.setWidth(UnitValue.createPercentValue(100));

            // Dữ liệu hóa đơn
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            addTableRow(table, "Mã Hóa Đơn:", String.valueOf(invoice.getInvoiceID()), font, labelColor, valueColor);
            addTableRow(table, "Họ Tên:", invoice.getContract().getStudent().getFullName(), font, labelColor, valueColor);
            addTableRow(table, "Mã Sinh Viên:", invoice.getContract().getStudent().getIdSinhVien(), font, labelColor, valueColor);
            addTableRow(table, "Phòng:", String.valueOf(invoice.getContract().getRoom().getRoomID()), font, labelColor, valueColor);
            addTableRow(table, "Loại Phòng:", invoice.getContract().getRoom().getRoomType(), font, labelColor, valueColor);
            addTableRow(table, "Ngày Phát Hành:", dateFormat.format(invoice.getIssueDate()), font, labelColor, valueColor);
            addTableRow(table, "Ngày Thanh Toán:", invoice.getPaymentDate() != null ? dateFormat.format(invoice.getPaymentDate()) : "Chưa thanh toán", font, labelColor, valueColor);
            addTableRow(table, "Số Tiền:", String.format("%,d VNĐ", invoice.getAmount()), font, labelColor, valueColor);
            String statusText = invoice.getPaymentStatus().equals("Paid") ? "Đã thanh toán" : "Chưa thanh toán";
            addTableRow(table, "Trạng Thái:", statusText, font, labelColor, statusColor);

            document.add(table);

            // Thêm QR code
            String qrContent = "Hóa đơn #" + invoice.getInvoiceID() + " - Sinh viên: " + invoice.getContract().getStudent().getFullName() + 
                              " - Phòng: " + invoice.getContract().getRoom().getRoomID() + " - Số tiền: " + invoice.getAmount() + " VNĐ";
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, 120, 120);
            BufferedImage qrImage = MatrixToImageWriter.toBufferedImage(bitMatrix);
            ByteArrayOutputStream qrBaos = new ByteArrayOutputStream();
            ImageIO.write(qrImage, "png", qrBaos);
            Image qrItextImage = new Image(ImageDataFactory.create(qrBaos.toByteArray()));
            qrItextImage.scaleToFit(100, 100);
            qrItextImage.setTextAlignment(TextAlignment.CENTER);
            qrItextImage.setMarginTop(20);
            document.add(qrItextImage);

            // Footer
            Paragraph footer = new Paragraph(new Text("Ký túc xá Đại học - Hệ thống quản lý\nHotline: 1800 1234 | www.dormitory.university.vn")
                .setFont(font).setFontSize(12).setFontColor(footerColor));
            footer.setTextAlignment(TextAlignment.CENTER);
            footer.setMarginTop(20);
            document.add(footer);

            LOGGER.info("Closing PDF document");
            document.close();

        } catch (Exception e) {
            LOGGER.severe("Error creating PDF: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tạo hóa đơn PDF: " + e.getMessage());
        }
    }

    /**
     * Thêm hàng vào Table, không dùng màu nền.
     */
    private void addTableRow(Table table, String label, String value, PdfFont font, 
                            com.itextpdf.kernel.colors.Color labelColor, com.itextpdf.kernel.colors.Color valueColor) {
        Cell labelCell = new Cell().add(new Paragraph(new Text(label).setFont(font).setFontSize(12).setFontColor(labelColor)));
        labelCell.setPadding(8);
        table.addCell(labelCell);

        Cell valueCell = new Cell().add(new Paragraph(new Text(value).setFont(font).setFontSize(12).setFontColor(valueColor)));
        valueCell.setPadding(8);
        table.addCell(valueCell);
    }

    /**
     * Đọc InputStream thành mảng byte.
     */
    private byte[] readInputStreamToBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int bytesRead;
        while ((bytesRead = inputStream.read(buffer)) != -1) {
            baos.write(buffer, 0, bytesRead);
        }
        return baos.toByteArray();
    }
}