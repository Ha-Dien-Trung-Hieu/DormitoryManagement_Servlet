<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" import="entity.Student" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Sinh Viên</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
            border: 1px solid #dfe4ea;
            border-radius: 8px;
            padding: 10px;
            background: #f9f9f9;
            height: 300px;
            overflow-y: auto;
            margin-bottom: 10px;
        }
        .chat-box p {
            margin: 5px 0;
            padding: 8px;
            background: #ecf0f1;
            border-radius: 8px;
            font-size: 14px;
            color: #34495e;
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
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 15px;
            border: 3px solid #4a90e2;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .avatar:hover {
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
			<!-- Thông báo thanh toán -->
            <c:if test="${not empty student.contract and student.contract.status == 'Active'}">
                <c:choose>
                    <c:when test="${not empty unpaidInvoices and unpaidInvoices.size() > 0}">
                        <div class="alert alert-danger">Bạn còn 3 ngày để thanh toán, hãy thanh toán trong thời gian quy định.</div>
                    </c:when>
                    <c:when test="${empty unpaidInvoices}">
                        <div class="alert alert-success">Bạn đã thanh toán thành công.</div>
                    </c:when>
                </c:choose>
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
                                <p>Số phòng trống: ${availableRooms.size()}</p>
                                <form action="<%=request.getContextPath()%>/student/bookRoom" method="post">
                                    <div class="form-group">
                                        <label for="RoomID">Chọn Phòng:</label>
                                        <select id="RoomID" name="RoomID">
                                            <c:if test="${not empty availableRooms}">
												<c:forEach var="room" items="${availableRooms}">
												    <option value="${room[0]}">${room[0]}. ${room[1]} : <fmt:formatNumber value="${room[4]}" type="number"/> VNĐ (${room[5]}) (${room[3]}/${room[2]})</option>
												</c:forEach>                                           
 													</c:if>	
 												<c:if test="${empty availableRooms}">
                                                <option value="">Không có phòng trống</option>
                                            </c:if>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn-submit" <c:if test="${empty availableRooms}">disabled</c:if>>Đặt Phòng</button>
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
				                <!-- Danh sách sinh viên -->
				                <c:forEach var="otherStudent" items="${allStudents}">
				                    <c:if test="${otherStudent.idSinhVien != student.idSinhVien}">
				                        <option value="${otherStudent.idSinhVien}|${not empty otherStudent.ipAddress ? otherStudent.ipAddress : '0.0.0.0'}|${not empty otherStudent.port ? otherStudent.port : '0'}">
				                            ${otherStudent.fullName}
				                        </option>
				                    </c:if>
				                </c:forEach>
				                <!-- Danh sách quản lý -->
				                <c:forEach var="manager" items="${allManagers}">
				                    <option value="${manager.adminID}|${not empty manager.ipAddress ? manager.ipAddress : '0.0.0.0'}|${not empty manager.port ? manager.port : '0'}">
				                        ${manager.fullName} (Quản lý)
				                    </option>
				                </c:forEach>
				                <!-- Chat nhóm với phòng (nếu có) -->
				                <c:if test="${not empty student.contract and student.contract.status == 'Active' and not empty room}">
				                    <option value="room_${student.contract.room.roomID}|${not empty room.ipAddress ? room.ipAddress : '0.0.0.0'}|${not empty room.port ? room.port : '0'}">
				                        Phòng ${student.contract.room.roomID}
				                    </option>
				                </c:if>
				            </select>
				        </div>
				        <div id="chat-box" class="chat-box">
				            <!-- Tin nhắn và file sẽ hiển thị ở đây -->
				        </div>
				        <div class="input-group">
				            <input type="text" id="messageInput" placeholder="Nhập tin nhắn...">
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
                        <img src="<%=request.getContextPath()%>/images/avt.jpg" alt="Avatar" class="avatar">
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

    <!-- Chat Script -->
    <script>
    let currentChannel = null;
    const userID = '${not empty student ? student.idSinhVien : ""}';

    function changeChatChannel() {
        const select = document.getElementById('chatWith');
        currentChannel = select.value;
        document.getElementById('chat-box').innerHTML = '';
        if (currentChannel) {
            loadChatHistory(currentChannel.split('|')[0]);
        }
    }

    function sendMessage() {
        const messageInput = document.getElementById('messageInput');
        const message = messageInput.value.trim();
        if (message && currentChannel) {
            const [receiverID, ip, port] = currentChannel.split('|');
            fetch('<%=request.getContextPath()%>/chat/send', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    senderID: userID,
                    receiverID: receiverID,
                    ip: ip,
                    port: port,
                    type: 'message',
                    content: message
                })
            })
            .then(() => {
                messageInput.value = '';
                loadChatHistory(receiverID);
            })
            .catch(error => console.error('Lỗi khi gửi tin nhắn:', error));
        }
    }

    function sendFile() {
        const fileInput = document.getElementById('fileInput');
        const file = fileInput.files[0];
        if (file && currentChannel) {
            const [receiverID, ip, port] = currentChannel.split('|');
            const reader = new FileReader();
            reader.onload = function(e) {
                const arrayBuffer = e.target.result;
                const bytes = new Uint8Array(arrayBuffer);
                fetch('<%=request.getContextPath()%>/chat/send', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({
                        senderID: userID,
                        receiverID: receiverID,
                        ip: ip,
                        port: port,
                        type: 'file',
                        fileName: file.name,
                        fileData: Array.from(bytes)
                    })
                })
                .then(() => {
                    fileInput.value = '';
                    loadChatHistory(receiverID);
                })
                .catch(error => console.error('Lỗi khi gửi file:', error));
            };
            reader.readAsArrayBuffer(file);
        }
    }

    function loadChatHistory(channel) {
        fetch('<%=request.getContextPath()%>/chat/history?channel=' + channel)
            .then(response => response.json())
            .then(messages => {
                const chatBox = document.getElementById('chat-box');
                chatBox.innerHTML = '';
                messages.forEach(msg => {
                    if (msg.type === 'message') {
                        chatBox.innerHTML += '<p>' + msg.senderID + ': ' + msg.message + ' (' + new Date(msg.timestamp).toLocaleString('vi-VN') + ')</p>';
                    } else if (msg.type === 'file') {
                        chatBox.innerHTML += '<p>' + msg.senderID + ': Đã gửi file <a href="<%=request.getContextPath()%>/chat/download?messageID=' + msg.messageID + '">' + msg.message + '</a> (' + new Date(msg.timestamp).toLocaleString('vi-VN') + ')</p>';
                    }
                });
                chatBox.scrollTop = chatBox.scrollHeight;
            })
            .catch(error => console.error('Lỗi khi tải lịch sử tin nhắn:', error));
    }
    </script>
</body>
</html>