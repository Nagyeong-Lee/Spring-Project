<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오후 5:22
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

        .cart, .pagingDiv {
            flex: 1 0 auto;
        }

        .pagingDiv {
            position: fixed;
            left: 0;
            bottom: 130px;
            width: 100%;
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            /*padding: 15px; !* 위아래/좌우 패딩 *!*/
        }

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
<input type="hidden" id="id" name="id" value="${id}">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>상품 이미지</th>
        <th>상품 정보</th>
        <th>배송지</th>
        <th>결제 정보</th>
        <th>배송 상태</th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty historyList}">
                <c:set var="paySeq" value="0"/>
                <c:forEach var="i" items="${historyList}" varStatus="status">
                    <%--                    ${i.pay_seq}-${i.count}--%>
                    <c:set var="loop_flag" value="false"/>
                    <tr>
                        <td><a href="/product/detail?pd_seq=${i.productDTO.pd_seq}"><img
                                src="/resources/img/products/${i.productDTO.img}" style="width: 120px; height: 100px;"></a>
                        </td>
                        <td>
                            <p>${i.productDTO.name} ${i.cntPerPd}개</p>
                            <input type="hidden" value="${i.payPd_seq}" name="payPd_seq" class="payPd_seq">
                            <input type="hidden" value="${i.productDTO.pd_seq}" name="pd_seq" class="pd_seq">
                                <%--옵션 있을때--%>
                            <c:if test="${!empty i.option}">
                                <c:forEach var="k" items="${i.option}">
                                    <c:forEach var="j" items="${k}">
                                        <p>${j.key} : ${j.value}</p>
                                    </c:forEach>
                                </c:forEach>
                            </c:if>
                        </td>
                        <c:if test="${i.pay_seq != paySeq}">
                            <c:set var="paySeq" value="${i.pay_seq}"/>
                            <td style="text-align: center;" rowspan="${i.payPdCnt}">
                                <p>받는 사람 : ${i.deliDTO.name}</p>
                                <p>전화번호 : ${i.deliDTO.phone}</p>
                                <p>주소 : ${i.deliDTO.address}</p>
                            </td>
                            <td style="text-align: center" rowspan="${i.payPdCnt}">
                                <p>결제 일자 : ${i.payDate}</p>
                                <p>결제 방법 : ${i.payMethod}</p>
                                <p>결제 금액 : <fmt:formatNumber pattern="#,###" value="${i.price}"/>원</p>
                                <p>사용 포인트 : <fmt:formatNumber pattern="#,###" value="${i.usedPoint}"/>점</p>
                            </td>
                            <c:set var="loop_flag" value="true"/>
                        </c:if>
                        <c:choose>
                            <c:when test="${i.deliYN == 'N'}"> <%--배송 안했을때--%>
                                <td style="text-align: center;">배송전</td>
                            </c:when>
                            <c:when test="${i.deliYN == 'M'}"> <%--배송중일때--%>
                                <td style="text-align: center;">배송중</td>
                            </c:when>
                            <c:otherwise> <%--배송 완료--%>
                                <td style="text-align: center;">
                                    배송 완료
                                    <c:choose>
                                        <%-- 리뷰 있을때 --%>
                                        <c:when test="${i.reviewDTO.status == 'Y'}">
                                            <button type="button" class="updReviewBtn btn btn-light"
                                                    style="font-size: 13px;">
                                                <input type="hidden" value="${i.reviewDTO.review_seq}">리뷰 수정하기
                                            </button>
                                            <c:choose>
                                                <%-- 환불/교환 신청했을때 --%>
                                                <c:when test="${!empty i.refundDTO}">
                                                    <c:if test="${i.refundDTO.type == 'exchange'}">
                                                        <c:choose>
                                                            <c:when test="${i.refundDTO.status == 'M' and i.isRefundApprove == 0}">
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button"
                                                                        class="btn btn-light cancleExchange">교환 취소
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${i.refundDTO.status == 'Y' and i.isRefundApprove == 1}">
                                                                <button type="button" class="btn btn-light refund"
                                                                        disabled>교환 완료
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                    <c:if test="${i.refundDTO.type == 'refund'}">
                                                        <c:choose>
                                                            <c:when test="${i.refundDTO.status == 'M' and i.isRefundApprove == 0}">
                                                                <button type="button"
                                                                        class="btn btn-light cancleRefund">환불 취소
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${i.refundDTO.status == 'Y' and i.isRefundApprove == 1}">
                                                                <button type="button" class="btn btn-light refund"
                                                                        disabled>환불 완료
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </c:when>
                                                <%-- 환불/교환 신청 안했을때 --%>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-light refund">환불</button>
                                                    <button type="button" class="btn btn-light exchange">교환</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="reviewBtn btn btn-light"
                                                    style="font-size: 13px;">리뷰 작성하기
                                            </button>
                                            <c:choose>
                                                <%-- 환불/교환 신청했을때 --%>
                                                <c:when test="${!empty i.refundDTO}">
                                                    <c:if test="${i.refundDTO.type == 'exchange'}">
                                                        <c:choose>
                                                            <c:when test="${i.refundDTO.status == 'M' and i.isRefundApprove == 0}">
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button"
                                                                        class="btn btn-light cancleExchange">교환 취소
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${i.refundDTO.status == 'Y' and i.isRefundApprove == 1}">
                                                                <button type="button" class="btn btn-light refund"
                                                                        disabled>교환 완료
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                    <c:if test="${i.refundDTO.type == 'refund'}">
                                                        <c:choose>
                                                            <c:when test="${i.refundDTO.status == 'M' and i.isRefundApprove == 0}">
                                                                <button type="button"
                                                                        class="btn btn-light cancleRefund">환불 취소
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:when>
                                                            <c:when test="${i.refundDTO.status == 'Y' and i.isRefundApprove == 1}">
                                                                <button type="button" class="btn btn-light refund"
                                                                        disabled>환불 완료
                                                                </button>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <button type="button" class="btn btn-light refund">환불
                                                                </button>
                                                                <button type="button" class="btn btn-light exchange">
                                                                    교환
                                                                </button>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </c:when>
                                                <%-- 환불/교환 신청 안했을때 --%>
                                                <c:otherwise>
                                                    <button type="button" class="btn btn-light refund">환불</button>
                                                    <button type="button" class="btn btn-light exchange">교환</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
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

