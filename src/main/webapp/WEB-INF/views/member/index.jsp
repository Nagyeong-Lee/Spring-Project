<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>메인 페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
    <style>
        .loginBox{
            text-align: center;
            margin-top: 200px;
        }
    </style>
</head>
<body>

<div class="loginBox">
    <form action="/member/login" method="post">
        아이디 &nbsp&nbsp&nbsp<input type="text" id="id" name="id" style="width:250px;"> <br>
        비밀번호 <input type="password" id="pw" name="pw"  style="width:250px;">
        <br>
        <br>
        <a href="/member/toSignUpForm"><input type="button" value="회원가입" class="btn btn-light"></a>
        <input type="submit" value="로그인" id="loginBtn" class="btn btn-light">
        <input type="button" value="ID찾기" id="searchIdBtn" class="btn btn-light">
        <input type="button" value="PW찾기" id="searchPwBtn" class="btn btn-light">
    </form>
</div>

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