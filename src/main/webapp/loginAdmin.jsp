<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập Admin</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
			background: linear-gradient(135deg, #fa66ab, #fbc2eb, #a18cd1);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .form-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            width: 400px;
            text-align: center;
        }
        .form-container h2 {
            color: #333;
            margin-top: -10px;
            margin-bottom: 30px;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
            
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            transition: border-color 0.3s ease;
        }
        .form-group input:focus {
            border-color: #4a90e2;
            outline: none;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #4a90e2;
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.2s ease, background-color 0.3s ease;
        }
        .btn-login:hover {
            transform: scale(1.05);
            background-color: #357ABD;
        }
        .links {
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
        }
        .links a {
            color: #4a90e2;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s ease;
        }
        .links a:hover {
            color: #2c598e;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            color: #4a90e2;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.2s ease;
        }
        .back-link:hover {
            color: #2c598e;
        }
        .error {
            color: #e74c3c;
            margin-top: 10px;
        }
        .success {
            color: #2ecc71;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <header>
            <h2>Đăng Nhập Admin</h2>
        </header>
        <form action="<%=request.getContextPath()%>/loginAdmin" method="post">
            <div class="form-group">
                <label for="AdminID">ID Admin</label>
                <input type="text" class="form-control" id="AdminID" name="AdminID" required>
            </div>
            <div class="form-group" style="margin-top : 30px">
                <label for="Password">Mật Khẩu</label>
                <input type="password" class="form-control" id="Password" name="Password" required>
            </div>
            <input type="submit" value="Đăng Nhập" class="btn-login">
           
            <!-- Back -->
            <a href="<%=request.getContextPath()%>/index.jsp" class="back-link">Quay lại</a>
            <!-- Thông báo lỗi -->
            <% String err = request.getParameter("error"); %>
            <% String success = request.getParameter("success"); %>
            <% if (err != null) { %>
                <p class="error">
                    Lỗi: 
                    <% if ("invalid".equals(err)) { %>
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