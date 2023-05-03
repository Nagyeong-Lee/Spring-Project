<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>마이페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
            crossorigin="anonymous"></script>
    <style>
        * {
            cursor: pointer;
            text-decoration: none;
        }

        .flex-nav {
            display: flex;
            justify-content: space-between;
        }

        .flex-nav > div {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/product/communityNavUtil.jsp"%>
<%--<form id="frm" name="frm" method="post"></form>--%>
<%--<form id="frm2" name="frm2" method="post"></form>--%>
<%--<form id="frm3" name="frm3" method="post"></form>--%>
<%--<input type="hidden" value="${id}" id="sessionID">--%>
<%--<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">--%>
<%--    <div class="collapse navbar-collapse flex-nav" id="navbarSupportedContent">--%>
<%--        <div>--%>
<%--            <ul class="navbar-nav mr-auto">--%>
<%--                <li class="nav-item active">--%>
<%--                    <span id="btn1" style="color: white">커뮤니티로</span>--%>
<%--                </li>--%>
<%--                &nbsp--%>
<%--            </ul>--%>
<%--            &nbsp&nbsp&nbsp&nbsp--%>
<%--            <ul class="navbar-nav mr-auto">--%>
<%--                <li class="nav-item active">--%>
<%--                    <span id="btn4" style="color: white">정보 수정</span>--%>
<%--                </li>--%>
<%--                &nbsp--%>
<%--            </ul>--%>
<%--            &nbsp&nbsp&nbsp&nbsp--%>
<%--            <ul class="navbar-nav mr-auto">--%>
<%--                <c:forEach var="i" items="${pathList}" varStatus="status" begin="2" end="4">--%>
<%--                    <li class="nav-item active">--%>
<%--                        <a href="javascript:api${status.count}()" style="text-decoration: none; color: white">--%>
<%--                            <input type="hidden" value="${i.path}" id="api${status.count}">${i.name}</a>--%>
<%--                    </li>--%>
<%--                    &nbsp&nbsp&nbsp&nbsp&nbsp--%>
<%--                </c:forEach>--%>
<%--            </ul>--%>
<%--        </div>--%>

<%--        <ul class="navbar-nav mr-auto" style="margin-left: -750px;">--%>
<%--            <li class="nav-item active">--%>
<%--                <a href=${pathList.get(5).path}?currentPage=1&count=10--%>
<%--                   style="color: white; text-decoration: none">${pathList.get(5).name}</a>--%>
<%--            </li>--%>
<%--        </ul>--%>
<%--        &nbsp&nbsp&nbsp--%>
<%--        <div style="margin-right: -750px;">--%>
<%--            <ul class="navbar-nav mr-auto">--%>
<%--                <li class="nav-item active">--%>
<%--                    <a href="${pathList.get(6).path}" style="color: white; text-decoration: none">커머스</a>--%>
<%--                </li>--%>
<%--                &nbsp--%>
<%--            </ul>--%>
<%--            &nbsp&nbsp&nbsp&nbsp--%>
<%--&lt;%&ndash;            <ul class="navbar-nav mr-auto">&ndash;%&gt;--%>
<%--&lt;%&ndash;                <li class="nav-item active">&ndash;%&gt;--%>
<%--&lt;%&ndash;                    <span style="color: white" id="toCart">${pathList.get(7).name}</span>&ndash;%&gt;--%>
<%--&lt;%&ndash;                </li>&ndash;%&gt;--%>
<%--&lt;%&ndash;                &nbsp&ndash;%&gt;--%>
<%--&lt;%&ndash;            </ul>&ndash;%&gt;--%>
<%--        </div>--%>

<%--        <div>--%>
<%--            <ul class="navbar-nav mr-auto">--%>
<%--                <li class="nav-item active">--%>
<%--                    <span style="color: white" id="logout">로그아웃</span>--%>
<%--                </li>--%>
<%--                &nbsp--%>
<%--            </ul>--%>
<%--        </div>--%>

<%--    </div>--%>
<%--</nav>--%>

<%--<div>--%>
<%--    <c:if test="${id != null}">--%>
<%--        ${id}님 안녕하세요.--%>
<%--    </c:if>--%>
<%--</div>--%>

<%--<c:forEach var="i" items="${list}" varStatus="status" begin="0" end="3">--%>
<%--    <button type="button" id="btn${status.count}"><input type="hidden" value="${i.path}" id="${status.count}">${i.name}</button>--%>
<%--</c:forEach>--%>
<%--<c:forEach var="i" items="${list}" varStatus="status" begin="4" end="6">--%>
<%--    <a href="javascript:api${status.count}()"><button type="button" id="apiBtn${status.count}"><input type="hidden" value="${i.path}" id="api${status.count}">${i.name}</button></a>--%>
<%--</c:forEach>--%>

<%--&lt;%&ndash;뉴스 검색&ndash;%&gt;--%>
<%--<a href=${list.get(7).path}?currentPage=1&count=10><button type="submit">${list.get(7).name}</button></a>--%>
<%--&lt;%&ndash;쿠폰함&ndash;%&gt;--%>
<%--&lt;%&ndash;<a href="${list.get(14).path}"><button type="button">${list.get(14).name}</button></a>&ndash;%&gt;--%>
<%--&lt;%&ndash;상품목록&ndash;%&gt;--%>
<%--<a href="${list.get(9).path}"><button type="button">${list.get(9).name}</button></a>--%>
<%--&lt;%&ndash;장바구니&ndash;%&gt;--%>
<%--<form name="frm" method="post" action="/product/cart">--%>
<%--    <input type="hidden" name="id" value="${id}" id="id">--%>
<%--    <button type="submit">${list.get(10).name}</button>--%>
<%--</form>--%>
<script src="/resources/asset/js/util.js"></script>
<script>
    let id = $("#sessionID").val();
    //커뮤니티로 이동
    $("#btn1").on("click", function () {
        location.href = '/board/list?currentPage=1&count=10';
    });

    //계정 탈퇴
    $("#btn2").on("click", function () {
        if (confirm("탈퇴하시겠습니까?")) {
            location.href = $("#2").val() + id;
        }
    });

    //로그아웃
    $("#logout").on("click", function () {
        if (confirm("로그아웃하시겠습니까?")) {
            location.href = '/member/logout?id=' + id;
        }
    });

    //정보 수정 페이지로 이동
    $("#btn4").on("click", function () {
        location.href = '/member/toUpdateForm?id=' + id;
    });

    //병원 정보
    function api1() {
        $('#frm').html("");
        var form = $('form[name="frm"]')[0];
        var html = '<input type="hidden" value="1" name="currentPage" />';
        html += '<input type="hidden" value="10" id="count" name="count" />';
        html += '<input type="hidden" value="" id="searchType" name="searchType" />';
        html += '<input type="hidden" value="" id="keyword" name="keyword" />';
        $('#frm').append(html);

        form.action = $("#api1").val();
        form.submit();
    }

    //일별 감염자수
    function api2() {
        let form = $('form[name="frm2"]')[0];
        form.action = $("#api2").val();
        form.submit();
    }

    //월별 감염자수
    function api3() {
        let form = $("#frm3")[0];
        form.action = $("#api3").val();
        form.submit();
    }


    $("#toCart").click(function () {
        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/product/cart");
        let newInput = document.createElement("input");
        newInput.setAttribute("type", "hidden");
        newInput.setAttribute("name", "id");
        newInput.setAttribute("value", $("#sessionID").val());
        newForm.appendChild(newInput);
        document.body.append(newForm);
        newForm.submit();
    })

</script>
</body>
</html>