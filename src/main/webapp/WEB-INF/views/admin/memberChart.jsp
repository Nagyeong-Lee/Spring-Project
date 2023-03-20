<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-03-12
  Time: 오후 5:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>차트</title>
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
<%--차트를 그릴 영역으로 canvas태그를 사용한다.--%>
<div class="chart">
    <canvas id="myChart" width="10px" ; height="10px" ;></canvas>
    <input type="hidden" value="${list.get(0)}" id="count1">
    <input type="hidden" value="${list.get(1)}" id="count2">
    <input type="hidden" value="${list.get(2)}" id="count3">
    <input type="hidden" value="${list.get(3)}" id="count4">
</div>

<script>

    let count1=$("#count1").val();
    let count2=$("#count2").val();
    let count3=$("#count3").val();
    let count4=$("#count4").val();
    var chartArea = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(chartArea, {
        type: 'bar',
        data: {
            labels: ['1-3','4-6','7-9','10-12'],
            datasets: [{
                label: '# of Votes',
                data: [count1, count2, count3, count4],
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
