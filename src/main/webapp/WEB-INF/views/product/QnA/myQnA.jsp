<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-05-16
  Time: 오전 12:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>나의 Q&A 조회</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/resources/cart.css">
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>

    <style>
        #footer {
            /*position: fixed;*/
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
            position: relative;
            /*transform: translatY(-100%);*/
        }

        .pagingDiv {
            position: fixed;
            left: 0;
            bottom: 100px;
            width: 100%;
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>
</head>
<body>
<input type="hidden" id="id" name="id" value="${id}">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>답변 상태</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th></th>
        </thead>
        <tbody id="tbody">
        <tr>
            <c:choose>
                <c:when test="${!empty qNaList}">
                    <c:forEach var="i" items="${qNaList}">
                        <c:choose>
                            <c:when test="${i.answerYN != null && i.answerYN == 'N'}">
                                <td>미답변</td>
                            </c:when>
                            <c:otherwise>
                                <td>답변 완료</td>
                            </c:otherwise>
                        </c:choose>
                        <td>${i.questionDTO.content}</td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                        <input type="hidden" value="${i.questionDTO.q_seq}" class="q_seq">
                        <td>
                            <button type="button" class="updQuestion">수정</button>
                            <button type="button" class="delQuestion">삭제</button>
                        </td>
                    </c:forEach>
                </c:when
                <c:otherwise>
                    <td></td>
                </c:otherwise>
            </c:choose>
        </tr>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>
    //수정
    $(".updQuestion").click(function () {

    })

    //삭제
    $(".delQuestion").click(function () {
        let q_seq = $(this).parent().siblings().find(".q_seq").val();

        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/QnA");

        let newInput = document.createElement("input");
        newInput.setAttribute("type", "hidden");
        newInput.setAttribute("name", "id");
        newInput.setAttribute("value", $("#id").val());

        let newInput2 = document.createElement("input");
        newInput2.setAttribute("type", "hidden");
        newInput2.setAttribute("name", "q_seq");
        newInput2.setAttribute("value", q_seq);

        newForm.appendChild(newInput);
        newForm.appendChild(newInput2);
        document.body.append(newForm);
        newForm.submit();
    })
</script>
</body>
</html>
