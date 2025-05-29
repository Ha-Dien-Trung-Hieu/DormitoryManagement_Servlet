<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Thông Tin Sinh Viên</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
   	<style>
   		body {
        background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
        background-size: cover;
        font-family: 'Arial', sans-serif;
        overflow-y: auto;
        scroll-behavior: smooth;
    }

    .container {
        margin-top: 30px;
        max-width: 850px;
        background: rgba(255, 255, 255, 0.92);
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .card {
        border: 2px solid #007bff;
        border-radius: 15px;
        box-shadow: 0 8px 20px rgba(0, 123, 255, 0.25);
        transition: transform 0.4s ease, box-shadow 0.4s ease;
    }

    .card:hover {
        transform: translateY(-6px);
        box-shadow: 0 12px 30px rgba(0, 123, 255, 0.35);
    }

    .card-header {
        background: linear-gradient(45deg, #007bff, #6610f2);
        color: white;
        font-weight: bold;
        font-size: 1.5rem;
        text-align: center;
        border-radius: 15px 15px 0 0;
    }

    .btn {
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .btn-success:hover {
        background-color: #28a745;
        transform: scale(1.05);
    }

    .btn-secondary:hover {
        background-color: #6c757d;
        transform: scale(1.05);
    }

    .form-group label {
        font-weight: bold;
        color: #333;
    }

    .form-control {
        border: 2px solid #ced4da;
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .form-control:hover {
        border-color: #80bdff;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
    }

    .form-control:focus {
        border-color: #007bff;
        box-shadow: 0 0 10px rgba(0, 123, 255, 0.7);
        transform: scale(1.02);
    }

    .alert {
        border-radius: 8px;
    }
   	</style>
   	
</head>
<body>
    <div class="container">
        <h1 class="text-center mb-4">Chỉnh Sửa Thông Tin Sinh Viên</h1>

        <!-- Thông báo -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <c:choose>
                    <c:when test="${error == 'server_error'}">Lỗi hệ thống, vui lòng thử lại!</c:when>
                    <c:when test="${error == 'invalid_email'}">Email không hợp lệ hoặc đã tồn tại!</c:when>
                    <c:when test="${error == 'invalid_phone'}">Số điện thoại không hợp lệ!</c:when>
                    <c:when test="${error == 'invalid_date'}">Ngày sinh không hợp lệ!</c:when>
                    <c:when test="${error == 'invalid_input'}">Dữ liệu đầu vào không hợp lệ!</c:when>
                </c:choose>
            </div>
        </c:if>
        <c:if test="${param.message == 'update_success'}">
            <div class="alert alert-success">Cập nhật thông tin thành công!</div>
        </c:if>

        <!-- Form chỉnh sửa -->
        <div class="card">
            <div class="card-header">Thông Tin Cá Nhân</div>
            <div class="card-body">
                <form action="<%=request.getContextPath()%>/student/updateProfile" method="post">
                    <div class="form-group">
                        <label for="idSinhVien">ID Sinh Viên:</label>
                        <input type="text" class="form-control" id="idSinhVien" value="${student.idSinhVien}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="fullName">Họ Tên:</label>
                        <input type="text" class="form-control" id="fullName" name="fullName" value="${student.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label for="dateOfBirth">Ngày Sinh:</label>
                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" value="<fmt:formatDate value='${student.dateOfBirth}' pattern='yyyy-MM-dd'/>" required>
                    </div>
                    <div class="form-group">
                        <label for="gender">Giới Tính:</label>
                        <select class="form-control" id="gender" name="gender" required>
                            <option value="Nam" ${student.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${student.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${student.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="className">Lớp:</label>
                        <select class="form-control" id="className" name="className" required>
                            <option value="">Chọn lớp</option>
                            <c:choose>
                                <c:when test="${not empty classes}">
                                    <c:forEach var="classItem" items="${classes}">
                                        <option value="${classItem}" ${student.className == classItem ? 'selected' : ''}>${classItem}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="" disabled>Không có lớp nào để chọn</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="department">Khoa:</label>
                        <select class="form-control" id="department" name="department" required>
                            <option value="">Chọn khoa</option>
                            <c:choose>
                                <c:when test="${not empty departments}">
                                    <c:forEach var="dept" items="${departments}">
                                        <option value="${dept}" ${student.department == dept ? 'selected' : ''}>${dept}</option>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <option value="" disabled>Không có khoa nào để chọn</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="phoneNumber">Số Điện Thoại:</label>
                        <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${student.phoneNumber}" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" class="form-control" id="email" name="email" value="${student.email}" required>
                    </div>
                    <button type="submit" class="btn btn-success">Lưu Thay Đổi</button>
                    <a href="<%=request.getContextPath()%>/student/dashboard" class="btn btn-secondary">Hủy</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>