<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Sinh Viên</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/register.css">

</head>
<body>
  <div class="form-container">
	<header>
   	 	<h2>Đăng Ký Tài Khoản Sinh Viên</h2>
    </header>
    <form action="<%=request.getContextPath()%>/register" method="post">
        <div class="form-grid">
     	<!-- Column 1 -->
     	  <div class="column">
     	
	        <label for="IDSinhVien">ID Sinh Viên:</label>
	        <input type="text" id="IDSinhVien" name="IDSinhVien" required>

			<label for="Password">Mật Khẩu:</label>
	        <input type="password" id="Password" name="Password" required>
	        
	        
			<label for="Email">Email:</label>
	        <input type="text" id="Email" name="Email" required>
	      </div>
	    <!-- Column 2 -->
	      <div class="column">
	      
	        <label for="FullName">Họ và Tên:</label>
	        <input type="text" id="FullName" name="FullName" required>

	        <label for="PhoneNumber">Số Điện Thoại:</label>
	        <input type="text" id="PhoneNumber" name="PhoneNumber" required>

	        <label for="CCCDID">Số CCCD:</label>
	        <input type="text" id="CCCDID" name="CCCDID" required>
		  </div>
        </div>

    	<input type="submit" value="Đăng Ký" class="btn-submit">
        
		<a href="<%=request.getContextPath()%>/index.jsp" class="back-link">Quay lại</a>
	
	<!-- Debug -->
    <% if (request.getParameter("error") != null) { %>
        <p class="error">Lỗi: 
            <% if ("missing_fields".equals(request.getParameter("error"))) { %>
                Vui lòng điền đầy đủ thông tin!
            <% } else if ("database_error".equals(request.getParameter("error"))) { %>
                Lỗi cơ sở dữ liệu, vui lòng thử lại!
            <% } %>
        </p>
    <% } %>
    </form>
   </div>
</body>
</html>