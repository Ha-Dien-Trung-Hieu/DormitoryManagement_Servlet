<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chỉnh Sửa Hóa Đơn</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .form-wrapper { max-width: 800px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .form-title { text-align: center; margin-bottom: 20px; color: #2c3e50; }
        .form-group label { font-weight: 600; color: #34495e; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #dfe4ea; border-radius: 8px; font-size: 14px; }
        .form-group input:focus, .form-group select:focus { border-color: #4a90e2; outline: none; box-shadow: 0 2px 10px rgba(74, 144, 226, 0.2); }
        .btn-primary { background: linear-gradient(90deg, #4a90e2, #357abd); border: none; padding: 12px 20px; border-radius: 8px; color: #fff; font-weight: 500; transition: all 0.3s ease; }
        .btn-primary:hover { background: linear-gradient(90deg, #357abd, #4a90e2); transform: scale(1.05); }
        .btn-secondary { background: linear-gradient(90deg, #95a5a6, #7f8c8d); border: none; padding: 12px 20px; border-radius: 8px; color: #fff; font-weight: 500; transition: all 0.3s ease; }
        .btn-secondary:hover { background: linear-gradient(90deg, #7f8c8d, #95a5a6); transform: scale(1.05); }
        .alert { margin-bottom: 20px; }
        .info-table { width: 100%; border-collapse: collapse; font-size: 14px; color: #34495e; margin-bottom: 20px; }
        .info-table th, .info-table td { padding: 10px; border-bottom: 1px solid #dfe4ea; }
        .info-table th { font-weight: 600; color: #2c3e50; width: 30%; }
        .info-table td { color: #7f8c8d; }
		.form-control { height: 3rem; font-size: 1rem; }
	 </style>
</head>
<body>
    <div class="container form-wrapper">
        <h2 class="form-title">Chỉnh Sửa Hóa Đơn</h2>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/admin/EditInvoiceServlet" method="post" class="form">
            <input type="hidden" name="invoiceID" value="${invoice.invoiceID}" />
            <!-- Thông tin sinh viên -->
            <h4>Thông tin sinh viên</h4>
            <table class="info-table">
                <tr><th>IDSinhVien:</th><td>${invoice.contract.student.IDSinhVien}</td></tr>
                <tr><th>Họ Tên:</th><td>${invoice.contract.student.fullName}</td></tr>
                <tr><th>Ngày Sinh:</th><td><fmt:formatDate value="${invoice.contract.student.dateOfBirth}" pattern="dd/MM/yyyy"/></td></tr>
                <tr><th>Giới Tính:</th><td>${invoice.contract.student.gender}</td></tr>
                <tr><th>Lớp:</th><td>${invoice.contract.student.className}</td></tr>
                <tr><th>Khoa:</th><td>${invoice.contract.student.department}</td></tr>
                <tr><th>SĐT:</th><td>${invoice.contract.student.phoneNumber}</td></tr>
                <tr><th>Email:</th><td>${invoice.contract.student.email}</td></tr>
                <tr><th>CCCDID:</th><td>${invoice.contract.student.CCCDID}</td></tr>
                <tr><th>Trạng Thái:</th><td>${invoice.contract.student.status}</td></tr>
            </table>
            <!-- Thông tin phòng -->
            <h4>Thông tin phòng</h4>
            <table class="info-table">
                <tr><th>RoomID:</th><td>${invoice.contract.room.roomID}</td></tr>
                <tr><th>BuildingID:</th><td>${invoice.contract.room.building.name}</td></tr>
                <tr><th>RoomType:</th><td>${invoice.contract.room.roomType}</td></tr>
                <tr><th>Sức chứa:</th><td>${invoice.contract.room.capacity}</td></tr>
                <tr><th>Giá phòng:</th><td><fmt:setLocale value="vi_VN"/><fmt:formatNumber value="${invoice.contract.room.price}" type="number" groupingUsed="true"/> VNĐ</td></tr>
            </table>
            <!-- Thông tin hợp đồng và hóa đơn -->
            <h4>Thông tin hợp đồng và hóa đơn</h4>
            <table class="info-table">
                <tr><th>ContractID:</th><td>${invoice.contract.contractID}</td></tr>
                <tr><th>StartDate:</th><td><fmt:formatDate value="${invoice.contract.startDate}" pattern="dd/MM/yyyy"/></td></tr>
                <tr><th>EndDate:</th><td><fmt:formatDate value="${invoice.contract.endDate}" pattern="dd/MM/yyyy"/></td></tr>
                <tr><th>Contract Status:</th><td>${invoice.contract.status}</td></tr>
                <tr><th>InvoiceID:</th><td>${invoice.invoiceID}</td></tr>
                <tr><th>IssueDate:</th><td><fmt:formatDate value="${invoice.issueDate}" pattern="dd/MM/yyyy"/></td></tr>
                <tr><th>PaymentDate:</th><td><fmt:formatDate value="${invoice.paymentDate}" pattern="dd/MM/yyyy"/></td></tr>
                <tr><th>Amount:</th><td><fmt:setLocale value="vi_VN"/><fmt:formatNumber value="${invoice.amount}" type="number" groupingUsed="true"/> VNĐ</td></tr>
            </table>
            <!-- Chỉnh sửa PaymentStatus -->
            <h4>Chỉnh sửa trạng thái thanh toán</h4>
            <div class="form-group">
                <label for="paymentStatus">PaymentStatus:</label>
                <select id="paymentStatus" name="paymentStatus" class="form-control">
                    <option value="Paid" ${invoice.paymentStatus == 'Paid' ? 'selected' : ''}>Paid</option>
                    <option value="Unpaid" ${invoice.paymentStatus == 'Unpaid' ? 'selected' : ''}>Unpaid</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Cập Nhật</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/admin/dashboard?section=invoices'">Quay Lại</button>
        </form>
    </div>
</body>
</html>