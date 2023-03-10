<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>PW 찾기</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<div class="searchPwBox">
    <div>
        <input type="text" name="email" id="email" placeholder="이메일을 입력해주세요">
        <button type="button" id="authenticBtn">인증번호 전송</button>
    </div>
    <input type="text" name="tempNum" id="tempNum" placeholder="임시 비밀번호를 입력해주세요">
    <button type="button" id="author">인증하기</button>
    <div class="text" id="text"></div>
    <a href="/">
        <button type="button">목록으로</button>
    </a>
</div>

<script>
    $("#searchBtn").on("click", function () {
        location.href = "/member.searchPw";
    });

    //6글자 랜덤 숫자 생성
    function randomString() {
        const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz';
        const stringLength = 10;
        let randomstring = '';
        for (let i = 0; i < stringLength; i++) {
            const rnum = Math.floor(Math.random() * chars.length);
            randomstring += chars.substring(rnum, rnum + 1);
        }
        return randomstring;
    }

    let msg = randomString();
    console.log("msg : "+msg);

    //인증번호 전송 클릭 시
    $("#authenticBtn").on("click", function () {
        console.log('버튼 클릭');
        $.ajax({
            url: "/mail",
            type: "post",
            data: {
                "address": $("#email").val(),
                "title": "임시 비밀번호",
                "message": msg
            }
        }).done(function (resp) {
            alert("임시 비밀번호를 전송했습니다.");
        });
    });

    $("#author").on("click", function () {
        let email = $("#email").val();
        let pw=msg;
        console.log("msg : "+msg);
        console.log("email : "+email);

        $.ajax({
            url: "/member/searchPw",
            type: "post",
            data: {
                "email": email,
                "pw": pw
            }
        }).done(function (resp) {
            console.log("resp : "+resp);
            if (resp == msg) {
                alert('임시비밀번호로 변경되었습니다.');
            }else{
                alert('임시비밀번호가 일치하지 않습니다.');
            }
        });
    });
</script>
</body>
</html>