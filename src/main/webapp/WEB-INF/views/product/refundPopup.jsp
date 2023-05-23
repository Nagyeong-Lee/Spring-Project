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
  <title>환불 신청</title>
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

    h5{
      margin-top: 30px;
      text-align: center;
    }
  </style>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<h5>반품/교환 신청</h5>
<div class="popup">
  <form action="" method="post">
<%--    상품이미지 상품명 결제정보 사용 포인트 옵션있으면 옵션정보 사유 교환받을 배송지 입력 신청 버튼
       교환 신청 클릭 시 해당주소(관리자)로 반품해주세요 팝업띄우기-
        기존 배송지 주소 띙워놓고 배송지 추가버튼도 만듦-%>
  </form>
</div>
<script>

  //취소
  $("#cancleBtn").click(function () {
    window.close();
  })
</script>
</body>
</html>
