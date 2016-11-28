<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<jsp:useBean id="toDay" class="java.util.Date" />
<fmt:formatDate value="${toDay}" pattern="yyyy-MM-dd" var="date" />
<c:if test="${not empty boardVO}">
	<fmt:formatDate value="${boardVO.regdate}" pattern="yyyy-MM-dd" var="redate" />
</c:if>
<sec:authentication property="name" var="secName" />
<%
	// 	Enumeration<String> en = request.getAttributeNames();
	// 	while (en.hasMoreElements()) {
	// 		String enstr = en.nextElement();
	// 		System.out.println("속성명 : " + enstr);
	// 	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>글쓰기</title>
<script src="<c:url value="/resources/js/jquery-3.1.1.min.js"/>"></script>

<link href="<c:url value="/resources/css/style-596b304ea6.min.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/style.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/nice.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/mui.min.css" />" rel="stylesheet" type="text/css" />

<script src="<c:url value="/resources/js/jquery-f9c7afd057.min.js/"/>"></script>
<script src="//cdn.muicss.com/mui-0.9.4/js/mui.min.js"></script>
<script src="<c:url value="/resources/js/script.js/"/>"></script>
<script src="http://malsup.github.com/jquery.form.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		var option = {
			error : function(xhr, status, error) {
				alert(error);
			},
			complete : function(res) {
				var obj = jQuery.parseJSON(res.responseText);
				if (obj.result) {
					alert("저장 성공");
					location.href = obj.way;
				} else {
					alert("저장 실패 다시 시도해주세요");
				}
			}
		};
		$('form[name=uploadForm]').ajaxForm(option);
	});
</script>
</head>
<body class="hide-sidedrawer">
	<header id="header">
	<div class="mui-appbar mui--appbar-line-height">
		<div class="mui-container-fluid">
			<a class="sidedrawer-toggle mui--visible-xs-inline-block mui--visible-sm-inline-block js-show-sidedrawer">☰</a> <a class="sidedrawer-toggle mui--hidden-xs mui--hidden-sm js-hide-sidedrawer">☰</a> <a class="appbar-brand" href="home">Board</a>
		</div>
	</div>
	</header>
	<div id="content-wrapper">
		<div class="mui--appbar-height"></div>
		<div class="mui-container-fluid">

			<form:form name="uploadForm" method="post" enctype="multipart/form-data" action="write" commandName="boardVO">
				<form:input type="hidden" path="num" />
				<form:input type="hidden" path="modify" />
				<table class="mui-table mui-table--bordered" style="word-break: break-all;">
					<c:if test="${not empty boardVO.filename}">
						<tr>
							<th>등록된 파일</th>
							<td>${boardVO.filename}　　<input type="checkbox" name="deletefile" value="true">삭제
							</td>
							<form:input type="hidden" path="filename" />
						</tr>
					</c:if>
					<tr>
						<th>파일선택</th>
						<td><form:input type="file" path="uploadedFile" /></td>
						<form:errors path="uploadedFile" cssClass="errorMsg"></form:errors>
					</tr>
					<tr>
						<th>업로더</th>
						<td><label>${secName}</label></td>
						<form:input type="hidden" path="author" value="${secName}" />
						<form:errors path="author" cssClass="errorMsg" />
					</tr>
					<tr>
						<th>제목</th>
						<td><form:input style="width:100%;" type="text" path="title" /></td>
						<form:errors path="title" cssClass="errorMsg" />
					</tr>
					<tr>
						<th>내용</th>
						<td><form:textarea type="text" path="content" id="wcontent"/></td>
					</tr>
					<tr>
						<th>등록일</th>
						<td><label>${not empty redate ? redate : date}</label></td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center;"><button class="mui-btn mui-btn--raised mui-btn--primary" type="submit">전송</button></td>
					</tr>
				</table>
			</form:form>
			<div class="btnraw">
				<a href="home"><button class="mui-btn mui-btn--raised mui-btn--primary" type="button">목록으로</button></a>
			</div>
		</div>
	</div>
	<footer id="footer">
	<div class="mui-container-fluid">
		<br> Made with LJW by <a href="https://www.muicss.com">MUI</a>
	</div>
	</footer>
	<div id="sidedrawer" class="mui--no-user-select">
		<div id="sidedrawer-brand" class="mui--appbar-line-height">${secName != 'anonymousUser' ? secName : 'Guest'}</div>
		<div class="mui-divider"></div>
		<ul>
			<c:if test="${secName == 'anonymousUser'}">
				<li><a href="/board/login"><strong>로그인</strong></a></li>
			</c:if>
			<c:if test="${secName != 'anonymousUser'}">
				<li><a href="<c:url value="/logout" />"><strong>로그아웃</strong></a></li>
			</c:if>
		</ul>
	</div>
</body>
</html>