<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật Khẩu</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/login.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 400px;
            width: 100%;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
            margin: 5px;
        }
        .btn-primary {
            background-color: #3498db;
            color: #fff;
            border: none;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        .btn-secondary {
            background-color: #ccc;
            color: #333;
            border: none;
        }
        .btn-secondary:hover {
            background-color: #bbb;
        }
        .error {
            color: #e74c3c;
            margin-bottom: 15px;
        }
        .success {
            color: #2ecc71;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <header>
            <h2>Quên Mật Khẩu</h2>
        </header>
        <form action="<%=request.getContextPath()%>/sendResetCode" method="post">
            <div class="form-group">
                <label for="email">Nhập email của bạn:</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <!-- Thông báo lỗi hoặc thành công -->
            <% String err = request.getParameter("error"); %>
            <% String success = request.getParameter("success"); %>
            <% if (err != null) { %>
                <p class="error">
                    Lỗi: 
                    <% if ("invalid_email".equals(err)) { %>
                        Email không tồn tại!
                    <% } else if ("database".equals(err)) { %>
                        Lỗi hệ thống, vui lòng thử lại!
                    <% } else { %>
                        <%= err %>
                    <% } %>
                </p>
            <% } %>
            <% if (success != null && "code_sent".equals(success)) { %>
                <p class="success">Mã xác nhận đã được gửi đến email của bạn!</p>
            <% } %>
            <button type="submit" class="btn btn-primary">Gửi Mã</button>
			<div class="links">
			    <a href="<%=request.getContextPath()%>/login.jsp" class="footer-link">Quay lại Đăng Nhập</a>
            </div>   
        </form>
    </div>
</body>
</html>