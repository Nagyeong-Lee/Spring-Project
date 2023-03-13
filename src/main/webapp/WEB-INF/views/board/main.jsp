<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

        #myTable {
            border: 1px solid black;
        }

        /*제목 길이 넘치는거 자름*/
        .title {
            overflow: hidden;
            white-space: nowrap;
            word-break: break-word;
            text-overflow: ellipsis;
            max-width: 270px;
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
                    <td class="title"><a href="/board/detail?b_seq=${i.b_seq}">${i.title}</a></td>
                    <td><fmt:formatDate pattern='yyyy-MM-dd hh:mm' value="${i.write_date}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty i.update_date}">
                                <fmt:formatDate pattern='yyyy-MM-dd hh:mm' value="${i.update_date}"/>
                            </c:when>
                        </c:choose>
                    </td>
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

<div>${paging}</div>

<div class="btn">
<form action="/board/list?" method="get">
    <input type=hidden value="1" name="currentPage" id="currentPage">
    <input type=hidden value="10" name="count" id="count">

    <select name="searchType" id="searchType">
        <option value="title" selected>제목</option>
        <option value="writer">작성자</option>
        <option value="content">내용</option>
    </select>
    <input type="text" id="keyword" name="keyword">
    <button type="submit" id="searchBtn">글 검색</button>
    <button type="button" id="writeBtn">글 작성</button>
</form>
</div>

<script>
    $("#writeBtn").on("click", function () {  //글작성 폼으로 이동
        location.href = "/board/toWriteForm";
    });

</script>
</body>
</html>