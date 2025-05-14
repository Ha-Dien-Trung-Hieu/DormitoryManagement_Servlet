<xaiArtifact artifact_id="b21e8d32-a9c3-4a05-8b7b-cff7fd85fa57"
	artifact_version_id="2e7e7bf6-25ce-4471-94df-08d757c40a18"
	title="login.jsp" contentType="text/html"> <%@ page
	language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html lang="vi">
<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Đăng Nhập</title>
		<link rel="stylesheet" href="<%=request.getContextPath()%>/css/login.css">
</head>
<body>
	<div class="form-container">
		<header>
			<h2>Đăng Nhập</h2>
		</header>		
		<form action="<%=request.getContextPath()%>/login" method="post">		
			<div class="form-group">
				<label for="IDSinhVien">ID Sinh Viên:</label> 
				<input type="text" class="form-control" id="IDSinhVien" name="IDSinhVien" required>
			</div>
			<div class="form-group">
				<label for="Password">Mật Khẩu:</label> 
				<input type="password" class="form-control" id="Password" name="Password" required>
			</div>
			
			<input type="submit" value="Đăng Nhập" class="btn-login">
			<div class="links">
                <a href="<%=request.getContextPath()%>/register.jsp" class="footer-link">Chưa có tài khoản? Đăng ký</a>
                <a href="<%=request.getContextPath()%>/student/forgetPassword.jsp" class="footer-link">Quên mật khẩu?</a>
            </div>
			<!-- Back -->
			<a href="<%=request.getContextPath()%>/index.jsp" class="back-link">Quay lại</a>
			<!-- Thông báo lỗi -->
            <% String err = request.getParameter("error"); %>
            <% String success = request.getParameter("success"); %>
            <% if (err != null) { %>
                <p class="error">
                    Lỗi: 
                    <% if ("invalid_credentials".equals(err)) { %>
                        Sai ID hoặc mật khẩu!
                    <% } else if ("database".equals(err)) { %>
                        Lỗi hệ thống, vui lòng thử lại!
                    <% } else if ("session_expired".equals(err)) { %>
                        Phiên xác minh đã hết hạn, vui lòng thử lại!
                    <% } else { %>
                        <%= err %>
                    <% } %>
                </p>
            <% } %>
            <% if (success != null && "password_reset".equals(success)) { %>
                <p class="success">Mật khẩu đã được đặt lại thành công! Vui lòng đăng nhập.</p>
            <% } %>
        </form>
	    	
	</div>
</body>
</html>
</xaiArtifact>