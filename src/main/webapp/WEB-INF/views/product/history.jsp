<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오후 5:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>구매 내역</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
</head>
<body>
<h3>구매 내역</h3>
<c:choose>
  <c:when test="${!empty payInfoDTOS}">
    <c:forEach var="i" items="${payInfoDTOS}">
     <div class="payInfo">
       ${i.price}
     </div>
    </c:forEach>
  </c:when>
</c:choose>
</body>
</html>
