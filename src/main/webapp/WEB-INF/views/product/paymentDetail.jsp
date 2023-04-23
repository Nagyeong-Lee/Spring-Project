<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-23
  Time: 오후 1:21
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
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" type="text/css" href="/resources/cart.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>
<div class="cart">
  <input type="hidden" id="cartLength" value="${cart.size()}">
  <table class="cart__list">
    <form>
      <c:choose>
        <c:when test="${!empty cart}">
          <thead>
          <tr id="thead">
            <td colspan="4">결제 정보</td>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="i" items="${cart}" varStatus="status">
            <tr class="itemDiv">
              <td colspan="2"><a href="/product/detail?pd_seq=${i.get('pd_seq')}"><img
                      src="/resources/img/products/${i.get("img")}"></a></td>
              <td colspan="2">
                <p class="pdName${status.count}">${i.get("name")}</p>
                <p>수량 : ${i.get("count")}</p>
                <input type="hidden" class="pdCnt${status.count}" value="${i.get("count")}">
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
            </tr>
          </c:forEach>
          </tbody>
        </c:when>
      </c:choose>
    </form>
  </table>
  <hr>
  <div style="margin-top: 50px;">총 수량 : ${totalSum}개</div>
  <div>총 합계 : <fmt:formatNumber pattern="#,###" value="${totalPrice}" />원</div>
  <input type="hidden" id="hiddenPay" value="<fmt:formatNumber pattern="#,###" value="${totalPrice}" />">
  <div class="cart__mainbtns">
    <button class="cart__bigorderbtn left" id="continue" style="margin-left:70px;">상품 리스트로 이동</button>
  </div>
</div>
<script>
  $("#continue").on("click", function () {
    location.href = "/product/list";
  });

</script>
</body>
</html>
