<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-16
  Time: 오후 1:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Q&A 수정</title>
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

        input {
            white-space: pre-line;
        }

        h5 {
            margin-top: 30px;
            text-align: center;
        }
    </style>
</head>
<body>
<h5>Q&A 수정</h5>
<div class="popup">
    <form action="/QnA/insert" method="post" id="frm">
        <input type="hidden" value="${id}" id="id" name="id">
        <input type="hidden" value="${questionDTO.q_seq}" id="q_seq" name="q_seq">
        <input type="hidden" value="${questionDTO.pd_seq}" id="pd_seq" name="pd_seq">
        <textarea style="width: 500px; height: 300px;" id="content">${questionDTO.content}</textarea>
        <div class="btns" style="margin-top: 20px;">
            <button type="button" id="updBtn" class="btn btn-light">수정</button>
            <button type="button" id="cancleBtn" class="btn btn-light">취소</button>
        </div>
    </form>
</div>
<script>
    //작성 클릭
    $("#updBtn").click(function () {
        let id = $("#session").val();
        let q_seq = $("#q_seq").val();
        let content = $("#content").val();


        if (content.length === 0) {
            alert('질문을 작성해주세요.');
            return;
        }

        $.ajax({
            url: '/QnA/updQuestion',
            type: 'post',
            data: {
                "id": id,
                "q_seq": q_seq,
                "content": content
            },
            success: function (data) {
                window.close();
                opener.parent.location.reload();
            }
        })
    })

    //취소
    $("#cancleBtn").click(function () {
        window.close();
    })
</script>
</body>
</html>
