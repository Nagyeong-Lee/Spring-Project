<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-04-18
  Time: 오후 11:08
  To change this template use File | Settings | File Templates.
--%>

<div class="product-list">
    <c:choose>
        <c:when test="${!empty productDTOList}">
            <c:forEach var="i" items="${productDTOList}">
                <div class="product">
                    <img src="/resources/img/products/${i.img}" width="225" class="img">
                    <div class="product-name">
                        <a href="/product/detail?pd_seq=${i.pd_seq}">${i.name}</a>
                    </div>
                    <div class="product-price">
                        <fmt:formatNumber value="${i.price}" type="number"/>원<br>
                    </div>
                </div>
            </c:forEach>
        </c:when>
    </c:choose>
</div>
