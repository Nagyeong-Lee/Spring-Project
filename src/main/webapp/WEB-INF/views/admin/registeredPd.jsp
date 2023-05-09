<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-25
  Time: 오후 4:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>등록 상품 조회</title>
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
</head>
<body>
<%@include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<%--<button type="button" id="toList">관리자 메인페이지로</button>--%>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>이미지</th>
        <th>상품명</th>
        <th>옵션</th>
        <th>가격</th>
        <th>수량</th>
        <th></th>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${!empty registeredPd}">
                <c:forEach var="i" items="${registeredPd}">
                    <tr class="itemDiv">
                        <td><img src="/resources/img/products/${i.productDTO.img}" style="width: 120px; height: 100px;">
                        </td>
                        <td style="width: 500px; text-align: center">${i.productDTO.name}</td>
                        <c:choose>
                            <c:when test="${!empty i.optionDTOList}">
                                <td style="text-align: center">
                                    <c:forEach var="k" items="${i.optionDTOList}">
                                        <p>${k.category}:${k.name}-${k.stock}개</p>
                                    </c:forEach>
                                </td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                        <td style="text-align: center;"><fmt:formatNumber pattern="#,###" value="${i.productDTO.price}"/>원</td>
                        <td style="text-align: center;">${i.productDTO.stock}개</td>
                        <td style="text-align: center">
                            <button type="button" class="delBtn btn btn-light" value="${i.pd_seq}">삭제</button>
                            <button type="button" class="updBtn btn btn-light" value="${i.pd_seq}">수정</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
        </c:choose>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>
    //관리자 메인으로
    $("#toList").click(function () {
        location.href = '/admin/main';
    });

    // 상품 삭제 클릭 시
    $(".delBtn").on("click", function () {
        $this = $(this);
        let cf = confirm('상품을 삭제하시겠습니까?');
        let pd_seq = $(this).val();
        if (cf == true) {
            console.log(pd_seq);
            $.ajax({
                url: '/product/deletePd',
                type: 'post',
                data: {
                    "pd_seq": pd_seq
                },
                success: function (data) {
                    if (data == 'success') {
                        $this.closest(".itemDiv").remove();
                    }
                }
            })
        }
    });

    //상품 수정 클릭 시
    $(".updBtn").on("click", function () {
        let pd_seq = $(this).val();
        location.href = '/admin/updProduct?pd_seq=' + pd_seq;
    });
</script>
</body>
</html>
