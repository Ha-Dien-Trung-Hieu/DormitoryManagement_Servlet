<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Phòng Thành Công</title>
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
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }
        h2 {
            color: #2ecc71;
            margin-bottom: 20px;
        }
        p {
            color: #555;
            font-size: 18px;
            margin-bottom: 30px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #3498db;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .icon {
            font-size: 50px;
            color: #2ecc71;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">✔</div>
        <h2>Đặt Phòng Thành Công!</h2>
        <p>Chúc mừng bạn đã đặt phòng thành công. Hợp đồng của bạn đã được tạo và sẽ có hiệu lực ngay lập tức.</p>
        <a href="<%=request.getContextPath()%>/student/dashboard" class="btn">Quay lại Dashboard</a>
    </div>
</body>
</html>