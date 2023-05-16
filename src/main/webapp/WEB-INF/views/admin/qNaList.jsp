<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-16
  Time: 오후 1:47
  To change this template use File | Settings | File Templates.
--%>
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
    <title>Q&A 조회</title>
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

        #tbody * {
            text-align: center;
        }
    </style>
</head>
<body>
<input type="hidden" id="id" name="id" value="${id}">
<%@ include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>상품</th>
        <th>답변 상태</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th></th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty qNaList}">
                <c:forEach var="i" items="${qNaList}" varStatus="status">
                    <tr>
                        <td>
                            <a href="/product/detail?pd_seq=${i.productDTO.pd_seq}">
                                <img src="/resources/img/products/${i.productDTO.img}"
                                     style="width: 100px; height: 100px;">
                            </a>
                            <p>${i.productDTO.name}</p>
                        </td>
                        <c:choose>
                            <c:when test="${i.answerYN != null && i.answerYN == 'N'}">
                                <td>미답변</td>
                            </c:when>
                            <c:otherwise>
                                <td>답변 완료</td>
                            </c:otherwise>
                        </c:choose>
                        <td><a href="javascript:;" onclick="showAns(${status.index})">${i.questionDTO.content}</a></td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                        <input type="hidden" value="${i.questionDTO.q_seq}" class="q_seq">
                        <td>
                            <c:choose>
                                <c:when test="${i.answerYN != 'N'}">
                                    <button type="button" class="updAnsBtn btn btn-light">답변 수정</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" class="ansWriteBtn btn btn-light">답변 작성</button>
                                </c:otherwise>
                            </c:choose>
                            <button type="button" class="delQBtn btn btn-light">삭제</button>
                        </td>
                    </tr>
                    <tr class="answer_${status.index} answer" style="display:none;">
                        <td></td>
                        <td></td>
                        <td>${i.questionDTO.content}</td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                        <td></td>
                    </tr>
                    <c:if test="${i.answerYN == 'Y'}">
                        <tr class="answer_${status.index} answer" style="display:none;">
                            <td></td>
                            <td></td>
                            <td>${i.answerDTO.answer}</td>
                            <td>${i.answerDTO.writer}</td>
                            <td>${i.answerDTO.writeDate}</td>
                            <td></td>
                        </tr>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td></td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>

    function showAns(index) {
        $(".answer").css("display","none");
        $(".answer_"+index).css("display","table-row");
    }
    //답변 작성
    $(".ansWriteBtn").click(function () {
        let q_seq = $(this).parent().closest("tr").find(".q_seq").val();
        let id = $("#id").val();
        var option = 'width=500, height=500, left=800, top=250';

        let newFrm = document.createElement("form");
        newFrm.setAttribute("method", "post");
        newFrm.setAttribute("action", "/QnA/ansPopup");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("value", q_seq);
        input1.setAttribute("name", "q_seq");

        newFrm.append(input1);
        document.body.append(newFrm);

        window.open("/QnA/ansPopup", "newFrm", option);
        var myForm = newFrm;
        myForm.method = "post";
        myForm.target = "newFrm";
        myForm.submit();
    })

    //답변 수정
    $(".updAnsBtn").click(function(){
        let q_seq = $(this).parent().closest("tr").find(".q_seq").val();
        let id = $("#id").val();
        var option = 'width=500, height=500, left=800, top=250';

        let newFrm = document.createElement("form");
        newFrm.setAttribute("method", "post");
        newFrm.setAttribute("action", "/QnA/updAnsPopup");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("value", q_seq);
        input1.setAttribute("name", "q_seq");
        let input2 = document.createElement("input");
        input2.setAttribute("type", "hidden");
        input2.setAttribute("value", id);
        input2.setAttribute("name", "id");

        newFrm.append(input1);
        newFrm.append(input2);
        document.body.append(newFrm);

        window.open("/QnA/updAnsPopup", "newFrm", option);
        var myForm = newFrm;
        myForm.method = "post";
        myForm.target = "newFrm";
        myForm.submit();
    });
    //삭제
    $(".delQBtn").click(function () {
        let q_seq = $(this).parent().closest("tr").find(".q_seq").val();
        $.ajax({
            url: '/QnA/' + q_seq,
            type: 'post',
            data: {
                "q_seq": q_seq
            },
            success: function (data) {
                location.reload();
            }
        })
    });
</script>
</body>
</html>