<div class="pagingDiv" style="text-align: center; ">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>

    //환불 취소
    $(document).on("click", ".cancleRefund", function () {
        let id = $("#id").val();
        let payPdSeq = $(this).closest("tr").find(".payPd_seq").val();
        var _width = '500';
        var _height = '400';

        var _left = Math.ceil((window.screen.width - _width) / 2);
        var _top = Math.ceil((window.screen.height - _height) / 2);

        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/product/cancleRefundPopup");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("value", id);
        input1.setAttribute("name", "id");

        let input2 = document.createElement("input");
        input2.setAttribute("type", "hidden");
        input2.setAttribute("value", payPdSeq);
        input2.setAttribute("name", "payPdSeq");

        newForm.append(input1);
        newForm.append(input2);
        document.body.append(newForm);

        window.open("/product/cancleRefundPopup", "newForm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
        let newForm1 = newForm;
        newForm1.method = "post";
        newForm1.target = "newForm";
        newForm1.submit();
    })

    //교환 취소
    $(document).on("click", ".cancleExchange", function () {
        let id = $("#id").val();
        let payPdSeq = $(this).closest("tr").find(".payPd_seq").val();
        var _width = '500';
        var _height = '400';

        var _left = Math.ceil((window.screen.width - _width) / 2);
        var _top = Math.ceil((window.screen.height - _height) / 2);

        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/product/cancleExchangePopup");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("value", id);
        input1.setAttribute("name", "id");

        let input2 = document.createElement("input");
        input2.setAttribute("type", "hidden");
        input2.setAttribute("value", payPdSeq);
        input2.setAttribute("name", "payPdSeq");

        newForm.append(input1);
        newForm.append(input2);
        document.body.append(newForm);

        window.open("/product/cancleExchangePopup", "newForm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
        let newForm1 = newForm;
        newForm1.method = "post";
        newForm1.target = "newForm";
        newForm1.submit();
    })

    //환불 클릭 시
    $(document).on("click", ".refund", function () {
        let id = $("#id").val();
        let payPdSeq = $(this).closest("tr").find(".payPd_seq").val();
        $.ajax({
            url: '/product/refundYN',
            type: 'post',
            data: {
                "id": id,
                "payPdSeq": payPdSeq
            },
            async: false,
            success: function (data) {
                if (data == 'Y') {
                    alert('교환을 취소하고 진행해주세요.');
                    return;
                } else {
                    var _width = '500';
                    var _height = '400';

                    var _left = Math.ceil((window.screen.width - _width) / 2);
                    var _top = Math.ceil((window.screen.height - _height) / 2);

                    let newForm = document.createElement("form");
                    newForm.setAttribute("method", "post");
                    newForm.setAttribute("action", "/product/refundPopup");

                    let input1 = document.createElement("input");
                    input1.setAttribute("type", "hidden");
                    input1.setAttribute("value", id);
                    input1.setAttribute("name", "id");
                    let input2 = document.createElement("input");
                    input2.setAttribute("type", "hidden");
                    input2.setAttribute("value", payPdSeq);
                    input2.setAttribute("name", "payPdSeq");

                    newForm.append(input1);
                    newForm.append(input2);
                    document.body.append(newForm);

                    window.open("/product/refundPopup", "newForm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
                    let newForm1 = newForm;
                    newForm1.method = "post";
                    newForm1.target = "newForm";
                    newForm1.submit();
                }
            }
        })
    })

    //교환 클릭 시
    $(document).on("click", ".exchange", function () {
        let id = $("#id").val();
        let payPdSeq = $(this).closest("tr").find(".payPd_seq").val();
        $.ajax({
            url: '/product/refundYN',
            type: 'post',
            data: {
                "id": id,
                "payPdSeq": payPdSeq
            },
            async: false,
            success: function (data) {
                if (data == 'Y') {
                    alert('환불을 취소하고 진행해주세요.');
                    return;
                } else {
                    var _width = '500';
                    var _height = '400';

                    var _left = Math.ceil((window.screen.width - _width) / 2);
                    var _top = Math.ceil((window.screen.height - _height) / 2);

                    let newForm = document.createElement("form");
                    newForm.setAttribute("method", "post");
                    newForm.setAttribute("action", "/product/exchangePopup");

                    let input1 = document.createElement("input");
                    input1.setAttribute("type", "hidden");
                    input1.setAttribute("value", id);
                    input1.setAttribute("name", "id");
                    let input2 = document.createElement("input");
                    input2.setAttribute("type", "hidden");
                    input2.setAttribute("value", payPdSeq);
                    input2.setAttribute("name", "payPdSeq");

                    newForm.append(input1);
                    newForm.append(input2);
                    document.body.append(newForm);

                    window.open("/product/exchangePopup", "newForm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
                    let newForm1 = newForm;
                    newForm1.method = "post";
                    newForm1.target = "newForm";
                    newForm1.submit();
                }
            }
        })
    })

    //페이징 다시 그려줌
    function paging(startNavi) {
        $.ajax({
            url: '/product/historyRepaging',
            type: 'post',
            data: {
                "cpage": startNavi,
                "id": $("#id").val()
            },
            success: function (data) {
                $(".pagingDiv").children().remove();
                createPaging(data);
            }
        })
    }

    function createPaging(data) {
        let startNavi = data.paging.startNavi;
        let endNavi = data.paging.endNavi;
        let needPrev = data.paging.needPrev;
        let needNext = data.paging.needNext;
        let paging = data.paging;
        let historyList = data.historyList;
        let cpage = data.cpage;


        $("#tbody").children().remove();
        for (let i = 0; i < historyList.length; i++) {
            var newHtml = createHtml(historyList[i], startNavi);
            $("#tbody").append(newHtml);
        }

        if (needPrev) {
            var html = createPrev(startNavi);
            $(".pagingDiv").append(html);
        }
        for (let k = startNavi; k <= endNavi; k++) {
            if (startNavi == k) {
                var html = createNewPage1(k);
                $(".pagingDiv").append(html);
            } else {
                var html = createNewPage2(k);
                $(".pagingDiv").append(html);
            }
        }
        if (needNext) {
            var html = createNext(endNavi, totalPageCount);
            $(".pagingDiv").append(html);
        }
    }

    let paySeq = 0;

    function createHtml(item, cpage) {
        var newTable = '';
        var temp = '';
        newTable = '<tr><td><a href="/product/detail?pd_seq=' + item.productDTO.pd_seq + '"><img src="/resources/img/products/' + item.productDTO.img + '" style="width:120px; height: 100px;"></a></td>';
        newHtml = newTable;
        if (item.option == null) { //옵션 없을때
            newTable += '<td style="text-align: center"><p>' + item.productDTO.name + '  ' + item.count + '개' + '</p>';
            newTable += '<input type="hidden" value="' + item.payPd_seq + '" name="payPd_seq" class="payPd_seq"><input type="hidden" value="' + item.productDTO.pd_seq + '" name="pd_seq" class="pd_seq"></td>';
        } else { //옵션 있을때
            temp += '<td><p>' + item.productDTO.name + '  ' + item.count + '개' + '</p>';
            for (let i = 0; i < item.option.length; i++) {
                temp += '<p>' + Object.keys(item.option[i])[0] + ' : ' + item.option[i][Object.keys(item.option[i])[0]] + '</p>';
            }
            temp += '<input type="hidden" value="' + item.payPd_seq + '" name="payPd_seq" class="payPd_seq"><input type="hidden" value="' + item.productDTO.pd_seq + '" name="pd_seq" class="pd_seq"></td>';
            newTable = newTable + temp;
        }
        if (item.pay_seq != paySeq) {
            paySeq = item.pay_seq;
            newTable += '<td style="text-align: center" rowspan="' + item.payPdCnt + '"><p>받는 사람 : ' + item.deliDTO.name + '</p><p>전화번호 : ' + item.deliDTO.phone + '</p><p>주소 : ' + item.deliDTO.address + '</p></td>';
            newTable += '<td style="text-align: center" rowspan="' + item.payPdCnt + '"><p>결제 일자 : ' + item.payDate + '</p><p>결제 방법 : ' + item.payMethod + '</p><p>결제 금액 : ' + item.price.toLocaleString() + '원</p></td>';
        }
        if (item.deliYN == 'N') {
            newTable += '<td style="text-align: center;">배송전</td></tr>';
        } else if (item.deliYN == 'M') {
            newTable += '<td style="text-align: center;">배송중</td></tr>';
        }
        //배송완료일때
        else {
            newTable += '<td style="text-align: center;">배송 완료';
            if (item.reviewDTO != null) {
                if (item.reviewDTO.status == 'Y') {
                    newTable += '<button type="button" class="updReviewBtn btn btn-light" style="font-size: 13px;"><input type="hidden" value="' + item.reviewDTO.review_seq + '">리뷰 수정하기</button>';
                    //교환 환불 신청했을때
                    if (item.refundDTO != null) {
                        //교환일때
                        if (item.refundDTO.type == 'exchange') {
                            if (item.refundDTO.status == 'M' && item.isRefundApprove == 0) {
                                newTable += '<button type="button" class="btn btn-light refund">환불</button>';
                                newTable += '<button type="buttonclass="btn btn-light cancleExchange">교환 취소</button></td>';
                            } else if (item.refundDTO.status == 'Y' && item.isRefundApprove == 1) {
                                newTable += '<button type="button" class="btn btn-light refund" disabled>교환 완료</button></td>';
                            } else {
                                newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                            }
                        }
                        //환불일때
                        else if (item.refundDTO.type == 'refund') {
                            if (item.refundDTO.status == 'M' && item.isRefundApprove == 0) {
                                newTable += '<button type="button" class="btn btn-light cancleRefund">환불 취소</button>';
                                newTable += '<button type="buttonclass="btn btn-light exchange">교환</button></td>';
                            } else if (item.refundDTO.status == 'Y' && item.isRefundApprove == 1) {
                                newTable += '<button type="button" class="btn btn-light refund" disabled>환불 완료</button></td>';
                            } else {
                                newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                            }
                        }
                    } //교환 환불 신청안했을때
                    else {
                        newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                    }
                }
            } else {
                newTable += '<button type="button" class="reviewBtn btn btn-light" style="font-size: 13px;">리뷰 작성하기</button>';
                if (item.refundDTO != null) {
                    //교환일때
                    if (item.refundDTO.type == 'exchange') {
                        if (item.refundDTO.status == 'M' && item.isRefundApprove == 0) {
                            newTable += '<button type="button" class="btn btn-light refund">환불</button>';
                            newTable += '<button type="buttonclass="btn btn-light cancleExchange">교환 취소</button></td>';
                        } else if (item.refundDTO.status == 'Y' && item.isRefundApprove == 1) {
                            newTable += '<button type="button" class="btn btn-light refund" disabled>교환 완료</button></td>';
                        } else {
                            newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                        }
                    }
                    //환불일때
                    else if (item.refundDTO.type == 'refund') {
                        if (item.refundDTO.status == 'M' && item.isRefundApprove == 0) {
                            newTable += '<button type="button" class="btn btn-light cancleRefund">환불 취소</button>';
                            newTable += '<button type="buttonclass="btn btn-light exchange">교환</button></td>';
                        } else if (item.refundDTO.status == 'Y' && item.isRefundApprove == 1) {
                            newTable += '<button type="button" class="btn btn-light refund" disabled>환불 완료</button></td>';
                        } else {
                            newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                        }
                    }
                } //교환 환불 신청안했을때
                else {
                    newTable += '<button type="button" class="btn btn-light refund">환불</button><button type="button" class="btn btn-light exchange">교환</button></td>';
                }
            }
        }
        return newTable;
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

    $("#keyword").val($("#key").val());

    $("#search").on("click", function () {
        let keyword = $("#keyword").val();
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

    //리뷰 작성하기 클릭 시
    $(document).on("click", ".reviewBtn", function () {
        let pd_seq = $(this).parent().parent().find(".pd_seq").val();
        let payPd_seq = $(this).parent().parent().find(".payPd_seq").val();

        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/pdReview/toWriteForm");

        let input = document.createElement("input");
        input.setAttribute("type", "hidden");
        input.setAttribute("name", "pd_seq");
        input.setAttribute("value", pd_seq);

        let input2 = document.createElement("input");
        input2.setAttribute("type", "hidden");
        input2.setAttribute("name", "payPd_seq");
        input2.setAttribute("value", payPd_seq);

        newForm.appendChild(input);
        newForm.appendChild(input2);
        document.body.append(newForm);
        newForm.submit();
    });

    //리뷰 수정하기 클릭 시
    $(document).on("click", ".updReviewBtn ", function () {
        // let pd_seq = $(this).parent().parent().find(".pd_seq").val();
        // let payPd_seq = $(this).parent().parent().find(".payPd_seq").val();
        let review_seq = $(this).children().val();

        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/pdReview/updReview");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("name", "review_seq");
        input1.setAttribute("value", review_seq);

        newForm.appendChild(input1);
        document.body.append(newForm);
        newForm.submit();
    });

    // $(document).on("click",".exchange",function(){
    //     alert('환불 취소 후 교환 신청이 가능합니다.');
    //     return;
    // })
</script>
</body>
</html>
