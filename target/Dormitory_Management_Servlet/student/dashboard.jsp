<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="entity.Student" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Sinh Viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	  		background: linear-gradient(to right, #74ebd5, #acb6e5);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        /* Header */
        header {
            background: linear-gradient(90deg, #4a90e2, #357abd);
            color: #fff;
            padding: 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        }
        header img.logo {
        	margin-left: 50px;
            height: 50px;
            transition: transform 0.3s ease;
        }
        header img.logo:hover {
            transform: scale(1.05);
        }
        header .title {
            font-size: 2rem;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
          	margin-right: 50px;
        	
        }
        /* Left */
        .left-nav {
            width: 15%;
            background: linear-gradient(180deg, #2c3e50, #3498db);
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
        }
        .left-nav ul {
            list-style: none;
            padding: 0;
        }
        .left-nav li {
            margin-bottom: 15px;
        }
        .left-nav a {
            height: 50px;
            display: flex;
            align-items: center;
            padding: 12px;
            text-decoration: none;
            color: #fff;
            font-size: 16px;
            font-weight: 500;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        .left-nav a i {
            margin-right: 10px;
            font-size: 18px;
        }
        .left-nav a:hover {
            background: linear-gradient(90deg, #e74c3c, #c0392b);
            transform: translateX(5px);
        }
        .left-nav a.active {
            background: linear-gradient(90deg, #4a90e2, #357abd);
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        }
        /* Main */
        .main-content {
            flex: 1;
            padding: 20px;
        }
        .main-content h1 {
            color: #333;
            margin-bottom: 20px;
        }
        .content-card {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .content-card h3 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
        }
        .content-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            color: #34495e;
        }
        .content-table th, .content-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #dfe4ea;
            transition: background 0.3s ease;
        }
        .content-table th {
            font-weight: 600;
            color: #2c3e50;
            background: rgba(78, 115, 223, 0.1); /* Đậm hơn cho cột đầu */
        }
        .content-table td {
            color: #7f8c8d;
        }
        .content-table tr:hover td {
            background: rgba(78, 115, 223, 0.05);
        }
        .content-table tr:first-child {
            background: rgba(78, 115, 223, 0.1); /* Đậm hơn cho hàng đầu của bảng bạn cùng phòng */
        }
     	.chat-box {
		    height: 400px;
		    overflow-y: auto;
		    padding: 15px;
		    border: 1px solid #dfe4ea;
		    border-radius: 8px;
		    background: #f9f9f9;
		    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
		}
		.message {
		    display: flex;
		    margin-bottom: 15px;
		    align-items: flex-start;
		}
		.message.sent {
		    flex-direction: row-reverse;
		}
		.message.sent .message-content {
		    align-items: flex-end;
		}
		.message.received .avatar {
		    margin-right: 10px;
		}
		.message.sent .avatar {
		    margin-left: 10px;
		}
		.avatar {
		    width: 40px;
		    height: 40px;
		    border-radius: 50%;
		    object-fit: cover;
		}
		.message-content {
		    display: flex;
		    flex-direction: column;
		    min-width: 0;
		}
		.message-header {
		    display: flex;
		    font-size: 14px;
		    margin-bottom: 5px;
		    /* Bỏ justify-content: space-between */
		}
		.message.sent .message-header {
		    justify-content: flex-end; /* Căn phải cho tin nhắn gửi */
		}
		.header-group {
		    display: flex;
		    align-items: center;
		    gap: 5px; /* Khoảng cách cố định giữa .name và .time */
		}
		.name {
		    font-weight: 600;
		    color: #2c3e50;
		}
		.message.sent .name {
		    color: #4a90e2;
		}
		.time {
		    color: #888;
		    font-size: 12px;
		    flex-shrink: 0;
		}
		.message.sent .time {
		    margin-right: 0;
		    margin-left: 10px;
		}
		.message.received .time {
		    margin-right: 0;
		    margin-left: 10px;
		}
		.text {
		    padding: 8px 12px;
		    border-radius: 12px;
		    word-wrap: break-word;
		    font-size: 14px;
		    line-height: 1.4;
		    min-width: 0;
		}
		.message.received .text {
		    background: #e9ecef;
		    color: #34495e;
		}
		.message.sent .text {
		    background: #4a90e2;
		    color: #fff;
		}
		.text a {
		    color: inherit;
		    text-decoration: underline;
		}
		.text a:hover {
		    text-decoration: none;
		}

        .input-group {
            display: flex;
            gap: 10px;
        }
        .input-group input {
            flex: 1;
            padding: 10px;
            border: 1px solid #dfe4ea;
            border-radius: 8px;
            font-size: 14px;
        }
        .input-group button {
            padding: 10px 20px;
            background: linear-gradient(90deg, #4a90e2, #357abd);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .input-group button:hover {
            background: linear-gradient(90deg, #357abd, #4a90e2);
            transform: scale(1.05);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-size: 14px;
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 5px;
            display: block;
        }
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #dfe4ea;
            border-radius: 8px;
            font-size: 14px;
            color: #34495e;
        }
        .btn-submit {
            display: block;
            width: 100%;
            padding: 12px;
            background: linear-gradient(90deg, #2ecc71, #27ae60);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            background: linear-gradient(90deg, #27ae60, #2ecc71);
            transform: scale(1.05);
        }
        .btn-submit:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        .alert {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            text-align: center;
        }
        .alert-success {
            background: #e0f7e9;
            color: #27ae60;
        }
        .alert-danger {
            background: #fce4e4;
            color: #e74c3c;
        }
        /* Right */
        .avatar-upload {
		    margin: 10px 0;
		    text-align: center;
		}
		.btn-upload {
		    background-color: #4CAF50;
		    color: white;
		    padding: 8px 16px;
		    border: none;
		    border-radius: 4px;
		    cursor: pointer;
		    margin: 0 5px;
		}
		.btn-upload:disabled {
		    background-color: #cccccc;
		    cursor: not-allowed;
		}
        .right-panel {
            width: 280px;
            background: #fff;
            padding: 20px;
            box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
        }
        .profile-card {
            padding: 20px;
            border-radius: 12px;
            background: linear-gradient(135deg, #ecf0f1, #dfe4ea);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .profile-card img{
        	width: 35%; 
        	height: auto;
        	
        }
        .profile-card:hover {
            transform: translateY(-5px);
        }
        .avatar-right {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 15px;
            border: 3px solid #4a90e2;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .avatar-right:hover {
            transform: scale(1.05);
        }
        .profile-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            color: #34495e;
        }
        .profile-table th, .profile-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #dfe4ea;
            transition: background 0.3s ease;
        }
        .profile-table th {
            font-weight: 600;
            color: #2c3e50;
            width: 40%;
        }
        .profile-table td {
            color: #7f8c8d;
        }
        .profile-table tr:hover td {
            background: rgba(78, 115, 223, 0.05);
        }
        .button-container {
		    text-align: center; 
		    margin-top: 5px;
		}
        .btn-update {
		    display: inline-block;
		    padding: 12px;
		    background: linear-gradient(90deg, #3498db, #2980b9); /* Màu xanh dương */
		    color: #fff;
		    text-decoration: none;
		    border-radius: 8px;
		    margin-top: 20px;
		    text-align: center;
		    font-weight: 500;
		    transition: transform 0.3s ease, background 0.3s ease;
		}
		
		.btn-update:hover {
		    background: linear-gradient(90deg, #2980b9, #3498db); /* Đảo ngược gradient khi hover */
		    transform: scale(1.05);
		}
        .btn-logout {
            display: inline-block;
            padding: 12px;
            background: linear-gradient(90deg, #e74c3c, #c0392b);
            color: #fff;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: 500;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        .btn-logout:hover {
            transform: scale(1.05);
            background: linear-gradient(90deg, #c0392b, #e74c3c);
        }
        .error-message {
            color: #e74c3c;
            font-size: 14px;
            text-align: center;
            margin-bottom: 10px;
        }
        .btn-print {
            background: linear-gradient(90deg, #3498db, #2980b9);
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
        }
        .btn-print:hover {
            background: linear-gradient(90deg, #2980b9, #3498db);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <img src="<%=request.getContextPath()%>/images/login/logo.png" alt="Logo" class="logo">
        <div class="title">Dashboard</div>
    </header>

    <!-- Dashboard Content -->
    <div class="dashboard-container">
        <!-- Left Navigation -->
        <div class="left-nav">
            <ul>
                <li><a href="?section=home" class="${param.section == 'home' || empty param.section ? 'active' : ''}">
                    <i class="fas fa-home"></i> Trang chủ</a></li>
                <li><a href="?section=bookRoom" class="${param.section == 'bookRoom' ? 'active' : ''}">
                    <i class="fas fa-book"></i> Đặt phòng</a></li>
                <li><a href="?section=invoices" class="${param.section == 'invoices' ? 'active' : ''}">
                    <i class="fas fa-file-invoice"></i> Hóa đơn</a></li>
                <li><a href="?section=chat" class="${param.section == 'chat' ? 'active' : ''}">
                    <i class="fas fa-comments"></i> Chat nhóm</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Thông báo -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <c:choose>
                        <c:when test="${error == 'server_error'}">Lỗi hệ thống, vui lòng thử lại!</c:when>
                        <c:when test="${error == 'invalid_room_id'}">ID phòng không hợp lệ!</c:when>
                        <c:when test="${error == 'room_not_found'}">Phòng không tồn tại!</c:when>
                        <c:when test="${error == 'room_full'}">Phòng đã đầy!</c:when>
                        <c:when test="${error == 'booking_failed'}">
                            Đặt phòng thất bại! Lý do: ${not empty param.reason ? param.reason : 'Không xác định'}
                        </c:when>
                    </c:choose>
                </div>
            </c:if>
            <c:if test="${param.message == 'booking_success'}">
                <div class="alert alert-success">Đặt phòng thành công!</div>
            </c:if>
            <c:if test="${param.message == 'update_success'}">
                <div class="alert alert-success">Cập nhật thông tin thành công!</div>
            </c:if>
			<!-- Dùng time để hiển thị cho Student biết khi nào cần thanh toán -->
			<c:if test="${not empty lockRemainingTime and lockRemainingTime > 0}">
			    <div class="alert alert-warning">
			        Phòng đã bị khóa. Thời gian để thanh toán: <span id="lockTimer"></span>
			        <input type="hidden" id="lockRemainingTime" value="${lockRemainingTime * 24 * 60 * 60 * 1000}">
			    </div>
			    <script>
			        function updateLockTimer() {
			            const remainingTime = parseInt(document.getElementById('lockRemainingTime').value);
			            if (remainingTime > 0) {
			                const days = Math.floor(remainingTime / (1000 * 60 * 60 * 24)); // 24h
			                const hours = Math.floor((remainingTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)); //1h
			                const minutes = Math.floor((remainingTime % (1000 * 60 * 60)) / (1000 * 60)); // 1p
			                const seconds = Math.floor((remainingTime % (1000 * 60)) / 1000); // 1s
			                document.getElementById('lockTimer').innerText = `${days}d ${hours}h ${minutes}m ${seconds}s`;
			                setTimeout(updateLockTimer, 1000);
			                document.getElementById('lockRemainingTime').value = remainingTime - 1000;
			            } else {
			                document.getElementById('lockTimer').innerText = "Đã mở khóa";
			            }
			        }
			        updateLockTimer();
			    </script>
			</c:if>
            <c:choose>
                <c:when test="${param.section == 'home' || empty param.section}">
                    <div class="content-card">
                        <h3>Thông tin phòng</h3>
                        <c:choose>
                            <c:when test="${not empty student.contract and student.contract.status == 'Active'}">
                                <table class="content-table">
                                    <tr>
                                        <th>ID Phòng:</th>
                                        <td>${student.contract.room.roomID}</td>
                                    </tr>
                                    <tr>
                                        <th>Loại Phòng:</th>
                                        <td>${student.contract.room.roomType}</td>
                                    </tr>
                                    <tr>
                                        <th>Giá Phòng:</th>
                                        <td><fmt:formatNumber value="${student.contract.room.price}" type="number" groupingUsed="true"/> VNĐ</td>
                                    </tr>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <p class="error-message">Bạn chưa có phòng. Vui lòng chọn "Đặt phòng" để chọn phòng.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${not empty student.contract and student.contract.status == 'Active'}">
                        <div class="content-card">
                            <h3>Bạn cùng phòng</h3>
                            <c:if test="${not empty roommates}">
                                <table class="content-table">
                                    <tr>
                                        <th>ID</th>
                                        <th>Họ tên</th>
                                        <th>SĐT</th>
                                    </tr>
                                    <c:forEach var="roommate" items="${roommates}">
                                        <tr>
                                            <td>${roommate.idSinhVien}</td>
                                            <td>${roommate.fullName}</td>
                                            <td>${roommate.phoneNumber}</td>
                                        </tr>
                                    </c:forEach>
                                </table>
                            </c:if>
                            <c:if test="${empty roommates}">
                                <p class="error-message">Không có bạn cùng phòng.</p>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:when test="${param.section == 'bookRoom'}">
                     <div class="content-card">
			        <h3>Đặt phòng</h3>
			        <c:choose>
			            <c:when test="${not empty student.contract and student.contract.status == 'Active'}">
			                <p class="error-message">Bạn đã có phòng.</p>
			            </c:when>
			            <c:otherwise>
			                <!-- Tabs cho tòa nhà -->
			                <div class="tabs mb-4">
			                    <ul class="flex border-b">
			                        <c:forEach var="building" items="${buildings}">
			                            <li class="mr-1">
			                                <a class="tab-link inline-block py-2 px-4 font-semibold cursor-pointer ${building.name == 'A' ? 'bg-blue-500 text-white' : 'bg-gray-200'}" data-building="${building.name}">
			                                    Tòa ${building.name}
			                                </a>
			                            </li>
			                        </c:forEach>
			                    </ul>
			                </div>
			
			                <div class="flex">
			                    <!-- Danh sách tầng -->
			                    <div class="w-1/6 bg-white p-4 rounded shadow">
			                        <h2 class="text-lg font-semibold mb-2">Tầng</h2>
			                        <ul>
			                            <c:forEach var="floor" begin="1" end="5">
			                                <li class="floor-link py-2 px-4 cursor-pointer ${floor == 1 ? 'bg-blue-500 text-white' : 'bg-gray-100'}" data-floor="${floor}">
			                                    Tầng ${floor}
			                                </li>
			                            </c:forEach>
			                        </ul>
			                    </div>
			
			                    <!-- Khu vực hiển thị phòng -->
			                    <div class="w-5/6 ml-4 bg-white p-4 rounded shadow">
			                        <h2 class="text-lg font-semibold mb-4" id="roomTitle">Phòng - Tòa A, Tầng 1</h2>
			                        <div id="roomGrid" class="grid grid-cols-3 gap-4">
			                            <c:forEach var="room" items="${buildings[0].rooms}">
			                                <c:if test="${fn:substring(room.roomName, 1, 3) == 'A01'}">
			                                    <div class="room-card p-4 border rounded ${room.currentOccupants < room.capacity ? 'bg-green-100 cursor-pointer' : 'bg-red-100 cursor-not-allowed'}" data-room="${room.roomName}">
			                                        <div class="flex justify-between items-center">
			                                            <div>
			                                                <p><strong>${room.roomName}</strong> (${room.capacity} người${room.currentOccupants >= room.capacity ? ', Full' : ''})</p>
			                                                <p>Loại: ${room.roomType}</p>
			                                                <p>Giá: <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true"/> VNĐ</p>
			                                            </div>
			                                            <div class="flex space-x-1">
			                                                <c:forEach var="i" begin="1" end="${room.capacity}">
			                                                    <div class="w-6 h-6 rounded ${i <= room.currentOccupants ? 'bg-gray-500' : 'bg-green-500'}"></div>
			                                                </c:forEach>
			                                            </div>
			                                        </div>
			                                    </div>
			                                </c:if>
			                            </c:forEach>
			                        </div>
			                    </div>
			                </div>
			
			                <!-- Form đặt phòng -->
			                <form id="bookingForm" action="<%=request.getContextPath()%>/student/bookRoom" method="post" class="mt-4">
			                    <input type="hidden" name="RoomName" id="selectedRoomName">
			                    <button type="submit" class="btn-submit" id="submitButton" disabled>Đặt Phòng</button>
			                </form>
			            </c:otherwise>
			        </c:choose>
			    </div>
                </c:when>
                <c:when test="${param.section == 'invoices'}">
                    <div class="content-card">
                        <h3>Hóa đơn <c:if test="${not empty unpaidInvoices and unpaidInvoices.size() > 0}">(Chưa thanh toán)</c:if><c:if test="${empty unpaidInvoices}">(Đã thanh toán)</c:if></h3>
                        <c:choose>
                            <c:when test="${not empty student.contract and student.contract.status == 'Active'}">
									<p>Số tiền cần chuyển: 
									    <fmt:formatNumber value="${student.contract.room.price}" type="number" groupingUsed="true"/> VNĐ
									</p>                                
								<div style="text-align: center; margin-top: 20px;">
                                    <!-- Hoặc chèn hình ảnh QR -->
                                    <img src="<%=request.getContextPath()%>/images/qr_code.jpg" alt="QR Code" style="width: 50%; height: auto;">
                                </div>	
                                <p>Thanh toán theo cú pháp: <strong>${student.idSinhVien}_${student.fullName}_${student.contract.room.roomID}</strong></p>
                                <button class="btn-print" onclick="window.location.href='<%=request.getContextPath()%>/student/printInvoice?contractID=${student.contract.contractID}'">IN HÓA ĐƠN</button>
                                
                            </c:when>
                            <c:otherwise>
                                <p class="error-message">Bạn chưa có phòng để thanh toán.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>
                <c:when test="${param.section == 'chat'}">
				    <div class="content-card">
				        <h3>Chat</h3>
				        <div class="form-group">
				            <label for="chatWith">Chat với:</label>
				            <select id="chatWith" onchange="changeChatChannel()">
				                <option value="">Chọn người hoặc phòng</option>
				                <!-- Danh sách quản lý -->
				                <c:forEach var="manager" items="${allManagers}">
									<option value="${fn:escapeXml(manager.adminID)}">
				                        ${fn:escapeXml(manager.fullName)} (Quản lý)
				                    </option>
				                </c:forEach>
				                <!-- Danh sách sinh viên -->
				                <c:if test="${not empty student.contract and student.contract.status == 'Active' and not empty student.contract.room}">
				                    <option value="room_${fn:escapeXml(student.contract.room.roomID)}">
				                        Phòng ${fn:escapeXml(student.contract.room.roomID)}
				                    </option>
				                </c:if>
								<!-- Danh sách bạn cùng phòng (nếu có) -->
								<c:if test="${not empty student.contract and student.contract.status == 'Active' and (student.contract.room.roomType == 'Đôi' or student.contract.room.roomType == 'Tập thể') and not empty roommates}">
				                    <c:forEach var="roommate" items="${roommates}">
				                        <c:if test="${roommate.idSinhVien != student.idSinhVien}">
				                            <option value="${fn:escapeXml(roommate.idSinhVien)}">
				                                ${fn:escapeXml(roommate.fullName)}
				                            </option>
				                        </c:if>
				                    </c:forEach>
				                </c:if>
    				        </select>
				        </div>
				        <div id="chat-box" class="chat-box">
				            <!-- Tin nhắn và file sẽ hiển thị ở đây -->
				        </div>
				        <div class="input-group">
				            <input type="text" id="messageInput" placeholder="Nhập tin nhắn..." onkeypress="if(event.key === 'Enter') sendMessage()">
				            <input type="file" id="fileInput" accept=".pdf,.doc,.docx">
				            <button onclick="sendMessage()">Gửi Tin Nhắn</button>
				            <button onclick="sendFile()">Gửi File</button>
				        </div>
				    </div>
				</c:when>
                <c:otherwise>
                    <div class="content-card">
                        <h3>Phần không tồn tại</h3>
                        <p class="error-message">Phần yêu cầu không tồn tại.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Right Panel -->
        <div class="right-panel">
            <c:choose>
                <c:when test="${not empty student}">
                    <div class="profile-card">
						<img id="avatar-preview" src="<%=request.getContextPath()%>/images/avt.jpg" alt="Avatar" class="avatar-right">
                        <div class="avatar-upload">
                            <input type="file" id="avatar-input" accept="image/png,image/jpeg" style="display: none;">
                            <button onclick="document.getElementById('avatar-input').click();" class="btn-upload">Chọn ảnh</button>
                            <button onclick="uploadAvatar();" class="btn-upload" id="upload-btn" disabled>Lưu ảnh</button>
                        </div>
                        <table class="profile-table">
                            <tr>
                                <th>ID:</th>
                                <td>${student.idSinhVien}</td>
                            </tr>
                            <tr>
                                <th>Họ Tên:</th>
                                <td>${student.fullName}</td>
                            </tr>
                            <tr>
                                <th>Ngày Sinh:</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty student.dateOfBirth}">
                                            <fmt:formatDate value="${student.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise><i>Chưa cập nhật</i></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>Giới Tính:</th>
                                <td><c:out value="${student.gender != null ? student.gender : '<i>Chưa cập nhật</i>'}" escapeXml="false"/></td>
                            </tr>
                            <tr>
                                <th>Lớp:</th>
                                <td><c:out value="${student.className != null ? student.className : '<i>Chưa cập nhật</i>'}" escapeXml="false"/></td>
                            </tr>
                            <tr>
                                <th>Khoa:</th>
                                <td><c:out value="${student.department != null ? student.department : '<i>Chưa cập nhật</i>'}" escapeXml="false"/></td>
                            </tr>
                            <tr>
                                <th>SĐT:</th>
                                <td>${student.phoneNumber}</td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td>${student.email}</td>
                            </tr>
                            <tr>
                                <th>CCCD:</th>
                                <td>${student.CCCDID}</td>
                            </tr>
                            <tr>
                                <th>Trạng Thái:</th>
                                <td>${student.status}</td>
                            </tr>
                        </table>
                    </div>
                  <div class="button-container">
                    <a href="<%= request.getContextPath() %>/student/updateProfile" class="btn-update">Thay đổi Thông Tin</a>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn-logout">Đăng xuất</a>
               	</div>
                </c:when>
                <c:otherwise>
                    <p class="error-message">Không tìm thấy thông tin sinh viên. Vui lòng đăng nhập lại.</p>
                    <a href="<%= request.getContextPath() %>/login.jsp" class="btn-logout">Đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    
    <script>
    <!-- Book Room -->
    document.querySelectorAll('.tab-link').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.tab-link').forEach(t => {
                t.classList.remove('bg-blue-500', 'text-white');
                t.classList.add('bg-gray-200');
            });
            this.classList.add('bg-blue-500', 'text-white');
            updateRoomTitle();
            filterRooms();
        });
    });

    document.querySelectorAll('.floor-link').forEach(floor => {
        floor.addEventListener('click', function() {
            document.querySelectorAll('.floor-link').forEach(f => {
                f.classList.remove('bg-blue-500', 'text-white');
                f.classList.add('bg-gray-100');
            });
            this.classList.add('bg-blue-500', 'text-white');
            updateRoomTitle();
            filterRooms();
        });
    });

    function bindRoomClickEvents() {
        document.querySelectorAll('.room-card').forEach(room => {
            room.addEventListener('click', function() {
                if (!this.classList.contains('cursor-not-allowed')) {
                    document.querySelectorAll('.room-card').forEach(r => r.classList.remove('bg-blue-200'));
                    this.classList.add('bg-blue-200');
                    document.getElementById('selectedRoomName').value = this.dataset.room;
                    document.getElementById('submitButton').disabled = false;
                }
            });
        });
    }

    function updateRoomTitle() {
        const building = document.querySelector('.tab-link.bg-blue-500').dataset.building;
        const floor = document.querySelector('.floor-link.bg-blue-500').dataset.floor;
        document.getElementById('roomTitle').textContent = `Phòng - Tòa ${building}, Tầng ${floor}`;
    }

    function filterRooms() {
        const building = document.querySelector('.tab-link.bg-blue-500').dataset.building;
        const floor = document.querySelector('.floor-link.bg-blue-500').dataset.floor;
        const floorPrefix = building + (floor.length === 1 ? '0' + floor : floor);
        const roomGrid = document.getElementById('roomGrid');
        roomGrid.innerHTML = '';

        <c:forEach var="b" items="${buildings}">
            if ('${b.name}' === building) {
                <c:forEach var="room" items="${b.rooms}">
                    if ('${fn:substring(room.roomName, 0, 3)}' === floorPrefix) {
                        let slotHtml = '';
                        <c:forEach var="i" begin="1" end="${room.capacity}">
                            slotHtml += `<div class="w-6 h-6 rounded ${i <= room.currentOccupants ? 'bg-gray-500' : 'bg-green-500'}"></div>`;
                        </c:forEach>
                        roomGrid.innerHTML += `
                            <div class="room-card p-4 border rounded ${room.currentOccupants < room.capacity ? 'bg-green-100 cursor-pointer' : 'bg-red-100 cursor-not-allowed'}" data-room="${room.roomName}">
                                <div class="flex justify-between items-center">
                                    <div>
                                        <p><strong>${room.roomName}</strong> (${room.capacity} người${room.currentOccupants >= room.capacity ? ', Full' : ''})</p>
                                        <p>Loại: ${room.roomType}</p>
                                        <p>Giá: <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true"/> VNĐ</p>
                                    </div>
                                    <div class="flex space-x-1">
                                        ${slotHtml}
                                    </div>
                                </div>
                            </div>
                        `;
                    }
                </c:forEach>
            }
        </c:forEach>

        bindRoomClickEvents();
    }

    // Khởi tạo
    bindRoomClickEvents();
    
    <!-- Chat Script -->    
let socket;
let currentChannel;
let userID = "${student.idSinhVien}";
let userName = "${student.fullName}";

let userAvatar = "";
fetch('<%=request.getContextPath()%>/student/getAvatar?idSinhVien=${student.idSinhVien}')
    .then(response => response.json())
    .then(data => {
        if (data.avatar) {
            userAvatar = 'data:image/jpeg;base64,' + data.avatar;
        } else {
            userAvatar = '<%=request.getContextPath()%>/images/avt.jpg';
        }
    })
    .catch(error => {
        console.error('Error loading user avatar:', error);
        userAvatar = '<%=request.getContextPath()%>/images/avt.jpg';
    });
    
function connectWebSocket(roomId) {
    if (socket) socket.close();
    const wsUrl = 'ws://' + window.location.host + '<%=request.getContextPath()%>/chat/' + roomId + '/' + userID;
    console.log('Connecting to WebSocket:', wsUrl);
    socket = new WebSocket(wsUrl);
    socket.onopen = () => console.log('Connected to WebSocket for room ' + roomId);
    socket.onmessage = (event) => {
        console.log('Received raw data:', event.data);
        try {
            const messageData = JSON.parse(event.data);
            console.log('Parsed message:', messageData);
            displayMessage(messageData);
        } catch (e) {
            console.error('Error parsing message:', e, 'Raw data:', event.data);
            const chatBox = document.getElementById('chat-box');
            const p = document.createElement('p');
            p.style.color = 'red';
            p.textContent = 'Error parsing message';
            chatBox.appendChild(p);
        }
    };
    socket.onclose = () => console.log('Disconnected from WebSocket for room ' + roomId);
    socket.onerror = (error) => console.error('WebSocket error for room ' + roomId + ':', error);
}


function changeChatChannel() {
    const select = document.getElementById('chatWith');
    currentChannel = select.value;
    console.log('Selected channel:', currentChannel);
    document.getElementById('chat-box').innerHTML = '';
    if (currentChannel) {
        const roomId = currentChannel.startsWith('room_') ? currentChannel.split('_')[1] : currentChannel;
        console.log('Changing to channel:', roomId);
        connectWebSocket(roomId);
        loadChatHistory(roomId);
    }
}

function sendMessage() {
    const messageInput = document.getElementById('messageInput');
    const message = messageInput.value.trim();
    console.log('Attempting to send message:', message, 'Channel:', currentChannel, 'Socket state:', socket ? socket.readyState : 'No socket');
    if (message && socket && socket.readyState === WebSocket.OPEN) {
    	const messageObj = {
                senderID: userID,
                senderName: userName,
                avatarUrl: userAvatar,
                timestamp: new Date().toISOString(),
                message: message,
                type: 'message'
            };
        if (!currentChannel.startsWith('room_')) {
            messageObj.receiverID = currentChannel;
        }
        console.log('Sending JSON:', JSON.stringify(messageObj));
        socket.send(JSON.stringify(messageObj));
        messageInput.value = '';
    } else {
        console.error('Cannot send message: WebSocket not open or invalid input', {
            message: message,
            socket: socket,
            readyState: socket ? socket.readyState : 'No socket',
            currentChannel: currentChannel
        });
    }
}

function sendFile() {
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    console.log('Selected file:', file ? { name: file.name, size: file.size, type: file.type } : 'No file selected');
    
    if (!file) {
        console.error('No file selected');
        alert('Vui lòng chọn một file PDF!');
        return;
    }
    
    if (file.type !== 'application/pdf') {
        console.error('Invalid file type:', file.type);
        alert('Chỉ hỗ trợ file PDF!');
        return;
    }
    
    if (file.size > 10 * 1024 * 1024) { // 10MB
        console.error('File too large:', file.size);
        alert('File phải nhỏ hơn 10MB!');
        return;
    }
    
    if (!socket || socket.readyState !== WebSocket.OPEN) {
        console.error('WebSocket not open:', socket ? socket.readyState : 'No socket');
        alert('Không thể gửi file: Kết nối WebSocket không hoạt động!');
        return;
    }
    
    const reader = new FileReader();
    reader.onload = function(event) {
        const base64Data = event.target.result.split(',')[1];
        console.log('File read as Base64, length:', base64Data.length);
        const messageObj = {
                senderID: userID,
                senderName: userName,
                avatarUrl: userAvatar,
                timestamp: new Date().toISOString(),
                fileName: file.name,
                fileData: base64Data,
                type: 'file'
            };
        if (!currentChannel.startsWith('room_')) {
            messageObj.receiverID = currentChannel;
        }
        console.log('Sending file JSON, size:', JSON.stringify(messageObj).length);
        try {
            socket.send(JSON.stringify(messageObj));
            console.log('File sent successfully');
            fileInput.value = '';
        } catch (e) {
            console.error('Error sending file:', e);
            alert('Lỗi khi gửi file: ' + e.message);
        }
    };
    reader.onerror = function(event) {
        console.error('Error reading file:', event.target.error);
        alert('Lỗi khi đọc file!');
    };
    reader.readAsDataURL(file);
}

function loadChatHistory(channel) {
    const chatBox = document.getElementById('chat-box');
    chatBox.innerHTML = '';
    const url = '<%=request.getContextPath()%>/chat/history?channel=' + encodeURIComponent(channel) + '&userId=' + encodeURIComponent(userID);
    console.log('Fetching history from:', url);
    fetch(url)
        .then(response => {
            console.log('Fetch response status:', response.status);
            if (!response.ok) throw new Error('HTTP error ' + response.status);
            return response.json();
        })
        .then(messages => {
            console.log('Loaded history:', messages);
            if (!Array.isArray(messages)) {
                const p = document.createElement('p');
                p.style.color = 'red';
                p.textContent = 'Invalid chat history format';
                chatBox.appendChild(p);
                return;
            }
            messages.forEach(msg => displayMessage(msg));
            chatBox.scrollTop = chatBox.scrollHeight;
        })
        .catch(error => {
            console.error('Error loading chat history:', error);
            const p = document.createElement('p');
            p.style.color = 'red';
            p.textContent = 'Failed to load chat history: ' + error.message;
            chatBox.appendChild(p);
        });
}

// display
function displayMessage(messageData) {
    const chatBox = document.getElementById('chat-box');
    const isSender = messageData.senderID === userID;

    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + (isSender ? 'sent' : 'received');

    const avatarImg = document.createElement('img');
    avatarImg.src = messageData.avatarUrl || '<%=request.getContextPath()%>/images/default_avatar.jpg';
    avatarImg.alt = 'Avatar';
    avatarImg.className = 'avatar';

    const contentDiv = document.createElement('div');
    contentDiv.className = 'message-content';

    const headerDiv = document.createElement('div');
    headerDiv.className = 'message-header';
    
    const headerGroup = document.createElement('div');
    headerGroup.className = 'header-group';
    
    const nameSpan = document.createElement('span');
    nameSpan.className = 'name';
    nameSpan.style.color = getColorForUser(messageData.senderID);
    nameSpan.textContent = messageData.senderName || messageData.senderID || '[Unknown]';

    const timeSpan = document.createElement('span');
    timeSpan.className = 'time';
    timeSpan.textContent = messageData.timestamp ? new Date(messageData.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Unknown time';

    const textP = document.createElement('p');
    textP.className = 'text';
    if (messageData.type === 'message') {
        textP.textContent = messageData.message || '[Empty message]';
    } else if (messageData.type === 'file') {
        const fileName = messageData.fileName || '[No file name]';
        const fileData = messageData.fileData || '';
        if (fileData) {
            const a = document.createElement('a');
            a.href = 'data:application/pdf;base64,' + fileData;
            a.download = fileName;
            a.textContent = fileName;
            textP.appendChild(a);
        } else {
            textP.textContent = '[File missing data]';
        }
    } else {
        textP.textContent = '[Unknown type: ' + (messageData.type || 'unknown') + ']';
    }

    headerDiv.appendChild(nameSpan);
    headerDiv.appendChild(timeSpan);
    headerDiv.appendChild(headerGroup);
    contentDiv.appendChild(headerDiv);
    contentDiv.appendChild(textP);
    messageDiv.appendChild(avatarImg);
    messageDiv.appendChild(contentDiv);
    chatBox.appendChild(messageDiv);

    chatBox.scrollTop = chatBox.scrollHeight;
}
function getColorForUser(senderID) {
	const numberPart = parseInt(senderID.replace(/^\D+/, ''), 10);
	const hue = numberPart % 360;
	return `hsl(${hue}, 70%, 50%)`;
}
// Avatar
	// Load avatar từ API khi trang load
        window.onload = function() {
            fetch('<%=request.getContextPath()%>/student/getAvatar?idSinhVien=${student.idSinhVien}')
                .then(response => {
                    if (!response.ok) throw new Error('HTTP error ' + response.status);
                    return response.json();
                })
                .then(data => {
                    if (data.avatar) {
                        document.getElementById('avatar-preview').src = 'data:image/jpeg;base64,' + data.avatar;
                        console.log('Avatar loaded, Base64 length:', data.avatar.length);
                    } else {
                        console.log('No avatar found for student: ${student.idSinhVien}');
                    }
                })
                .catch(error => {
                    console.error('Error loading avatar:', error);
                });
        };

        const avatarInput = document.getElementById('avatar-input');
        const avatarPreview = document.getElementById('avatar-preview');
        const uploadBtn = document.getElementById('upload-btn');

        avatarInput.addEventListener('change', function() {
            const file = this.files[0];
            console.log('Selected avatar:', file ? { name: file.name, size: file.size, type: file.type } : 'No file');
            if (!file) {
                alert('Vui lòng chọn một file ảnh!');
                uploadBtn.disabled = true;
                return;
            }

            if (!['image/png', 'image/jpeg'].includes(file.type)) {
                alert('Chỉ hỗ trợ định dạng PNG hoặc JPG!');
                uploadBtn.disabled = true;
                return;
            }

            if (file.size > 16 * 1024 * 1024) {
                alert('Dung lượng file tối đa là 16MB!');
                uploadBtn.disabled = true;
                return;
            }

            const img = new Image();
            img.onload = function() {
                if (img.width > 4000 || img.height > 4000) {
                    alert('Kích thước ảnh tối đa là 4000x4000 pixel!');
                    uploadBtn.disabled = true;
                    return;
                }
                avatarPreview.src = URL.createObjectURL(file);
                uploadBtn.disabled = false;
                console.log('Avatar preview updated, size:', img.width + 'x' + img.height);
            };
            img.onerror = function() {
                alert('Lỗi khi đọc file ảnh!');
                uploadBtn.disabled = true;
            };
            img.src = URL.createObjectURL(file);
        });

        function uploadAvatar() {
            const file = avatarInput.files[0];
            if (!file) {
                alert('Vui lòng chọn một file ảnh trước!');
                return;
            }

            const formData = new FormData();
            formData.append('avatar', file);
            formData.append('idSinhVien', '${student.idSinhVien}');

            console.log('Uploading avatar for student:', '${student.idSinhVien}', 'File size:', file.size, 'bytes');
            fetch('<%=request.getContextPath()%>/student/updateAvatar', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('Upload response status:', response.status);
                if (!response.ok) throw new Error('HTTP error ' + response.status);
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    alert('Cập nhật ảnh đại diện thành công!');
                    uploadBtn.disabled = true;
                    avatarInput.value = '';
                    // Tải lại avatar từ API
                    fetch('<%=request.getContextPath()%>/student/getAvatar?idSinhVien=${student.idSinhVien}')
                        .then(resp => resp.json())
                        .then(avatarData => {
                            if (avatarData.avatar) {
                                avatarPreview.src = 'data:image/jpeg;base64,' + avatarData.avatar;
                                console.log('Avatar updated, Base64 length:', avatarData.avatar.length);
                            }
                        });
                } else {
                    alert('Lỗi: ' + (data.message || 'Không thể cập nhật ảnh!'));
                }
            })
            .catch(error => {
                console.error('Error uploading avatar:', error);
                alert('Lỗi khi tải ảnh: ' + error.message);
            });
        }
        </script>
</body>
</html>