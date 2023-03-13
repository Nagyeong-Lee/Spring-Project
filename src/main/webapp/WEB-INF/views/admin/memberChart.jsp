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
</div>

<script>
    // 차트를 그럴 영역을 dom요소로 가져온다.
    var chartArea = document.getElementById('myChart').getContext('2d');
    // 차트를 생성한다.
    var myChart = new Chart(chartArea, {
        // ①차트의 종류(String)
        type: 'bar',
        // ②차트의 데이터(Object)
        data: {
            // ③x축에 들어갈 이름들(Array)
            labels: ['6개월전','3개월전','1개월전','3월'],
            // ④실제 차트에 표시할 데이터들(Array), dataset객체들을 담고 있다.
            datasets: [{
                // ⑤dataset의 이름(String)
                label: '# of Votes',
                // ⑥dataset값(Array)
                data: [12, 19, 3, 5, 2, 3],
                // ⑦dataset의 배경색(rgba값을 String으로 표현)
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                // ⑧dataset의 선 색(rgba값을 String으로 표현)
                borderColor: 'rgba(255, 99, 132, 1)',
                // ⑨dataset의 선 두께(Number)
                borderWidth: 1
            }]
        },
        // ⑩차트의 설정(Object)
        options: {
            // ⑪축에 관한 설정(Object)
            scales: {
                // ⑫y축에 대한 설정(Object)
                y: {
                    // ⑬시작을 0부터 하게끔 설정(최소값이 0보다 크더라도)(boolean)
                    beginAtZero: true
                }
            }
        }
    });
</script>
</body>
</html>
