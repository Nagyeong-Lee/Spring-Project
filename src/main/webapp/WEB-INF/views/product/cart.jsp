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
    <input type="hidden" id="cartLength" value="${cart.size()}">
    <table class="cart__list">
        <form>
            <c:choose>
                <c:when test="${!empty cart}">
                    <thead>
                    <tr id="thead">
                        <td colspan="2">상품 이미지</td>
                        <td colspan="2">상품정보</td>
                        <td colspan="2">수량</td>
                        <td colspan="2">상품금액</td>
                        <td colspan="2">삭제</td>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="i" items="${cart}">
                        <tr class="itemDiv">
                            <td colspan="2"><a href="/product/detail?pd_seq=${i.get('pd_seq')}"><img
                                    src="/resources/img/products/${i.get("img")}"></a></td>
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
                            <td colspan="2">
                                <div class="count">
                                    <input type="hidden" value="${i.get("price")}" class="pd_price">
                                    <input type="text" style="width: 20px;" value="${i.get("count")}" class="stock"
                                           readonly>
                                    <button style="width: 20px;" class="plus" type="button">
                                        <input type="hidden" value="${i.get("cart_seq")}" class="cartSeq">+
                                    </button>

                                    <button style="width: 20px;" class="minus" type="button">
                                        <input type="hidden" value="${i.get("cart_seq")}" class="cartSeq">-
                                    </button>
                                </div>
                            </td>
                                <%--                            <td colspan="2"><span class="price"><fmt:formatNumber pattern="#,###"--%>
                                <%--                                                                                  value="${i.get('price')}"/>원</span>--%>
                            <input type="hidden" value="${i.get('price')}" class="productPrice">
                            <td colspan="2"><span class="price"><fmt:formatNumber pattern="#,###"
                                                                                  value="${i.get('totalPrice')}"/>원</span>
                            </td>
                            <td>
                                <button type="button" class="delBtn">삭제
                                    <input type="hidden" value="${i.get('cart_seq')}">
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </c:when>
                <%--                <c:otherwise>--%>
                <%--                    <tr>--%>
                <%--                        <td colspan="8">장바구니가 비었습니다.</td>--%>
                <%--                    </tr>--%>
                <%--                </c:otherwise>--%>

            </c:choose>
            <c:choose>
                <c:when test="${empty cart}">
                    <thead>
                    <tr>
                        <td colspan="5">장바구니가 비었습니다.</td>
                    </tr>
                    </thead>
                </c:when>
            </c:choose>

        </form>
    </table>
    <hr>
    <br>
    <%--    <div class="pay">--%>
    <%--        <div>전체 가격</div>--%>
    <%--        <div>할인</div>--%>
    <%--        <div>합계</div>--%>
    <%--    </div>--%>
    <hr id="priceHr">
    <%--    총 합계 : <span style="text-align: right" id="total"><fmt:formatNumber pattern="#,###" value="${totalPrice}"/></span>원--%>
    <span style="text-align: right" id="sum"> 총 수량 : ${totalSum}개</span><br>
    <span style="text-align: right" id="total"> 총 합계 : <fmt:formatNumber pattern="#,###" value="${totalPrice}"/>원</span>
    <input type="hidden" value="${totalPrice}" id="hiddenTotalPrice">
    <input type="hidden" value="${totalSum}" id="hiddenTotalSum">




    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right" id="pay">결제하기</button>
    </div>
</div>

