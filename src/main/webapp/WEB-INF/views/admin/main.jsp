<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-03-13
  Time: 오후 9:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>관리자 메인페이지</title>
    <!--jQuery-->
    <%--    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>--%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
    <script src="https://malsup.github.io/jquery.form.js"></script>
</head>
<body>
회원 리스트
<br>

<form action="/admin/upload" enctype="multipart/form-data" method="post" id="frm">
    <input type="file" id="fileExcel" name="fileExcel">
    <button type="button" id="uploadBtn" onclick="check()">excel upload</button>
</form>

<table border="1px solid black">
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr>
                    <th>이름</th>
                    <th>아이디</th>
                    <th>이메일</th>
                    <th>전화번호</th>
                    <th>가입일자</th>
                </tr>
                <tr>
                    <td>${i.name}</td>
                    <td>${i.id}</td>
                    <td>${i.email}</td>
                    <td>${i.phone}</td>
                    <td><fmt:formatDate pattern="YYYY-MM-dd" value="${i.signup_date}"/></td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <td>회원이 존재하지 않습니다.</td>
        </c:otherwise>
    </c:choose>
</table>
<button type="button" id="downloadBtn">excel download</button>
<br>
<a href="/admin/chart">
    <button type="button">월별 회원가입 차트</button>
</a>

<script>
    $("#downloadBtn").on("click", function () {
        location.href = "/admin/download";
    });

    //엑셀 업로드
    function check() {

        var file = $("#fileExcel").val();

        if (file == "" || file == null) {
            alert("파일을 선택해주세요.");

            return false;
        } else if (!checkFileType(file)) {
            alert("엑셀 파일만 업로드 가능합니다.");

            return false;
        }

        if (confirm("업로드 하시겠습니까?")) {

            var options = {

                success: function (data) {
                    alert("모든 데이터가 업로드 되었습니다.");

                },
                type: "POST"
            };

            $("#frm").ajaxSubmit(options);
        }
    }

    function checkFileType(filePath) {
        var fileFormat = filePath.split(".");

        if (fileFormat.indexOf("xls") > -1 || fileFormat.indexOf("xlsx") > -1) {
            return true;
        } else {
            return false;
        }
    }
</script>
</body>
</html>
