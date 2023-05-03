<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-04
  Time: 오후 5:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <title>병원 상세 정보</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d5dfc2b38866c471f7e31225499b0760&libraries=LIBRARY"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
</head>
<body>
<div id="hospitalName">병원명 : ${hospitalDTO.hospital_name}</div>
<div id="city">시군명 : ${hospitalDTO.city}</div>
<div id="postcode">우편번호 : ${hospitalDTO.postcode}</div>
<div id="roadAddress">도로명주소 : ${hospitalDTO.roadAddress}</div>
<div id="jibunAddress">지번주소 : ${hospitalDTO.jibunAddress}</div>
<div id="weekBsHour">진료 시간 : ${hospitalDTO.weekOpen} ~ ${hospitalDTO.weekClose}</div>
<c:if test="${not empty hospitalDTO.satOpen}">
    <div id="satBsHour">토요일 진료 시간 : ${hospitalDTO.satOpen} ~ ${hospitalDTO.satClose}</div>
</c:if>
<c:if test="${not empty hospitalDTO.holidayOpen}">
    <c:if test="${hospitalDTO.holidayOpen ne '-'}">
        <div id="holidayBsHour">일요일 및 공휴일 진료시간 : ${hospitalDTO.holidayOpen} ~ ${hospitalDTO.holidayClose}</div>
    </c:if>
    <c:if test="${hospitalDTO.holidayOpen eq '-'}">
<%--    <div id="holidayBsHour">일요일 및 공휴일 진료시간 : -</div>--%>
    <div id="holidayBsHour"></div>
    </c:if>
</c:if>
<div id="map" style="width:50%;height:350px;"></div>

<a href="javascript:void(0);"
   onclick="toList(${currentPage},${count},'${searchType}','${keyword}','${city}','${weekOpen}','${weekClose}'
           ,'${satOpen}','${satClose}','${holidayY}','${holidayN}','${holidayOpen}','${holidayClose}')">
    <button type="button" id="toList" class="btn btn-light">목록으로</button>
</a>
<%--<a href="javascript:void(0);" onclick="toList(${currentPage},${count},'${searchType}','${keyword}')"><button type="button" id="toList">목록으로</button></a>--%>

<form id="frm" name="frm" method="post" action="/api/hospital">
    <input type="hidden" name="currentPage" id="currentPage"/>
    <input type="hidden" name="count" id="count"/>
    <input type="hidden" name="searchType" id="searchType"/>
    <input type="hidden" name="keyword" id="keyword"/>
    <input type="hidden" name="city" id="city2"/>
    <input type="hidden" name="weekOpen" id="weekOpen"/>
    <input type="hidden" name="weekClose" id="weekClose"/>
    <input type="hidden" name="satOpen" id="satOpen"/>
    <input type="hidden" name="satClose" id="satClose"/>
    <input type="hidden" name="holidayY" id="holidayY"/>
    <input type="hidden" name="holidayN" id="holidayN"/>
    <input type="hidden" name="holidayOpen" id="holidayOpen"/>
    <input type="hidden" name="holidayClose" id="holidayClose"/>
</form>
<script>
    function toList(currentPage, count, searchType, keyword, city, weekOpen, weekClose, satOpen, satClose,holidayY,holidayN, holidayOpen, holidayClose) {
        $("#currentPage").val(currentPage);
        $("#count").val(count);
        $("#searchType").val(searchType);
        $("#keyword").val(keyword);

        $("#city2").val(city);
        $("#weekOpen").val(weekOpen);
        $("#weekClose").val(weekClose);
        $("#satOpen").val(satOpen);
        $("#satClose").val(satClose);

        $("#holidayY").val(holidayY);
        $("#holidayN").val(holidayN);

        $("#holidayOpen").val(holidayOpen);
        $("#holidayClose").val(holidayClose);
        $("#frm").submit();
    }

    var mapContainer = document.getElementById('map'), // 지도를 표시할 div
        mapOption = {
            center: new kakao.maps.LatLng(${hospitalDTO.latitude}, ${hospitalDTO.longitude}), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
        };

    var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

    // 마커가 표시될 위치입니다
    var markerPosition = new kakao.maps.LatLng(${hospitalDTO.latitude}, ${hospitalDTO.longitude});

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({
        position: markerPosition
    });

    // 마커가 지도 위에 표시되도록 설정합니다
    marker.setMap(map);
</script>
</body>
</html>