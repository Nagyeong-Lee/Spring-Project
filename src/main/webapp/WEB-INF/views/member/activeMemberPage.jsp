<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-03-24
  Time: 오전 10:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
    <script src="https://malsup.github.io/jquery.form.js"></script>
    <title>휴면계정 해제</title>
</head>
<body>
<div class="ActiveBox">
    <div>
        이메일 <input type="text" name="email" id="email">
    </div>
    <div>
        아이디 <input type="text" name="id" id="id">
    </div>
    <div>
        비밀번호 <input type="password" name="pw" id="pw">
    </div>
</div>
<button type="button" id="active">휴면 해제</button>

<script>
    $("#active").on("click", function () {
        let email = $("#email").val();
        let id = $("#id").val();
        let pw = $("#pw").val();

        console.log("email : "+email);
        console.log("id : "+id);
        console.log("pw : "+pw);
        $.ajax({
            url: "/member/active",
            type: "post",
            data: {
                "email": email,
                "id": id,
                "pw": pw
            },
            dataType:"text",
            success: function (data) {
                console.log("data : "+data);
                if (data == "success") {
                    alert('휴면처리가 해제되었습니다.');
                    location.href = "/";
                } else {
                    alert('정보를 다시 입력해주세요.');
                    //input 초기화
                    $("#email").val("");
                    $("#id").val("");
                    $("#pw").val("");
                }
            }
        });
    });
</script>
</body>
</html>
