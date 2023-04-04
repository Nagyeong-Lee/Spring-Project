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
</head>
<body>
<div id="hospitalName">병원명 : ${hospitalDTO.hospital_name}</div>
<div id="city">시군명 : ${hospitalDTO.city}</div>
<div id="postcode">우편번호 : ${hospitalDTO.postcode}</div>
<div id="roadAddress">도로명주소 : ${hospitalDTO.roadAddress}</div>
<div id="jibunAddress">지번주소 : ${hospitalDTO.jibunAddress}</div>
<div id="open">시작시간 : ${hospitalDTO.weekOpen}</div>
<div id="close">종료시간 : ${hospitalDTO.weekClose}</div>
<c:if test="${not empty hospitalDTO.satOpen}">토요일 오픈시간 : ${hospitalDTO.satOpen}</c:if>
<c:if test="${not empty hospitalDTO.satClose}">토요일 종료시간 : ${hospitalDTO.satClose}</c:if>
<c:if test="${not empty hospitalDTO.holidayOpen}">일요일 오픈시간 : ${hospitalDTO.holidayOpen}</c:if>
<c:if test="${not empty hospitalDTO.holidayClose}">일요일 오픈시간 : ${hospitalDTO.holidayClose}</c:if>
<div id="map" style="width:50%;height:350px;"></div>

<script>
  var mapContainer = document.getElementById('map'), // 지도를 표시할 div
          mapOption = {
            center: new kakao.maps.LatLng(${latitude}, ${longitude}), // 지도의 중심좌표
            level: 3 // 지도의 확대 레벨
          };

  var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

  // 마커가 표시될 위치입니다
  var markerPosition = new kakao.maps.LatLng(${latitude}, ${longitude});

  // 마커를 생성합니다
  var marker = new kakao.maps.Marker({
    position: markerPosition
  });

  // 마커가 지도 위에 표시되도록 설정합니다
  marker.setMap(map);

  // 아래 코드는 지도 위의 마커를 제거하는 코드입니다
  // marker.setMap(null);
</script>
</body>
</html>