<script>

    if ($(".itemDiv").length == 0) {
        $(".pay").remove();
        $("#total").remove();
    }
    $("#continue").on("click", function () {
        location.href = "/product/list";
    });

    $(".delBtn").on("click", function () { //해당 cart_seq status n으로
        let total_price = $("#hiddenTotalPrice").val();
        console.log("원래 상품 가격 : " + total_price);

        //삭제할때 총합계 변경
        console.log('삭제 클릭 : ' + $(this).closest(".itemDiv").find(".productPrice").val());
        console.log('삭제 클릭 시 수량 : ' + $(this).closest(".itemDiv").find(".stock").val());

        let chgPrice = $(this).closest(".itemDiv").find(".productPrice").val() * $(this).closest(".itemDiv").find(".stock").val();  //변경된 총 합계
        console.log("chgPrice : " + chgPrice);

        //총 합계 변경해주기
        $("#total").text('총 합계 : ' + (parseInt(total_price) - chgPrice).toLocaleString() + '원');
        $("#hiddenTotalPrice").val(parseInt(total_price) - chgPrice); //변경된 상품 가격

        //삭제할때 총 수량 변경
        console.log('삭제할때 총 수량 변경 : ' + $(this).closest(".itemDiv").find(".stock").val());

        //삭제할때 총 수량 변경
        let changedSum = parseInt($("#hiddenTotalSum").val())-$(this).closest(".itemDiv").find(".stock").val();
        console.log('123132 : '+changedSum);
        $("#sum").text('총 수량 : ' + changedSum + '개');
        $("#hiddenTotalSum").val(changedSum); //변경된 수량 저장

        let cart_seq = $(this).closest(".itemDiv").find(".cartSeq").val();
        console.log(cart_seq);
        $(this).closest(".itemDiv").remove();
        if ($(".itemDiv").length == 0) {
            $(".pay").remove();
        }
        $.ajax({
            url: '/product/cart/delete',
            type: 'post',
            data: {
                "cart_seq": cart_seq
            },
            success: function (data) {
                if ($(".itemDiv").length == 0) {
                    $("#thead").children().remove();
                    $("#total").remove();
                    var html = '<td colspan="5">장바구니가 비었습니다.</td>';
                    $("#thead").append(html);
                }
            }
        })
    });

    //+버튼 누를때 수량
    $(".plus").on("click", function () {
        let total_price = $("#hiddenTotalPrice").val();
        console.log("원래 상품 가격 : " + total_price);

        let $this = $(this);
        let cart_seq = $this.closest(".count").find(".cartSeq").val();
        let count = $this.closest(".count").find(".stock").val();
        count++
        $this.closest(".count").find(".stock").val(count);

        //가격 변경
        let totalPrice = $this.closest(".count").find(".pd_price").val() * count;
        var price = $this.closest(".itemDiv").find(".price").text(totalPrice.toLocaleString() + '원');

        let productPrice = $this.closest(".itemDiv").find(".productPrice").val();
        let changedTotalPrice = parseInt(total_price) + parseInt(productPrice);

        console.log("해당 상품 한개 가격 : " + productPrice);
        console.log("changedTotalPrice : " + changedTotalPrice);

        //총 합계 변경해주기
        $("#total").text('총 합계 : ' + changedTotalPrice.toLocaleString() + '원');
        $("#hiddenTotalPrice").val(changedTotalPrice); //변경된 상품 가격


        //총 수량 변경
        let changedSum = parseInt($("#hiddenTotalSum").val()) + 1;
        $("#sum").text('총 수량 : ' + changedSum + '개');
        $("#hiddenTotalSum").val(changedSum); //변경된 수량 저장

        console.log("$this.closest : " + totalPrice);
        $.ajax({
            url: '/product/count',
            type: 'post',
            data: {
                "cart_seq": cart_seq
            },
            success: function (data) {
                //구매 가능한 개수 가져옴
                console.log("count : " + count);
                if (count > data) {
                    alert('구매 가능한 수량이 아닙니다.');
                    --count
                    $this.closest(".count").find(".stock").val(count);
                    $this.hide();
                }
            }
        });
    })


    //-버튼 누를때
    $(".minus").on("click", function () {

        let total_price = $("#hiddenTotalPrice").val();
        console.log("원래 상품 가격 : " + total_price);

        let $this = $(this);
        let count = $(this).closest(".count").find(".stock").val();
        let cart_seq = $this.closest(".count").find(".cartSeq").val();
        count--
        console.log("count : " + count);
        $(this).closest(".count").find(".stock").val(count);
        if (count < 1) {
            alert('수량을 1개 이상 선택해주세요.');
            $(this).closest(".count").find(".stock").val(1);
            count = 1;
        } else {

            //가격 변경
            let totalPrice = $this.closest(".count").find(".pd_price").val() * count;
            var price = $this.closest(".itemDiv").find(".price").text(totalPrice.toLocaleString() + '원');

            let productPrice = $this.closest(".itemDiv").find(".productPrice").val();
            let changedTotalPrice = parseInt(total_price) - parseInt(productPrice);

            console.log("해당 상품 한개 가격 : " + productPrice);
            console.log("changedTotalPrice : " + changedTotalPrice);

            //총 합계 변경해주기
            $("#total").text('총 합계 : ' + changedTotalPrice.toLocaleString() + '원');
            $("#hiddenTotalPrice").val(changedTotalPrice); //변경된 상품 가격

            //총 수량 변경
            let changedSum = $("#hiddenTotalSum").val() - 1;
            $("#sum").text('총 수량 : ' + changedSum + '개');
            $("#hiddenTotalSum").val(changedSum); //변경된 수량 저장
        }
        $.ajax({
            url: '/product/count',
            type: 'post',
            data: {
                "cart_seq": cart_seq
            },
            success: function (data) {
                //구매 가능한 개수 가져옴
                console.log("count : " + count);
                if (count <= data) {
                    $this.closest(".count").find(".stock").val(count);
                    $this.closest(".count").find(".plus").show();
                }
            }
        });
    });

    //결제하기 버튼 클릭
    //옵션,상품 개수 변경
    $("#pay").on("click", function () {

    });
</script>
</body>
</html>
