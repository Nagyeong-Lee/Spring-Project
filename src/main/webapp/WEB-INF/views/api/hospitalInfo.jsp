<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-04
  Time: 오후 5:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <title>병원 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>

<select name="city" id="city">
    <option value="ALL" <c:out value="${cityOption eq 'ALL'  ? 'selected' :''}"/>>전체지역</option>
    <c:forEach var="i" items="${city}">
        <option value="${i}" <c:out value="${city ne 'ALL' and cityOption eq i ? 'selected' :''}"/> >${i}</option>
    </c:forEach>
</select>
<br>
평일 진료 시작 시간 :
<c:forEach var="i" items="${weekOpen}">
    ${i}<input type="radio" value="${i}" name="weekOpen" class="weekOpen" <c:out
        value="${i eq weekOpenOption? 'checked' : ''}"/>>
</c:forEach>
<br>
평일 진료 마감 시간 :
<c:forEach var="i" items="${weekClose}">
    ${i}<input type="radio" value="${i}" name="weekClose" class="weekClose" <c:out
        value="${i eq weekCloseOption? 'checked' : ''}"/>>
</c:forEach>
<br>
토요일 진료 시작 시간 :
<c:forEach var="i" items="${satOpen}">
    ${i}<input type="radio" value="${i}" name="satOpen" class="satOpen" <c:out
        value="${i eq satOpenOption? 'checked' : ''}"/>>
</c:forEach>
<br>
토요일 진료 마감 시간 :
<c:forEach var="i" items="${satClose}">
    ${i}<input type="radio" value="${i}" name="satClose" class="satClose"  <c:out
        value="${i eq satCloseOption? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 여부 :
<input type="checkbox" value="진료" name="holidayY" class="holidayY"
<c:out
        value="${holidayY eq '진료'? 'checked' : ''}"/>>진료

<input type="checkbox" value="미진료" name="holidayN" class="holidayN"
<c:out
        value="${holidayN eq '미진료'? 'checked' : ''}"/>>미진료

<br>
일요일/공휴일 진료 시작 시간 :
<c:forEach var="i" items="${holidayOpen}">
    <c:if test="${i ne '-'}">
        ${i}<input type="radio" value="${i}" name="holidayOpen" class="holidayOpen" <c:out
            value="${i eq holidayOpenOption? 'checked' : ''}"/>>
    </c:if>
</c:forEach>
<br>
일요일/공휴일 진료 마감 시간 :
<c:forEach var="i" items="${holidayClose}">
    <c:if test="${i ne '-'}">
        ${i}<input type="radio" value="${i}" name="holidayClose" class="holidayClose" <c:out
            value="${i eq holidayCloseOption? 'checked' : ''}"/>>
    </c:if>
</c:forEach>
<br>
<hr>
<input type="hidden" name="currentPage" value="${currentPage}" id="boardCurrentPage">
<input type="hidden" name="count" value="${count}" id="boardCount">
<input type="hidden" name="searchType" value="${searchType}" id="boardSearchType">
<input type="hidden" name="keyword" value="${keyword}" id="boardKeyword">
<input type="hidden" name="city" value="${cityOption}" id="boardCity">
<input type="hidden" name="weekOpen" value="${weekOpenOption}" id="boardWeekOpen">
<input type="hidden" name="weekClose" value="${weekCloseOption}" id="boardWeekClose">
<input type="hidden" name="satOpen" value="${satOpenOption}" id="boardSatOpen">
<input type="hidden" name="satClose" value="${satCloseOption}" id="boardSatClose">
<input type="hidden" name="holidayOpen" value="${holidayOpenOption}" id="boardHolidayOpen">
<input type="hidden" name="holidayClose" value="${holidayCloseOption}" id="boardHolidayClose">
<input type="hidden" name="holidayYN" value="${holidayYNOption}" id="boardHolidayClose">
<input type="hidden" name="holidayY" value="${holidayY}" id="boardHolidayY">
<input type="hidden" name="holidayN" value="${holidayN}" id="boardHolidayN">


<form method="post" action="/api/hospital" id="pagingFrm">
    <input type="hidden" name="currentPage" id="cpage">
    <input type="hidden" name="count" id="cnt">
    <input type="hidden" name="searchType" id="type">
    <input type="hidden" name="keyword" id="key">
</form>

