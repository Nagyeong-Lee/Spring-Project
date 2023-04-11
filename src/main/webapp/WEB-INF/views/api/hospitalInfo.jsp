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
        <option value="${i}" <c:out value="${cityOption eq i ? 'selected' :''}"/> >${i}</option>
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
<c:forEach var="i" items="${holidayYN}">
    ${i}<input type="checkbox" value="${i}" name="holidayYN" class="holidayYN"
    <c:out
            value="${i eq holidayYNOption? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 시작 시간 :
<c:forEach var="i" items="${holidayOpen}">
    ${i}<input type="radio" value="${i}" name="holidayOpen" class="holidayOpen" <c:out
        value="${i eq holidayOpenOption? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 마감 시간 :
<c:forEach var="i" items="${holidayClose}">
    ${i}<input type="radio" value="${i}" name="holidayClose" class="holidayClose" <c:out
        value="${i eq holidayCloseOption? 'checked' : ''}"/>>
</c:forEach>
<br>
<hr>

<input type="hidden" name="currentPage" value="${currentPage}" id="boardCurrentPage">
<input type="hidden" name="count" value="${count}" id="boardCount">
<input type="hidden" name="searchType" value="${searchType}" id="boardSearchType">
<input type="hidden" name="keyword" value="${keyword}" id="boardKeyword">

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
                            <%--                           onclick="detail(${i.hospital_seq});">${i.hospital_name}</a>--%>
                            <%--                                                       onclick="detail(${i.hospital_seq},${currentPage},${count});">${i.hospital_name}</a>--%>
                           onclick="detail(${i.hospital_seq},${currentPage},${count},'${cityOption}','${weekOpenOption}','${weekCloseOption}','${satOpenOption}','${satCloseOption}','${holidayOpenOption}','${holidayCloseOption}');">${i.hospital_name}</a>
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
    <input type="hidden" name="holidayOpen" id="holidayOpen1"/>
    <input type="hidden" name="holidayClose" id="holidayClose1"/>

</form>
<form id="frm2" name="frm2" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage2"/>
    <input type="hidden" name="count" id="count2"/>
    <input type="hidden" name="searchType" id="searchType2"/>
    <input type="hidden" name="keyword" id="keyword2"/>
</form>
<form id="frm3" name="frm3" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage3"/>
    <input type="hidden" name="count" id="count3"/>
    <input type="hidden" name="searchType" id="searchType3"/>
    <input type="hidden" name="keyword" id="keyword3"/>
