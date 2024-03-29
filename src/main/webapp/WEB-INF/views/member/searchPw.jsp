<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>PW 찾기</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
</head>
<body>
<div class="searchPwBox" style="text-align: center; margin-top: 150px;">
    <div>
        <input type="text" name="email" id="email" placeholder="이메일을 입력해주세요">
        <button type="button" id="authenticBtn" class="btn btn-light">인증번호 전송</button>
    </div>
    <input type="text" name="tempNum" id="tempNum" placeholder="임시 비밀번호를 입력해주세요">
    <button type="button" id="author" class="btn btn-light">인증하기</button>
    <div class="text" id="text"></div>
    <a href="/">
        <button type="button" class="btn btn-light">목록으로</button>
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

    $("#author").hide();
    $("#authenticBtn").hide();

    //이메일 입력했을때
    $("#email").on("change", function () {
        $.ajax({
            url: "/member/emailExist",
            type: "post",
            data: {
                "email": $("#email").val()
            },
            success: function (resp) {
                if (resp == 'none') {
                    alert('존재하지 않는 이메일입니다.');
                    $("#author").hide();
                    $("#authenticBtn").hide();
                    $("#email").val('');
                } else {
                    $("#author").show();
                    $("#authenticBtn").show();
                }
            }
        });
    });

    //인증번호 전송 클릭 시
    $("#authenticBtn").on("click", function () {
        $.ajax({
            url: "/mail",
            type: "post",
            data: {
                "address": $("#email").val(),
                "title": "임시 비밀번호",
                "message": msg
            },
            success: function (resp) {
                alert("임시 비밀번호를 전송했습니다.");
            }
        });
    });

    $("#author").on("click", function () {
        let email = $("#email").val();
        let pw = msg; // pw를 임시비번으로

        let temp = $("#tempNum").val();

        $.ajax({
            url: "/member/searchPw",
            type: "post",
            data: {
                "email": email,
                "pw": pw
            },
            success: function (resp) {
                if (temp == msg) {
                    alert('임시비밀번호로 변경되었습니다.');
                    location.href = "/";
                } else {
                    alert('인증번호가 일치하지 않습니다.');
                    $("#tempNum").val('');
                }
            }
        });
    });
</script>
</body>
</html>