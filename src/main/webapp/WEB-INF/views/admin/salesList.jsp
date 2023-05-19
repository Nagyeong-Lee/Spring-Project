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
        html, body {
            height: 100%;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        .cart,.pagingDiv {
            flex: 1 0 auto;
        }
        #footer{  flex-shrink: 0;}
    </style>
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
                            <input type="hidden" value="${i.sales_seq}" class="sales_seq">
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
                                    <button class="selectCourier btn btn-light">택배사 입력</button>
                                </td>
                            </c:when>
                            <c:when test="${i.deliYN == 'M'}"> <%--배송중일때--%>
                                <td style="text-align: center;">배송중</td>
                            </c:when>
                            <c:otherwise> <%--배송 완료--%>
                                <td style="text-align: center;">배송 완료</td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" style="text-align: center;">구매 내역이 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
<div class="pagingDiv" style="text-align: center;">
    <c:if test="${paging.needPrev eq true}">
        <a href="javascript:void(0); onclick=paging(${paging.startNavi-1}});"><</a>
        <a href="javascript:void(0); onclick=paging(1);">맨 처음</a>
    </c:if>
    <c:forEach var="i" begin="${paging.startNavi}" end="${paging.endNavi}" varStatus="var">
        <c:if test="${paging.cpage eq i}">
            <a href="javascript:void(0); onclick=paging(${i});" style="font-weight: bold;">${i}</a>
        </c:if>
        <c:if test="${paging.cpage ne i}">
            <a href="javascript:void(0); onclick=paging(${i});">${i}</a>
        </c:if>
    </c:forEach>
    <c:if test="${paging.needNext eq true}">
        <a href="javascript:void(0); onclick=paging(${paging.endNavi+1});">></a>
        <a href="javascript:void(0); onclick=paging(${paging.totalPageCount});">맨끝</a>
    </c:if>
</div>
<footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>

<script>
    // /*택배사 db 저장*/
    // $(".selectCourier").click(function () {
    //     var list = [];
    //     let key = 'Zw11zx4vY7bsy0IdlOp98Q';
    //     $.ajax({
    //         type: "GET",
    //         dataType: "json",
    //         url: "http://info.sweettracker.co.kr/api/v1/companylist?t_key=" + key,
    //         async:false,
    //         success: function (data) {
    //             let size = data.Company.length;
    //             for (let i = 0; i < size; i++) {
    //                 let tmp =[];
    //                 tmp.push(data.Company[i].Code);
    //                 tmp.push(data.Company[i].Name);
    //                 list.push(tmp);
    //             }
    //             console.log(list);
    //             $.ajax({
    //                     url: '/product/insertDeliInfo',
    //                     contentType:'application/json',
    //                     type: 'POST',
    //                     async: false,
    //                     data:JSON.stringify(list),
    //                     success: function (data) {
    //                         console.log(data);
    //                     }
    //                 })
    //
    //         }
    //     });

    /*택배사 입력 클릭 시*/
    $(".selectCourier").click(function () {
        let sales_seq = $(this).parent().parent().find(".sales_seq").val();
        window.open('/admin/chgDeliStatus?sales_seq=' + sales_seq, '', 'width=500, height=500, left=800, top=250');
    });

    //페이징 다시 그려줌
    function paging(startNavi) {
        $.ajax({
            url: '/product/rePagingSalesList',
            type: 'post',
            data: {
                "cpage": startNavi,
                "id": $("#id").val()
            },
            success: function (data) {
                console.log(data);
                $(".pagingDiv").children().remove();
                createPaging(data);
            }
        })
    }

    function createPaging(data) {
        $("#tbody").children().remove();
        for (let i = 0; i < data.length; i++) {
            var newHtml = createHtml(data[i], data[i].startNavi);
            $("#tbody").append(newHtml);
        }

        if (data[0].needPrev) {
            var html = createPrev(startNavi);
            $(".pagingDiv").append(html);
        }
        for (let k = data[0].startNavi; k <= data[0].endNavi; k++) {
            if (data[0].startNavi == k) {
                var html = createNewPage1(k);
                $(".pagingDiv").append(html);
            } else {
                var html = createNewPage2(k);
                $(".pagingDiv").append(html);
            }
        }
        if (data[0].needNext) {
            var html = createNext(data[0].endNavi, data[0].totalPageCount);
            $(".pagingDiv").append(html);
        }
    }

    function createHtml(item, cpage) {
        let pd_seq = item.productDTO.pd_seq;
        var temp = '';
        var HTML = '<tr><td><a href="/product/detail?pd_seq=' + pd_seq + '"><img src="/resources/img/products/' + item.productDTO.img + '" style="width:120px; height: 100px;"></a></td>';
        if (item.optionMapList == null) { //옵션 없을때
            HTML += '<td style="text-align: center;"><p>' + item.productDTO.name + item.productDTO.stock + '개</p>';
        } else if (item.optionMapList != null) { //옵션 있을때
            temp += '<td style="text-align: center;"><p>' + item.productDTO.name + ' ' + item.productDTO.stock + '개</p>';
            for (let i = 0; i < item.optionMapList.length; i++) {
                temp += '<p>' + Object.keys(item.optionMapList[i])[0] + ' : ' + item.optionMapList[i][Object.keys(item.optionMapList[i])[0]] + '</p>';
            }
            temp += '</td>';
            HTML = HTML + temp;
        }
        HTML += '<td style="text-align: center;">' + item.productDTO.stock + '개</td>';
        if (item.deliYN == 'M') {
            HTML += '<td style="text-align: center;">배송중</td>';
        } else if (item.deliYN == 'N') {
            HTML += '<td style="text-align: center;"><button class="selectCourier btn btn-light">택배사 입력</button></td>';
        } else {
            HTML += '<td style="text-align: center;">배송 완료</td>';
        }
        return HTML;
    }

    function createPrev(startNavi) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + (startNavi - 1) + ');">' + "<" + '</a>';
        html += '<a href="javascript:void(0);" onclick="paging(' + (1) + ');">' + "맨 처음" + '</a>';
        return html;
    }

    function createNewPage1(k) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + k + ')"> ' + k + ' </a>';
        return html;
    }

    function createNewPage2(k) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + k + ')" style="font-weight: bold;"> ' + k + ' </a>';
        return html;
    }

    function createNext(endNavi, totalPageCount) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + (endNavi + 1) + ');">' + ">" + '</a>';
        html += '<a href="javascript:void(0);" onclick="paging(' + (totalPageCount) + ');">' + "맨끝" + '</a>';
        return html;
    }

</script>
</body>
</html>