</form>
<script>

    // function detail(hospital_seq/*, currentPage, count, searchType, keyword*/) {
    //     $("#hospital_seq1").val(hospital_seq);
    //     $("#currentPage1").val($("#boardCurrentPage").val());
    //     $("#count1").val($("#boardCount").val());
    //     $("#searchType1").val($("#boardSearchType").val());
    //     $("#keyword1").val($("#boardKeyword").val());
    //     $("#frm").submit();
    // }

    // function detail(hospital_seq, cpage, count) {
    //     $("#hospital_seq1").val(hospital_seq);
    //     $("#currentPage1").val(cpage);
    //     $("#count1").val(count);
    //     $("#searchType1").val($("#boardSearchType").val());
    //     $("#keyword1").val($("#boardKeyword").val());
    //
    //     $("#city1").val($("#boardKeyword").val());
    //     $("#weekOpen1").val($("#boardKeyword").val());
    //     $("#weekClose1").val($("#boardKeyword").val());
    //     $("#satOpen1").val($("#boardKeyword").val());
    //     $("#satClose1").val($("#boardKeyword").val());
    //     $("#holidayOpen1").val($("#boardKeyword").val());
    //     $("#holidayClose1").val($("#boardKeyword").val());
    //
    //     $("#frm").submit();
    // }

    function detail(hospital_seq, cpage, count, city, weekOpen, weekClose, satOpen, satClose, holidayOpen, holidayClose) {
        console.log("디테일");
        console.log(hospital_seq);
        console.log(cpage);
        console.log(count);
        console.log(city);
        console.log(weekOpen);
        console.log(weekClose);
        console.log(satOpen);
        console.log(satClose);
        console.log(holidayOpen);
        console.log(holidayClose);
        $("#hospital_seq1").val(hospital_seq);
        $("#currentPage1").val(cpage);
        $("#count1").val(count);
        $("#searchType1").val($("#boardSearchType").val());
        $("#keyword1").val($("#boardKeyword").val());
        $("#city1").val(city);
        $("#weekOpen1").val(weekOpen);
        $("#weekClose1").val(weekClose);
        $("#satOpen1").val(satOpen);
        $("#satClose1").val(satClose);
        $("#holidayOpen1").val(holidayOpen);
        $("#holidayClose1").val(holidayClose);

        $("#frm").submit();
    }

    function paging(startNavi, count, searchType, keyword) {
        /*$("#cpage").val(startNavi);
        $("#cnt").val(count);
        $("#type").val(searchType);
        $("#key").val(keyword);
        $("#pagingFrm").submit();*/

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
                "holidayYN": result.holidayYN,
                "holidayOpen": result.holidayOpen,
                "holidayClose": result.holidayClose
            },
            success: function (data) {
                console.log("cpage : " + data.currentPage);
                console.log("count : " + data.count);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                let cpage = data.currentPage;
                let cnt = data.count;
                console.log('data.cpage : ' + data.currentPage);
                console.log('data.cnt : ' + data.count);
                for (let i = 0; i < items.length; i++) {
                    // var newHtml = createHtml(items[i]);
                    // var newHtml = createHtml(items[i], cpage, cnt);
                    var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                        data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                    var pagingHtml = createPaging2(page);
                    $(".pagingDiv").append(pagingHtml);
                }

                /*console.log(data);
                $(".tbody").children().remove();
                $(".pagingDiv").children().remove();
                let items = data.items;
                let page = data.paging;
                for (let i = 0; i < items.length; i++) {
                    var newHtml = createHtml(items[i]);
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
                    var pagingHtml = createPaging2(page);
                    $(".pagingDiv").append(pagingHtml);
                }*/
            }
        })
    }

    $("#count").on("change", function () {
        let count = $("#count").val();
        countChange(count);
    });

    function countChange(count) {
        $("#currentPage2").val(1);
        $("#count2").val(count);
        $("#searchType2").val("");
        $("#keyword2").val("");
        $("#frm2").submit();
    }

    $("#searchBtn").on("click", function () {
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();

        $("#currentPage3").val(1);
        $("#count3").val(count);
        $("#searchType3").val(searchType);
        $("#keyword3").val(keyword);
        $("#frm3").submit();
    });

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
            holidayYN: $(".holidayYN:checked").val(),
            holidayOpen: $(".holidayOpen:checked").val(),
            holidayClose: $(".holidayClose:checked").val()
        };
        return data;
    }

    //tbody생성
    // function createHtml(item) {
    //     var html = '<tr><td>' + item.city + '</td>';
    //     // html += '<td><a href="javascript:void(0);" onclick="detail(' + item.hospital_seq + ');">' + item.hospital_name + '</a></td>';
    //     html += '<td><a href="javascript:void(0);" onclick="detail(' + item.hospital_seq + ','+item.);">' + item.hospital_name + '</a></td>';
    //     html += '<td>' + item.weekOpen + '~' + item.weekClose + '</td>';
    //     html += '<td>' + item.satOpen + '~' + item.satClose + '</td>';
    //     if (item.holidayOpen != null && item.holidayClose != null) {
    //         html += '<td>' + item.holidayOpen + '~' + item.holidayClose + '</td>';
    //     } else {
    //         html += '<td style="text-align: center">-</td>';
    //     }
    //     html += '<td>' + item.phone + '</td></tr>';
    //     return html;
    //}

    //tbody생성
    // function createHtml(item, cpage, cnt) {
    //     //     "1, '홍길동'"
    //     // var arr = [item.hospital_seq, "\'"+item.city+"\'", "\'"+item.weekOpen + "\'", ];
    //     // "...onclick=detail(1, '홍길동'.....);
    //     // var b = "'" + item.city + "'";
    //
    //     var html = '<tr><td>' + item.city + '</td>';
    //     html += '<td><a href="javascript:void(0);" onclick="detail(' + item.hospital_seq + ',' + cpage + ',' + cnt + ',\'' + item.city+ '\'' + ',\''+item.weekOpen + '\''
    //         + ',\'' + item.weekClose + '\''+',\'' + item.satOpen + '\''+',\'' + item.satClose + '\''+',\'' + item.holidayOpen + '\''+ ',\'' + item.holidayClose + '\''+');">' + item.hospital_name + '</a></td>';
    //     html += '<td>' + item.weekOpen + '~' + item.weekClose + '</td>';
    //     html += '<td>' + item.satOpen + '~' + item.satClose + '</td>';
    //     if (item.holidayOpen != null && item.holidayClose != null) {
    //         html += '<td>' + item.holidayOpen + '~' + item.holidayClose + '</td>';
    //     } else {
    //         html += '<td style="text-align: center">-</td>';
    //     }
    //     html += '<td>' + item.phone + '</td></tr>';
    //     return html;
    // }

    //tbody생성
    function createHtml(item, cpage, cnt, cityOption, weekOpenOption, weekCloseOption,
                        satOpenOption, satCloseOption, holidayOpenOption, holidayCloseOption) {
        //     "1, '홍길동'"
        // var arr = [item.hospital_seq, "\'"+item.city+"\'", "\'"+item.weekOpen + "\'", ];
        // "...onclick=detail(1, '홍길동'.....);
        // var b = "'" + item.city + "'";

        var html = '<tr><td>' + item.city + '</td>';
        html += '<td><a href="javascript:void(0);" onclick="detail(' + item.hospital_seq + ',' + cpage + ',' + cnt + ',\'' + cityOption + '\'' + ',\'' + weekOpenOption + '\''
            + ',\'' + weekCloseOption + '\'' + ',\'' + satOpenOption + '\'' + ',\'' + satCloseOption + '\'' + ',\'' + holidayOpenOption + '\'' + ',\'' + holidayCloseOption + '\'' + ');">' + item.hospital_name + '</a></td>';
        html += '<td>' + item.weekOpen + '~' + item.weekClose + '</td>';
        html += '<td>' + item.satOpen + '~' + item.satClose + '</td>';
        if (item.holidayOpen != null && item.holidayClose != null) {
            html += '<td>' + item.holidayOpen + '~' + item.holidayClose + '</td>';
        } else {
            html += '<td style="text-align: center">-</td>';
        }
        html += '<td>' + item.phone + '</td></tr>';
        return html;
    }

    //데이터 없을때
    function noDataHtml() {
        //     "1, '홍길동'"
        // var arr = [item.hospital_seq, "\'"+item.city+"\'", "\'"+item.weekOpen + "\'", ];
        // "...onclick=detail(1, '홍길동'.....);
        // var b = "'" + item.city + "'";

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
        return pagingHtml;
    }

    function createPaging2(page) {
        var pagingHtml = '';
        if (page.searchType == null && page.keyword == null) {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.endNavi + 1) + ',' + $('#count').val() + ',\'\',\'\');">' + ">" + '</a>';
        } else {
            pagingHtml += '<a href="javascript:void(0);" onclick="paging(' + (page.endNavi + 1) + ',' + $('#count').val() + ',' + page.searchType + ',' + page.keyword + ');">' + ">" + '</a>';
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });

    $(".holidayYN").on("change", function () {
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
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
                // console.log('data.cpage : ' + data.currentPage);
                // console.log('data.cnt : ' + data.count);
                if (data.items.length == 0) {
                    var html = noDataHtml();
                    $(".tbody").append(html);
                } else {
                    for (let i = 0; i < items.length; i++) {
                        // var newHtml = createHtml(items[i]);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        // var newHtml = createHtml(items[i], cpage, cnt);
                        var newHtml = createHtml(items[i], cpage, cnt, data.cityOption, data.weekOpenOption, data.weekCloseOption,
                            data.satOpenOption, data.satCloseOption, data.holidayOpenOption, data.holidayCloseOption);
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
                        var pagingHtml = createPaging2(page);
                        $(".pagingDiv").append(pagingHtml);
                    }
                }
            }
        })
    });
</script>
</body>
</html>