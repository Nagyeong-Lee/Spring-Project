<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-05-23
  Time: 오후 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>안내 팝업</title>
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
        .popup{ margin-top: 50px; text-align: center;  }
        input {white-space: pre-line;}
        .text{text-align: center;}
        .notice{margin-top: 50px;}
    </style>
</head>
<body>
<div class="notice">
    <p class="text">서울특별시 구로구 구로동 디지털로26길 123 </p>
    <p class="text">지플러스타워 4층으로 배송해주세요.</p>
    <button type="button" id="close" class="btn btn-light" style="margin-left: 250px;">닫기</button>
</div>

<script>
    $("#close").click(function(){
        window.close(); // 팝업창 닫기
    });
</script>
</body>
</html>
