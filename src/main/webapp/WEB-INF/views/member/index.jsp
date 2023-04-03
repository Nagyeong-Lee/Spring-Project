<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>

<div class="loginBox">
    <form action="/member/login" method="post">
        아이디 &nbsp&nbsp&nbsp<input type="text" id="id" name="id"> <br>
        비밀번호 <input type="password" id="pw" name="pw">
        <br>
        <br>
        <a href="/member/toSignUpForm"><input type="button" value="회원가입"></a>
        <input type="submit" value="로그인" id="loginBtn">
        <input type="button" value="ID찾기" id="searchIdBtn">
        <input type="button" value="PW찾기" id="searchPwBtn">
    </form>
</div>

<a href="/api/data">
        <button type="submit">일일 감염자수</button>
</a>
<form name="frm2" method="post" action="/api/hospital">
        <button type="submit">병원 정보</button>
</form>

<script>
    $("#searchIdBtn").on("click", function () {
        location.href = "/member/toSearchIdForm";
    });

    $("#searchPwBtn").on("click", function () {
        location.href = "/member/toSearchPwForm";
    });

</script>
</body>
</html>