<table style="border: 1px solid black">
    <thead>
    <th>지역명</th>
    <th>병원명</th>
    <th>평일</th>
    <th>토요일</th>
    <th>일요일/공휴일</th>
    <th>전화번호</th>
    </thead>
    <tbody class="tbody">
    <c:choose>
        <c:when test="${not empty test}">
            <c:forEach var="i" items="${test}">
                <tr>
                    <td>${i.city}</td>
                    <td>
                        <a href="javascript:void(0);"
                           onclick="detail(${i.hospital_seq},${currentPage},${count},'${searchType}','${keyword}','${cityOption}','${weekOpenOption}','${weekCloseOption}','${satOpenOption}','${satCloseOption}','${holidayY}','${holidayN}','${holidayOpenOption}','${holidayCloseOption}');">${i.hospital_name}</a>
                    </td>
                    <td>${i.weekOpen}~${i.weekClose}&nbsp&nbsp</td>
                    <td>${i.satOpen}~${i.satClose}</td>
                    <td style="text-align: center">${i.holidayOpen}</td>
                    <td>${i.phone}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="6" style="text-align: center;">병원이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<div class="pagingDiv">
    <c:choose>
        <c:when test="${needPrev eq true}">
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(${startNavi-1},${count});"><</a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(${startNavi-1},${count},'${searchType}','${keyword}');"><</a>
            </c:if>
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(1,${count});">맨 처음</a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(1,${count},'${searchType}','${keyword}');">맨 처음</a>
            </c:if>
        </c:when>
    </c:choose>
    <%--<c:choose>
        <c:when test="${needNext eq true}">--%>
    <c:forEach var="i" begin="${startNavi}" end="${endNavi}" varStatus="var">
        <c:if test="${currentPage eq i}">
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(${i},${count});" style="font-weight: bold;">${i}</a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(${i},${count},'${searchType}','${keyword}');"
                   style="font-weight: bold;">${i}</a>
            </c:if>
        </c:if>
        <c:if test="${currentPage ne i}">
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(${i},${count});">${i}</a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(${i},${count},'${searchType}','${keyword}');">${i}</a>
            </c:if>
        </c:if>
    </c:forEach>
    <%--</c:when>
</c:choose>--%>
    <c:choose>
        <c:when test="${needNext eq true}">
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(${endNavi+1},${count});"></a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(${endNavi+1},${count},'${searchType}','${keyword}');">></a>
            </c:if>
            <c:if test="${searchType eq null and keyword eq null}">
                <a href="javascript:void(0); onclick=paging(${pageTotalCount},${count});">맨끝</a>
            </c:if>
            <c:if test="${searchType ne null and keyword ne null}">
                <a href="javascript:void(0); onclick=paging(${pageTotalCount},${count},'${searchType}','${keyword}');">맨끝</a>
            </c:if>
        </c:when>
    </c:choose>
</div>
<%--${paging}<br>--%>
<select name="searchType" id="searchType">
    <option value="hospital_name"<c:out value="${searchType eq 'hospital_name' ? 'selected' : ''}"/>>병원명</option>
    <option value="phone"<c:out value="${searchType eq 'phone' ? 'selected' : ''}"/>>전화번호</option>
    <option value="postcode"<c:out value="${searchType eq 'postcode' ? 'selected' : ''}"/>>우편번호</option>
    <option value="roadAddress"<c:out value="${searchType eq 'roadAddress' ? 'selected' : ''}"/>>도로명 주소</option>
</select>
<input type="text" name="keyword" id="keyword" value="${keyword}">
<button type="button" id="searchBtn">검색</button>
<select name="count" id="count">
    <option value="10"<c:out value="${count eq '10' ? 'selected' : ''}"/>>10개씩 보기</option>
    <option value="30"<c:out value="${count eq '30' ? 'selected' : ''}"/>>30개씩 보기</option>
    <option value="50"<c:out value="${count eq '50' ? 'selected' : ''}"/>>50개씩 보기</option>
</select>
<button type="button" id="reset">리셋</button>
<a href="/member/myPage"><button type="button">마이페이지로</button></a>

<form id="frm" name="frm" method="post" action="/api/detail">
    <input type="hidden" name="hospital_seq" id="hospital_seq1"/>
    <input type="hidden" name="currentPage" id="currentPage1"/>
    <input type="hidden" name="count" id="count1"/>
    <input type="hidden" name="searchType" id="searchType1"/>
    <input type="hidden" name="keyword" id="keyword1"/>
    <input type="hidden" name="city" id="city1"/>
    <input type="hidden" name="weekOpen" id="weekOpen1"/>
    <input type="hidden" name="weekClose" id="weekClose1"/>
    <input type="hidden" name="satOpen" id="satOpen1"/>
    <input type="hidden" name="satClose" id="satClose1"/>
    <%--    <input type="hidden" name="holidayYN" id="holidayYN1"/>--%>
    <input type="hidden" name="holidayY" id="holidayY1"/>
    <input type="hidden" name="holidayN" id="holidayN1"/>
    <input type="hidden" name="holidayOpen" id="holidayOpen1"/>
    <input type="hidden" name="holidayClose" id="holidayClose1"/>

