<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Trang Chủ – Quản lý Ký túc xá VKU</title>
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/homepage.css">
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
	
</head>
<body>
    <!-- Header Logo -->
  <header class="site-header">
    <img src="<%=request.getContextPath()%>/images/homepage/logo.png" alt="VKU Ký túc xá logo">
  </header>

  <!-- Menu bar -->
  <nav class="menu-bar">
    <ul>
      <li><a href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a></li>
      <li><a href="<%=request.getContextPath()%>/loginAdmin.jsp">Đăng nhập Admin</a></li>
      <li><a href="<%=request.getContextPath()%>/login.jsp">Đăng nhập</a></li>
      <li><a href="<%=request.getContextPath()%>/register.jsp">Đăng ký</a></li>
    </ul>
  </nav>

  <!-- Container -->
  <div class="slider-container">
    <div class="slider-wrapper">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (1).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (2).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (3).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (4).png" alt="">
      <!-- Clone for somulthy -->
      <img src="<%=request.getContextPath()%>/images/homepage/slide (1).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (2).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (3).png" alt="">
      <img src="<%=request.getContextPath()%>/images/homepage/slide (4).png" alt="">
    </div>
  </div>
</body>
</html>