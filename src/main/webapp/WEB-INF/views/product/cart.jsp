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

</head>
<body>
<input type="hidden" value="${keyword}" id="key" name="key">
<%--<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>--%>
<input type="hidden" value="${cart}" id="hiddenCart">
<input type="hidden" value="${id}" id="session">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<div class="cart">
    <input type="hidden" id="cartLength" value="${cart.size()}">
    <table class="cart__list">
        <form>
            <c:choose>
                <c:when test="${!empty cart}">
                    <thead>
                    <tr id="thead">
                        <td colspan="2"></td>
                        <td colspan="2">상품 이미지</td>
                        <td colspan="2">상품정보</td>
                        <td colspan="2">수량</td>
                        <td colspan="2">상품금액</td>
                        <td colspan="2">
                            <button type="button" class="delBtn" onclick="deleteCart()">삭제</button>
                        </td>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="i" items="${cart}">
                        <tr class="itemDiv">
                            <td>
                                <input type="checkbox" name="buyPdSeq" value="${i.get('cart_seq')}" class="buyPdSeq"
                                       checked="checked">
                            </td>
                            <td colspan="2"><a href="/product/detail?pd_seq=${i.get('pd_seq')}"><img
                                    src="/resources/img/products/${i.get("img")}" style="width: 120px; height: 100px;"></a>
                            </td>
                            <td colspan="2" style="text-align: center">
                                <p>${i.get("name")}</p>
                                <p class="chgCnt">수량 : ${i.get("count")}</p>
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
                                <div class="count" style="text-align: center">
                                    <input type="hidden" value="${i.get("price")}" class="pd_price">
                                    <input type="text" style="width: 20px;" value="${i.get("count")}" class="stock"
                                           readonly>
                                    <button style="width: 30px;" class="plus btn btn-light" type="button">
                                        <input type="hidden" value="${i.get("cart_seq")}" class="cartSeq">+
                                    </button>

                                    <button style="width: 30px;" class="minus btn btn-light" type="button">
                                        <input type="hidden" value="${i.get("cart_seq")}" class="cartSeq">-
                                    </button>
                                </div>
                            </td>
                            <input type="hidden" value="${i.get('price')}" class="productPrice">
                            <td colspan="2" style="text-align: center" style="text-align: center"><span
                                    class="price"><fmt:formatNumber pattern="#,###"
                                                                    value="${i.get('totalPrice')}"/>원</span>
                                <input type="hidden" class="thisPrice" value="${i.get('totalPrice')}">
                            </td>
                            <td style="text-align: center">
                                <input type="checkbox" name="delete" value="${i.get('cart_seq')}">
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </c:when>
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
    <hr id="priceHr">

    <%--    &lt;%&ndash;쿠폰&ndash;%&gt;--%>
    <%--    <select name="discount" id="discount">--%>
    <%--        <option value="coupon">--coupon--</option>--%>
    <%--        <c:if test="${!empty couponDTOList}">--%>
    <%--            <c:forEach var="i" items="${couponDTOList}">--%>
    <%--                <option value="${i.discount}" class="useCoupon">${i.title}${i.discount}%</option>--%>
    <%--            </c:forEach>--%>
    <%--        </c:if>--%>
    <%--    </select><br>--%>
    <span style="text-align: right" id="sum"> 총 수량 : ${totalSum}개</span><br>
    <span style="text-align: right" id="total"> 총 합계 : <fmt:formatNumber pattern="#,###" value="${totalPrice}"/>원</span>
    <input type="hidden" value="${totalPrice}" id="hiddenTotalPrice">
    <input type="hidden" value="${totalSum}" id="hiddenTotalSum"><br>
    <input type="hidden" value="${totalPrice}" id="hiddenTotalPreviousTotalPrice"><br>


    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right" id="pay" type="button">결제하기</button>
    </div>
</div>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>