</form>
<form id="frm2" name="frm2" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage2"/>
    <input type="hidden" name="count" id="count2"/>
    <input type="hidden" name="searchType" id="searchType2"/>
    <input type="hidden" name="keyword" id="keyword2"/>
    <input type="hidden" name="city" id="city2"/>
    <input type="hidden" name="weekOpen" id="weekOpen2"/>
    <input type="hidden" name="weekClose" id="weekClose2"/>
    <input type="hidden" name="satOpen" id="satOpen2"/>
    <input type="hidden" name="satClose" id="satClose2"/>
    <%--    <input type="hidden" name="holidayYN" id="holidayYN2"/>--%>
    <input type="hidden" name="holidayY" id="holidayY2"/>
    <input type="hidden" name="holidayN" id="holidayN2"/>
    <input type="hidden" name="holidayOpen" id="holidayOpen2"/>
    <input type="hidden" name="holidayClose" id="holidayClose2"/>
</form>

<form id="frm3" name="frm3" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage3"/>
    <input type="hidden" name="count" id="count3"/>
    <input type="hidden" name="searchType" id="searchType3"/>
    <input type="hidden" name="keyword" id="keyword3"/>
    <input type="hidden" name="city" id="city3"/>
    <input type="hidden" name="weekOpen" id="weekOpen3"/>
    <input type="hidden" name="weekClose" id="weekClose3"/>
    <input type="hidden" name="satOpen" id="satOpen3"/>
    <input type="hidden" name="satClose" id="satClose3"/>
    <%--    <input type="hidden" name="holidayYN" id="holidayYN3"/>--%>
    <input type="hidden" name="holidayY" id="holidayY3"/>
    <input type="hidden" name="holidayN" id="holidayN3"/>
    <input type="hidden" name="holidayOpen" id="holidayOpen3"/>
    <input type="hidden" name="holidayClose" id="holidayClose3"/>
