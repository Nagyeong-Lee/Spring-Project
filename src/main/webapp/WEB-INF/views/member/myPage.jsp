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

<script>

    let id = $("#sessionID").val();
    //커뮤니티로 이동
    $("#btn1").on("click", function () {
        location.href = $("#1").val();
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
        /*let path = $("#api1").val();
        let form = document.createElement("form");
        form.setAttribute("method", "post");
        form.setAttribute("action", path);

        let input1 = document.createElement("input1");
        let input2 = document.createElement("input2");
        let input3 = document.createElement("input3");
        let input4 = document.createElement("input4");

        input1.setAttribute("type", "hidden");
        input1.setAttribute("name", "currentPage");
        input1.setAttribute("value", parseInt("1"));
        let crr_page = '<input type="hidden" name="currentPage" value="1">'

        input2.setAttribute("type", "hidden");
        input2.setAttribute("name", "count");
        input2.setAttribute("value", parseInt("10"));
        let count = '<input type="hidden" name="count" value="10">'

        input3.setAttribute("type", "hidden");
        input3.setAttribute("name", "searchType");
        input3.setAttribute("value", "TEST");

        input4.setAttribute("type", "hidden");
        input4.setAttribute("name", "keyword");
        input4.setAttribute("value", "T2");

        //form.append(input1);
        form.append(crr_page);
        //form.append(input2);
        form.append(count);
        form.append(input3);
        form.append(input4);

        document.body.appendChild(form);
        form.submit();*/

        $('#frm').html("");
        var form = $('form[name="frm"]')[0];
        var html = '<input type="hidden" value="1" name="currentPage" />';
        html += '<input type="hidden" value="10" id="count" name="count" />';
        html += '<input type="hidden" value="" id="searchType" name="searchType" />';
        html += '<input type="hidden" value="" id="keyword" name="keyword" />';
        html += '<input type="hidden" value="" id="city" name="city" />';
        $('#frm').append(html);

        form.action =  $("#api1").val();;
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