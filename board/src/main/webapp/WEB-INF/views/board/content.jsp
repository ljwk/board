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

<title>CONTENT</title>
<script src="<c:url value="/resources/js/jquery-3.1.1.min.js"/>"></script>

<link href="<c:url value="/resources/css/style-596b304ea6.min.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/style.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/nice.css" />" rel="stylesheet">
<link href="<c:url value="/resources/css/mui.min.css" />" rel="stylesheet" type="text/css" />


<%-- <script src="<c:url value="/resources/js/script-b1e3e66e02.min.js/"/>"></script> --%>
<script src="<c:url value="/resources/js/jquery-f9c7afd057.min.js/"/>"></script>
<script src="//cdn.muicss.com/mui-0.9.4/js/mui.min.js"></script>
<script src="<c:url value="/resources/js/script.js/"/>"></script>

<script type="text/javascript">
	var mod = false;
	var mod2 = false;
	
	function change(num) {
		$('.recon'+num).css("display", mod ? "block" : "none"); 
		$('.rehidecon'+num).css("display", mod ? "none" : "block"); 
		mod = !mod;
	}

	function modifyreple(number) {
		console.log($('#modifyk'+number).val());
		var obj = {};
		obj.num = number;
		obj.parent = ${num};
		obj.content = $('#modifyk'+number).val();
		obj.modify = true;
		
		$.ajax({
			url : 'writeReple',
			data : obj,
			type : 'post',
			success : function(html) {
				console.log(html);
				$('ul#reple').html(html);
				mod = false;
				mod2 = false;
// 				$('.reple > #' + number + '> input').val('');
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
	}
	
	function reply(number) {
		var obj = {};
		obj.num = ${num};
		obj.author = '${secName}';
		obj.content = $('.reple > #' + number + '> input').val();
		obj.parent = number;

		$.ajax({
			url : 'writeReple',
			data : obj,
			type : 'post',
			success : function(html) {
				console.log(html);
				$('ul#reple').html(html);
				$('.reple > #' + number + '> input').val('');
				mod = false;
				mod2 = false;
			},
			error : function(xhr, status, error) {
				console.log(error);
			}
		});
	};
	
	function visible(renumber) {
		$('.reple > #' + renumber).css("display", mod2 ? "none" : "block");
		mod2 = !mod2;
	};

	function del(num) {
		if (confirm('삭제 하시겠습니까?')) {
			console.log(num);
			var obj = {};
			obj.num = num;
			$.ajax({
				url : 'delete',
				data : obj,
				type : 'post',
				success : function(result) {
					alert(result);
					var obj2 = jQuery.parseJSON(result);
					if (obj2.result == 0) {
						alert("삭제 성공");
						location.href = obj2.way;
					} else if (obj2.denied == 1) {
						alert("삭제 실패 관리자에게 문의하세요");
					} else if (obj2.result == 2) {
						alert("권한이 없습니다");
					}
				},
				error : function(xhr, status, error) {
					console.log(xhr);
					console.log(error);
					console.log(status);
				}
			});
		}
	};
	
	function delreple(num) {
		if (confirm('삭제 하시겠습니까?')) {
			console.log(num);
			var obj = {};
			obj.num = num;
			$.ajax({
				url : 'delete',
				data : obj,
				type : 'post',
				success : function(result) {
					var obj2 = jQuery.parseJSON(result);
					if (obj2.result == 0) {
						alert("삭제 성공");
						location.href = obj2.way;
					} else if (obj2.denied == 1) {
						alert("삭제 실패 관리자에게 문의하세요");
					} else if (obj2.result == 2) {
						alert("권한이 없습니다");
					}
				},
				error : function(xhr, status, error) {
					console.log(xhr);
					console.log(error);
					console.log(status);
				}
			});
		}
	};
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
			<table class="mui-table mui-table--bordered" style="word-break: break-all;">
				<tr>
					<th><h2>${content.title}</h2></th>
				</tr>
				<tr>
					<td colspan="2" height="350px"><textarea onFocus="this.blur()" id="content">${content.content}
						</textarea></td>
				</tr>
				<tr>
					<th>업로더</th>
					<td>${content.author}</td>
				</tr>
				<c:if test="${not empty filedata.filename}">
					<tr>
						<th>파일</th>
						<td><a href="download?id=${filedata.id}&rfile=${filedata.filename}.${filedata.ext}">${filedata.filename}.${filedata.ext}</a></td>
					</tr>
				</c:if>
				<tr>
					<th>등록일</th>
					<td>${content.regdate}</td>
				</tr>
			</table>
			<div class="btnraw">
				<a href="home"><button class="mui-btn mui-btn--raised mui-btn--primary" type="button">목록으로</button></a>
				<sec:authorize access="${secName==content.author}">
					<a href="modify?num=${num}"><button class="mui-btn mui-btn--raised mui-btn--primary" type="button">수정</button></a>
					<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="del(${num});">삭제</button>
				</sec:authorize>
			</div>
			<div class="mui-divider"></div>
			<div>
				<ul class="reple" id="reple">
					<c:forEach var="reple" items="${reples}">
							<li style="padding-left: ${(reple.level -2) * 18}px;">
								<table class="repletable" >
									<tr>
										<th class="recon${reple.num}" style="display:inline-block; width:75%;">
											<label>${reple.author} : ${reple.content}</label> 
										</th>
										<td class="recon${reple.num}" style="display:inline-block; width:270px; text-align: right;">
											<sec:authorize access="hasRole('ROLE_MEMBER')">
												<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="visible(${reple.num});">댓글</button>
												<sec:authorize access="${secName == reple.author}">
													<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="change(${reple.num});">수정</button>
													<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="delreple(${reple.num});">삭제</button>
												</sec:authorize>
											</sec:authorize>
										</td>
										<sec:authorize access="${secName == reple.author}">
											<th class="rehidecon${reple.num}" style="display: none; width:75%;">
												<span>${reple.author} : </span>
												<input id="modifyk${reple.num}" type="text" value="${reple.content}" />
											</th>
											<td class="rehidecon${reple.num}" style="display: none;">
												<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="modifyreple(${reple.num});">수정완료</button>
												<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="change(${reple.num});">취소</button>
											</td>
										</sec:authorize>
									</tr>
								</table>
							</li>
						<li id="${reple.num}" style="display: none; padding-left: ${(reple.level -2) * 18}px;">
							<table class="repletable">
								<tr>
									<td style="display:inline-block; width:75%;">
										<input style="width:100%;"id="input">
									</td>
									<td style="display:inline-block; width:178px;">
										<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="javascript:reply(${reple.num});">댓글</button>
										<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="visible(${reple.num});">취소</button>
									</td>
								</tr>
							</table>
						</li>
					</c:forEach>
				</ul>
			</div>
			<sec:authorize access="hasRole('ROLE_MEMBER')">
				<div>
					<ul class="reple">
						<li id="${num}"><input id="input">
							<button class="mui-btn mui-btn--raised mui-btn--primary" type="button" onclick="javascript:reply(${num});">댓글</button>
						</li>
					</ul>
				</div>
			</sec:authorize>
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