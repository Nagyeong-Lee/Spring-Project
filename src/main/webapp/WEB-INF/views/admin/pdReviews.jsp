<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-16
  Time: 오후 5:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>리뷰 조회</title>
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
        #footer {
            position: relative;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
            transform: translatY(-100%);
        }

        #wrapper {
            height: auto;
            min-height: 550px;
        }

        img {
            width: 300px;
            height: 300px;
        }

        #QnATable {
            text-align: center;
        }
    </style>
<body>
<table id="QnATable" class="table table-striped">
    <thead>
    <th>상품 이미지</th>
    <th>상품명</th>
    <th>가격</th>
    <th>작성자</th>
    <th>작성시간</th>
    <th></th>
    </thead>
    <tbody id="tbody">
    <c:choose>
        <c:when test="${!empty reviewList}">
            <c:forEach var="i" items="${reviewList}">
                <tr>
                    <td>
                        <a href="/product/detail?pd_seq=${i.productDTO.pd_seq}">
                            <img src="/resources/img/products/${i.productDTO.img}"
                                 style="width: 100px; height: 100px;">
                        </a>
                    </td>
                    <td>
                        <p>${i.productDTO.name}</p>
                        ${i.option}
                        <c:if test="${!empty i.option}">
                            <c:forEach var="k" items="${i.option}">
                                ${k}
<%--                                <c:forEach var="j" items="${k.optionMapList}">--%>
<%--&lt;%&ndash;                                    <p>${j}</p>&ndash;%&gt;--%>
<%--                                </c:forEach>--%>
                            </c:forEach>
                        </c:if>
                    </td>
                    <td><fmt:formatNumber pattern="#,###" value="${i.totalPrice}"/>원</td>
                    <td>${i.reviewDTOS.ID}</td>
                    <td>${i.reviewDTOS.WRITEDATE}</td>
                    <td>
                        <button type="button" class="delReviewBtn btn btn-light">삭제</button>
                    </td>
                </tr>
<%--                <hr>--%>
            </c:forEach>
        </c:when>
        <c:otherwise>

        </c:otherwise>
    </c:choose>
    </tbody>
</table>
</body>
</html>
