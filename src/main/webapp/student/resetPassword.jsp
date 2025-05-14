<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Lại Mật Khẩu</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/login.css">
</head>
<body>
    <div class="form-container">
        <header>
            <h2>Đặt Lại Mật Khẩu</h2>
        </header>
        <form action="<%=request.getContextPath()%>/resetPassword" method="post">
            <div class="form-group">
                <label for="newPassword">Mật khẩu mới:</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required 
                minlength="8" title="Mật khẩu phải có ít nhất 8 ký tự">
            </div>	
            <div class="form-group">
                <label for="confirmPassword">Xác nhận mật khẩu:</label>
                <input type="password" class="form-control" id="confirmPassword" 
                name="confirmPassword" required minlength="8">
            </div>
            <% String err = request.getParameter("error"); %>
            <% if (err != null) { %>
                <p class="error">
                    Lỗi: 
                    <% if ("password_mismatch".equals(err)) { %>
                        Mật khẩu không khớp!
                    <% } else if ("weak_password".equals(err)) { %>
                        Mật khẩu quá yếu!
                    <% } else { %>
                        <%= err %>
                    <% } %>
                </p>
            <% } %>
            <button type="submit" class="btn-login">Cập Nhật Mật Khẩu</button>
            <div class="links">
                <a href="<%=request.getContextPath()%>/login.jsp" class="footer-link">Quay lại đăng nhập</a>
            </div>
        </form>
    </div>
</body>
</html>