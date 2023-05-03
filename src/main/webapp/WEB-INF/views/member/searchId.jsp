<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>ID 찾기</title>
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
<div class="searchIdBox" style="text-align: center; margin-top: 150px;">
    <div>
        이메일 &nbsp<input type="text" placeholder='이메일을 입력해주세요' id="email" name="email">
        <button type="button" id="searchIdBtn" class="btn btn-light">찾기</button>
    </div>
    <div class="text" id="text"></div>
    <a href="/">
        <button type="button" class="btn btn-light">목록으로</button>
    </a>
</div>

<script>
    $("#searchIdBtn").on("click", function () {
        let email = $("#email").val();
        $.ajax({
            url: "/member/searchId",
            type: "post",
            data: {"email": email},
            async: false,
            success: function (data) {
                if (data != 'NONE') {
                    $("#text").text("ID : " + data);
                } else {
                    $("#text").text("아이디가 존재하지 않습니다.");
                }
            }
        });
    });
</script>
</body>
</html>