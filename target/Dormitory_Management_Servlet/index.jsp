<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>Trang Chủ – Quản lý Ký túc xá VKU</title>
	<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        /* Custom styles */
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(90deg, #00ffff, #4a90e2);
            margin: 0; 
            padding-top: 76px;
        }
        .navbar {
            background: linear-gradient(135deg, #ffffff 40%, #4a90e2 60%);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .navbar-brand img {
            max-height: 50px;
        }
        .nav-link {
            color: #fff !important;
            font-weight: 700;
            padding: 8px 15px;
            border-radius: 5px;
            transition: background 0.3s ease, transform 0.2s ease;
        }
        .nav-link:hover {
            background: #357abd;
            transform: scale(1.05);
        }
        /* Swiper Slider */
        .swiper {
            position: relative;
            height: 90vh;
            width: 100%;
        }
        .swiper-slide img {
            height: 100%;
            width: 100%;
            object-fit: cover;
        }
        .swiper-button-prev, .swiper-button-next {
            color: #fff;
            width: 5%;
            opacity: 0.5;
        }
        .swiper-button-prev:hover, .swiper-button-next:hover {
            opacity: 1;
        }
        .swiper-pagination-bullet {
            width: 10px;
            height: 10px;
            background: #fff;
            opacity: 0.5;
        }
        .swiper-pagination-bullet-active {
            opacity: 1;
            background: #4a90e2;
        }
        .swiper-pagination {
            bottom: 10px;
        }
        @media (max-width: 768px) {
            .swiper {
                height: 45vh;
            }
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp">
                <img src="<%=request.getContextPath()%>/images/homepage/logo.png" alt="VKU Ký túc xá logo">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/loginAdmin.jsp">Đăng nhập Admin</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/login.jsp">Đăng nhập</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/register.jsp">Đăng ký</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Swiper Slider -->
    <div class="swiper mySwiper">
        <div class="swiper-wrapper">
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (1).jpg" alt="Slide 1">
            </div>
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (2).jpg" alt="Slide 2">
            </div>
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (3).jpg" alt="Slide 3">
            </div>
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (4).jpg" alt="Slide 4">
            </div>
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (5).jpg" alt="Slide 5">
            </div>
            <div class="swiper-slide">
                <img src="<%=request.getContextPath()%>/images/homepage/slide (6).jpg" alt="Slide 6">
            </div>
        </div>
        <!-- Nút điều hướng -->
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
        <!-- Chấm điều hướng -->
        <div class="swiper-pagination"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const swiper = new Swiper('.mySwiper', {
                slidesPerView: 1, // 1 slide/màn hình
                spaceBetween: 0,
                loop: true, // Vòng lặp vô hạn
                autoplay: {
                    delay: 2000, // Chuyển slide mỗi 2 giây
                    disableOnInteraction: true, // Dừng tự động chạy khi kéo thả
                },
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                speed: 500, // Hiệu ứng chuyển 0.5 giây
                on: {
                    touchStart: function () {
                        this.autoplay.stop(); // Dừng tự động chạy khi kéo
                    },
                    touchEnd: function () {
                        this.autoplay.start(); // Reset tự động chạy khi thả
                    },
                },
            });
        });
    </script>
</body>
</html>