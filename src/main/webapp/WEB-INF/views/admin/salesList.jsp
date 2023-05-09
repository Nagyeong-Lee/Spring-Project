<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-09
  Time: 오후 3:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>구매 내역</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/resources/asset/js/scripts.js"></script>
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
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>

    <script>
        $(function () {
            /*택배사 선택 클릭 시*/
            $(".selectDeli").click(function () {
                var list = [];
                let key = 'Zw11zx4vY7bsy0IdlOp98Q';
                $.ajax({
                    type: "GET",
                    dataType: "json",
                    url: "http://info.sweettracker.co.kr/api/v1/companylist?t_key=" + key,
                    async:false,
                    success: function (data) {
                        let size = data.Company.length;
                        for (let i = 0; i < size; i++) {
                            let map = new Map();
                            map.set("code", data.Company[i].Code);
                            map.set("name", data.Company[i].Name);
                            list.push(map);
                            //db에 저장
                            $.ajax({
                                url:'/product/insertDeliInfo',
                                type:'POST',
                                data:{
                                    "list":list.toString()
                                },
                                success:function(data){
                                    console.log(data);
                                }
                            })
                        }
                        window.open('/admin/chgDeliStatus', '', 'width=500, height=500, left=800, top=250');
                    }
                });
            });
        })
    </script>

</head>
<body>
<%@ include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>상품 이미지</th>
        <th>판매 정보</th>
        <th>남은 재고</th>
        <th></th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty paramList}">
                <c:forEach var="i" items="${paramList}">
                    <tr>
                        <td><img
                                src="/resources/img/products/${i.productDTO.img}" style="width: 120px; height: 100px;">
                        </td>
                        <td style="text-align: center;">
                            <p>${i.productDTO.name} ${i.stock}개</p>
                                <%--옵션 있을때--%>
                            <c:if test="${i.optionMapList != null}">
                                <c:forEach var="k" items="${i.optionMapList}">
                                    <c:forEach var="j" items="${k}">
                                        <p>${j.key} : ${j.value}</p>
                                    </c:forEach>
                                </c:forEach>
                            </c:if>
                        </td>
                        <td style="text-align: center;">${i.pdStock}개</td>
                        <c:choose>
                            <c:when test="${i.deliYN == 'N'}"> <%--배송 안했을때--%>
                                <td style="text-align: center;">
                                    <button class="selectDeli btn btn-light">택배사 입력</button>
                                </td>
                            </c:when>
                            <c:otherwise>

                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5">구매 내역이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>
