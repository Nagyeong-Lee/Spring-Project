<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-13
  Time: 오전 9:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>뉴스</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<c:forEach var="i" items="${list}" varStatus="status">
    <button type="button" id="${status.count}">${i.code}</button>
</c:forEach>


<div class="header">
    <h2>전체 뉴스</h2>
</div>
<%--게시판--%>
<table style="border: 1px solid black">
    <thead>
    <th>키워드</th>
    <th>제목</th>
    <th>설명</th>
    <th>링크</th>
    </thead>
    <tbody id="tbody">
    <c:forEach var="i" items="${newsList}">
        <tr>
            <td class="key">${i.keyword}</td>
            <td>${i.title}</td>
            <td>${i.description}</td>
            <td><a href="${i.link}">${i.link}</a></td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<div class="pagingDiv">
    <c:choose>
        <c:when test="${needPrev eq true}">
                <a href="javascript:void(0); onclick=newsPaging(${startNavi-1},${count}});"><</a>
                <a href="javascript:void(0); onclick=newsPaging(1,${count});">맨 처음</a>
        </c:when>
    </c:choose>
    <%--<c:choose>
        <c:when test="${needNext eq true}">--%>
    <c:forEach var="i" begin="${startNavi}" end="${endNavi}" varStatus="var">
        <c:if test="${currentPage eq i}">
                <a href="javascript:void(0); onclick=newsPaging(${i},${count});" style="font-weight: bold;">${i}</a>
        </c:if>
        <c:if test="${currentPage ne i}">
                <a href="javascript:void(0); onclick=newsPaging(${i},${count});">${i}</a>
        </c:if>
    </c:forEach>
    <%--</c:when>
</c:choose>--%>
    <c:choose>
        <c:when test="${needNext eq true}">
                <a href="javascript:void(0); onclick=newsPaging(${endNavi+1},${count});">></a>
                <a href="javascript:void(0); onclick=newsPaging(${pageTotalCount},${count});">맨끝</a>
        </c:when>
    </c:choose>
</div>

<script>


    function newsPaging(startNavi) {
        $.ajax({
            url: '/api/repaging',
            data: {
                "currentPage": startNavi,
                "count": 10,
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $("#tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                let page = data.paging;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtmlNews(items[i],cpage, cnt, data.keyword);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (data.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    }

    //페이징 새로
    function createPagingNews1(page) {
        var pagingHtml = '';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + (page.startNavi - 1) + ',' + $('#count').val() + ',\'\',\'\');">' + "<" + '</a>';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + (1) + ',' + $('#count').val() + ',\'\',\'\');">' + "맨 처음" + '</a>';
        return pagingHtml;
    }

    function createPagingNews2(page, pageTotalCount) {
        var pagingHtml = '';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + (page.endNavi + 1) + ',' + $('#count').val() + ',\'\',\'\');">' + ">" + '</a>';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + (pageTotalCount) + ',' + $('#count').val() + ',\'\',\'\');">' + "맨끝" + '</a>';
        return pagingHtml;
    }

    function createPagingNews3(k, page) {
        var pagingHtml = '';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + k + ',' + $('#count').val() + ',\'\',\'\')" style="font-weight: bold"> ' + k + ' </a>';
        return pagingHtml;
    }

    function createPagingNews4(k, page) {
        var pagingHtml = '';
            pagingHtml += '<a href="javascript:void(0);" onclick="newsPaging(' + k + ',' + $('#count').val() + ',\'\',\'\')"> ' + k + ' </a>';

        return pagingHtml;
    }

    function createHtmlNews(item) {
        var html = '<tr><td>' + item.keyword+ '</td>';
        html += '<td>' + item.title+ '</td>';
        html += '<td>' + item.description + '</td></tr>';
        html += '<td><a href='+item[i].link+'>'+ item[i].link + '</td>';
        return html;
    }


    var title='';
    //코로나 클릭
    $("#1").on("click", function () {
        title='<h2>코로나 관련 뉴스</h2>';
        $(".header").children().remove();
        $(".header").append(title);
        $("#tbody").children().remove();
        $.ajax({
            url: "/api/covid",
            data:
                {
                 "keyword": "코로나",
                 "currentPage":1,
                 "count":10
                },
            success: function (data) {
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var html = createHtmlNews(items[i]);
                        $(".tbody").append(html);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $("#2").on("click", function () {
        title='<h2>자가격리 관련 뉴스</h2>';
        $(".header").children().remove();
        $(".header").append(title);
        $("#tbody").children().remove();
        $.ajax({
            url: "/api/quarantine",
            data:
                {"keyword": "자가격리",
                    "currentPage":1,
                    "count":10},
            success: function (data) {
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var html = createHtmlNews(items[i]);
                        $(".tbody").append(html);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $("#3").on("click", function () {
        title='<h2>거리두기 관련 뉴스</h2>';
        $(".header").children().remove();
        $(".header").append(title);
        $("#tbody").children().remove();
        $.ajax({
            url: "/api/distancing",
            data:
                {"keyword": "거리두기",
                    "currentPage":1,
                    "count":10},
            success: function (data) {
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                }else {
                    for (let i = 0; i < items.length; i++) {
                        var html = createHtmlNews(items[i]);
                        $(".tbody").append(html);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $("#4").on("click", function () {
        title='<h2>마스크 관련 뉴스</h2>';
        $(".header").children().remove();
        $(".header").append(title);
        $("#tbody").children().remove();
        $.ajax({
            url: "/api/mask",
            data:
                {"keyword": "마스크",
                    "currentPage":1,
                    "count":10},
            success: function (data) {
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var html = createHtmlNews(items[i]);
                        $(".tbody").append(html);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $("#5").on("click", function () {
        title='<h2>백신 관련 뉴스</h2>';
        $(".header").children().remove();
        $(".header").append(title);
        $("#tbody").children().remove();
        $.ajax({
            url: "/api/vaccine",
            data:
                {"keyword": "백신",
                    "currentPage":1,
                    "count":10},
            success: function (data) {
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var html = createHtmlNews(items[i]);
                        $(".tbody").append(html);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPagingNews1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPagingNews3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPagingNews4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPagingNews2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    //전체보기
    $("#6").on("click",function(){
       location.reload();
    });
</script>
</body>

</html>
