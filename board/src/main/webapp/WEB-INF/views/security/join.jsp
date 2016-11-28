<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Join</title>
<script src="<c:url value="/resources/js/jquery-3.1.1.min.js"/>"></script>

<link href="<c:url value="/resources/css/mui.min.css" />" rel="stylesheet" type="text/css" />

<script src="//cdn.muicss.com/mui-0.9.4/js/mui.min.js"></script>

<script type="text/javascript">
	var check = false;

	function sendJoin() {
		if (check) {
			$('#join').submit();
		} else {
			alert("중복 검사를 해주세요");
		}
	};

	function duplicate() {
		var obj = {};
		obj.id = $('#id').val();

		$.ajax({
			url : "duplicate",
			data : obj,
			type : "post",
			dataType : "json",
			success : function(result) {
				if (result) {
					check = true;
					alert("가입 가능");
				} else {
					alert("중복");
				}
			},
			error : function(xhr, status, error) {
				console.log(xhr);
				console.log(status);
				console.log(error);
			}
		});
	}
</script>
<style type="text/css">
button {
	width: 100px;
}

form {
	width: 300px;
	margin: 0 auto;
	text-align: center;
}

h1 {
	text-align: center;
}

tr {
	text-align: center;
}

body {
	position: absolute;
	top: 50%;
	left: 50%;
	width: 300px;
	height: 200px;
	overflow: hidden;
	margin-top: -150px;
	margin-left: -100px;
}

table {
	margin: 0 auto;
}

</style>
<title>회원 가입</title>
</head>
<body>
	<c:choose>
		<c:when test="${result == null}">
			<form action="certify" method="post">
				<h1>이메일 인증</h1>
				<input type="text" name="email"><br>
				<button class="mui-btn mui-btn--raised mui-btn--primary" type="submit">인증</button>
			</form>
		</c:when>
		<c:when test="${result eq 'pass'}">
			<h1>회원 가입</h1>
			<form method="post" id="join" action="join" method="post">
				<table>
					<tr>
						<th>EMAIL</th>
						<td><label id="email">${email}</label></td>
						<td><input type="hidden" name="email" value="${email}"></td>
					</tr>
					<tr>
						<th>ID</th>
						<td><input type="text" name="id" id="id"></td>
						<td><button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="duplicate();">중복 확인</button>
					</tr>
					<tr>
						<th>PW</th>
						<td><input type="password" name="pw"></td>
					</tr>
					<tr>
						<td colspan="2"><button type="button" onclick="sendJoin();" class="mui-btn mui-btn--raised mui-btn--primary">회원가입</button></td>
					</tr>
				</table>
			</form>
		</c:when>
	</c:choose>
</body>
</html>