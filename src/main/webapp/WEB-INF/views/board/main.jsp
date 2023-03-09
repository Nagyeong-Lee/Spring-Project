<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>게시판</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>

    <style>
        * {
            box-sizing: border-box;
        }

        #myTable, #myTable * {
            border: 1px solid black;
        }
    </style>
</head>
<body>
<table id="myTable">
    <tr>
        <th>작성자</th>
        <th>제목</th>
        <th>작성일자</th>
        <th>수정일자</th>
        <th>조회수</th>
    </tr>
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr>
                    <td>${i.writer}</td>
                    <a href="/board/detail?b_seq=${i.b_seq}"><td>${i.title}</td></a>
                    <td>${i.write_date}</td>
                    <td>${i.write_date}</td>
                    <td>${i.count}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="5">출력할 게시글이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
</table>

<div class="btn">
    <button type="button" id="writeBtn">글 작성</button>
</div>


<script>
    $("#writeBtn").on("click", function () {
        location.href = "/board/toWriteForm";
    });
</script>
</body>
</html>