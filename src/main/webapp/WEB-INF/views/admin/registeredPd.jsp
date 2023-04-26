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
    <title>등록한 상품 조회</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
</head>
<body>
<h3>등록한 상품 조회</h3>
<button type="button" id="toList">관리자 메인페이지로</button>
<table>
    <tbody>
    <c:choose>
        <c:when test="${!empty optList}">
            <c:forEach var="i" items="${optList.list}">
                <tr class="itemDiv">
                    <td><img src="/resources/img/products/${i.img}" style="width: 225px;"></td>
                    <td>${i.name}</td>
                    <c:choose>
                        <c:when test="${!empty optList.optionDTOList}">
                            <c:forEach var="k" items="${optList.optionDTOList}">
                                <td colspan="5">${k.category}:${k.name}-${k.stock}개</td>
                            </c:forEach>
                        </c:when>
                    </c:choose>
                    <td><fmt:formatNumber pattern="#,###" value="${i.price}"/>원</td>
                    <td>${i.stock}개</td>
                    <td>
                        <button type="button" class="delBtn" value="${i.pd_seq}">삭제</button>
                        <button type="button" class="updBtn" value="${i.pd_seq}">수정</button>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
    </c:choose>
    </tbody>
</table>

<script>
    //관리자 메인으로
    $("#toList").click(function () {
        location.href='/admin/main';
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
    $(".updBtn").on("click",function(){
        let pd_seq = $(this).val();
        location.href='/admin/updProduct?pd_seq='+pd_seq;
    });
</script>
</body>
</html>
