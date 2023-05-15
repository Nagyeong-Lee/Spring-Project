<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오전 9:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Q&A 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.css" rel="stylesheet">
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
    <style>
        .popup {
            margin-top: 50px;
            text-align: center;
        }
        input{
            white-space: pre-line;
        }
    </style>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<div class="popup">
    <form action="/QnA/" method="post" id="frm">
        <textarea style="width: 500px; height: 300px;"></textarea>
        <div class="btns" style="margin-top: 20px;">
            <button type="button" id="writeBtn" class="btn btn-light">작성</button>
            <button type="button" id="cancleBtn" class="btn btn-light">취소</button>
        </div>
    </form>
</div>
<script>

    //저장 클릭 시
    $("#sbn").on("click", function () {

        let regexName = /^[가-힣]{2,5}$/;
        let regexPhone = /^010\d{4}\d{4}$/;

        let name = $("#name").val();
        let phone = $("#phone").val();
        let address = $("#address").val();
        let nickname = $("#nickname").val();
        let flag = $("#default").is(':checked');  //기본 주소 체크 여부
        let id = $("#id").val();
        if (flag == true) {
            $("#default").val(1);
        } else {
            $("#default").val(0);
        }
        if (name == '') {
            alert("이름을 입력해주세요.");
            return false;
        }

        if (regexName.test(name) == false) {
            alert("이름 형식이 맞지 않습니다.");
            return false;
        }

        if (phone == '') {
            alert("전화번호를 입력해주세요.");
            return false;
        }

        //전화번호 유효성
        if (regexPhone.test(phone) == false) {
            alert("전화번호 형식이 맞지 않습니다.");
            return false;
        }

        if (address == '') {
            alert("주소를 입력해주세요.");
            return false;
        }

        if (nickname == '') {
            alert("별칭을 입력해주세요.");
            return false;
        }

        $.ajax({
            url: '/product/addDelivery',
            type: 'post',
            data: {
                "name": name,
                "phone": phone,
                "address": address,
                "nickname": nickname,
                "def": flag,
                "id": id
            },
            success: function (data) {
                if (data == 'success') {
                    window.close();
                    opener.parent.location.reload();
                }
            }
        })

    })

    $("#cancleBtn").click(function () {
        window.close();
    })
</script>
</body>
</html>
