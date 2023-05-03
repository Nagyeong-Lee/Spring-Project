<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-02
  Time: 오후 6:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<form id="frm" name="frm" method="post"></form>
<form id="frm2" name="frm2" method="post"></form>
<form id="frm3" name="frm3" method="post"></form>
<input type="hidden" value="${id}" id="sessionID">
<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
    <div class="collapse navbar-collapse flex-nav" id="navbarSupportedContent">
        <div>
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <span id="btn1" style="color: white">커뮤니티로</span>
                </li>
                &nbsp
            </ul>
            &nbsp&nbsp&nbsp&nbsp
            <ul class="navbar-nav mr-auto">
                <c:forEach var="i" items="${pathList}" varStatus="status" begin="2" end="4">
                    <li class="nav-item active">
                        <a href="javascript:api${status.count}()" style="text-decoration: none; color: white">
                            <input type="hidden" value="${i.path}" id="api${status.count}">${i.name}</a>
                    </li>
                    &nbsp&nbsp&nbsp&nbsp&nbsp
                </c:forEach>
            </ul>
        </div>

        <ul class="navbar-nav mr-auto" style="margin-left: -800px;">
            <li class="nav-item active">
                <a href=${pathList.get(5).path}?currentPage=1&count=10
                   style="color: white; text-decoration: none">${pathList.get(5).name}</a>
            </li>
        </ul>
        &nbsp&nbsp&nbsp
        <div style="margin-right: -800px;">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a href="${pathList.get(6).path}" style="color: white; text-decoration: none">커머스</a>
                </li>
                &nbsp
            </ul>
            &nbsp&nbsp&nbsp&nbsp
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <span id="btn4" style="color: white">정보 수정</span>
                </li>
                &nbsp
            </ul>
            &nbsp&nbsp&nbsp&nbsp
        </div>

        <div>
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <span style="color: white" id="logout">로그아웃</span>
                </li>
                &nbsp
            </ul>
        </div>

    </div>
</nav>

