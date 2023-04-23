<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-21
  Time: 오후 2:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>결제 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/resources/cart.css">

    <!-- jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
    <!-- iamport.payment.js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>
<input type="hidden" value="${id}" id="session">
<input type="hidden" value="${cart}" id="cartInfo">
<input type="hidden" value="${totalPrice}" id="totalPrice">
<input type="hidden" value="${totalSum}" id="totalSum">
<input type="hidden" value="${memberDTO.name}" id="mem_name">
<input type="hidden" value="${memberDTO.phone}" id="mem_phone">
<input type="hidden" value="${memberDTO.email}" id="mem_email">
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
    <br>


    <h3>배송지 선택</h3>
    <input type="radio" name="address" checked value="default">기본 배송지
    <input type="radio" name="address" value="additional1">추가 배송지1
    <input type="radio" name="address" value="additional2">기본 배송지2

    <div class="deliveryInfo">
        <div>이름 : ${deliAddress.get("name")}</div>
        <div id="phone"> 전화번호 : ${deliAddress.get("phone")}</div>
        <div id="addr">기본주소 : <span id="defaultAddress"
                                    contenteditable="false">${deliAddress.get("defaultAddress")}</span>
            <button type="button" id="updateBtn">배송지 수정</button>
        </div>
    </div>

    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right" id="pay" type="button">
            <fmt:formatNumber pattern="#,###" value="${price}"/>원 결제하기
        </button>
        <input type="hidden" value="${price}" id="totalMoney" name="price">
    </div>
</div>


<script>

    $("#continue").on("click", function () {
        location.href = "/product/list";
    });

    //배송지 수정 클릭 시
    // $("#updateBtn").on("click", function () {
    $(document).on("click", "#updateBtn", function () {
        $("#defaultAddress").attr("contentEditable", true);
        $("#updateBtn").hide();
        var button = '<button type="button" id="cplUpdate">수정 완료</button>';
        $("#defaultAddress").after(button);
    });

    //수정 완료 클릭 시
    $(document).on("click", "#cplUpdate", function () {
        $("#defaultAddress").attr("contentEditable", false);
        $("#updateBtn").show();
        $("#cplUpdate").hide();
    });

    //라디오 버튼 바뀔때
    $("input[type=radio]").on("change", function () {
        let checkedVal = $('input[name="address"]:checked').val();
        if (checkedVal == 'additional1') {  //추가 배송지1
            $("#addr").remove();
            $.ajax({
                url: '/product/getAdditionalAddr',
                data: {
                    "id": $("#session").val()
                },
                success: function (data) {
                    let addr = data;
                    var html = '<div id="addr">기본주소 : ' + '<span id="defaultAddress" contenteditable="false">' + data + '</span>' +
                        '<button type="button" id="updateBtn">배송지 수정</button></div>';
                    $("#phone").after(html);
                }
            });
        } else if (checkedVal == 'additional2') { //추가 배송지2
            $("#addr").remove();
            $.ajax({
                url: '/product/getAdditionalAddr2',
                data: {
                    "id": $("#session").val()
                },
                success: function (data) {
                    let addr = data;
                    var html = '<div id="addr">기본주소 : ' + '<span id="defaultAddress" contenteditable="false">' + data + '</span>' +
                        '<button type="button" id="updateBtn">배송지 수정</button></div>';
                    $("#phone").after(html);
                }
            });
        } else {  //기본 배송지
            $("#addr").remove();
            $.ajax({
                url: '/product/getDefaultAddr',
                data: {
                    "id": $("#session").val()
                },
                success: function (data) {
                    let addr = data;
                    var html = '<div id="addr">기본주소 : ' + '<span id="defaultAddress" contenteditable="false">' + data + '</span>' +
                        '<button type="button" id="updateBtn">배송지 수정</button></div>';
                    $("#phone").after(html);
                }
            });
        }
    });


    //결제 하기 클릭
    $("#pay").on("click", function () {
        // requestPay();
        var msg = '결제가 완료되었습니다.';
        //결제 내역으로 이동
        let frm = document.createElement("form");
        frm.setAttribute("method","post");
        frm.setAttribute("action","/product/paymentDetails");
        let newInput = document.createElement("input");
        let newInput2 = document.createElement("input");
        let newInput3 = document.createElement("input");
        newInput.setAttribute("type","hidden");
        newInput.setAttribute("value",$("#session").val());
        newInput.setAttribute("name","id");

        newInput2.setAttribute("type","hidden");
        newInput2.setAttribute("value",$("#totalMoney").val());
        newInput2.setAttribute("name","price");

        newInput3.setAttribute("type","hidden");
        newInput3.setAttribute("value",$("#cartInfo").val());
        newInput3.setAttribute("name","carts");
        frm.appendChild(newInput);
        frm.appendChild(newInput2);
        frm.appendChild(newInput3);
        document.body.appendChild(frm);
        frm.submit();
    });

    var IMP = window.IMP;
    IMP.init("imp62163330");

    function requestPay() {
        var email = $("#mem_email").val();
        var name = $("#mem_name").val();
        var phone = $("#mem_phone").val();
        var address = $("#defaultAddress").text();
        var price =  $("#totalPrice").val()
        if($("#totalSum").val() != 1){
           var title = $(".pdName1").text() + '외 ' + ($("#totalSum").val() - $(".pdCnt1").val());
        }else{
            title=$(".pdName1").text();
        }

        var payInfo = {
            pg: 'kakaopay',
            pay_method: 'card',
            merchant_uid: 'merchant_' + new Date().getTime(),
            name: title,
            amount: 100,
            buyer_email: email,
            buyer_name: name,
            buyer_tel: phone,
            buyer_addr: address
        };

        IMP.request_pay(payInfo, function (rsp) {
            if (rsp.success) {
                // var msg = '결제가 완료되었습니다.';
                // //결제 내역으로 이동
                // let frm = document.createElement("form");
                // frm.setAttribute("method","post");
                // frm.setAttribute("action","/product/paymentDetails");
                // let newInput = document.createElement("input");
                // let newInput2 = document.createElement("input");
                // newInput.setAttribute("type","hidden");
                // newInput.setAttribute("value",$("#session").val());
                // newInput.setAttribute("name","id");
                //
                // newInput2.setAttribute("type","hidden");
                // newInput2.setAttribute("value",$("#totalMoney").val());
                // newInput2.setAttribute("name","price");
                // frm.appendChild(newInput);
                // frm.appendChild(newInput2);
                // document.body.appendChild(frm);
                // frm.submit();
            } else {
                // var msg = '결제에 실패했습니다.';
            }
            alert(msg);
        });
    }
</script>
</body>
</html>