<script>

    $("#keyword").val($("#key").val());
    $("#search").on("click", function () {
        let keyword = $("#keyword").val();
        if (keyword.length == 0) {
            alert('상품을 입력하세요.');
            return;
        }
        location.href = '/product/searchPd?keyword=' + keyword;
    });

    $("#cart").click(function () {
        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/product/cart");
        let newInput = document.createElement("input");
        newInput.setAttribute("type", "hidden");
        newInput.setAttribute("name", "id");
        newInput.setAttribute("value", $("#id").val());
        newForm.appendChild(newInput);
        document.body.append(newForm);
        newForm.submit();
    })

    if ($(".itemDiv").length == 0) {
        $(".pay").remove();
        $("#total").remove();
        $("#sum").remove();
        $("#discount").remove();
    }
    $("#continue").on("click", function () {
        location.href = "/product/list?cpage=1";
    });

    //구매 클릭 시
    function buyPd() {
        var buyPdSeq = []; //구매할 cart_seq 담을 배열
        $("input[name=buyPdSeq]:checked").each(function () {
            var cart_seq = $(this).val();
            buyPdSeq.push(parseInt(cart_seq));
        });
    }

    //삭제시 실행될 함수
    function deleteCart() {
        let deleteCartSeq = []; //삭제할 cart_seq 담을 배열
        $("input[name=delete]:checked").each(function () {
            var cart_seq = $(this).val();
            deleteCartSeq.push(cart_seq);
        });
        if (deleteCartSeq.length == 0) {
            alert('삭제할 항목을 선택해주세요.');
        } else {  //체크된 tr 제거
            $("input[name=delete]:checked").each(function () {
                $("#discount  option:eq(0)").prop("selected", true);
                $("#discount option:not(select)").show();
                let total_price = $("#hiddenTotalPreviousTotalPrice").val();
                //삭제할때 총합계 변경
                // console.log('삭제 클릭 : ' + $("input[name=delete]:checked").closest(".itemDiv").find(".thisPrice").val());
                // console.log('삭제 클릭 시 수량 : ' + $("input[name=delete]:checked").closest(".itemDiv").find(".stock").val());
                let chgPrice = $(this).closest(".itemDiv").find(".productPrice").val() * $(this).closest(".itemDiv").find(".stock").val();  //변경된 총 합계
                // console.log("변경된 총 합계 : " + chgPrice);
                // 총 합계 변경해주기
                $("#total").text('총 합계 : ' + (parseInt(total_price) - chgPrice).toLocaleString() + '원');
                $("#hiddenTotalPrice").val(parseInt(total_price) - chgPrice); //변경된 상품 가격
                $("#hiddenTotalPreviousTotalPrice").val($("#hiddenTotalPrice").val()); //변경된 상품 가격
                //삭제할때 총 수량 변경
                let changedSum = parseInt($("#hiddenTotalSum").val()) - $(this).closest(".itemDiv").find(".stock").val();
                $("#sum").text('총 수량 : ' + changedSum + '개');
                $("#hiddenTotalSum").val(changedSum); //변경된 수량 저장
            })
            $.ajax({
                url: '/product/cart/delCart',
                data: {
                    "deleteCartSeq": deleteCartSeq
                },
                success: function (data) {
                    $("input[name=delete]:checked").closest(".itemDiv").remove();
                    if ($(".itemDiv").length == 0) {
                        $(".pay").remove();
                        $("#total").remove();
                        $("#sum").remove();
                        $("#discount").remove();
                        $("#thead").remove();
                        var html = '<tr><td colspan="5">장바구니가 비었습니다.</td></tr>';
                        $("thead").append(html);
                    }
                }
            });
        }
    }

    //+버튼 누를때 수량
    $(".plus").on("click", function () {
        var $this = $(this);
        let flag = $(this).closest(".itemDiv").find(".buyPdSeq").is(':checked');
        let cart_seq = $this.closest(".count").find(".cartSeq").val();
        // if (flag == true) {
        let checkedPrice = $(this).closest(".itemDiv").find(".productPrice").val();
        console.log(': ' + $(this).val() + " : " + checkedPrice);
        let sum = parseInt($("#hiddenTotalPrice").val()) + parseInt(checkedPrice);
        let cnt = parseInt($("#hiddenTotalSum").val()) + 1;
        $("#total").text('총 합계 : ' + sum.toLocaleString() + '원');
        $("#hiddenTotalPrice").val(sum); //변경된 상품 가격
        console.log('hiddenTotalPrice  : ' + $("#hiddenTotalPrice").val());
        // 총 수량 변경
        $("#hiddenTotalSum").val(cnt);
        //$("#sum").text('총 수량 : ' + cnt + '개');
        console.log('hiddenTotalSum  : ' + $("#hiddenTotalSum").val());
        $("#discount  option:eq(0)").prop("selected", true);

        $("#discount option:not(select)").show();
        var total_price = $("#hiddenTotalPreviousTotalPrice").val();
        var count = $this.closest(".count").find(".stock").val();
        count++
        $this.closest(".count").find(".stock").val(count);
        updateCnt();
        //가격 변경
        var totalPrice = $this.closest(".count").find(".pd_price").val() * count;
        var price = $this.closest(".itemDiv").find(".price").text(totalPrice.toLocaleString() + '원');
        var productPrice = $this.closest(".itemDiv").find(".productPrice").val();
        // }
        $.ajax({
            url: '/product/count',
            type: 'post',
            data: {
                "cart_seq": cart_seq
            },
            success: function (data) {
                //구매 가능한 개수 가져옴
                if (count > data) {
                    alert('구매 가능한 수량이 아닙니다.');
                    --count
                    $this.closest(".count").find(".stock").val(count);
                    $this.hide();
                } else {
                    $this.closest(".itemDiv").find(".chgCnt").text('수량 : ' + count);
                }
            }
        });
        //수량 update
        $.ajax({
            url: '/product/updCount',
            type: 'post',
            data: {
                "count": count,
                "cart_seq": cart_seq
            },
            success: function (data) {
            }
        });
    })

    function updateCnt() {
        let countTotal = 0;
        let totalMoney = 0;
        $(".buyPdSeq:checked").each(function () {
            totalMoney += $(this).closest(".itemDiv").find(".productPrice").val() * parseInt($(this).parent().parent().find(".stock").val());  //총 합계
            countTotal += parseInt($(this).parent().parent().find(".stock").val()); //총 수량
        });
        console.log('토탈 : ' + countTotal);
        console.log('totalMoney : ' + totalMoney);
        $("#sum").text('총 수량 : ' + countTotal.toLocaleString() + '개');
        $("#total").text('총 합계 : ' + totalMoney.toLocaleString() + '원');
    }

    var preSum = 0;
    //-버튼 누를때
    $(".minus").on("click", function () {
        var $this = $(this);
        let flag = $(this).closest(".itemDiv").find(".buyPdSeq").is(':checked');
        let cart_seq = $this.closest(".count").find(".cartSeq").val();
        var count = $(this).closest(".count").find(".stock").val();
        console.log('count : ' + count);

        if (count == 1) {
            count = 1;
            alert('수량을 1개 이상 선택해주세요.');
        } else {
            $(this).closest(".itemDiv").find(".chgCnt").text('수량 : ' + count);

            let checkedPrice = $(this).closest(".itemDiv").find(".productPrice").val();
            let sum = parseInt($("#hiddenTotalPrice").val()) - parseInt(checkedPrice);
            let cnt = parseInt($("#hiddenTotalSum").val()) - 1;

            $("#total").text('총 합계 : ' + sum.toLocaleString() + '원');
            $("#hiddenTotalPrice").val(sum); //변경된 상품 가격
            // 총 수량 변경
            $("#hiddenTotalSum").val(cnt);

            $("#discount  option:eq(0)").prop("selected", true);
            $("#discount option:not(select)").show();

            var total_price = $("#hiddenTotalPreviousTotalPrice").val();
            var count = $this.closest(".count").find(".stock").val();
            count--
            $this.closest(".count").find(".stock").val(count);
            updateCnt();
            //가격 변경
            var totalPrice = $this.closest(".count").find(".pd_price").val() * count;
            var price = $this.closest(".itemDiv").find(".price").text(totalPrice.toLocaleString() + '원');
            var productPrice = $this.closest(".itemDiv").find(".productPrice").val();
            preSum = parseInt($("#hiddenTotalSum").val());
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
                        $this.closest(".itemDiv").find(".chgCnt").text('수량 : ' + count);
                    }
                }
            });
            //수량 update
            $.ajax({
                url: '/product/updCount',
                type: 'post',
                data: {
                    "count": count,
                    "cart_seq": cart_seq
                },
                success: function (data) {
                }
            });
        }
    });
    //쿠폰 선택할때 -> ajax로 가격 변경된거 가져옴
    $("#discount").on("change", function () {
        let totalPrice = $("#hiddenTotalPreviousTotalPrice").val();
        let exPrice = $("#hiddenTotalPreviousTotalPrice").val();
        let usableCoupon = $("#discount option:selected").val();
        console.log("totalPrice : " + totalPrice);
        console.log("exPrice : " + exPrice);
        console.log("usableCoupon : " + usableCoupon);
        if (usableCoupon != 'coupon') { //할인되는거 선택했을때
            totalPrice = $("#hiddenTotalPrice").val();
            $.ajax({
                url: '/product/discountedPrice',
                type: 'post',
                data: {
                    "discount": usableCoupon,
                    "price": totalPrice
                },
                success: function (data) {
                    if (data != null) {
                        //총 합계 변경
                        $("#hiddenTotalPreviousTotalPrice").val(totalPrice);
                        $("#total").text('총 합계 : ' + data.toLocaleString() + '원');
                        $("#hiddenTotalPreviousTotalPrice").val(totalPrice);
                        $("#hiddenTotalPrice").val(parseInt(data)); //변경된 상품 가격
                        $("#discount option:selected").hide();
                    }
                }
            })
        } else {
            $("#discount option:not(select)").show();
            $("#total").text('총 합계 : ' + parseInt($("#hiddenTotalPreviousTotalPrice").val()).toLocaleString() + '원');
            $("#hiddenTotalPrice").val(exPrice); //변경된 상품 가격
        }
    });
    //결제하기 버튼 클릭
    //옵션,상품 개수 변경
    $("#pay").on("click", function () {

        var buyPdSeq = []; //구매할 cart_seq 담을 배열

        $("input[name=buyPdSeq]:checked").each(function () {
            var cart_seq = $(this).val();
            buyPdSeq.push(parseInt(cart_seq));
        });
        if (buyPdSeq.length == 0) {
            alert('구매할 상품을 선택하세요.');
        } else {
            console.log($("#hiddenTotalPrice").val());
            console.log($("#discount option:selected").val());
            var newForm = document.createElement("form");
            var newInput = document.createElement("input");
            var newInput2 = document.createElement("input");
            var newInput3 = document.createElement("input");
            newForm.setAttribute("action", "/product/payInfo");
            newForm.setAttribute("method", "post");
            newInput.setAttribute("value", $("#session").val());
            newInput.setAttribute("type", "hidden");
            newInput.setAttribute("name", "data");
            newInput2.setAttribute("value", $("#hiddenTotalPrice").val());
            newInput2.setAttribute("type", "hidden");
            newInput2.setAttribute("name", "price");
            newInput3.setAttribute("value", buyPdSeq.toString());
            newInput3.setAttribute("type", "hidden");
            newInput3.setAttribute("name", "buyPdSeq");
            newForm.appendChild(newInput);
            newForm.appendChild(newInput2);
            newForm.appendChild(newInput3);
            document.body.append(newForm);
            newForm.submit();
        }
    });

    //구매 체크박스
    $(".buyPdSeq").on("change", function () {
        var t_sum = 0;
        var t_count = 0;
        var pdPrice = 0;
        if ($(".buyPdSeq:checked").length == 0) {
            t_sum = 0;
            t_count = 0;
            pdPrice = 0;
            // 총 합계 변경해주기
            $("#total").text('총 합계 : ' + 0 + '원');
            $("#sum").text('총 수량 : ' + 0 + '개');
        }
        let flag = $(this).is(':checked');
        if (flag == false) {  //cart - flag n으로 변경
            let cart_seq = $(this).val();
            $.ajax({
                url: '/product/cart/updFlag',
                type: 'post',
                async: false,
                data: {
                    "cart_seq": cart_seq
                },
                success: function (data) {
                    console.log(data);
                }
            })
        } else {  //cart - flag Y로 변경
            let cart_seq = $(this).val();
            $.ajax({
                url: '/product/cart/updFlagToY',
                type: 'post',
                async: false,
                data: {
                    "cart_seq": cart_seq
                },
                success: function (data) {
                    console.log(data);
                }
            })
        }
        $(".buyPdSeq:checked").each(function () {
            let checkedPrice = $(this).closest(".itemDiv").find(".productPrice").val();
            console.log('선택된 것들 : ' + $(this).val() + " : " + checkedPrice);
            let count = $(this).closest(".itemDiv").find(".stock").val();
            //체크된 상품 합계
            pdPrice = checkedPrice * count;
            t_sum += pdPrice;
            t_count += parseInt(count);
            console.log('pdPrice   : ' + pdPrice);
            console.log('t_sum  : ' + t_sum);
            console.log('t_count  : ' + t_count);
            // 총 합계 변경해주기
            $("#total").text('총 합계 : ' + t_sum.toLocaleString() + '원');
            $("#hiddenTotalPrice").val(t_sum); //변경된 상품 가격
            console.log('변경된 상품 가격  : ' + $("#hiddenTotalPrice").val());
            // 총 수량 변경
            $("#hiddenTotalSum").val(t_count);
            $("#sum").text('총 수량 : ' + t_count + '개');
            console.log('변경된 총 수량  : ' + $("#hiddenTotalSum").val());
        });
    });
</script>
</body>
</html>