<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>장바구니</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="/resources/cart.css">
</head>
<body>
<div class="cart">
    <table class="cart__list">
        <form>
            <thead>
            <tr>
                <td colspan="2">상품 이미지</td>
                <td colspan="2">상품정보</td>
                <td colspan="2">상품금액</td>
                <td colspan="2">삭제</td>
            </tr>
            </thead>
            <tbody>
            <%--foreach--%>
            <c:choose>
                <c:when test="${!empty cart}">
                    <c:forEach var="i" items="${cart}">
                        <tr class="itemDiv">
                            <td colspan="2"><img src="/resources/img/products/${i.get("img")}"></td>
                            <td colspan="2">
                                <p>${i.get("name")}</p>
                                <p>수량 : ${i.get("count")}</p>
                                <c:choose>
                                    <c:when test="${!empty i.get('option')}">
                                        <c:forEach var="k" items="${i.get('option')}">
                                            <c:forEach var="j" items="${k}">
                                                <p>&nbsp${j}</p>
                                            </c:forEach>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td colspan="2"><span class="price"><fmt:formatNumber pattern="#,###"
                                                                                  value="${i.get('price')}"/>원</span>
                            </td>
                            <td>
                                <button type="button" class="delBtn">삭제
                                    <input type="hidden" value="${i.get('cart_seq')}">
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8">장바구니가 비었습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </form>
    </table>
    <hr>
    <br>
    <div class="pay">
        <div>전체 가격</div>
        <div>할인</div>
        <div>합계</div>
    </div>
    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right">결제하기</button>
    </div>
</div>

<script>
    $("#continue").on("click", function () {
        location.href = "/product/list";
    });

    $(".delBtn").on("click", function () { //해당 cart_seq status n으로
        let cart_seq = $(this).closest("tr").find("input").val();
        $(this).closest(".itemDiv").remove();
        $.ajax({
            url: '/product/cart/delete',
            type: 'post',
            data: {
                "cart_seq" : cart_seq
            },
            success:function(data){
            }
        })
    });
</script>
</body>
</html>
