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
    <title>반품 조회</title>
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
<%--    <select name="category">--%>
<%--        <option value="exchange" selected>반품/교환</option>--%>
<%--        <option value="refund">환불</option>--%>
<%--    </select>--%>
    <table id="table" class="table table-striped">
        <th>이미지</th>
        <th>상품 정보</th>
        <th>사유</th>
        <th>반환 금액/포인트</th>
        <th>신청 일자</th>
        <th>배송 정보</th>
        <th></th>
        <c:choose>
            <c:when test="${!empty refundInfoList}">
                <tr>
                    <c:forEach var="i" items="${refundInfoList}">
                        <input type="hidden" value="${i.payPd_seq}" id="payPd_seq" name="payPd_seq">
                        <input type="hidden" value="${i.refund_seq}" id="refund_seq" name="refund_seq">
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
                            </c:if>
                                ${i.count}개-<fmt:formatNumber value="${i.price}" pattern="#,###"/>원
                        <td>
                                ${i.content}
                        </td>
                        <%--반환 금액 및 포인트--%>
                        <td>

                        </td>
                        <td>${i.applyDate}</td>
                        <td>
                            <p>받는 사람 : ${i.deliDTO.name}</p>
                            <p>전화번호 : ${i.deliDTO.phone}</p>
                            <p>주소 : ${i.deliDTO.address}</p>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${i.shopRefundDTO.status == 'Y'}">
                                    <button type="button" id="cplApproveBtn" class="btn btn-light" disabled>승인 완료</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="button" id="approveBtn" class="btn btn-light">승인</button>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </c:forEach>
                </tr>
            </c:when>
        </c:choose>
    </table>
</form>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>
    $(document).on("click", "#approveBtn", function () {
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

        window.open("/admin/approveRefund", "newFrm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
        var myForm = newFrm;
        myForm.method = "post";
        myForm.target = "newFrm";
        myForm.submit();

        //페이징 다시 그려줌
        function paging(startNavi) {
            $.ajax({
                url: '/admin/repagingRefundList',
                type: 'post',
                data: {
                    "cpage": startNavi
                },
                success: function (data) {
                    $(".pagingDiv").children().remove();
                    createPaging(data);
                }
            })
        }

        function createPaging(data) {
            console.log(data);
            let startNavi = data.startNavi;
            let endNavi = data.endNavi;
            let needPrev = data.needPrev;
            let needNext = data.needNext;
            let productDTOList = data.productDTOList;
            $("#row").children().remove();
            for (let i = 0; i < productDTOList.length; i++) {
                console.log(productDTOList[i]);
                console.log(startNavi);
                var newHtml = createHtml(productDTOList[i], startNavi);
                $("#row").append(newHtml);
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

        function createHtml(item, cpage) {
            // let pdName = item.name;
            // let pd_seq = item.pd_seq;
            // var HTML = '<div class="col mb-5"><div class="card h-100">';
            // HTML += '<img class="card-img-top img" src="/resources/img/products/' + item.img + '" style="width: 225px;">';
            // HTML += '<div class="card-body p-4"><div class="text-center"><h5 class="fw-bolder">';
            // HTML += '<a href="/product/detail?pd_seq=' + pd_seq + '">' + pdName + '</a></h5>';
            // HTML += item.price.toLocaleString() + '원';
            // HTML += '</div></div></div></div>';
            // console.log(HTML);
            // return HTML;
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
    })
</script>
</body>
</html>