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
<button type="button" id="board">커뮤니티로</button>
<button type="button" id="update">정보수정하기</button>
<button type="button" id="delete">탈퇴하기</button>
<button type="button" id="logout">로그아웃</button>


<script>

    //커뮤니티로 이동
    $("#board").on("click", function () {
        location.href = "/board/list?currentPage=1&count=10&searchType=''&keyword=''";
    });

    //계정 탈퇴
    $("#delete").on("click", function () {
        if (confirm("탈퇴하시겠습니까?")) {
            location.href = "/member/delete?id=${id}";
        }
    });

    //로그아웃
    $("#logout").on("click", function () {
        if (confirm("로그아웃하시겠습니까?")) {
            location.href = "/member/logout?id=${id}";
        }
    });

    //정보 수정 페이지로 이동
    $("#update").on("click", function () {
        location.href = "/member/toUpdateForm?id=${id}";
    });

</script>
</body>
</html>