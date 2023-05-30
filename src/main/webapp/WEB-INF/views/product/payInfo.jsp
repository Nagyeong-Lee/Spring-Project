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
<input type="hidden" value="${totalPayPrice}" id="totalPrice">
<input type="hidden" value="${totalPayCount}" id="totalSum">
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
                            <input type="hidden" value="${i.get('pd_seq')}" name="pdSeq" id="pdSeq">
                            <td colspan="2"><a href="/product/detail?pd_seq=${i.get('pd_seq')}"><img
                                    src="/resources/img/products/${i.get("img")}" style="width: 120px; height: 100px;"></a>
                            </td>
                            <td colspan="2">
                                <p class="pdName${status.count}">${i.get("name")}</p>
                                <p>수량 : ${i.get("count")}</p>
                                <input type="hidden" class="pdCnt${status.count} pdStock" value="${i.get("count")}">
                                <c:choose>
                                    <c:when test="${!empty i.get('option')}">
                                        <c:forEach var="k" items="${i.get('option')}">
                                            <c:forEach var="j" items="${k}">
                                                <p>&nbsp${j}</p>
                                                <input type="hidden" name="option" class="option" value="${j}">
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
    <h5>적립될 포인트</h5>
    <%--    <input type="hidden" value="${usedPoint}" id="usedPoint" name="usedPoint">--%>
    <h5><fmt:formatNumber value="${memPoint}" pattern="#,###"/>점</h5><br>

    <%--포인트 사용--%>
    <div class="pointDiv">
        <input type="hidden" name="usablePoint" id="usablePoint" value="${memberPoint}">
        나의 포인트 : <fmt:formatNumber value="${memberPoint}" pattern="#,###"/>점
        <br>
        <input type="number" name="point" id="point" min="1">
        <button type="button" name="usePointBtn" id="usePointBtn" class="btn btn-light">사용하기</button>
    </div>
    <h3>배송지 선택</h3>
    <button type="button" id="addBtn" class="btn btn-light">배송지 추가</button>
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
            <button type="button" id="updateBtn" class="btn btn-light">배송지 수정</button>
            <button type="button" id="delBtn" class="btn btn-light">배송지 삭제</button>
        </c:when>
    </c:choose>

    <div class="cart__mainbtns">
        <button class="cart__bigorderbtn left" id="continue">쇼핑 계속하기</button>
        <button class="cart__bigorderbtn right" id="pay" type="button">
            <fmt:formatNumber pattern="#,###" value="${totalPayPrice}"/>원 결제하기
        </button>
        <input type="hidden" value="${totalPayPrice}" id="totalMoney" name="price">
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>

    var IMP = window.IMP;
    IMP.init("imp62163330");

    function requestPay(productArr) {
        let testArray = [];
        for (let i = 0; i < productArr.length; i++) {
            var param = Object.fromEntries(productArr[i]);
            testArray.push(param);
        }

        //재고 있는지 확인
        $.ajax({
            url: '/product/checkStock',
            type: 'post',
            async: false,
            data: {
                "testArray": JSON.stringify(testArray)
            },
            success: function (data) {
                console.log(data);
                //재고 없으면
                if (data == false) {
                    alert('재고가 없습니다.');
                    return;
                }else{
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
                        if (rsp.success) {
                            //결제 실행
                            let frm = document.createElement("form");
                            frm.setAttribute("method", "post");
                            frm.setAttribute("action", "/product/paymentDetails");
                            frm.setAttribute("display", "none");
                            let newInput = document.createElement("input");
                            let newInput2 = document.createElement("input");
                            let newInput3 = document.createElement("input");
                            let newInput4 = document.createElement("input");
                            let newInput5 = document.createElement("input");
                            let newInput6 = document.createElement("input");
                            let newInput7 = document.createElement("input");
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

                            newInput5.setAttribute("type", "hidden");
                            newInput5.setAttribute("value", $("#point").val());  //입력한 포인트
                            newInput5.setAttribute("name", "usedPoint");
                            newInput7.setAttribute("type", "hidden");
                            newInput7.setAttribute("value", JSON.stringify(testArray));
                            newInput7.setAttribute("name", "testArray");
                            frm.appendChild(newInput);
                            frm.appendChild(newInput2);
                            frm.appendChild(newInput3);
                            frm.appendChild(newInput4);
                            frm.appendChild(newInput5);
                            frm.appendChild(newInput6);
                            frm.appendChild(newInput7);
                            document.body.appendChild(frm);
                            frm.submit();
                            var msg = '결제가 완료되었습니다.';
                        } else {
                            var msg = '결제에 실패했습니다.';
                        }
                        alert(msg);
                    });
                }
            }
        })
    }

    //포인트 사용 클릭 시 -> 서버에서 포인트 쓸 수 있는지 확인
    $("#usePointBtn").on("click", function () {
        let inputPoint = Number($("#point").val());//입력한 포인트
        let usablePoint = $("#usablePoint").val();//나의 포인트
        let isPointUsable = false;
        console.log(inputPoint);
        console.log(usablePoint);

        $.ajax({
            url: '/product/checkPoint',
            type: 'post',
            async: false,
            data: {
                "inputPoint": inputPoint,
                "id": $("#session").val()
            },
            success: function (data) {
                if (data == true) {
                    isPointUsable = data;
                }
            }
        })

        //결제 금액보다 포인트 사용 많이하면
        if ($("#totalPrice").val() < inputPoint) {
            alert('사용 포인트가 결제 금액보다 클 수 없습니다.');
            $("#point").val("");
            return false;
        }

        if (isPointUsable == false) {
            alert('사용가능한 포인트가 아닙니다.');
            $("#point").val("");
            let totalPrice = $("#totalPrice").val();  //총 합계 금액
            let totalHtml = totalPrice + '원 결제하기';
            $("#pay").text(totalHtml);
            return false;
        } else {
            let totalPrice = $("#totalPrice").val();  //총 합계 금액
            totalPrice -= inputPoint;
            let totalHtml = totalPrice.toLocaleString() + '원 결제하기';
            $("#pay").text(totalHtml);
        }

    })

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
        newForm.setAttribute("display", "none");
        let newInput = document.createElement("input");
        newInput.setAttribute("type", "hidden");
        newInput.setAttribute("name", "id");
        newInput.setAttribute("value", $("#id").val());
        newForm.appendChild(newInput);
        document.body.append(newForm);
        newForm.submit();
    })

    $("#continue").on("click", function () {
        location.href = "/product/list?cpage=1";
    });

    //배송지 추가 클릭 시
    $("#addBtn").click(function () {
        let id = $("#session").val();
        let point = $("#point").val();
        if (point != 0) {
            window.open('/product/addDeli?id=${id}&point=' + point, '', 'width=500, height=500, left=800, top=250');
        } else {
            window.open('/product/addDeli?id=${id}', '', 'width=500, height=500, left=800, top=250');
        }
    })

    //배송지 수정 클릭 시
    $("#updateBtn").click(function () {
        let seq = $("input[name=address]:checked").val();
        popup(seq);
    })

    function popup(seq) {
        window.open('/product/updDeliInfo?seq=' + seq, '', 'width=500, height=500, left=650, top=250');
    }

    //배송지 삭제 클릭 시
    $("#delBtn").click(function () {
        let seq = $("input[name=address]:checked").val();
        console.log(seq);
        let defaultSeq = 0;
        //기본 배송지 seq 가져오기
        $.ajax({
            url: '/product/getDefaultAdr',
            type: 'post',
            async: false,
            success: function (data) {
                defaultSeq = data;
                console.log(data);
                if (seq == data) {
                    alert('기본 배송지를 삭제할 수 없습니다.');
                    return false;
                }
            }
        })

        if (seq != defaultSeq) {
            $.ajax({
                url: '/product/deleteDeli',
                type: 'post',
                async: false,
                data: {
                    "seq": seq
                },
                success: function (data) {
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

    //결제 하기 클릭 -> 카카오페이
    //결제 성공 시 -> 결제 결과 페이지
    // 결제 실패 시 -> 결제 상세 페이지 그대로
    $("#pay").on("click", function () {
        console.log($("#point").val());
        if ($('input:radio[name=address]').length === 0) {
            alert('배송지를 추가해주세요');
            return false;
        }

        if ($('input:radio[name=address]').is(':checked') === false) {
            alert('배송지를 선택해주세요');
            return false;
        }

        let productArr = [];

        $(".itemDiv").each(function () {
            let map = new Map();
            let pdSeq = $(this).find("#pdSeq").val();
            let pdStock = $(this).find(".pdStock").val();
            map.set("pdSeq", pdSeq);
            map.set("pdStock", pdStock);
            //옵션 있으면
            if($(this).find(".option").length>0) {
                let optionArr = [];
                let size = $(this).find(".option").length;
                for(let i = 0 ; i<size; i++){
                    let option = $(this).find(".option").eq(i).val();
                    console.log(option);
                    optionArr.push(option);
                }
                map.set("optionArr",optionArr);
            }
            productArr.push(map);
        })
        requestPay(productArr);
    });

</script>
</body>
</html>
