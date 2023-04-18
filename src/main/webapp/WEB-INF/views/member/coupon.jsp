<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-17
  Time: 오후 4:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>내 쿠폰함</title>
  <!--jQuery-->
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>

</head>
<body>

<div class="coupon">
  <c:choose>
    <c:when test="${!empty coupon}">
      <c:forEach items="${coupon}" var="i">
        <div>${i.title} 할인률 : ${i.discount}%</div>
      </c:forEach>
    </c:when>
  </c:choose>
</div>
</body>
</html>
