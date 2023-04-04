<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-04
  Time: 오후 5:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <title>병원 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<select>
    <option value="10">10개씩 보기</option>
    <option value="30">30개씩 보기</option>
    <option value="50">50개씩 보기</option>
</select>
<table style="border: 1px solid black">
    <th>지역명</th>
    <th>병원명</th>
    <th>오픈시간</th>
    <th>닫는시간</th>
    <th>전화번호</th>
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr>
                    <td>${i.city}</td>
                    <td>
                        <a href="/api/detail?hospital_seq=${i.hospital_seq}&latitude=${i.latitude}&longitude=${i.longitude}">${i.hospital_name}</a>
                    </td>
                    <td>${i.weekOpen}</td>
                    <td>${i.weekClose}</td>
                    <td>${i.phone}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td>출력할 정보가 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
</table>
<select>
    <option value="city">지역명</option>
    <option value="name">병원명</option>
    <option value="phone">전화번호</option>
    <option value="bsHour">운영시간</option>
</select>
<input type="text">
<button type="button">검색</button>
</body>
</html>
