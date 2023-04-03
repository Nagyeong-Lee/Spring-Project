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
    <title>감염현황 차트</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <%--chart.js--%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.2.1/dist/chart.umd.min.js"></script>

    <style>
        .chart {
            width: 600px;
            height: 600px;
        }
    </style>
</head>
<body>
<div class="chart">
    <canvas id="myChart" width="10px" ; height="10px" ;></canvas>
    <input type="hidden" value=${mmdd1} id="mmdd1">
    <input type="hidden" value=${mmdd2} id="mmdd2">
    <input type="hidden" value=${mmdd3} id="mmdd3">
    <input type="hidden" value=${mmdd4} id="mmdd4">
    <input type="hidden" value=${mmdd5} id="mmdd5">
    <input type="hidden" value=${mmdd6} id="mmdd6">
    <input type="hidden" value=${mmdd7} id="mmdd7">
    <input type="hidden" value=${mmdd8} id="mmdd8">
    <input type="hidden" value=${cnt1} id="cnt1">
    <input type="hidden" value=${cnt2} id="cnt2">
    <input type="hidden" value=${cnt3} id="cnt3">
    <input type="hidden" value=${cnt4} id="cnt4">
    <input type="hidden" value=${cnt5} id="cnt5">
    <input type="hidden" value=${cnt6} id="cnt6">
    <input type="hidden" value=${cnt7} id="cnt7">
    <input type="hidden" value=${cnt8} id="cnt8">
</div>

<script>
    let day1 = $("#mmdd1").val();
    let day2 = $("#mmdd2").val();
    let day3 = $("#mmdd3").val();
    let day4 = $("#mmdd4").val();
    let day5 = $("#mmdd5").val();
    let day6 = $("#mmdd6").val();
    let day7 = $("#mmdd7").val();
    let day8 = $("#mmdd8").val();

    let cnt1=$("#cnt1").val();
    let cnt2=$("#cnt2").val();
    let cnt3=$("#cnt3").val();
    let cnt4=$("#cnt4").val();
    let cnt5=$("#cnt5").val();
    let cnt6=$("#cnt6").val();
    let cnt7=$("#cnt7").val();
    let cnt8=$("#cnt8").val();

    console.log(day1)
    var chartArea = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(chartArea, {
        type: 'bar',
        data: {
            labels: [day1,day2,day3,day4,day5,day6,day7,day8],
            datasets: [{
                label: '# of Votes',
                data: [cnt1,cnt2,cnt3,cnt4,cnt5,cnt6,cnt7,cnt8],
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
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
