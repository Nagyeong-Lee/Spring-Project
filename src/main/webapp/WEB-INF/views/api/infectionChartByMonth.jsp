<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-04
  Time: 오후 1:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>월별 감염현황 차트</title>
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
    <c:if test="${not empty mapList}">
        <c:forEach var="i" items="${mapList}" varStatus="status">
            <input type="hidden" value="${i.get("month")}" id='month${status.count}'>
            <input type="hidden" value="${i.get("sum")}" id='sum${status.count}'>
        </c:forEach>
    </c:if>
</div>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer" >
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<script src="/resources/asset/js/util.js"></script>
<script>
    let cnt1 = $("#sum1").val();
    let cnt2 = $("#sum2").val();
    let cnt3 = $("#sum3").val();
    let cnt4 = $("#sum4").val();
    let cnt5 = $("#sum5").val();
    let cnt6 = $("#sum6").val();
    let cnt7 = $("#sum7").val();
    let cnt8 = $("#sum8").val();
    let cnt9 = $("#sum9").val();
    let cnt10 = $("#sum10").val();
    let cnt11 = $("#sum11").val();
    let cnt12 = $("#sum12").val();

    var chartArea = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(chartArea, {
        type: 'line',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [{
                data: [cnt1, cnt2, cnt3, cnt4, cnt5, cnt6, cnt7, cnt8, cnt9, cnt10, cnt11, cnt12,],
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
</body>
</html>
