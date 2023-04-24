<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-03-13
  Time: 오후 9:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>관리자 메인페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
    <script src="https://malsup.github.io/jquery.form.js"></script>
</head>
<body>
<a href="/admin/mngMember">
    <button type="button">회원관리</button>
</a><br>
<a href="/admin/chart">
    <button type="button">월별 회원가입 차트</button>
    <br>
</a>
<a href="/admin/list?currentPage=1&count=10&postNum=&searchType=&keyword="><button type="button">로그 확인</button></a>
<br>
<button type="button" id="logout"><input type="hidden" id="toLogOut" value="${logoutPath}">로그아웃</button>
<input type="hidden" id="session" name="session" value="${id}">
<br>
<button type="button" id="register">상품 등록</button>
<script>
    let path=$("#toLogOut").val();
    let session=$("#session").val();
    $("#logout").on("click",function(){
        location.href=path+session;
    });

    //상품 등록
    $("#register").click(function(){
       location.href='/admin/registerPd';
    });
</script>
</body>
</html>
