<xaiArtifact artifact_id="8c62c069-76ce-45ec-84ec-deea9ba1b5aa"
	artifact_version_id="0a35d76b-084c-40bd-aa1b-984b2e1d3239"
	title="admin/passwordChange.jsp" contentType="text/html">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%> <!DOCTYPE html>
<html lang="vi">
<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Thay Đổi Mật Khẩu</title>
		<link rel="stylesheet"
			href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container">
		<h1 class="text-center">Thay Đổi Mật Khẩu</h1>
		<form action="/admin/password/change" method="post">
			<div class="form-group">
				<label for="newPassword">Mật Khẩu Mới:</label> <input
					type="password" class="form-control" id="newPassword"
					name="newPassword" required>
			</div>
			<button type="submit" class="btn btn-primary">Thay Đổi</button>
		</form>
	</div>
</body>
</html>
</xaiArtifact>