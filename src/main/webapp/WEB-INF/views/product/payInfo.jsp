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
    <!-- jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <!-- iamport.payment.js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
<input type="hidden" value="${keyword}" id="key" name="key">
<%--<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>--%>
<input type="hidden" value="${id}" id="session">
<input type="hidden" value="${cart}" id="cartInfo">
<input type="hidden" value="${totalPrice}" id="totalPrice">
<input type="hidden" value="${totalSum}" id="totalSum">
<input type="hidden" value="${memberDTO.name}" id="mem_name">
<input type="hidden" value="${memberDTO.phone}" id="mem_phone">
<input type="hidden" value="${memberDTO.email}" id="mem_email">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
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
                                    src="/resources/img/products/${i.get("img")}" style="width: 120px; height: 100px;"></a>
                            </td>
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
    <button type="button" id="addBtn">배송지 추가</button>
    <br>
    <c:choose>
        <c:when test="${!empty deliDTOList}">
            <c:forEach var="i" items="${deliDTOList}">
                <input type="radio" class="select_add_radio" name="address" value="${i.seq}" <c:out
                        value="${i.status eq 'Y' ? 'checked' : ''}"/>>
                <c:choose>
                    <c:when test="${i.status eq 'Y'}">기본 배송지</c:when>
                    <c:otherwise>${i.nickname}</c:otherwise>
                </c:choose>

            </c:forEach>
            <c:forEach var="i" items="${deliDTOList}">
                <c:if test="${i.status eq 'Y'}">
                    <div class="deliInfo">
                        <p id="select_name">이름 : ${i.name}</p>
                        <p id="select_address">주소 : ${i.address}</p>
                        <p id="select_phone">전화번호 : ${i.phone}</p>
                    </div>
                </c:if>
            </c:forEach>
            <button type="button" id="updateBtn">배송지 수정</button>
            <button type="button" id="delBtn">배송지 삭제</button>
        </c:when>
    </c:choose>

    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right" id="pay" type="button">
            <fmt:formatNumber pattern="#,###" value="${totalPrice}"/>원 결제하기
        </button>
        <input type="hidden" value="${price}" id="totalMoney" name="price">
    </div>
