<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Biểu Đồ Giới Tính</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <canvas id="genderChart"></canvas>
    <script>
        var ctx = document.getElementById('genderChart').getContext('2d');
        var chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Nam', 'Nữ'],
                datasets: [{
                    data: [${maleCount}, ${femaleCount}],
                    backgroundColor: ['#36a2eb', '#ff6384']
                }]
            },
            options: {
                responsive: true,
                title: { display: true, text: 'Phân Bố Giới Tính' }
            }
        });
    </script>
</body>
</html>