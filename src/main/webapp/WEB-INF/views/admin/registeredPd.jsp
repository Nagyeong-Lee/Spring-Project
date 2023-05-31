<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-25
  Time: 오후 4:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>등록 상품 조회</title>
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

        #footer {
            flex-shrink: 0;
        }
    </style>
</head>
<body>
<%@include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<%--<button type="button" id="toList">관리자 메인페이지로</button>--%>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>이미지</th>
        <th>상품명</th>
        <th>옵션</th>
        <th>가격</th>
        <th>수량</th>
        <th></th>
        </thead>
        <tbody class="itemDiv">
        <c:choose>
            <c:when test="${!empty registeredPd}">
                <c:forEach var="i" items="${registeredPd}">
                    <tr>
                        <td><img src="/resources/img/products/${i.productDTO.img}" style="width: 120px; height: 100px;">
                        </td>
                        <td style="width: 500px; text-align: center">${i.productDTO.name}</td>
                        <c:choose>
                            <c:when test="${!empty i.optionDTOList}">
                                <td style="text-align: center">
                                    <c:forEach var="k" items="${i.optionDTOList}">
                                        <p>${k.category}:${k.name}-${k.stock}개</p>
                                    </c:forEach>
                                </td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                        <td style="text-align: center;"><fmt:formatNumber pattern="#,###"
                                                                          value="${i.productDTO.price}"/>원
                        </td>
                        <td style="text-align: center;">${i.productDTO.stock}개</td>
                        <td style="text-align: center">
                            <button type="button" class="delBtn btn btn-light" value="${i.productDTO.pd_seq}">삭제
                            </button>
                            <button type="button" class="updBtn btn btn-light" value="${i.productDTO.pd_seq}">수정
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
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

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>

    //페이징 다시 그려줌
    function paging(startNavi) {
        $.ajax({
            url: '/product/rePaging',
            type: 'post',
            data: {
                "cpage": startNavi,
                "id": $("#id").val()
            },
            success: function (data) {
                $(".itemDiv").children().remove();
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
        let paging = data.paging.paging;
        let registeredPd = data.registeredPd;
        let cpage = data.cpage;
        // debugger;

        for (let i = 0; i < registeredPd.length; i++) {
            var newHtml = createHtml(registeredPd[i], startNavi);
            $(".itemDiv").append(newHtml);
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
        var Html = '';
        Html = '<tr><td><a href="/product/detail?pd_seq=' + item.productDTO.pd_seq + '"><img src="/resources/img/products/' + item.productDTO.img + '" style="width: 120px; height: 100px;"></a></td>';
        Html += '<td style="width: 500px; text-align: center">' + item.productDTO.name + '</td>';
        if (item.optionDTOList == null) { //옵션 없을때
            Html += '<td></td>';
        } else { //옵션 있을때
            Html += '<td style="text-align: center">';
            for (let i = 0; i < item.optionDTOList.length; i++) {
                Html += '<p>' + item.optionDTOList[i].category + ' : ' + item.optionDTOList[i].name + '-' + item.optionDTOList[i].stock + '개</p>';
            }
            Html += '</td>';
        }
        Html += '<td style="text-align: center;">' + item.productDTO.price.toLocaleString() + '원</td>';
        Html += '<td style="text-align: center;">' + item.productDTO.stock + '개</td>';
        Html += '<td style="text-align: center"><button type="button" class="delBtn btn btn-light" value="' + item.productDTO.pd_seq + '">삭제</button>';
        Html += '<button type="button" class="updBtn btn btn-light" value="' + item.productDTO.pd_seq + '">수정</button></td></tr>';
        return Html;
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

    //관리자 메인으로
    $("#toList").click(function () {
        location.href = '/admin/main';
    });

    // 상품 삭제 클릭 시
    $(document).on("click", ".delBtn", function () {
        $this = $(this);
        let pd_seq = $(this).val();
        if (confirm('상품을 삭제하시겠습니까?')) {
            $.ajax({
                url: '/product/deletePd',
                type: 'post',
                data: {
                    "pd_seq": pd_seq
                },
                success: function (data) {
                        $this.closest("tr").remove();
                }
            })
        }
    });

    //상품 수정 클릭 시

    $(document).on("click", ".updBtn", function () {
        let pd_seq = $(this).val();
        location.href = '/admin/updProduct?pd_seq=' + pd_seq;
    })

</script>
</body>
</html>
