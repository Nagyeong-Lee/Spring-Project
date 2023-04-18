<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <td colspan="3">상품 이미지</td>
                <td colspan="3">상품정보</td>
                <td>상품금액</td>
            </tr>
            </thead>
            <tbody>
            <%--foreach--%>
            <tr class="cart__list__detail">
                <td colspan="3"><img src="image/keyboard.jpg" ></td>
                <td colspan="3">
                    <p>Apple 매직 키보드</p>
                    <p>모델명 : 키보드 - 한국어 MK2A3KH/A / 1개</p>
                </td>
                <td><span class="price">116,620원</span></td>
            </tr>
            </tbody>
        </form>
    </table>
    <hr>
    <div class="pay">
        <div>수량</div>
        <div>가격</div>
        <div>할인</div>
        <hr>
        <div>합계</div>
    </div>
    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right">결제하기</button>
    </div>
</div>

<script>
    $("#continue").on("click",function(){
       history.back();
    });
</script>
</body>
</html>
