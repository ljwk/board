<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Fail</title>
<script type="text/javascript">
	window.onload = function() {
		var i = 4;
		setInterval(function() {
			document.getElementById("timer").innerHTML = (i -= 1)
					+ "초 후 이동합니다.";
			console.log(i);
			if (i == 0) {
				location.href = "login";
			}
		}, 1000);
	};
</script>
<style type="text/css">
h1 {
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
</style>
</head>
<body>
	<h1>접근 권한이 없습니다</h1>
	<div>
		<h2 id="timer"></h2>
	</div>
</body>
</html>