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

<input type="hidden" value="${id}" id="sessionID">
<button type="button" id="board"><input type="hidden" value="${communityPath}" id="toCommunity">커뮤니티로</button>
<button type="button" id="update"><input type="hidden" value="${updateFormPath}" id="toUpdate">정보수정하기</button>
<button type="button" id="delete"><input type="hidden" value="${deletePath}" id="toDelete">탈퇴하기</button>
<button type="button" id="logout"><input type="hidden" value="${logoutPath}" id="toLogout">로그아웃</button>

<script>

    let id = $("#sessionID").val();
    //커뮤니티로 이동
    $("#board").on("click", function () {
        location.href = $("#toCommunity").val();
    });

    //계정 탈퇴
    $("#delete").on("click", function () {
        if (confirm("탈퇴하시겠습니까?")) {
            location.href =$("#toDelete").val()+id;
        }
    });

    //로그아웃
    $("#logout").on("click", function () {
        if (confirm("로그아웃하시겠습니까?")) {
            location.href = $("#toLogout").val()+id;
        }
    });

    //정보 수정 페이지로 이동
    $("#update").on("click", function () {
        location.href = $("#toUpdate").val() + id;
    });

</script>
</body>
</html>