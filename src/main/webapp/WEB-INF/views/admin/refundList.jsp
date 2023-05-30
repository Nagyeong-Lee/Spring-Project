<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-24
  Time: 오후 1:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>환불 조회</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.css" rel="stylesheet">
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
    <style>
        img {
            width: 300px;
            height: 300px;
        }

        table {
            table-layout: fixed;
        }

        a {
            text-decoration: none;
        }


        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .filter {
            flex: 1 0 auto;
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

        .pagingDiv {
            position: fixed;
            left: 0;
            bottom: 100px;
            width: 100%;
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>
<body>
<%@include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<form action="/admin/approveRefund">
    <select name="category" id="type">
        <option value="all" selected>전체</option>
        <option value="refund">환불</option>
        <option value="exchange">교환</option>
    </select>
    <table id="table" class="table table-striped">
        <thead>
        <th>ID</th>
        <th>이미지</th>
        <th>상품 정보</th>
        <th>사유</th>
        <th>반환 금액/포인트</th>
        <th>신청 일자</th>
        <th>배송 정보</th>
        <th></th>
        </thead>
        <c:choose>
            <c:when test="${!empty refundInfoList}">
                <c:forEach var="i" items="${refundInfoList}">
                    <tr class="data">
                        <input type="hidden" value="${i.payPd_seq}" id="payPd_seq" name="payPd_seq">
                        <input type="hidden" value="${i.refund_seq}" id="refund_seq" name="refund_seq">
                        <input type="hidden" value="${i.refundDTO.type}" class="refundType" name="refundType">
                        <td>${i.id}</td>
                        <td>
                            <img src="/resources/img/products/${i.productDTO.img}" style="width: 100px; height: 100px;">
                        </td>
                        <td>
                                ${i.productDTO.name}
                            <c:if test="${i.optionMapList != null}">
                            <c:forEach var="k" items="${i.optionMapList}">
                            <c:forEach var="j" items="#{k}">
                            <p>${j.key} : ${j.value}</p>
                            </c:forEach>
                            </c:forEach>
                            </c:if><br>
                                ${i.count}개-<fmt:formatNumber value="${i.price}" pattern="#,###"/>원
                        <td>
                                ${i.content}
                        </td>
                            <%--반환 금액 및 포인트--%>
                        <td>
                            <c:if test="${!empty i.refundPoint}">
                                <p>반환 포인트 : <fmt:formatNumber pattern="#,###" value="${i.refundPoint}"/>점</p>
                                <p>반환 금액 : <fmt:formatNumber pattern="#,###" value="${i.refundMoney}"/>원</p>
                            </c:if>
                        </td>
                        <td>${i.applyDate}</td>
                        <td>
                            <c:if test="${!empty i.deliDTO}">
                                <p>받는 사람 : ${i.deliDTO.name}</p>
                                <p>전화번호 : ${i.deliDTO.phone}</p>
                                <p>주소 : ${i.deliDTO.address}</p>
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${i.shopRefundDTO.status == 'Y'}">
                                    <button type="button" class="btn btn-light cplApproveBtn"  disabled>승인 완료
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button"  class="btn btn-ligh approveBtn">승인</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
        </c:choose>
    </table>
</form>
<div class="pagingDiv" style="text-align: center;">
    <c:if test="${paging.needPrev eq true}">
        <a href="javascript:void(0); onclick=paging (${paging.startNavi-1}});"><</a>
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
<script>
    //페이징 다시 그려줌
    function paging(startNavi) {
        let type = $("select[id='type'] option:selected").val();
        $.ajax({
            url: '/admin/repagingRefundList',
            type: 'post',
            data: {
                "type": type,
                "cpage": startNavi
            },
            success: function (data) {
                console.log(data);
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
        let refundInfoList = data.refundInfoList;
        $("tbody").children().remove();
        for (let i = 0; i < refundInfoList.length; i++) {
            var newHtml = createHtml(refundInfoList[i], startNavi);
            $("tbody").append(newHtml);
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


    //셀렉트 박스 바뀔때
    $(document).on("change", "#type", function () {
        let type = $("select[id='type'] option:selected").val();
        $.ajax({
            url: '/admin/repagingRefundList',
            type: 'post',
            data: {
                "type": type,
                "cpage": 1
            },
            success: function (data) {
                console.log(data);
                $(".pagingDiv").children().remove();
                createPaging(data);
            }
        })
    })

    function createHtml(item, cpage) {
        var HTML = ' <tr><input type="hidden" value="' + item.payPd_seq + '" id="payPd_seq" name="payPd_seq"><input type="hidden" value="' + item.refund_seq + '" id="refund_seq" name="refund_seq">';
        HTML += '<td>' + item.id;
        +'</td>'
        HTML += '<td><img class="card-img-top img" src="/resources/img/products/' + item.productDTO.img + '" style="width: 100px; height: 100px;"></td>';
        HTML += '<td>' + item.productDTO.name;
        // 옵션 출력
        if (Object.keys(item).includes('optionMapList')) {  //key가 optionMapList 있으면 출력
            for (let k = 0; k < item.optionMapList.length; k++) {
                console.log(Object.keys(item.optionMapList[k]) + ":" + Object.values(item.optionMapList[k]));
                HTML += '<p>' + Object.keys(item.optionMapList[k]) + ":" + Object.values(item.optionMapList[k]) + '</p>';
            }
        }
        HTML += '<br>' + item.count + '개' + '-' + item.price.toLocaleString() + '원</td>';
        HTML += '<td>' + item.content + '</td>';
        if (item.refundPoint != null) {
            HTML += '<td><p>반환 포인트 : ' + item.refundPoint.toLocaleString() + '점</p>';
            HTML += '<p>반환 금액 : ' + item.refundMoney.toLocaleString() + '원</p></td>';
        } else {
            HTML += '<td></td>';
        }
        HTML += '<td>' + item.applyDate + '</td>';
        if (item.deliDTO != null) {
            HTML += '<td><p>받는 사람 : ' + item.deliDTO.name + '</p>';
            HTML += '<p>전화번호 : ' + item.deliDTO.phone + '</p>';
            HTML += '<p>주소 : ' + item.deliDTO.address + '</p></td>';
        } else {
            HTML += '<td></td>';
        }
        if (item.refundDTO.status == 'Y') {
            HTML += '<td><button type="button" id="cplApproveBtn" class="btn btn-light" disabled>승인 완료</button></td></tr>';
        } else {
            HTML += '<td><button type="button" id="approveBtn" class="btn btn-light">승인</button></td></tr>';
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

    //승인 클릭 시
    $(document).on("click", ".approveBtn", function () {
        let type = $(this).closest(".data").find(".refundType").val();
        console.log(type)
        //교환일때
        if (type == 'exchange') {
            let payPd_seq = $(this).closest("tr").find("#payPd_seq").val();
            let refund_seq = $(this).closest("tr").find("#refund_seq").val();

            var _width = '500';
            var _height = '400';
            var _left = Math.ceil((window.screen.width - _width) / 2);
            var _top = Math.ceil((window.screen.height - _height) / 2);

            let newFrm = document.createElement("form");
            newFrm.setAttribute("method", "post");
            newFrm.setAttribute("action", "/admin/approveRefund");

            let input1 = document.createElement("input");
            input1.setAttribute("type", "hidden");
            input1.setAttribute("value", payPd_seq);
            input1.setAttribute("name", "payPd_seq");

            let input2 = document.createElement("input");
            input2.setAttribute("type", "hidden");
            input2.setAttribute("value", refund_seq);
            input2.setAttribute("name", "refund_seq");

            newFrm.append(input1);
            newFrm.append(input2);
            document.body.append(newFrm);

            window.open("/admin/approveExchg", "newFrm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
            var myForm = newFrm;
            myForm.method = "post";
            myForm.target = "newFrm";
            myForm.submit();
        }
        //환불일때
        else if (type == 'refund') {
            let payPd_seq = $(this).closest("tr").find("#payPd_seq").val();
            let refund_seq = $(this).closest("tr").find("#refund_seq").val();
            $.ajax({
                url: '/admin/approveRfd',
                type: 'post',
                data: {
                    "payPd_seq": payPd_seq,
                    "refund_seq": refund_seq
                },
                success: function (data) {
                    console.log(data);
                    location.reload();
                    // $(".pagingDiv").children().remove();
                    // createPaging(data);
                }
            })
        }
    })
</script>
</body>
</html>