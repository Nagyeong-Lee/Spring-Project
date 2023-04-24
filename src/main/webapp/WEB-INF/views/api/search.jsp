<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-11
  Time: 오후 2:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <title>뉴스 검색</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<div class="news">
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <a href=${i.get("link")}>바로가기</a><br>
                제목 : ${i.get("title")}<br>
               <hr>
            </c:forEach>
        </c:when>
    </c:choose>
</div>
<button type="button" id="back">목록으로</button>

<script>
    $("#back").on("click",function(){
       history.back();
    });
</script>
</body>
</html>
