<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-03-29
  Time: 오후 3:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>로그 확인</title>

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

    </style>
</head>
<body>
<table id="myTable">
    <input type="hidden" id="pageCount" name="pageCount" value="${count}">
    <input type="hidden" id="currPage" name="currPage" value="${currPage}">
    <tr>
        <th>Type</th>
        <th>Id</th>
        <th>Parameter</th>
        <th>Url</th>
        <th>Time</th>
        <th>Description</th>
    </tr>
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr>
                    <td>${i.type}</td>
                    <td>${i.id}</td>
                    <td>${i.parameter}</td>
                    <td>${i.url}</td>
                    <td><fmt:formatDate pattern='yyyy-MM-dd hh:mm' value="${i.time}"/></td>
                    <td>${i.description}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="6">출력할 로그가 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
</table>
<div>${paging}</div>

<input type=hidden value="${currPage}" name="cpage" id="cpage">
<div class="btn">
    <form action="/admin/list?" method="get">
        <input type=hidden value="${count}" name="count" id="count">
        <input type=hidden value="1" name="currentPage" id="currentPage">
        <select name="postNum" id="postNum">
            <option value="5" <c:out value="${count eq '5' ? 'selected' : ''}"/>>5</option>
            <option value="10" <c:out value="${count eq '10' ? 'selected' : ''}"/>>10</option>
            <option value="15" <c:out value="${count eq '15' ? 'selected' : ''}"/>>15</option>
        </select>
        <select name="searchType" id="searchType">
            <option value="type" <c:out value="${searchType eq 'type' ? 'selected' : ''}"/>>type</option>
            <option value="url" <c:out value="${searchType eq 'url' ? 'selected' : ''}"/>>url</option>
            <option value="description" <c:out value="${searchType eq 'description' ? 'selected' : ''}"/>>description
            </option>
        </select>
        <input type="text" id="keyword" name="keyword" value="${keyword}">
        <button type="submit" id="searchBtn">검색</button>
    </form>
</div>

<script>
    $("#postNum").on("change", function () {
        let postNum = $("#postNum").val();
        location.href = "/admin/list?currentPage=1&count=" + postNum + "&searchType=&keyword=";
    });
</script>
</body>
</html>