</form>
<script>

    //리셋
    $("#reset").on("click", function () {
        location.reload();
    });

    function detail(hospital_seq, cpage, count, searchType, keyword, city, weekOpen, weekClose, satOpen, satClose, holidayY, holidayN, holidayOpen, holidayClose) {

        $("#hospital_seq1").val(hospital_seq);
        $("#currentPage1").val(cpage);
        $("#count1").val(count);
        $("#searchType1").val(searchType);
        $("#keyword1").val(keyword);
        $("#city1").val(city);
        $("#weekOpen1").val(weekOpen);
        $("#weekClose1").val(weekClose);
        $("#satOpen1").val(satOpen);
        $("#satClose1").val(satClose);
        // $("#holidayYN1").val($("#holidayYNOption").val());
        $("#holidayY1").val(holidayY);
        $("#holidayN1").val(holidayN);
        $("#holidayOpen1").val(holidayOpen);
        $("#holidayClose1").val(holidayClose);
        $("#frm").submit();
    }


    function paging(startNavi, count, searchType, keyword) {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": startNavi,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    }



    //옵션 선택
    function changeOption() {
        let data = {
            searchType: $("#searchType").val(),
            keyword: $("#keyword").val(),
            count: $("#count").val(),
            city: $("#city").val(),
            weekOpen: $(".weekOpen:checked").val(),
            weekClose: $(".weekClose:checked").val(),
            satOpen: $(".satOpen:checked").val(),
            satClose: $(".satClose:checked").val(),
            // holidayYN: $(".holidayYN:checked").val(),
            holidayOpen: $(".holidayOpen:checked").val(),
            holidayClose: $(".holidayClose:checked").val(),
            holidayY: $(".holidayY:checked").val() == '진료' ? $(".holidayY:checked").val() : '',
            holidayN: $(".holidayN:checked").val() == '미진료' ? $(".holidayN:checked").val() : ''
        };

        console.log(data);
        return data;
    }


    //tbody생성
    function createHtml(item, cpage, cnt, searchType, keyword, cityOption, weekOpenOption, weekCloseOption,
                        satOpenOption, satCloseOption, holidayY, holidayN, holidayOpenOption, holidayCloseOption) {
        var html = '<tr><td>' + item.city + '</td>';
        html += '<td><a href="javascript:void(0);" onclick="detail(' + item.hospital_seq + ',' + cpage + ',' + cnt + ',\'' + searchType + '\'' + ',\'' + keyword + '\'' + ',\'' + cityOption + '\'' + ',\'' + weekOpenOption + '\''
            + ',\'' + weekCloseOption + '\'' + ',\'' + satOpenOption + '\'' + ',\'' + satCloseOption + '\'' + ',\'' + holidayY + '\'' + ',\'' + holidayN + '\'' + ',\'' + holidayOpenOption + '\'' + ',\'' + holidayCloseOption + '\'' + ');">' + item.hospital_name + '</a></td>';
        html += '<td>' + item.weekOpen + '~' + item.weekClose + '</td>';
        html += '<td>' + item.satOpen + '~' + item.satClose + '</td>';
        if (item.holidayOpen != '-' && item.holidayClose != '-') {
            html += '<td>' + item.holidayOpen + '~' + item.holidayClose + '</td>';
        } else {
            html += '<td style="text-align: center">-</td>';
        }
        html += '<td>' + item.phone + '</td></tr>';
        return html;
    }

    //데이터 없을때
    function noDataHtml() {
        var html = '<tr><td>' + '정보가 없습니다.' + '</td>';
        return html;
    }

    //페이징 새로
    function createPaging1(page) {
        var pagingHtml = '';
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.startNavi - 1) + ',' + $('#count').val() + ',\'\',\'\');">' + "<" + '</a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.startNavi - 1) + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');">' + "<" + '</a>';
        }
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (1) + ',' + $('#count').val() + ',\'\',\'\');">' + "맨 처음" + '</a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (1) + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');">' + "맨 처음" + '</a>';
        }
        return pagingHtml;
    }

    function createPaging2(page, pageTotalCount) {
        var pagingHtml = '';
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.endNavi + 1) + ',' + $('#count').val() + ',\'\',\'\');">' + ">" + '</a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.endNavi + 1) + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');">' + ">" + '</a>';
        }
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (pageTotalCount) + ',' + $('#count').val() + ',\'\',\'\');">' + "맨끝" + '</a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (pageTotalCount) + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');">' + "맨끝" + '</a>';
        }
        return pagingHtml;
    }

    function createPaging3(k, page) {
        var pagingHtml = '';
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + k + ',' + $('#count').val() + ',\'\',\'\')" style="font-weight: bold"> ' + k + ' </a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + k + ',' + page.count + ',' + $('#count').val() + ',' + page.keyword + ');"> ' + k + ' </a>';
        }
        return pagingHtml;
    }

    function createPaging4(k, page) {
        var pagingHtml = '';
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + k + ',' + $('#count').val() + ',\'\',\'\')"> ' + k + ' </a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + k + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');" style="font-weight: bold"> ' + k + ' </a>';
        }
        return pagingHtml;
    }

    //카운트 변경
    $("#count").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    //검색
    $("#searchBtn").on("click", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });


    $("#city").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".weekOpen").on("change", function () {
        console.log("시작시간 변경할때");
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".weekClose").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".satOpen").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".satClose").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".holidayY").on("change", function () {
        let holY = $('.holidayY').is(':checked');
        let holN = $('.holidayN').is(':checked');
        console.log("holY : " + holY);
        console.log("holN : " + holN);

        if (!holY && !holN) {
            alert('진료 여부를 선택하세요');
            $('.holidayY').prop('checked', true);
            return false;
        }
        console.log('change');
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });


    $(".holidayN").on("change", function () {
        let holY = $('.holidayY').is(':checked');
        let holN = $('.holidayN').is(':checked');
        console.log("holY : " + holY);
        console.log("holN : " + holN);
        if (!holY && !holN) {
            alert('진료 여부를 선택하세요');
            $('.holidayN').prop('checked', true);
            return false;
        }
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });


    $(".holidayOpen").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page, pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });


    $(".holidayClose").on("change", function () {
        let result = changeOption();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": result.count,
                "searchType": result.searchType,
                "keyword": result.keyword,
                "city": result.city,
                "weekOpen": result.weekOpen,
                "weekClose": result.weekClose,
                "satOpen": result.satOpen,
                "satClose": result.satClose,
                "holidayYN": result.holidayYN,
                "holidayY": result.holidayY,
                "holidayN": result.holidayN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("list길이 : " + data.items.length);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                let pageTotalCnt = data.pageTotalCount;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        var newHtml = createHtml(items[i], cpage, cnt, data.searchType, data.keyword, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayY, data.holidayN, data.holidayOpenOption, data.holidayCloseOption);
                        $(".tbody").append(newHtml);
                    }
                    if (page.needPrev == true) {
                        var pagingHtml = createPaging1(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                    for (let k = page.startNavi; k <= page.endNavi; k++) {
                        if (data.currentPage == k) {
                            var pagingHtml = createPaging3(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        } else {
                            var pagingHtml = createPaging4(k, page);
                            $(".pagingDiv").append(pagingHtml);
                        }
                    }
                    if (page.needNext == true) {
                        var pagingHtml = createPaging2(page.pageTotalCnt);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

</script>
</body>
</html>