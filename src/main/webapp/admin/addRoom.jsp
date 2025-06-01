<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Phòng Mới</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    
	<style>
		body {
	        background: linear-gradient(to right, #fa66ab, #fbc2eb, #a18cd1);
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
    <div class="container form-wrapper">
        <h2 class="form-title">Thêm Phòng Mới</h2>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
			<form action="${pageContext.request.contextPath}/admin/addRoom" method="post" class="form">            
			<div class="form-group">
                <label for="buildingID">Tòa nhà:</label>
                <select id="buildingID" name="buildingID" class="form-control">
                    <c:forEach var="b" items="${buildings}">
                        <option value="${b.buildingID}">${b.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="floor">Tầng (1-5):</label>
                <select id="floor" name="floor" class="form-control" required>
                    <c:forEach var="i" begin="1" end="5">
                        <option value="${i}">${i}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="roomNumber">Số phòng (1-20):</label>
                <select id="roomNumber" name="roomNumber" class="form-control" required>
                    <c:forEach var="i" begin="1" end="20">
                        <option value="${i}">${i}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="roomType">Loại phòng:</label>
                <select id="roomType" name="roomType" class="form-control" required>
                    <option value="Đơn">Đơn</option>
                    <option value="Đôi">Đôi</option>
                    <option value="Tập thể">Tập thể</option>
                </select>
            </div>
            <div class="form-group">
                <label for="capacity">Sức chứa:</label>
                <input type="number" id="capacity" name="capacity" min="1" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="price">Giá phòng (VNĐ):</label>
                <input type="number" id="price" name="price" min="0" step="100000" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Thêm Phòng</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/admin/dashboard?section=rooms'">Quay Lại</button>
        </form>
    </div>
    <script>
        function updateCapacity() {
            const roomType = document.getElementById("roomType").value;
            const capacityInput = document.getElementById("capacity");
            switch (roomType) {
                case "Đơn":
                    capacityInput.value = 1;
                    break;
                case "Đôi":
                    capacityInput.value = 2;
                    break;
                case "Tập thể":
                    capacityInput.value = 4;
                    break;
            }
        }
        updateCapacity();
    </script>
 </body>
</html>
