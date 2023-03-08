index
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
    <form action="/signUp" method="post">
        아이디  &nbsp&nbsp&nbsp<input type="text"> <br>
        비밀번호   <input type="password">
        <br>
        <br>
        <a href="/toSignUpForm"><input type="button" value="회원가입"></a>
        <input type="submit" value="로그인">
        <input type="button" value="ID찾기">
        <input type="button" value="PW찾기">
    </form>
</div>
</body>