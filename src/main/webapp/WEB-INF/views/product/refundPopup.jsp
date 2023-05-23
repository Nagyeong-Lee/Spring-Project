<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오전 9:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>교환 신청</title>
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

        .img {
            float: left
        }
    </style>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<h5>반품/교환 신청</h5>
<div class="popup">
    <form action="" method="post">
        <div class="img">
            <img src="/resources/img/products/${productDTO.img}">
        </div>
        <div class="pdInfo">
            상품명 : ${productDTO.name}
            <c:if test="${!empty optionList}">
                옵션 정보
                <c:forEach var="k" items="${optionList}">
                    <c:forEach var="j" items="${k}">
                        <p>${j.key} : ${j.value}</p>
                    </c:forEach>
                </c:forEach>
            </c:if>
            개수 : ${refundPdInfo.count}개
            결제정보 : ${refundPdInfo.payMethod}
            결제 시간 : ${refundPdInfo.payDate}
        </div>
        사유 : <textarea id="content" name="content"></textarea>
        <div class="deliInfo">
            <h3>배송지 선택</h3>
            <button type="button" id="addBtn" class="btn btn-light">배송지 추가</button>
            <br>
            <c:choose>
                <c:when test="${!empty deliDTOList}">
                    <c:forEach var="i" items="${deliDTOList}">
                        <input type="radio" class="select_add_radio" name="address" value="${i.seq}" <c:out
                                value="${i.status eq 'Y' ? 'checked' : ''}"/>>
                        <c:choose>
                            <c:when test="${i.status eq 'Y'}">기본 배송지</c:when>
                            <c:otherwise>${i.nickname}</c:otherwise>
                        </c:choose>

                    </c:forEach>
                    <c:forEach var="i" items="${deliDTOList}">
                        <c:if test="${i.status eq 'Y'}">
                            <div class="deliInfo">
                                <p id="select_name">이름 : ${i.name}</p>
                                <p id="select_address">주소 : ${i.address}</p>
                                <p id="select_phone">전화번호 : ${i.phone}</p>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
            </c:choose>
        </div>
        <button type="button" id="refundBtn">교환 신청</button>
    </form>
    <%--    상품이미지 상품명 결제정보 사용 포인트 옵션있으면 옵션정보 사유 교환받을 배송지 입력 신청 버튼
           교환 신청 클릭 시 해당주소(관리자)로 반품해주세요 팝업띄우기-
            기존 배송지 주소 띙워놓고 배송지 추가버튼도 만듦--%>
</div>
<script>
    var _width = '500';
    var _height = '400';
    var _left = Math.ceil((window.screen.width - _width) / 2);
    var _top = Math.ceil((window.screen.height - _height) / 2);

    //배송지 추가 클릭 시
    $("#addBtn").click(function () {
        let id = $("#session").val();
        window.open('/product/addDeli?id=${id}', '',  'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
    })

    //교환 신청 클릭 시
    $("#refundBtn").click(function () {
        window.open('/product/applyRefund?id=${id}', '', 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
    })

</script>
</body>
</html>
