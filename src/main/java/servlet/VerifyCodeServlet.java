package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/verifyCode")
public class VerifyCodeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputCode = request.getParameter("code");
        String resetCode = (String) request.getSession().getAttribute("resetCode");
        String resetEmail = (String) request.getSession().getAttribute("resetEmail");

        if (resetCode == null || resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/student/forgetPassword.jsp?error=expired");
            return;
        }

        if (inputCode.equals(resetCode)) {
            request.getSession().setAttribute("verified", true);
            response.sendRedirect(request.getContextPath() + "/student/resetPassword.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/verifyCode.jsp?error=invalid_code");
        }
    }
}