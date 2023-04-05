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
<select name="city" id="city">
<%--    <c:forEach >--%>
<%--        <option value="${}">${}</option>--%>
<%--    </c:forEach>--%>
</select>
평일 진료 시작 시간<input type="radio"><br>
평일 진료 마감 시간<input type="radio"><br>
토요일 진료 시작 시간<input type="radio"><br>
토요일 진료 마감 시간<input type="radio"><br>
일요일/공휴일 진료 여부<input type="radio"><br>
일요일/공휴일 진료 시작 시간<input type="radio"><br>
일요일/공휴일 진료 마감 시간<input type="radio"><br>
<hr>
<input type="hidden" value="${currentPage}" id="currentPage">
<table style="border: 1px solid black">
    <th>지역명</th>
    <th>병원명</th>
    <th>진료 시작</th>
    <th>진료 종료</th>
    <th>전화번호</th>
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr>
                    <td>${i.city}</td>
                    <td>
                        <a href="/api/detail?hospital_seq=${i.hospital_seq}&currentPage=${currentPage}&count=${count}&searchType=${searchType}&keyword=${keyword}">${i.hospital_name}</a>
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
${paging}<br>
<select name="searchType" id="searchType">
    <option value="hospital_name"<c:out value="${searchType eq 'hospital_name' ? 'selected' : ''}"/>>병원명</option>
    <option value="phone"<c:out value="${searchType eq 'phone' ? 'selected' : ''}"/>>전화번호</option>
    <option value="postcode"<c:out value="${searchType eq 'postcode' ? 'selected' : ''}"/>>우편번호</option>
    <option value="roadAddress"<c:out value="${searchType eq 'roadAddress' ? 'selected' : ''}"/>>도로명 주소</option>
</select>
<input type="text" name="keyword" id="keyword" value="${keyword}">
<button type="button" id="searchBtn">검색</button>
<select name="count" id="count">
    <option value="10"<c:out value="${count eq '10' ? 'selected' : ''}"/>>10개씩 보기</option>
    <option value="30"<c:out value="${count eq '30' ? 'selected' : ''}"/>>30개씩 보기</option>
    <option value="50"<c:out value="${count eq '50' ? 'selected' : ''}"/>>50개씩 보기</option>
</select>

<script>
    // function detailView(hospital_seq) {
    //     let form = document.createElement("form");
    //     form.setAttribute("method", "post");
    //     form.setAttribute("action", "/api/detail");
    //
    //     let input1 = document.createElement("input");
    //     let input2 = document.createElement("input");
    //     let input3 = document.createElement("input");
    //     let input4 = document.createElement("input");
    //     let input5 = document.createElement("input");
    //
    //     input1.setAttribute("type", "hidden");
    //     input1.setAttribute("name", "hospital_seq");
    //     input1.setAttribute("value", hospital_seq);
    //
    //     input2.setAttribute("type", "hidden");
    //     input2.setAttribute("name", "currentPage");
    //     input2.setAttribute("value", hospital_seq);
    //
    //     input3.setAttribute("type", "hidden");
    //     input3.setAttribute("name", "count");
    //     input3.setAttribute("value", hospital_seq);
    //
    //     input4.setAttribute("type", "hidden");
    //     input4.setAttribute("name", "keyword");
    //     input4.setAttribute("value", hospital_seq);
    //
    //     input5.setAttribute("type", "hidden");
    //     input5.setAttribute("name", "hospital_seq");
    //     input5.setAttribute("value", hospital_seq);
    //
    //     form.appendChild(input1);
    //     form.appendChild(input2);
    //     form.appendChild(input3);
    //     form.appendChild(input4);
    //     form.appendChild(input5);
    //     document.body.appendChild(form);
    //     form.submit();
    // }

    $("#count").on("change", function () {
        let count = $("#count").val();
        console.log(count);
        location.href = "/api/hospital?currentPage=1&count=" + count + "&searchType=&keyword=";
    });

    $("#searchBtn").on("click", function () {
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        location.href = "/api/hospital?currentPage=1&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword;
    });
</script>
</body>
</html>