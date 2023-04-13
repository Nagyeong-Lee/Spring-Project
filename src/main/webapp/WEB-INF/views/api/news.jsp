<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-13
  Time: 오전 9:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>뉴스</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<c:forEach var="i" items="${list}" varStatus="status">
    <button type="button" id="${status.count}">${i.code}</button>
</c:forEach>

<div class="header">
    <h2>전체 뉴스</h2>
</div>
<%--게시판--%>
<table style="border: 1px solid black">
    <thead>
    <th>키워드</th>
    <th>제목</th>
    <th>설명</th>
    <th>링크</th>
    </thead>
    <tbody id="tbody">
    <c:forEach var="i" items="${newsList}">
        <tr>
            <td>${i.keyword}</td>
            <td>${i.title}</td>
            <td>${i.description}</td>
            <td>${i.link}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<script>

    var html = '';
    //코로나 클릭
    $("#1").on("click", function () {
        $.ajax({
            url: "/api/newsByKeyword",
            data:
                {"keyword": "코로나"},
            success: function (data) {
                if (data != null) {
                    $(".header").remove();
                    $(".header").append('<h2>코로나 관련 뉴스</h2>');
                    $("#tbody").children().remove();
                    for (let i = 0; i < data.length; i++) {
                        html = '<tr><td>' + data[i].keyword + '</td><tr>';
                        html += '<td>' + data[i].title + '</td>';
                        html += '<td>' + data[i].description + '</td>';
                        html += '<td>' + data[i].link + '</td>';
                        $("#tbody").append(html);
                    }
                } else {
                    html = '정보가 없습니다.';
                    $("#tbody").append(html);
                }
            }
        });
    });

    $("#2").on("click", function () {
        $.ajax({
            url: "/api/newsByKeyword",
            data:
                {"keyword": "자가격리"},
            success: function (data) {
                if (data != null) {
                    $(".header").remove();
                    $(".header").append('<h2>자가격리 관련 뉴스</h2>');
                    $("#tbody").children().remove();
                    for (let i = 0; i < data.length; i++) {
                        html = '<tr><td>' + data[i].keyword + '</td><tr>';
                        html += '<td>' + data[i].title + '</td>';
                        html += '<td>' + data[i].description + '</td>';
                        html += '<td>' + data[i].link + '</td>';
                        $("#tbody").append(html);
                    }
                } else {
                    html = '정보가 없습니다.';
                    $("#tbody").append(html);
                }
            }
        });
    });

    $("#3").on("click", function () {
        $.ajax({
            url: "/api/newsByKeyword",
            data:
                {"keyword": "거리두기"},
            success: function (data) {
                if (data != null) {
                    $(".header").remove();
                    $(".header").append('<h2>거리두기 관련 뉴스</h2>');
                    $("#tbody").children().remove();
                    for (let i = 0; i < data.length; i++) {
                        html = '<tr><td>' + data[i].keyword + '</td><tr>';
                        html += '<td>' + data[i].title + '</td>';
                        html += '<td>' + data[i].description + '</td>';
                        html += '<td>' + data[i].link + '</td>';
                        $("#tbody").append(html);
                    }
                } else {
                    html = '정보가 없습니다.';
                    $("#tbody").append(html);
                }
            }
        });
    });

    $("#4").on("click", function () {
        $.ajax({
            url: "/api/newsByKeyword",
            data:
                {"keyword": "마스크"},
            success: function (data) {
                if (data != null) {
                    $(".header").remove();
                    $(".header").append('<h2>마스크 관련 뉴스</h2>');
                    $("#tbody").children().remove();
                    for (let i = 0; i < data.length; i++) {
                        html = '<tr><td>' + data[i].keyword + '</td><tr>';
                        html += '<td>' + data[i].title + '</td>';
                        html += '<td>' + data[i].description + '</td>';
                        html += '<td>' + data[i].link + '</td>';
                        $("#tbody").append(html);
                    }
                } else {
                    html = '정보가 없습니다.';
                    $("#tbody").append(html);
                }
            }
        });
    });

    $("#5").on("click", function () {
        $.ajax({
            url: "/api/newsByKeyword",
            data:
                {"keyword": "백신"},
            success: function (data) {
                if (data != null) {
                    $(".header").remove();
                    $(".header").append('<h2>백신 관련 뉴스</h2>');
                    $("#tbody").children().remove();
                    for (let i = 0; i < data.length; i++) {
                        html = '<tr><td>' + data[i].keyword + '</td><tr>';
                        html += '<td>' + data[i].title + '</td>';
                        html += '<td>' + data[i].description + '</td>';
                        html += '<td>' + data[i].link + '</td>';
                        $("#tbody").append(html);
                    }
                } else {
                    html = '정보가 없습니다.';
                    $("#tbody").append(html);
                }
            }
        });
    });
</script>
</body>

</html>
