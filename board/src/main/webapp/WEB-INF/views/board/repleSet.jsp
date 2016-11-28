<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication property="name" var="secName" />

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