<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Minh Mã</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/login.css">
</head>
<body>
    <div class="form-container">
        <header>
            <h2>Xác Minh Mã</h2>
        </header>
        <form action="<%=request.getContextPath()%>/verifyCode" method="post">
            <div class="form-group">
                <label for="code">Nhập mã xác nhận (6 chữ số):</label>
                <input type="text" class="form-control" id="code" name="code" required 
                maxlength="6" pattern="\d{6}" title="Mã phải là 6 chữ số">
            </div>
            <% String err = request.getParameter("error"); %>
            <% if (err != null) { %>
                <p class="error">
                    Lỗi: 
                    <% if ("invalid_code".equals(err)) { %>
                        Mã xác nhận không đúng!
                    <% } else if ("expired".equals(err)) { %>
                        Mã xác nhận đã hết hạn!
                    <% } else { %>
                        <%= err %>
                    <% } %>
                </p>
            <% } %>
            <button type="submit" class="btn-login">Xác Minh</button>
            <div class="links">
                <a href="<%=request.getContextPath()%>/student/forgetPassword.jsp" class="footer-link">Gửi lại mã</a>
                <a href="<%=request.getContextPath()%>/login.jsp" class="footer-link">Quay lại đăng nhập</a>
            </div>
        </form>
    </div>
</body>
</html>