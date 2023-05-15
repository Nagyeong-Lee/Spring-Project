<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-03
  Time: 오후 4:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>일별 감염현황 차트</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <%--chart.js--%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.2.1/dist/chart.umd.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="/resources/asset/css/util.css">
    <style>
        .chart {
            width: 600px;
            height: 600px;
        }

        #footer {
            /*position: fixed;*/
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
            position: relative;
            /*transform: translatY(-100%);*/
        }

    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/product/communityNavUtil.jsp" %>
<div class="chart">
    <canvas id="myChart" width="10px" ; height="10px" ;></canvas>
    <input type="hidden" value="${infectionDTO.mmdd1}" id="mmdd1">
    <input type="hidden" value="${infectionDTO.mmdd2}" id="mmdd2">
    <input type="hidden" value="${infectionDTO.mmdd3}" id="mmdd3">
    <input type="hidden" value="${infectionDTO.mmdd4}" id="mmdd4">
    <input type="hidden" value="${infectionDTO.mmdd5}" id="mmdd5">
    <input type="hidden" value="${infectionDTO.mmdd6}" id="mmdd6">
    <input type="hidden" value="${infectionDTO.mmdd7}" id="mmdd7">
    <input type="hidden" value="${infectionDTO.mmdd8}" id="mmdd8">
    <input type="hidden" value="${infectionDTO.cnt1}" id="cnt1">
    <input type="hidden" value="${infectionDTO.cnt2}" id="cnt2">
    <input type="hidden" value="${infectionDTO.cnt3}" id="cnt3">
    <input type="hidden" value="${infectionDTO.cnt4}" id="cnt4">
    <input type="hidden" value="${infectionDTO.cnt5}" id="cnt5">
    <input type="hidden" value="${infectionDTO.cnt6}" id="cnt6">
    <input type="hidden" value="${infectionDTO.cnt7}" id="cnt7">
    <input type="hidden" value="${infectionDTO.cnt1}" id="cnt8">
</div>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer" >
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<script>
    let day1 = $("#mmdd1").val();
    let day2 = $("#mmdd2").val();
    let day3 = $("#mmdd3").val();
    let day4 = $("#mmdd4").val();
    let day5 = $("#mmdd5").val();
    let day6 = $("#mmdd6").val();
    let day7 = $("#mmdd7").val();
    let day8 = $("#mmdd8").val();

    let cnt1 = $("#cnt1").val();
    let cnt2 = $("#cnt2").val();
    let cnt3 = $("#cnt3").val();
    let cnt4 = $("#cnt4").val();
    let cnt5 = $("#cnt5").val();
    let cnt6 = $("#cnt6").val();
    let cnt7 = $("#cnt7").val();
    let cnt8 = $("#cnt8").val();

    var chartArea = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(chartArea, {
        type: 'line',
        data: {
            labels: [day1, day2, day3, day4, day5, day6, day7, day8],
            datasets: [{
                data: [cnt1, cnt2, cnt3, cnt4, cnt5, cnt6, cnt7, cnt8],
                backgroundColor: 'rgba(255, 500, 132, 0.2)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>
<script src="/resources/asset/js/util.js"></script>
</body>
</html>
