<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<sec:authentication property="name" var="secName" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>LIST</title>
<script src="<c:url value="/resources/js/jquery-3.1.1.min.js"/>"></script>

<link href="<c:url value="/resources/css/style-596b304ea6.min.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/style.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/mui.min.css" />" rel="stylesheet" type="text/css" />
<link href="<c:url value="/resources/css/nice.css" />" rel="stylesheet">

<script src="<c:url value="/resources/js/jquery-f9c7afd057.min.js/"/>"></script>
<script src="//cdn.muicss.com/mui-0.9.4/js/mui.min.js"></script>
<script src="<c:url value="/resources/js/script.js/"/>"></script>

<script type="text/javascript">
	var page = ${page == null ? 1 : page}; /* 현재 페이지 */
	var totalPage = ${total};
	var naviEA = 3;
	var viewNaviList = parseInt((page - 1) / naviEA);
	var word = '${word}';
	console.log(naviEA);
	console.log(viewNaviList);
	
	$(function() {
		setNavi(0);
	});
	
	function setPage(page) {
		if (word != '') {
			location.href='home?page=' + page + '&word=' + word + '&select=' + $('[name=select]').val();
		} else {
			location.href='home?page=' + page;
		}
	}
	
	function setNavi(set) {
		viewNaviList += set;
		var firstLink = viewNaviList * naviEA + 1;
		
		for (var i = firstLink; i < firstLink + (totalPage - firstLink > naviEA ? naviEA : totalPage - firstLink + 1); i++) {
			if (i == firstLink) {
				$('#navi').html("<button type='button' onclick='setPage(" + i + ")'>" + i + "</button>");
			} else {
				$('#navi').append("<button type='button' onclick='setPage(" + i + ")'>"	+ i + "</button>");
			}
		}
		
		if (viewNaviList > 0) {
			$('#prevNavi').html("<button type='button' onclick='setNavi(-1)'>&#60</button>");
		} else {
			$('#prevNavi').empty();
		}
		console.log((viewNaviList + 1) + " < " + parseInt(totalPage / naviEA));
		if (viewNaviList + 1 < parseInt(Math.ceil(totalPage / naviEA))) {
			$('#nextNavi').html("<button type='button' onclick='setNavi(1)'>&#62</button>");
		} else {
			$('#nextNavi').empty();
		}
	}

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
			<table class="mui-table mui-table--bordered">
				<thead>
					<tr>
						<th style="width: 5%; text-align: center;">번호</th>
						<th>제목</th>
						<th style="width: 10%;">작성자</th>
						<th style="width: 10%;">날짜</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="e" items="${list}">
						<tr>
							<td style="text-align: center;">${e.num}</td>
							<td><a href="content?num=${e.num}">${e.title}</a></td>
							<td>${e.author}</td>
							<td>${e.regdate}</td>
						</tr>
					</c:forEach>
				</tbody>
				<tr>
					<td colspan="4" class="btnraw"><a href="write"><button class="mui-btn mui-btn--raised mui-btn--primary" type="button">글쓰기</button></a></td>
				</tr>
			</table>
			<div class="navi">
				<span id="prevNavi"></span> <span id="navi"></span> <span id="nextNavi"></span>
			</div>
			<div class="search">
				<form class="mui-form--inline" action="home" method="post">
					<select id="selt" name="select">
						<option value="author" ${select eq 'author' ? 'selected=\"selected\"' : null}>업로더</option>
						<option value="title" ${select eq 'title' ? 'selected=\"selected\"' : null}>제목</option>
					</select>
					<div class="mui-textfield">
						<input style="" type="text" class="mui--is-empty" name="word" value="${word}">
					</div>
					<button type="submit" class="mui-btn mui-btn--raised mui-btn--primary">검색</button>
				</form>
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
	</div>
</body>
</html>