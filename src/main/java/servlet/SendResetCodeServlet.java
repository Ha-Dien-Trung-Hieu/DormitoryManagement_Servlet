package servlet;

import entity.Student;
import org.hibernate.Session;
import util.HibernateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;	
import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;

@WebServlet("/sendResetCode")
public class SendResetCodeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/forgetPassword.jsp?error=invalid_email");
            return;
        }

        // Kiểm tra email tồn tại trong cơ sở dữ liệu
        try (Session hibernateSession = HibernateUtil.getSessionFactory().openSession()) {
            Student student = hibernateSession.createQuery(
                    "FROM Student s WHERE s.email = :email", Student.class)
                .setParameter("email", email)
                .uniqueResult();

            if (student == null) {
                response.sendRedirect(request.getContextPath() + "/student/forgetPassword.jsp?error=invalid_email");
                return;
            }

            // Tạo mã 6 chữ số
            String resetCode = generateResetCode();

            request.getSession().setAttribute("resetCode", resetCode);
            request.getSession().setAttribute("resetEmail", email);

            // Gửi email
            boolean sent = sendEmail(email, resetCode);
            if (sent) {
                response.sendRedirect(request.getContextPath() + "/student/verifyCode.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/forgetPassword.jsp?error=email_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/student/forgetPassword.jsp?error=database");
        }
    }

    private String generateResetCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.format("%06d", code); 
    }

    private boolean sendEmail(String toEmail, String resetCode) {
        // Gmail SMTP
        String fromEmail = "trunghieu27032006@gmail.com"; 
        String password = "olbxmlmhrqqjrvum"; // App Password của Gmail

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
        	Message message = new MimeMessage(session);
        	message.setFrom(new InternetAddress(fromEmail));
        	message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        	message.setSubject("Mã Xác Nhận Đặt Lại Mật Khẩu");

        	String htmlContent = ""
+ "<!DOCTYPE html>"
+ "<html lang=\"vi\">"
+ "<head>"
+ "  <meta charset=\"UTF-8\">"
+ "  <title>Mã Xác Nhận</title>"
+ "</head>"
+ "<body style=\"font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;\">"
+ "  <table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">"
+ "    <tr>"
+ "      <td align=\"center\" style=\"padding: 20px 0;\">"
+ "        <table width=\"600\" cellpadding=\"0\" cellspacing=\"0\" style=\"background-color: #ffffff; border-radius: 8px; overflow: hidden;\">"
+ "          <tr>"
+ "            <td style=\"background-color: #007bff; color: #ffffff; padding: 20px; text-align: center; font-size: 24px;\">"
+ "              ĐẶT LẠI MẬT KHẨU"
+ "            </td>"
+ "          </tr>"
+ "          <tr>"
+ "            <td style=\"padding: 30px; color: #333333; font-size: 16px; line-height: 1.5;\">"
+ "              VKU Dormitory Xin chào,<br><br>"
+ "              Bạn nhận được email này vì đã yêu cầu đặt lại mật khẩu. Vui lòng sử dụng mã bên dưới để hoàn tất quá trình:<br><br>"
+ "              <div style=\"text-align: center; margin: 20px 0;\">"
+ "                <span style=\"display: inline-block; background-color: #e9ecef; padding: 15px 25px; font-size: 20px; font-weight: bold; letter-spacing: 2px;\">"
+                  resetCode
+ "                </span>"
+ "              </div>"
+ "              Mã sẽ hết hạn trong 10 phút. Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.<br><br>"
+ "              Trân trọng,<br>"
+ "              Đội ngũ Hỗ trợ Khách hàng VKU"
+ "            </td>"
+ "          </tr>"
+ "          <tr>"
+ "            <td style=\"background-color: #f1f1f1; color: #777777; font-size: 12px; text-align: center; padding: 15px;\">"
+ "              © 2025 VKU Dormitory. Mọi quyền được bảo lưu."
+ "            </td>"
+ "          </tr>"
+ "        </table>"
+ "      </td>"
+ "    </tr>"
+ "  </table>"
+ "</body>"
+ "</html>";

        	MimeBodyPart htmlPart = new MimeBodyPart();
        	htmlPart.setContent(htmlContent, "text/html; charset=UTF-8");

        	Multipart multipart = new MimeMultipart();
        	multipart.addBodyPart(htmlPart);

        	message.setContent(multipart);

        	Transport.send(message);
        	return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}