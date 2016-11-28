<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>AB</title>
<script src="<c:url value="/resources/js/jquery-3.1.1.min.js"/>"></script>

<link href="<c:url value="/resources/css/nice.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/mui.min.css" />" rel="stylesheet" type="text/css" />

<script src="//cdn.muicss.com/mui-0.9.4/js/mui.min.js"></script>

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

.rootdiv {
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
</head>
<body class="hide-sidedrawer">
	<div class="rootdiv">
		<h1>Anonymous Board</h1>
		<div>
			<form class="loginForm" action="user/login" method="post">
				<table>
					<tr>
						<th>ID</th>
						<td><input name="id" type="text"></td>
					</tr>
					<tr>
						<th>PW</th>
						<td><input name="pw" type="password"></td>
					</tr>
					<tr>
						<td colspan="2"><button class="mui-btn mui-btn--raised mui-btn--primary" type="submit">Login</button> <a href="join"><button type="button" class="mui-btn mui-btn--raised mui-btn--primary">Join</button></a></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>