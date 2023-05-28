<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오전 9:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>환불 신청</title>
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
        .popup {
            margin-top: 50px;
            text-align: center;
        }

        input {
            white-space: pre-line;
        }

        h5 {
            margin-top: 30px;
            text-align: center;
        }

        img {
            width: 100px;
            height: 100px;
        }

        textarea {
            width: 300px;
            height: 100px;
        }
    </style>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<input type="hidden" value="${refundPdInfo.PAYPD_SEQ}" id="payPd_seq" name="payPd_seq">
<h5>환불 신청</h5>
<div class="popup">
    <form action="" method="post">
        <div class="img">
            <img src="/resources/img/products/${productDTO.img}">
        </div>
        <div class="pdInfo">
            <div>상품명 : ${productDTO.name}</div>
            <c:if test="${!empty optionList}">
               옵션 정보<br>
                    <c:forEach var="k" items="${optionList}">
                        <c:forEach var="j" items="${k}">
                            ${j.key} : ${j.value}<br>
                        </c:forEach>
                    </c:forEach>
            </c:if>
            <div>개수 : ${refundPdInfo.COUNT}개</div>
            <div>가격 : <fmt:formatNumber pattern="#,###" value="${price}"/>원</div>
            <div>결제정보 : ${refundPdInfo.PAYMETHOD}</div>
            <div>결제 시간 : ${refundPdInfo.PAYDATE}</div>
            <div>사유 : <textarea id="content" name="content"></textarea></div>
        </div>
<%--        <div class="deliInfo">--%>
<%--            <h5>배송지 선택</h5>--%>
<%--            <button type="button" id="addBtn" class="btn btn-light">배송지 추가</button>--%>
<%--            <br>--%>
<%--            <c:choose>--%>
<%--                <c:when test="${!empty deliDTOList}">--%>
<%--                    <c:forEach var="i" items="${deliDTOList}">--%>
<%--                        <input type="radio" class="select_add_radio" name="address" value="${i.seq}" <c:out--%>
<%--                                value="${i.status eq 'Y' ? 'checked' : ''}"/>>--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${i.status eq 'Y'}">기본 배송지</c:when>--%>
<%--                            <c:otherwise>${i.nickname}</c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </c:forEach>--%>
<%--                    <c:forEach var="i" items="${deliDTOList}">--%>
<%--                        <c:if test="${i.status eq 'Y'}">--%>
<%--                            <div class="deliInfo">--%>
<%--                                <p id="select_name">이름 : ${i.name}</p>--%>
<%--                                <p id="select_address">주소 : ${i.address}</p>--%>
<%--                                <p id="select_phone">전화번호 : ${i.phone}</p>--%>
<%--                            </div>--%>
<%--                        </c:if>--%>
<%--                    </c:forEach>--%>
<%--                </c:when>--%>
<%--            </c:choose>--%>
<%--        </div>--%>
        <button type="button" id="refundBtn" class="btn btn-light">환불 신청</button>
        <button type="button" id="cancle" class="btn btn-light">취소</button>
    </form>
</div>
<script>
    var _width = '500';
    var _height = '400';
    var _left = Math.ceil((window.screen.width - _width) / 2);
    var _top = Math.ceil((window.screen.height - _height) / 2);

    //배송지 추가 클릭 시
    $("#addBtn").click(function () {
        let id = $("#session").val();
        window.open('/product/addDeli?id=${id}', '', 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
    })

    //환불 클릭 시
    $("#refundBtn").click(function () {
        let content = $("#content").val();
        if (content.length == 0) {
            alert('사유를 입력해주세요.');
            return false;
        }
        $.ajax({
            url: '/product/refund',
            type: 'post',
            data: {
                "payPd_seq": $("#payPd_seq").val(),
                "id": $("#id").val(),
                "content":$("#content").val()
                // "deli_seq":$("input[type='radio']:checked").val()
            },
            success:function(data){
                console.log(data);
                window.close();
                window.opener.location.reload();
                // window.open('/product/noticePopup', '', 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
            }
        })
    })

    //취소
    $("#cancle").click(function () {
        window.close();
    })
</script>
</body>
</html>