</div>

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

    $("#continue").on("click", function () {
        location.href = "/product/list";
    });

    //배송지 추가 클릭 시
    $("#addBtn").click(function () {
        let id = $("#session").val();
        window.open('/product/addDeli?id=${id}', '', 'width=500, height=500, left=800, top=250');
    })

    //배송지 수정 클릭 시
    $("#updateBtn").click(function () {
         let seq = $("input[name=address]:checked").val();
         popup(seq);
    })

    function popup(seq) {
        window.open('/product/updDeliInfo?seq='+seq, '', 'width=500, height=500, left=650, top=250');
    }

    //배송지 삭제 클릭 시
    $("#delBtn").click(function(){
        let seq = $("input[name=address]:checked").val();
        console.log(seq);
        let defaultSeq = 0;
        //기본 배송지 seq 가져오기
        $.ajax({
            url:'/product/getDefaultAdr',
            type:'post',
            async:false,
            success:function(data){
                defaultSeq = data;
                console.log(data);
                if(seq == data){
                    alert('기본 배송지를 삭제할 수 없습니다.');
                    return false;
                }
            }
        })

        if(seq != defaultSeq){
            $.ajax({
                url : '/product/deleteDeli',
                type:'post',
                async:false,
                data : {
                    "seq":seq
                },
                success:function(data){
                    location.reload();
                    console.log(data);
                }
            })
        }
    })

    //라디오 버튼 바뀔때
    $("input[type=radio]").on("change", function () {
        let seq = $(this).val();
        console.log(seq);
        $.ajax({
            url: '/product/getSeqDeli', //해당 seq 배달정보
            type: 'post',
            data: {
                "seq": seq
            },
            success: function (data) {
                console.log(data);
                $("#select_name").text('이름 : ' + data.name);
                $("#select_address").text('주소 : ' + data.address);
                $("#select_phone").text('전화번호 : ' + data.phone);
            }
        })
    })


    var pd_sum;
    var pd_price;
    //결제 하기 클릭
    $("#pay").on("click", function () {
        // requestPay();

            //결제 내역으로 이동
            let frm = document.createElement("form");
            frm.setAttribute("method", "post");
            frm.setAttribute("action", "/product/paymentDetails");
            let newInput = document.createElement("input");
            let newInput2 = document.createElement("input");
            let newInput3 = document.createElement("input");
            let newInput4 = document.createElement("input");
            newInput.setAttribute("type", "hidden");
            newInput.setAttribute("value", $("#session").val());
            newInput.setAttribute("name", "id");

            newInput2.setAttribute("type", "hidden");
            newInput2.setAttribute("value", $("#totalMoney").val());
            newInput2.setAttribute("name", "price");

            newInput3.setAttribute("type", "hidden");
            newInput3.setAttribute("value", $("input[name=address]:checked").val());
            newInput3.setAttribute("name", "seq");

            newInput4.setAttribute("type", "hidden");
            newInput4.setAttribute("value", $("#totalSum").val());
            newInput4.setAttribute("name", "pdTotalSum");
            frm.appendChild(newInput);
            frm.appendChild(newInput2);
            frm.appendChild(newInput3);
            frm.appendChild(newInput4);
            document.body.appendChild(frm);
            frm.submit();

    });

    var IMP = window.IMP;
    IMP.init("imp62163330");

    function requestPay() {

        // $.ajax({
        //     url:'/product/getTotal',
        //     type:'post',
        //     data:{
        //         "id": $("#session").val()
        //     },
        //     async:false,
        //     success:function(data){
        //         pd_price = data.price;
        //         pd_sum = data.total_sum;
        //     }
        // })
        var email = $("#mem_email").val();
        var name = $("#mem_name").val();
        var phone = $("#mem_phone").val();
        var address = $("#defaultAddress").text();
        var price = $("#totalPrice").val();
        console.log("price : " + price);
        if ($("#totalSum").val() != 1) {
            var title = $(".pdName1").text() + '외 ' + ($("#totalSum").val() - $(".pdCnt1").val());
        } else {
            title = $(".pdName1").text();
        }

        var payInfo = {
            pg: 'kakaopay',
            pay_method: 'card',
            merchant_uid: 'merchant_' + new Date().getTime(),
            name: title,
            amount: price,
            buyer_email: email,
            buyer_name: name,
            buyer_tel: phone,
            buyer_addr: address
        };

        IMP.request_pay(payInfo, function (rsp) {
            // if (rsp.success) {
            //     var msg = '결제가 완료되었습니다.';
            //     //결제 내역으로 이동
            //     let frm = document.createElement("form");
            //     frm.setAttribute("method", "post");
            //     frm.setAttribute("action", "/product/paymentDetails");
            //     let newInput = document.createElement("input");
            //     let newInput2 = document.createElement("input");
            //     let newInput3 = document.createElement("input");
            //     newInput.setAttribute("type", "hidden");
            //     newInput.setAttribute("value", $("#session").val());
            //     newInput.setAttribute("name", "id");
            //
            //     newInput2.setAttribute("type", "hidden");
            //     newInput2.setAttribute("value", $("#totalMoney").val());
            //     newInput2.setAttribute("name", "price");
            //
            //     newInput3.setAttribute("type", "hidden");
            //     newInput3.setAttribute("value", $("input[name=address]:checked").val());
            //     newInput3.setAttribute("name", "seq");
            //     frm.appendChild(newInput);
            //     frm.appendChild(newInput2);
            //     frm.appendChild(newInput3);
            //     document.body.appendChild(frm);
            //     frm.submit();
            // } else {
            //     var msg = '결제에 실패했습니다.';
            // }
            // alert(msg);
        });
    }
</script>
</body>
</html>
