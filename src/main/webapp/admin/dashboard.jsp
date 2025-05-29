<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" session="true" import="entity.Manager, entity.Student" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Quản Lý</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
       body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #fa66ab, #fbc2eb, #a18cd1); margin: 0; padding: 0; min-height: 100vh; }
        header { background: linear-gradient(90deg, #4a90e2, #357abd); color: #fff; padding: 1rem; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2); }
        header img.logo { padding-left: 5%; height: 50px; transition: transform 0.3s ease; }
        header img.logo:hover { transform: scale(1.05); }
        header .title { padding-right: 75px; font-size: 2rem; font-weight: 700; text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); }
        .dashboard-container { display: flex; min-height: 100vh; }
        .left-nav { width: 15%; background: linear-gradient(180deg, #2c3e50, #3498db); padding: 20px; box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3); }
        .left-nav ul { list-style: none; padding: 0; }
        .left-nav li { margin-bottom: 15px; }
        .left-nav a { height: 50px; display: flex; align-items: center; padding: 12px; text-decoration: none; color: #fff; font-size: 16px; font-weight: 500; border-radius: 8px; background: rgba(255, 255, 255, 0.1); transition: all 0.3s ease; }
        .left-nav a i { margin-right: 10px; font-size: 18px; }
        .left-nav a:hover { background: linear-gradient(90deg, #e74c3c, #c0392b); transform: translateX(5px); }
        .left-nav a.active { background: linear-gradient(90deg, #4a90e2, #357abd); box-shadow: 0 0 10px rgba(0, 0, 0, 0.2); }
        .main-content { flex: 1; padding: 20px; }
        .main-content h1 { color: #333; margin-bottom: 20px; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px;}
        .stat-box { background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1); text-align: center; transition: transform 0.2s ease; }
        .stat-box:hover { transform: translateY(-5px); }
        .stat-box i { font-size: 30px; color: #4a90e2; margin-bottom: 10px; }
        .stat-box h2 { font-size: 18px; margin: 10px 0; color: #555; }
        .stat-box p { font-size: 24px; font-weight: bold; color: #4a90e2; margin: 0; }
        .full-width { grid-column: span 3; padding: 30px; }
        .search-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-bar input { flex: 1; padding: 12px; border: 1px solid #dfe4ea; border-radius: 8px; font-size: 14px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: all 0.3s ease; }
        .search-bar input:focus { border-color: #4a90e2; outline: none; box-shadow: 0 2px 10px rgba(74, 144, 226, 0.2); }
        .search-bar button { padding: 12px 20px; background: linear-gradient(90deg, #4a90e2, #357abd); color: #fff; border: none; border-radius: 8px; font-weight: 500; cursor: pointer; transition: all 0.3s ease; }
        .search-bar button:hover { background: linear-gradient(90deg, #357abd, #4a90e2); transform: scale(1.05); }
        .student-table-wrapper, .room-table-wrapper, .building-table-wrapper, .contract-table-wrapper, .invoice-table-wrapper { position: relative; max-height: 400px; overflow-y: auto; margin-bottom: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .student-table, .room-table, .building-table, .contract-table, .invoice-table { width: 100%; border-collapse: collapse; font-size: 14px; color: #34495e; background: #fff; border-radius: 10px; }
        .student-table th, .student-table td, .room-table th, .room-table td, .building-table th, .building-table td, .contract-table th, .contract-table td, .invoice-table th, .invoice-table td { padding: 12px; text-align: left; border-bottom: 1px solid #dfe4ea; transition: background 0.3s ease; }
        .student-table th, .room-table th, .building-table th, .contract-table th, .invoice-table th { font-weight: 600; color: #2c3e50; background: rgba(78, 115, 223, 0.1); position: sticky; top: 0; z-index: 1; }
        .student-table td, .room-table td, .building-table td, .contract-table td, .invoice-table td { color: #7f8c8d; }
        .student-table tr:hover td, .room-table tr:hover td, .building-table tr:hover td, .contract-table tr:hover td, .invoice-table tr:hover td { background: rgba(78, 115, 223, 0.05); }
        .student-table tr.selected td, .room-table tr.selected td, .invoice-table tr.selected td { background: rgba(78, 115, 223, 0.2); }
        .student-details { background: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); margin-top: 20px; }
        .student-details h3 { margin: 0 0 15px; color: #2c3e50; font-size: 18px; }
        .student-details .info-table { width: 100%; border-collapse: collapse; font-size: 14px; color: #34495e; }
        .student-details .info-table th, .student-details .info-table td { padding: 10px; border-bottom: 1px solid #dfe4ea; }
        .student-details .info-table th { font-weight: 600; color: #2c3e50; width: 30%; }
        .student-details .info-table td { color: #7f8c8d; }
        .action-buttons { display: flex; gap: 10px; }
        .action-buttons button { padding: 12px 20px; border: none; border-radius: 8px; font-weight: 500; cursor: pointer; color: #fff; transition: all 0.3s ease; }
        .action-buttons button:hover { transform: scale(1.05); }
        .btn-sort { background: linear-gradient(90deg, #f1c40f, #e67e22); }
        .btn-filter { background: linear-gradient(90deg, #3498db, #2980b9); }
        .btn-chat { background: linear-gradient(90deg, #2ecc71, #27ae60); }
        .btn-delete { background: linear-gradient(90deg, #e74c3c, #c0392b); }
        .btn-add { background: linear-gradient(90deg, #2ecc71, #27ae60); }
        .btn-edit { background: linear-gradient(90deg, #0080ff, #3333ff); }
        .content-card { background-color: #fff; padding: 20px; border-radius: 10px; box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1); margin-bottom: 20px; }
		.content-card h3 { font-size: 18px; color: #333; margin-bottom: 15px; }
		.content-table { width: 100%; border-collapse: collapse; font-size: 14px; color: #34495e; }
		.content-table th, .content-table td { padding: 10px; text-align: left; border-bottom: 1px solid #dfe4ea; transition: background 0.3s ease; }
		.content-table th { font-weight: 600; color: #2c3e50; background: rgba(78, 115, 223, 0.1); }
		.content-table td { color: #7f8c8d; }
		.content-table tr:hover td { background: rgba(78, 115, 223, 0.05); }
		.content-table tr:first-child { background: rgba(78, 115, 223, 0.1); }
		.chat-card h3 { font-size: 20px; color: #fff; margin-bottom: 15px; font-weight: 700; text-align: center; background: linear-gradient(90deg, #4a90e2, #357abd); padding: 10px; border-radius: 8px 8px 0 0; }
		.chat-form-group { margin-bottom: 15px; padding: 10px; background: #fff; border-radius: 8px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }
		.chat-form-group label { display: block; font-size: 14px; color: #2c3e50; margin-bottom: 5px; font-weight: 600; }
		.chat-form-group input[type="text"] { width: 100%; padding: 8px; border: 1px solid #dfe4ea; border-radius: 4px; font-size: 14px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); transition: border-color 0.3s ease; }
		.chat-form-group input[type="text"]:focus { border-color: #4a90e2; outline: none; }
		.chat-form-group select { width: 100%; padding: 8px; border: 1px solid #dfe4ea; border-radius: 4px; font-size: 14px; background: #fff; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); transition: border-color 0.3s ease; }
		.chat-form-group select:focus { border-color: #4a90e2; outline: none; }
        .chat-box { height: 400px; overflow-y: auto; padding: 15px; border: 1px solid #dfe4ea; border-radius: 8px; background: #f9f9f9; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }
		.chat-message { display: flex; margin-bottom: 15px; align-items: flex-start; }
		.chat-message.chat-sent { flex-direction: row-reverse; }
		.chat-message.chat-sent .chat-message-content { align-items: flex-end; }
		.chat-message.chat-received .chat-avatar { margin-right: 10px; }
		.chat-message.chat-sent .chat-avatar { margin-left: 10px; }
		.chat-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
		.chat-message-content { display: flex; flex-direction: column; min-width: 0; }
		.chat-message-header { display: flex; font-size: 14px; margin-bottom: 5px; }
		.chat-message.chat-sent .chat-message-header { justify-content: flex-end; }
		.chat-header-group { display: flex; align-items: center; gap: 5px; }
		.chat-name { font-weight: 600; color: #2c3e50; }
		.chat-message.chat-sent .chat-name { color: #4a90e2; }
		.chat-time { color: #888; font-size: 12px; flex-shrink: 0; }
		.chat-message.chat-sent .chat-time { margin-right: 0; margin-left: 0; }
		.chat-message.chat-received .chat-time { margin-right: 0; margin-left: 0; }
		.chat-text { padding: 8px 12px; border-radius: 12px; word-wrap: break-word; font-size: 14px; line-height: 1.4; min-width: 0; }
		.chat-message.chat-received .chat-text { background: #e9ecef; color: #34495e; }
		.chat-message.chat-sent .chat-text { background: #4a90e2; color: #fff; }
		.chat-text a { color: inherit; text-decoration: underline; }
		.chat-text a:hover { text-decoration: none; }
      	.avatar-upload { margin: 10px 0; text-align: center; }
		.btn-upload { background-color: #4CAF50; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; margin: 0 5px; }
		.btn-upload:disabled { background-color: #cccccc; cursor: not-allowed; }
        .chat-input-group { display: flex; gap: 10px; padding: 10px; background: #fff; border-radius: 0 0 8px 8px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }
		.chat-input-group input[type="text"] { flex: 1; padding: 8px; border: 1px solid #dfe4ea; border-radius: 4px; font-size: 14px; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); transition: border-color 0.3s ease; }
		.chat-input-group input[type="text"]:focus { border-color: #4a90e2; outline: none; }
		.chat-input-group input[type="file"] { padding: 8px 0; border: none; font-size: 14px; flex: 0 0 200px; }
		.chat-input-group button { padding: 8px 15px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer; color: #fff; transition: transform 0.3s ease, background 0.3s ease; }
		.chat-input-group button:first-child { background: linear-gradient(90deg, #3498db, #2980b9); }
		.chat-input-group button:first-child:hover { transform: scale(1.05); background: linear-gradient(90deg, #2980b9, #3498db); }
		.chat-input-group button:last-child { background: linear-gradient(90deg, #3498db, #2980b9); }
		.chat-input-group button:last-child:hover { transform: scale(1.05); background: linear-gradient(90deg, #2980b9, #3498db); }
        .chat-input-group button { background: linear-gradient(90deg, #3498db, #2980b9); }
		.chat-input-group button :hover { transform: scale(1.05); background: linear-gradient(90deg, #2980b9, #3498db); }
        
        .right-panel { width: 280px; background: #fff; padding: 20px; box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1); }
        .profile-card { padding: 20px; border-radius: 12px; background: linear-gradient(135deg, #ecf0f1, #dfe4ea); box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1); }
        .avatar { width: 120px; height: 120px; border-radius: 50%; margin: 0 auto 15px; border: 3px solid #4a90e2; object-fit: cover; }
        .profile-table { width: 100%; border-collapse: collapse; font-size: 14px; color: #34495e; }
        .profile-table th, .profile-table td { padding: 10px; text-align: left; border-bottom: 1px solid #dfe4ea; }
        .profile-table th { font-weight: 600; color: #2c3e50; width: 40%; }
        .profile-table td { color: #7f8c8d; }
        .btn-logout { display: block; padding: 12px; background: linear-gradient(90deg, #e74c3c, #c0392b); color: #fff; text-decoration: none; border-radius: 8px; margin-top: 20px; text-align: center; font-weight: 500; transition: transform 0.3s ease, background 0.3s ease; }
        .btn-logout:hover { transform: scale(1.05); background: linear-gradient(90deg, #c0392b, #e74c3c); }
        .error-message { color: #e74c3c; font-size: 14px; text-align: center; margin-bottom: 10px; }
    </style>
</head>
<body>
	<header>
        <img src="${pageContext.request.contextPath}/images/login/logo.png" alt="Logo" class="logo">
        <div class="title">Dashboard</div>
    </header>
    <div class="dashboard-container">
        <div class="left-nav">
            <ul>
                <li><a href="?section=home" class="${param.section == 'home' || empty param.section ? 'active' : ''}">
                    <i class="fas fa-home"></i> Trang chủ</a></li>
                <li><a href="?section=students" class="${param.section == 'students' ? 'active' : ''}">
                    <i class="fas fa-users"></i> Quản lý sinh viên</a></li>
                <li><a href="?section=rooms" class="${param.section == 'rooms' ? 'active' : ''}">
                    <i class="fas fa-door-open"></i> Quản lý phòng</a></li>
                <li><a href="?section=contracts" class="${param.section == 'contracts' ? 'active' : ''}">
                    <i class="fas fa-file-contract"></i> Quản lý hợp đồng</a></li>
                <li><a href="?section=invoices" class="${param.section == 'invoices' ? 'active' : ''}">
                    <i class="fas fa-file-invoice"></i> Quản lý hóa đơn</a></li>
                <li><a href="?section=buildings" class="${param.section == 'buildings' ? 'active' : ''}">
                    <i class="fas fa-building"></i> Quản lý tòa nhà</a></li>
                <li><a href="?section=statistics" class="${param.section == 'statistics' ? 'active' : ''}">
           			 <i class="fas fa-chart-pie"></i> Thống kê</a></li>
                <li><a href="?section=chat" class="${param.section == 'chat' ? 'active' : ''}">
                    <i class="fas fa-comments"></i> Chat nhóm</a></li>
            </ul>
        </div>
        <div class="main-content">
            <c:choose>
                <c:when test="${param.section == 'home' || empty param.section}">
                    <h1>Trang chủ</h1>
                    <div class="stats-grid">
                        <div class="stat-box">
                            <i class="fas fa-users"></i>
                            <h2>Tổng số sinh viên</h2>
                            <p>${totalStudents}</p>
                        </div>
                        <div class="stat-box">
                            <i class="fas fa-user-check"></i>
                            <h2>Sinh viên đã có phòng</h2>
                            <p>${studentsWithRooms}</p>
                        </div>
                        <div class="stat-box">
                            <i class="fas fa-door-open"></i>
                            <h2>Phòng trống</h2>
                            <p>${vacantRooms}</p>
                        </div>
                        <div class="stat-box">
                            <i class="fas fa-building"></i>
                            <h2>Tổng số tòa nhà</h2>
                            <p>${totalBuildings}</p>
                        </div>
                        <div class="stat-box">
                            <i class="fas fa-money-bill-wave"></i>
                            <h2>Doanh thu 1 năm</h2>
                            <p>${annualRevenue}</p>
                        </div>
                        <div class="stat-box">
                            <i class="fas fa-file-invoice"></i>
                            <h2>Hóa đơn chưa thanh toán</h2>
                            <p>${pendingInvoices}</p>
                        </div>
                    </div>
                </c:when>
                <c:when test="${param.section == 'students'}">
                    <h1>Quản lý sinh viên</h1>
					<div class="search-bar">
                        <input type="text" id="searchInput" placeholder="Tìm kiếm theo ID, Tên, SĐT">
                        <button onclick="searchStudents()">Tìm kiếm</button>
                    </div>
                    <!-- Bảng sinh viên -->
                    <div class="student-table-wrapper">
                        <table class="student-table">
                            <thead>
                                <tr>
                                    <th>IDSinhVien</th>
                                    <th>Họ Tên</th>
                                    <th>Ngày Sinh</th>
                                    <th>Giới Tính</th>
                                    <th>Lớp</th>
                                    <th>Khoa</th>		
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="student" items="${students}">
                            	<c:set var="roomName" value="${not empty student.contract and student.contract.status == 'Active' ? student.contract.room.roomName : 'null'}" />
			                    <c:set var="roomType" value="${not empty student.contract and student.contract.status == 'Active' ? student.contract.room.roomType : 'null'}" />
			                    <c:set var="roomPrice" value="${not empty student.contract and student.contract.status == 'Active' ? student.contract.room.price : 'null'}" />
			                    <tr onclick="selectStudent(this)"
			                        data-id="${student.idSinhVien}"
			                        data-fullname="${student.fullName}"
			                        data-dob="<fmt:formatDate value='${student.dateOfBirth}' pattern='dd/MM/yyyy'/>"
			                        data-gender="${student.gender}"
			                        data-class="${student.className}"
			                        data-department="${student.department}"
			                        data-phone="${student.phoneNumber}"
			                        data-email="${student.email}"
			                        data-cccd="${student.CCCDID}"
			                        data-status="${student.status}"
                                	data-roomname="${roomName}"
			                        data-roomtype="${roomType}"
			                        data-roomprice="${roomPrice}">
			                        <td>${student.idSinhVien}</td>
			                        <td>${student.fullName}</td>
			                        <td><fmt:formatDate value="${student.dateOfBirth}" pattern="dd/MM/yyyy"/></td>
			                        <td>${student.gender}</td>
			                        <td>${student.className}</td>
			                        <td>${student.department}</td>
			                    </tr>
			                   </c:forEach>
                            </tbody>
                        </table>
                        </div>
                        
                        <div id="studentDetails" class="student-details" style="display: none;">
					        <h3>Thông tin chi tiết sinh viên</h3>
					        <table class="info-table">
					            <tr>
					                <th>IDSinhVien:</th>
					                <td id="detailIDSinhVien"></td>
					            </tr>
					            <tr>
					                <th>Họ Tên:</th>
					                <td id="detailFullName"></td>
					            </tr>
					            <tr>
					                <th>Ngày Sinh:</th>
					                <td id="detailDateOfBirth"></td>
					            </tr>
					            <tr>
					                <th>Giới Tính:</th>
					                <td id="detailGender"></td>
					            </tr>
					            <tr>
					                <th>Lớp:</th>
					                <td id="detailClassName"></td>
					            </tr>
					            <tr>
					                <th>Khoa:</th>
					                <td id="detailDepartment"></td>
					            </tr>
					            <tr>
					                <th>SĐT:</th>
					                <td id="detailPhoneNumber"></td>
					            </tr>
					            <tr>
					                <th>Email:</th>
					                <td id="detailEmail"></td>
					            </tr>
					            <tr>
					                <th>CCCDID:</th>
					                <td id="detailCCCDID"></td>
					            </tr>
					            <tr>
					                <th>Trạng Thái:</th>
					                <td id="detailStatus"></td>
					            </tr>
					            <tr id="roomInfo" style="display: none;">
					                <th>Tên Phòng:</th>
					                <td id="detailRoomName"></td>
					            </tr>
								<tr id="roomTypeInfo" style="display: none;">
					                <th>Loại Phòng:</th>
					                <td id="detailRoomType"></td>
					                					            </tr>
					            <tr id="roomPriceInfo" style="display: none;">
					                <th>Giá Phòng:</th>
					                <td id="detailRoomPrice"></td>
					            </tr>
				        </table>
				    </div>
                    
                    <!-- Nút tương tác -->
                    <div class="action-buttons">
                        <button class="btn-sort" onclick="sortStudents()">Sắp xếp theo IDSinhVien</button>
                        <button class="btn-filter" onclick="filterStudentsWithRooms()">Hiển thị đã có phòng</button>
                        <button class="btn-chat" onclick="chatWithStudent()">Chat với sinh viên</button>
                        <button class="btn-delete" onclick="deleteSelectedStudent()">Xóa sinh viên</button>
                    </div>
                </c:when>
                <c:when test="${param.section == 'rooms'}">
				    <h1>Quản lý phòng</h1>
				    <!-- Bảng phòng -->
				    <div class="room-table-wrapper">
				        <table class="room-table">
				            <thead>
				                <tr>
				                    <th>RoomName</th>
				                    <th>Building</th>
				                    <th>RoomType</th>
				                    <th>CurrentOccupants/Capacity</th>
				                    <th>Price</th>
				                </tr>
				            </thead>
				            <tbody>
				                <c:forEach var="room" items="${rooms}">
				                    <tr onclick="selectRoom(this)"
				                        data-id="${room.roomID}"
				                        data-building="${room.building.name}"
				                        data-type="${room.roomType}"
				                        data-occupants="${room.currentOccupants}"
				                        data-capacity="${room.capacity}"
				                        data-price="${room.price}">
				                        <td>${room.roomName}</td>
				                        <td>${room.building.name}</td>
				                        <td>${room.roomType}</td>
				                        <td>${room.currentOccupants}/${room.capacity}</td>
				                        <td>
				                            <fmt:setLocale value="vi_VN"/>
				                            <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true"/> VNĐ
				                        </td>
				                    </tr>
				                </c:forEach>
				                <c:if test="${empty rooms}">
		                            <tr><td colspan="5">Không có phòng nào để hiển thị.</td></tr>
		                        </c:if>
				            </tbody>
				        </table>
				    </div>
				    <!-- Nút tương tác -->
				    <div class="action-buttons">
						<button id="sortButton" class="btn-sort">Sắp xếp</button>
					    <button class="btn-add" onclick="addRoom()">Thêm phòng</button>
					    <button class="btn-delete" onclick="deleteSelectedRoom()">Xóa phòng</button>
					    <button class="btn-edit" onclick="editSelectedRoom()">Điều chỉnh Phòng</button>			
					</div>
				</c:when>
                <c:when test="${param.section == 'contracts'}">
                    <h1>Quản lý hợp đồng</h1>
                    <div class="contract-table-wrapper">
                        <table class="contract-table">
                            <thead>
                                <tr>
                                    <th>ContractID</th>
                                    <th>IDSinhVien</th>
                                    <th>RoomID</th>
                                    <th>StartDate</th>
                                    <th>EndDate</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="contract" items="${contracts}">
                                    <tr>
                                        <td>${contract.contractID}</td>
                                        <td>${contract.student.idSinhVien}</td>
                                        <td>${contract.room.roomID}</td>
                                        <td><fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>${contract.status}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty contracts}">
                                    <tr><td colspan="6">Không có hợp đồng nào để hiển thị.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:when test="${param.section == 'invoices'}">
                    <h1>Quản lý hóa đơn</h1>
                    <div class="invoice-table-wrapper">
                        <table class="invoice-table">
                            <thead>
                                <tr>
                                    <th>InvoiceID</th>
                                    <th>ContractID</th>
                                    <th>FullName</th>
                                    <th>RoomID</th>
                                    <th>IssueDate</th>
                                    <th>PaymentDate</th>
                                    <th>Amount</th>
                                    <th>PaymentStatus</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="invoice" items="${invoices}">
                                    <tr onclick="selectInvoice(this)"
                                        data-id="${invoice.invoiceID}"
                                        data-contractid="${invoice.contract.contractID}"
                                        data-paymentstatus="${invoice.paymentStatus}">
                                        <td>${invoice.invoiceID}</td>
                                        <td>${invoice.contract.contractID}</td>
                                        <td>${invoice.contract.student.fullName}</td>
                                        <td>${invoice.contract.room.roomID}</td>
                                        <td><fmt:formatDate value="${invoice.issueDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${invoice.paymentDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:setLocale value="vi_VN"/><fmt:formatNumber value="${invoice.amount}" type="number" groupingUsed="true"/> VNĐ</td>
                                        <td>${invoice.paymentStatus}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty invoices}">
                                    <tr><td colspan="8">Không có hóa đơn nào để hiển thị.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <div class="action-buttons">
                        <button class="btn-sort" onclick="sortInvoices()">Sắp xếp theo PaymentStatus</button>
                        <button class="btn-edit" onclick="editSelectedInvoice()">Chỉnh sửa hóa đơn</button>
                    </div>
                </c:when>
                <c:when test="${param.section == 'buildings'}">
				    <h1>Quản lý tòa nhà</h1>
				    <div class="building-table-wrapper">
				        <table class="building-table">
				            <thead>
				                <tr>
				                    <th>BuildingID</th>
				                    <th>Name</th>
				                    <th>Floors</th>
				                    <th>Location</th>
				                </tr>
				            </thead>
				            <tbody>
				                <c:forEach var="building" items="${buildings}">
				                    <tr>
				                        <td>${building.buildingID}</td>
				                        <td>${building.name}</td>
				                        <td>${building.floors}</td>
				                        <td>${building.location}</td>
				                    </tr>
				                </c:forEach>
				                <c:if test="${empty buildings}">
		                            <tr><td colspan="4">Không có tòa nhà nào để hiển thị.</td></tr>
		                        </c:if>
				            </tbody>
				        </table>
				    </div>
				</c:when>
				<c:when test="${param.section == 'statistics'}">
			        <h1>Thống kê</h1>
			        <div class="stats-grid">
			            <div class="stat-box">
			                <h2>Tỉ lệ sinh viên nam và nữ</h2>
			                <canvas id="genderChart"></canvas>
			            </div>
			            <div class="stat-box">
			                <h2>Tỉ lệ sinh viên có phòng và chưa có</h2>
			                <canvas id="roomStatusChart"></canvas>
			            </div>
			            <div class="stat-box">
			                <h2>Tỉ lệ phòng trống và phòng đầy</h2>
			                <canvas id="roomOccupancyChart"></canvas>
			            </div>
			         </div>
			         <div class="stats-grid">
				        <div class="stat-box full-width">
				            <h2>Doanh thu từng tháng</h2>
				            <canvas id="revenueChart"></canvas>
				        </div>
				    </div>
			       
			    </c:when>
                <c:when test="${param.section == 'chat'}">
				   <div class="content-card chat-card">
				        <h3>Chat</h3>
				        <div class="form-group chat-form-group">
				            <label for="searchStudent">Tìm kiếm sinh viên:</label>
				            <input type="text" id="searchStudent" placeholder="Nhập tên, phòng hoặc ID sinh viên" oninput="filterStudents()">
				        </div>
				        <div class="form-group chat-form-group">
				            <label for="chatWith">Chat với:</label>
				            <select id="chatWith" onchange="changeChatChannel()">
				                <option value="">Chọn sinh viên hoặc phòng</option>
				                <!-- Danh sách sinh viên -->
				                <c:forEach var="student" items="${allStudents}">
				                    <option value="${fn:escapeXml(student.idSinhVien)}" data-name="${fn:escapeXml(student.fullName)}" data-room="${fn:escapeXml(student.contract != null ? student.contract.room.roomID : '')}">
				                        ${fn:escapeXml(student.fullName)} (ID: ${fn:escapeXml(student.idSinhVien)})
				                    </option>
				                </c:forEach>
				                <!-- Danh sách phòng -->
								<c:forEach var="room" items="${allRooms}">
								        <option value="room_${fn:escapeXml(room.roomID)}" data-roomname="${fn:escapeXml(room.roomName)}">
								            Phòng ${fn:escapeXml(room.roomName)}
            				            </option>
				                </c:forEach>
				            </select>
				        </div>
				        <div id="chat-box" class="chat-box">
				            <!-- Tin nhắn và file sẽ hiển thị ở đây -->
				        </div>
				       <div class="input-group chat-input-group">
				            <input type="text" id="messageInput" placeholder="Nhập tin nhắn..." onkeypress="if(event.key === 'Enter') sendMessage()">
				            <input type="file" id="fileInput" accept=".pdf,.doc,.docx">
				            <button onclick="sendMessage()">Gửi Tin Nhắn</button>
				            <button onclick="sendFile()">Gửi File</button>
				        </div>
				    </div>
				</c:when>
                <c:otherwise>
                    <h1>Phần không tồn tại</h1>
                    <p>Phần yêu cầu không tồn tại.</p>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="right-panel">
            <div class="profile-card">
                <img src="${pageContext.request.contextPath}/images/avt.jpg" alt="Ảnh đại diện" class="avatar">
                <table class="profile-table">
                            <tr>
                                <th>Họ tên:</th>
                                <td><c:out value="${manager.fullName}" default="Không có tên"/></td>
                            </tr>
                            <tr>
                                <th>Mã quản trị:</th>
                                <td><c:out value="${manager.adminID}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Chức vụ:</th>
                                <td><c:out value="${manager.position}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Số điện thoại:</th>
                                <td><c:out value="${manager.phoneNumber}" default="N/A"/></td>
                            </tr>
                            <tr>
                                <th>Email:</th>
                                <td><c:out value="${manager.email}" default="N/A"/></td>
                            </tr>
                        </table>
                <a href="${pageContext.request.contextPath}/loginAdmin" class="btn-logout">Đăng xuất</a>
            </div>
        </div>
    </div>
    <script type="text/javascript">
    	const contextPath = "${pageContext.request.contextPath}";
    	
	    let selectedStudentId = null;
	    let selectedRoomId = null;
	   	let buildingList = [
	    	<c:forEach var="building" items="${buildings}" varStatus="loop">
            "${building.name}"${loop.last ? '' : ','}
        </c:forEach>
	    ];
	    console.log("Building List:", buildingList);
	    function selectStudent(row) {
	        // Đánh dấu hàng được chọn
	        const rows = document.querySelectorAll('.student-table tbody tr');
	        rows.forEach(r => r.classList.remove('selected'));
	        row.classList.add('selected');
	
	        // Lấy dữ liệu từ thuộc tính data-*
	        const idSinhVien = row.getAttribute('data-id') || '';
	        const fullName = row.getAttribute('data-fullname') || '';
	        const dateOfBirth = row.getAttribute('data-dob') || '';
	        const gender = row.getAttribute('data-gender') || '';
	        const className = row.getAttribute('data-class') || '';
	        const department = row.getAttribute('data-department') || '';
	        const phoneNumber = row.getAttribute('data-phone') || '';
	        const email = row.getAttribute('data-email') || '';
	        const CCCDID = row.getAttribute('data-cccd') || '';
	        const status = row.getAttribute('data-status') || '';
	        const roomName = row.getAttribute('data-roomname') || 'null';
	        const roomType = row.getAttribute('data-roomtype') || 'null';
	        const roomPrice = row.getAttribute('data-roomprice') || 'null';
	
	        selectedStudentId = idSinhVien;
	
	        // Hiển thị thông tin chi tiết
	        const detailDiv = document.getElementById('studentDetails');
	        detailDiv.style.display = 'block';
	
	        document.getElementById('detailIDSinhVien').innerText = idSinhVien;
	        document.getElementById('detailFullName').innerText = fullName;
	        document.getElementById('detailDateOfBirth').innerText = dateOfBirth;
	        document.getElementById('detailGender').innerText = gender;
	        document.getElementById('detailClassName').innerText = className;
	        document.getElementById('detailDepartment').innerText = department;
	        document.getElementById('detailPhoneNumber').innerText = phoneNumber;
	        document.getElementById('detailEmail').innerText = email;
	        document.getElementById('detailCCCDID').innerText = CCCDID;
	        document.getElementById('detailStatus').innerText = status;
	
	        // Hiển thị thông tin phòng nếu có
	        if (roomName !== 'null' && roomType !== 'null' && roomPrice !== 'null') {
	            document.getElementById('roomInfo').style.display = 'table-row';
	            document.getElementById('roomTypeInfo').style.display = 'table-row';
	            document.getElementById('roomPriceInfo').style.display = 'table-row';
	            document.getElementById('detailRoomName').innerText = roomName;
	            document.getElementById('detailRoomType').innerText = roomType;
	            document.getElementById('detailRoomPrice').innerText = roomPrice + ' VNĐ';
	        } else {
	            document.getElementById('roomInfo').style.display = 'none';
	            document.getElementById('roomTypeInfo').style.display = 'none';
	            document.getElementById('roomPriceInfo').style.display = 'none';
	        }
	    }
	   
	    
	    function searchStudents() {
	    	const searchInput = document.getElementById('searchInput');
	        if (!searchInput) {
	            alert('Không tìm thấy ô tìm kiếm. Vui lòng kiểm tra giao diện.');
	            return;
	        }
	        const query = searchInput.value.trim();
	        const xhr = new XMLHttpRequest();
	        xhr.open('GET', '?section=students&search=' + encodeURIComponent(query), true);
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState === 4) {
	                if (xhr.status === 200) {
	                    updateTable(xhr.responseText);
	                } else {
	                    console.error('Lỗi tìm kiếm:', xhr.status, xhr.statusText);
	                    alert('Lỗi khi tìm kiếm sinh viên: ' + xhr.statusText);
	                }
	            }
	        };
	        xhr.onerror = function() {
	            console.error('Lỗi mạng khi tìm kiếm');
	            alert('Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.');
	        };
	        xhr.send();
	    }
	
	    function sortStudents() {
	    	const xhr = new XMLHttpRequest();
	        xhr.open('GET', '?section=students&sort=IDSinhVien', true);
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState === 4 && xhr.status === 200) {
	                updateTable(xhr.responseText);
	            }
	        };
	        xhr.send();
	    }
	
	    function filterStudentsWithRooms() {
	    	const currentUrl = new URL(window.location);
	        const isFiltered = currentUrl.searchParams.get('filter') === 'withRooms';
	        const url = isFiltered ? '?section=students' : '?section=students&filter=withRooms';
	        const xhr = new XMLHttpRequest();
	        xhr.open('GET', url, true);
	        xhr.onreadystatechange = function() {
	            if (xhr.readyState === 4 && xhr.status === 200) {
	                updateTable(xhr.responseText);
	            }
	        };
	        xhr.send();
	    }
	    function updateTable(response) {
	    	try {
	            const parser = new DOMParser();
	            const doc = parser.parseFromString(response, 'text/html');
	            const newTable = doc.querySelector('.student-table tbody');
	            const currentTable = document.querySelector('.student-table tbody');
	            if (newTable && currentTable) {
	                currentTable.innerHTML = newTable.innerHTML;
	                const rows = currentTable.querySelectorAll('tr');
	                rows.forEach(row => {
	                    row.addEventListener('click', () => selectStudent(row));
	                });
	                selectedStudentId = null;
	                document.getElementById('studentDetails').style.display = 'none';
	            } else {
	                console.error('Không tìm thấy bảng sinh viên trong phản hồi');
	                currentTable.innerHTML = '<tr><td colspan="6" style="text-align: center;">Không tìm thấy sinh viên</td></tr>';
	            }
	        } catch (e) {
	            console.error('Lỗi khi cập nhật bảng:', e);
	            alert('Lỗi khi xử lý dữ liệu bảng: ' + e.message);
	        }
	    }
	    function chatWithStudent() {
	        alert('Chức năng chat với sinh viên sẽ được cập nhật sau.');
	    }
	
	    function deleteSelectedStudent() {
	        if (!selectedStudentId) {
	            alert('Vui lòng chọn một sinh viên để xóa.');
	            return;
	        }
	        if (confirm('Bạn có chắc chắn muốn xóa sinh viên này? Hành động này không thể hoàn tác.')) {
	            const xhr = new XMLHttpRequest();
	            const url = contextPath + '/students?ids=' + encodeURIComponent(selectedStudentId);
	            xhr.open('POST', url, true);
	            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	            xhr.onreadystatechange = function() {
	                if (xhr.readyState === 4) {
	                    if (xhr.status === 200) {
	                        const rows = document.querySelectorAll('.student-table tbody tr');
	                        for (let row of rows) {
	                            if (row.getAttribute('data-id') === selectedStudentId) {
	                                row.remove();
	                                break;
	                            }
	                        }
	                        document.getElementById('studentDetails').style.display = 'none';
	                        selectedStudentId = null;
	                    } else {
	                        alert('Lỗi khi xóa sinh viên: Status ' + xhr.status + ' - ' + xhr.statusText + '\nPhản hồi: ' + xhr.responseText);
	                    }
	                }
	            };
	            xhr.onerror = function() {
	                alert('Lỗi kết nối mạng khi xóa sinh viên. Vui lòng kiểm tra kết nối.');
	            };
	            xhr.send();
	        }
	    }
	
	    // --------------------- Room --------------------------  
	    function fetchBuildings() {
		    const xhr = new XMLHttpRequest();
		    xhr.open('GET', contextPath + '/buildings', true);
		    xhr.onreadystatechange = function() {
		        if (xhr.readyState === 4 && xhr.status === 200) {
		            try {
		                const parser = new DOMParser();
		                const doc = parser.parseFromString(xhr.responseText, 'text/html');
		                const buildings = doc.querySelectorAll('script[data-buildings]');
		                if (buildings.length > 0) {
		                    buildingList = JSON.parse(buildings[0].getAttribute('data-buildings'));
		                }
		            } catch (e) {
		                console.error('Lỗi khi lấy danh sách tòa nhà:', e);
		            }
		        }
		    };
		    xhr.send();
		}
	    function selectRoom(row) {
	        const rows = document.querySelectorAll('.room-table tbody tr');
	        rows.forEach(r => r.classList.remove('selected'));
	        row.classList.add('selected');
	        selectedRoomId = row.getAttribute('data-id');
	    }
	    let currentSort = 'name';
	    function sortRooms(sortBy = 'name') {
	        const tbody = document.querySelector('.room-table tbody');
	        if (!tbody) return;

	        const rows = Array.from(tbody.querySelectorAll('tr'));
	        
	        if (sortBy === 'type') {
	            // roomType
	            const order = { 'Đơn': 1, 'Đôi': 2, 'Tập thể': 3 };
	            rows.sort((a, b) => {
	                const typeA = a.getAttribute('data-type') || '';
	                const typeB = b.getAttribute('data-type') || '';
	                return (order[typeA] || 999) - (order[typeB] || 999);
	            });
	        } else {
	            // roomName 
	            rows.sort((a, b) => {
	                const nameA = a.cells[0].textContent.trim() || '';
	                const nameB = b.cells[0].textContent.trim() || '';
	                const buildingA = nameA[0] || 'Z';
	                const buildingB = nameB[0] || 'Z';
	                const numA = nameA.slice(1) || '9999';
	                const numB = nameB.slice(1) || '9999';
	                if (buildingA === buildingB) {
	                    return numA.localeCompare(numB, undefined, { numeric: true });
	                }
	                return buildingA.localeCompare(buildingB);
	            });
	        }

	        rows.forEach(row => tbody.appendChild(row));
	        currentSort = sortBy;
	    }

	    document.addEventListener('DOMContentLoaded', () => {
	        sortRooms('name');

	        const roomTable = document.querySelector('.room-table tbody');
	        if (roomTable) {
	            const rows = roomTable.querySelectorAll('tr');
	            rows.forEach(row => {
	                row.addEventListener('click', function() {
	                    selectRoom(row);
	                });
	            });
	        }

	        const sortButton = document.getElementById('sortButton');
	        if (sortButton) {
	            sortButton.addEventListener('click', () => {
	                const nextSort = currentSort === 'type' ? 'name' : 'type';
	                sortRooms(nextSort);
	                sortButton.textContent = nextSort === 'type' ? 'Sắp xếp' : 'Sắp xếp';
	            });
	        }
	    });	    
	    function addRoom() {
	        window.location.href = '${pageContext.request.contextPath}/admin/addRoom';
	    }
	    
	    function deleteSelectedRoom() {
	        var selectedRoom = document.querySelector('.room-table tr.selected');
	        if (!selectedRoom) {
	            alert("Vui lòng chọn một phòng để xóa!");
	            return;
	        }
	        var selectedRoomId = selectedRoom.getAttribute('data-id');
	        var occupants = selectedRoom.getAttribute('data-occupants');

	        if (occupants > 0) {
	            alert("Không thể xóa phòng đang có người ở!");
	            return;
	        }
	        if (!confirm("Bạn có chắc chắn muốn xóa phòng này?")) {
	            return;
	        }

            fetch(contextPath + '/admin/dashboard?action=deleteRoom&roomId=' + encodeURIComponent(selectedRoomId), {
	            method: 'POST'
	        }).then(response => {
	            if (response.ok) {
	                selectedRoom.remove();
	                alert("Xóa phòng thành công!");
	            } else {
	                return response.text().then(errorMsg => {
	                    alert("Có lỗi khi xóa phòng: " + (errorMsg || response.statusText));
	                });
	            }
	        }).catch(error => {
	            console.error("Lỗi:", error);
	            alert("Lỗi kết nối: " + error.message);
	        });
	    }
	    
	    function editSelectedRoom() {
	    	if (!selectedRoomId) {
	            alert('Vui lòng chọn một phòng để điều chỉnh.');
	            return;
	        }
	        window.location.href = '${pageContext.request.contextPath}/admin/EditRoomServlet?roomID=' + selectedRoomId;
	    }
	    
	    // Invoice
	    let selectedInvoiceId = null;

	    function selectInvoice(row) {
            const rows = document.querySelectorAll('.invoice-table tbody tr');
            rows.forEach(r => r.classList.remove('selected'));
            row.classList.add('selected');
            selectedInvoiceId = row.getAttribute('data-id');
        }
	    function sortInvoices() {
            const tbody = document.querySelector('.invoice-table tbody');
            if (!tbody) return;
            const rows = Array.from(tbody.querySelectorAll('tr'));
            rows.sort((a, b) => {
                const statusA = a.getAttribute('data-paymentstatus');
                const statusB = b.getAttribute('data-paymentstatus');
                return statusA === 'Paid' && statusB === 'Unpaid' ? -1 : statusA === 'Unpaid' && statusB === 'Paid' ? 1 : 0;
            });
            rows.forEach(row => tbody.appendChild(row));
        }

        function editSelectedInvoice() {
            if (!selectedInvoiceId) { alert('Vui lòng chọn một hóa đơn để chỉnh sửa.'); return; }
            window.location.href = '${pageContext.request.contextPath}/admin/EditInvoiceServlet?invoiceID=' + selectedInvoiceId;
        }
        
        // Bieu Do Thong Ke
        document.addEventListener('DOMContentLoaded', function() {
        if (window.location.search.includes('section=statistics')) {
            // Biểu đồ tỉ lệ sinh viên nam và nữ
            const genderCtx = document.getElementById('genderChart').getContext('2d');
            new Chart(genderCtx, {
                type: 'pie',
                data: {
                    labels: ['Nam', 'Nữ'],
                    datasets: [{
                        data: [${maleStudents}, ${femaleStudents}],
                        backgroundColor: ['#36a2eb', '#ff6384']
                    }]
                }
            });

            // Biểu đồ tỉ lệ sinh viên có phòng và chưa có
            const roomStatusCtx = document.getElementById('roomStatusChart').getContext('2d');
            new Chart(roomStatusCtx, {
                type: 'pie',
                data: {
                    labels: ['Có phòng', 'Chưa có phòng'],
                    datasets: [{
                        data: [${studentsWithRooms}, ${studentsWithoutRooms}],
                        backgroundColor: ['#4bc0c0', '#ff9f40']
                    }]
                }
            });

            // Biểu đồ doanh thu từng tháng
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            const monthlyRevenue = [
                <c:forEach var="revenue" items="${monthlyRevenue}">
                    { month: '${revenue[0]}', revenue: ${revenue[1]} },
                </c:forEach>
            ];
            new Chart(revenueCtx, {
                type: 'bar',
                data: {
                    labels: monthlyRevenue.map(item => item.month),
                    datasets: [{
                        label: 'Doanh thu',
                        data: monthlyRevenue.map(item => item.revenue),
                        backgroundColor: '#4a90e2'
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Biểu đồ tỉ lệ phòng trống và phòng đầy
            const roomOccupancyCtx = document.getElementById('roomOccupancyChart').getContext('2d');
            new Chart(roomOccupancyCtx, {
                type: 'pie',
                data: {
                    labels: ['Phòng trống', 'Phòng đầy'],
                    datasets: [{
                        data: [${vacantRooms}, ${fullRooms}],
                        backgroundColor: ['#2ecc71', '#e74c3c']
                    }]
                }
            });
        }
    });
        
        let socket;
        let currentChannel;
        let userID = "${manager.adminID}"; 
        let userName = "${manager.fullName}";
        let userAvatar = '<%=request.getContextPath()%>/images/avt.jpg';
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
                loadChatHistory(currentChannel);
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
		    messageDiv.className = 'chat-message ' + (isSender ? 'chat-sent' : 'chat-received');
		
		    const avatarImg = document.createElement('img');
		    avatarImg.src = messageData.avatarUrl || '<%=request.getContextPath()%>/images/avt.jpg';
		    avatarImg.alt = 'Avatar';
		    avatarImg.className = 'chat-avatar';
		
		    const contentDiv = document.createElement('div');
		    contentDiv.className = 'chat-message-content';
		
		    const headerDiv = document.createElement('div');
		    headerDiv.className = 'chat-message-header';
		
		    const headerGroup = document.createElement('div');
		    headerGroup.className = 'chat-header-group';
		
		    const nameSpan = document.createElement('span');
		    nameSpan.className = 'chat-name';
		    nameSpan.style.color = getColorForUser(messageData.senderID);
		    nameSpan.textContent = messageData.senderName || messageData.senderID || '[Unknown]';
		
		    const timeSpan = document.createElement('span');
		    timeSpan.className = 'chat-time';
		    timeSpan.textContent = messageData.timestamp ? new Date(messageData.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Unknown time';
		
		    const textP = document.createElement('p');
		    textP.className = 'chat-text';
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
		
		    // Thêm .chat-name và .chat-time vào .chat-header-group
		    headerGroup.appendChild(nameSpan);
		    headerGroup.appendChild(timeSpan);
		    headerDiv.appendChild(headerGroup);
		    contentDiv.appendChild(headerDiv);
		    contentDiv.appendChild(textP);
		    messageDiv.appendChild(avatarImg);
		    messageDiv.appendChild(contentDiv);
		    chatBox.appendChild(messageDiv);
		
		    chatBox.scrollTop = chatBox.scrollHeight;
		}
        function filterStudents() {
            const searchInput = document.getElementById('searchStudent').value.toLowerCase();
            const select = document.getElementById('chatWith');
            const options = select.getElementsByTagName('option');

            for (let i = 0; i < options.length; i++) {
                const option = options[i];
                if (option.value === '') {
                    continue; 
                }

                const name = option.getAttribute('data-name') ? option.getAttribute('data-name').toLowerCase() : '';
                const roomName = option.getAttribute('data-roomname') ? option.getAttribute('data-roomname').toLowerCase() : '';
                const value = option.value.toLowerCase();
                const isRoom = value.startsWith('room_');

                let match = false;

                if (searchInput.includes('phòng')) {
                	if (isRoom) {
                        const roomSearch = searchInput.replace('phòng', '').trim();
                        if (roomSearch === '') {
                            match = true;
                        } else if (roomName.includes(roomSearch) || value.includes(roomSearch)) {
                            match = true;
                        }
                    }                } else {
                    if ((isRoom && (roomName.includes(searchInput) || value.includes(searchInput))) ||
                        (!isRoom && (name.includes(searchInput) || value.includes(searchInput)))) {
                        match = true;
                    }
                }

                option.style.display = match ? '' : 'none';
            }
        }
        function getColorForUser(senderID) {
        	const numberPart = parseInt(senderID.replace(/^\D+/, ''), 10);
        	const hue = numberPart % 360;
        	return `hsl(${hue}, 70%, 50%)`;
        }
       
	</script>
</body>
</html>