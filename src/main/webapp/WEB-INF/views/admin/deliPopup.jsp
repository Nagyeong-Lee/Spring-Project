<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-09
  Time: 오후 5:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>배송상태 변경</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
  <style>
    .popup{
      margin-top: 100px;
      text-align: center;
    }
  </style>

  <script>
    $(function(){
      $("#close").click(function(){
        window.close();
      });
    })
  </script>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<div class="popup">
  <form action="/product/addDeli" method="post" id="frm">
    <div>이름 <input type="text" name="name" id="name"></div>
    <div>번호 <input type="text" name="phone" id="phone"></div>
    <div>주소 <input type="text" name="address" id="address"></div>
    <div>별칭 <input type="text" name="nickname" id="nickname"></div>
    <div>
      <button type="button" id="sbn">변경</button>
      <button type="button" id="close">취소</button>
    </div>
  </form>
</div>
</body>
</html>
