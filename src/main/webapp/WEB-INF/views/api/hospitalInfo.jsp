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
    <option value="ALL" selected>전체지역</option>
    <c:forEach var="i" items="${city}">
        <option value="${i}">${i}</option>
    </c:forEach>
</select>
<br>
평일 진료 시작 시간 :
<c:forEach var="i" items="${weekOpen}">
    ${i}<input type="radio" value="${i}" name="weekOpen" class="weekOpen" <c:out
        value="${i eq '09:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
평일 진료 마감 시간 :
<c:forEach var="i" items="${weekClose}">
    ${i}<input type="radio" value="${i}" name="weekClose" class="weekClose" <c:out
        value="${i eq '22:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
토요일 진료 시작 시간 :
<c:forEach var="i" items="${satOpen}">
    ${i}<input type="radio" value="${i}" name="satOpen" class="satOpen" <c:out
        value="${i eq '09:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
토요일 진료 마감 시간 :
<c:forEach var="i" items="${satClose}">
    ${i}<input type="radio" value="${i}" name="satClose" class="satClose"  <c:out
        value="${i eq '22:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 여부 :
<c:forEach var="i" items="${holidayYN}">
    ${i}<input type="checkbox" value="${i}" name="holidayYN" class="holidayYN"
    <c:out
            value="${i eq '미진료'? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 시작 시간 :
<c:forEach var="i" items="${holidayOpen}">
    ${i}<input type="radio" value="${i}" name="holidayOpen" class="holidayOpen" <c:out
        value="${i eq '09:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
일요일/공휴일 진료 마감 시간 :
<c:forEach var="i" items="${holidayClose}">
    ${i}<input type="radio" value="${i}" name="holidayClose" class="holidayClose" <c:out
        value="${i eq '19:00'? 'checked' : ''}"/>>
</c:forEach>
<br>
<hr>

<input type="hidden" value="${currentPage}" id="currentPage" <c:out value="${i eq '09:00'? 'checked' : ''}"/>>
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
               +             <%--onclick="detail(${i.hospital_seq}, ${currentPage}, ${count}, '${searchType}', '${keyword}');">${i.hospital_name}</a>--%>
                            onclick="detail(${i.hospital_seq});">${i.hospital_name}</a>
                    </td>
                    <td>${i.weekOpen}~${i.weekClose}&nbsp&nbsp</td>
                    <td>${i.satOpen}~${i.satClose}</td>
                    <td style="text-align: center">${i.holidayOpen}</td>
                    <td>${i.phone}</td>
                </tr>
            </c:forEach>
        </c:when>
    </c:choose>
    </tbody>
</table>
${paging}<br>
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
</form>
<form id="frm2" name="frm2" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage2"/>
    <input type="hidden" name="count" id="count2"/>
    <input type="hidden" name="searchType" id="searchType2"/>
    <input type="hidden" name="keyword" id="keyword2"/>
</form>
<form id="frm3" name="frm3" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" value="1" id="currentPage3"/>
    <input type="hidden" name="count" id="count3"/>
    <input type="hidden" name="searchType" id="searchType3"/>
    <input type="hidden" name="keyword" id="keyword3"/>
</form>
<script>

    function detail(hospital_seq/*, currentPage, count, searchType, keyword*/) {
        // $('#frm').html("");
        // let form=$('form[name="frm"]')[0];
        // let html='<input type="hidden" value="1" name="hospital_seq">';
        // html+='<input type="hidden" value="10" name="currentPage">';
        // html+='<input type="hidden" value="count" name="count">';
        // html+='<input type="hidden" value="searchType" name="searchType">';
        // html+='<input type="hidden" value="keyword" name="keyword">';
        // $('#frm').append(html);
        $("#hospital_seq1").val(hospital_seq);
        /*$("#currentPage1").val(currentPage);
        $("#count1").val(count);
        $("#searchType1").val(searchType);
        $("#keyword1").val(keyword);*/
        // $("#city1").val(city);

        $("#currentPage1").val(1);
        $("#count1").val(1);
        $("#searchType1").val('');
        $("#keyword1").val('');

        $("#frm").submit();
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

        $("#count3").val(count);
        $("#searchType3").val(searchType);
        $("#keyword3").val(keyword);
        $("#frm3").submit();
        // location.href = "/api/hospital?currentPage=1&count=" + count + "&searchType=" + searchType + "&keyword=" + keyword;
    });

    //옵션 선택
    // function changeFunction() {
    //     var searchType = $("#searchType").val();
    //     var keyword = $("#keyword").val();
    //     var count = $("#count").val();
    //     var city = $("#city").val();
    //     var weekOpen = $(".weekOpen:checked").val();
    //     var weekClose = $(".weekClose:checked").val();
    //     var satOpen = $(".satOpen:checked").val();
    //     var satClose = $(".satClose:checked").val();
    //     var holidayYN = $(".holidayYN:checked").val();
    //     var holidayOpen = $(".holidayOpen:checked").val();
    //     var holidayClose = $(".holidayClose:checked").val();
    // }

    $("#city").on("change", function () {
        // changeFunction(searchType,keyword,count,city,weekOpen,weekClose,satOpen,satClose,holidayYN,holidayOpen,holidayClose);
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                 console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td><a href="javascript:void(0);" onclick="detail('+items[i].hospital_seq+');">' + items[i].hospital_name + '</a></td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".weekOpen").on("change", function () {
        // $(".weekOpen").attr("checked",false);
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".weekClose").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".satOpen").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".satClose").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".holidayYN").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".holidayOpen").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });

    $(".holidayClose").on("change", function () {
        // changeFunction();
        let searchType = $("#searchType").val();
        let keyword = $("#keyword").val();
        let count = $("#count").val();
        let city = $("#city").val();
        let weekOpen = $(".weekOpen:checked").val();
        let weekClose = $(".weekClose:checked").val();
        let satOpen = $(".satOpen:checked").val();
        let satClose = $(".satClose:checked").val();
        let holidayYN = $(".holidayYN:checked").val();
        let holidayOpen = $(".holidayOpen:checked").val();
        let holidayClose = $(".holidayClose:checked").val();
        console.log(holidayClose);
        $.ajax({
            url: '/api/hospital/list',
            type: 'post',
            data: {
                "currentPage": 1,
                "count": count,
                "searchType": searchType,
                "keyword": keyword,
                "city": city,
                "weekOpen": weekOpen,
                "weekClose": weekClose,
                "satOpen": satOpen,
                "satClose": satClose,
                "holidayYN": holidayYN,
                "holidayOpen": holidayOpen,
                "holidayClose": holidayClose
            },
            success: function (data) {
                $(".tbody").children().remove();
                let items = data.items;
                console.log(data);
                console.log(items.length);
                for (let i = 0; i < items.length; i++) {
                    var html = '<tr><td>' + items[i].city + '</td>';
                    html += '<td>' + items[i].hospital_name + '</td>';
                    html += '<td>' + items[i].weekOpen + '~' + items[i].weekClose + '</td>';
                    html += '<td>' + items[i].satOpen + '~' + items[i].satClose + '</td>';
                    if (items[i].holidayOpen != null && items[i].holidayClose != null) {
                        html += '<td>' + items[i].holidayOpen + '~' + items[i].holidayClose + '</td>';
                    }else{
                        html += '<td style="text-align: center">-</td>';
                    }
                    html += '<td>' + items[i].phone + '</td></tr>';
                    $(".tbody").append(html);
                }
                console.log(html);
            }
        })
    });
</script>
</body>
</html>