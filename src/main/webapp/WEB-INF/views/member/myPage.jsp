<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>마이페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<div>
    <c:if test="${id != null}">
        ${id}님 안녕하세요.
    </c:if>
</div>
<form id="frm" name="frm" method="post"></form>
<form id="frm2" name="frm2" method="post"></form>
<form id="frm3" name="frm3" method="post"></form>
<input type="hidden" value="${id}" id="sessionID">
<c:forEach var="i" items="${list}" varStatus="status" begin="0" end="3">
    <button type="button" id="btn${status.count}"><input type="hidden" value="${i.path}" id="${status.count}">${i.name}</button>
</c:forEach>
<c:forEach var="i" items="${list}" varStatus="status" begin="4" end="6">
    <a href="javascript:api${status.count}()"><button type="button" id="apiBtn${status.count}"><input type="hidden" value="${i.path}" id="api${status.count}">${i.name}</button></a>
</c:forEach>

<a href=${list.get(7).path}?currentPage=1&count=10&keyword=><button type="submit">${list.get(7).name}</button></a>
<script>
    let id = $("#sessionID").val();
    //커뮤니티로 이동
    $("#btn1").on("click", function () {
        location.href = $("#1").val();``
    });

    //계정 탈퇴
    $("#btn2").on("click", function () {
        if (confirm("탈퇴하시겠습니까?")) {
            location.href =$("#2").val()+id;
        }
    });

    //로그아웃
    $("#btn3").on("click", function () {
        if (confirm("로그아웃하시겠습니까?")) {
            location.href = $("#3").val()+id;
        }
    });

    //정보 수정 페이지로 이동
    $("#btn4").on("click", function () {
        location.href = $("#4").val() + id;
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

        form.action =  $("#api1").val();
        form.submit();
    }

    //일별 감염자수
    function api2(){
        let form =  $('form[name="frm2"]')[0];
        form.action=$("#api2").val();
        form.submit();
    }

    //월별 감염자수
    function api3(){
        let form = $("#frm3")[0];
        form.action=$("#api3").val();
        form.submit();
    }

</script>
</body>
</html>