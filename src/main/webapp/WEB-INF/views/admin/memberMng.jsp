<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-03-29
  Time: 오전 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>회원 관리</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <%--chart.js--%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.2.1/dist/chart.umd.min.js"></script>
</head>
<body>
회원 리스트
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
                    <td><fmt:formatDate pattern="YYYY-MM-dd hh:mm" value="${i.signup_date}"/></td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <td>회원이 존재하지 않습니다.</td>
        </c:otherwise>
    </c:choose>
</table>

<button type="button" id="downloadBtn">Excel Download</button>
<form action="/admin/upload" enctype="multipart/form-data" method="post" id="frm">
    <input type="file" id="fileExcel" name="fileExcel">
    <button type="submit" id="uploadBtn">Excel Upload</button>
</form>

<script>

    let id = $("#session").val();
    let path = $("#toLogOut").val();

    $("#downloadBtn").on("click", function () {
        location.href = "/admin/download";
    });

    $("#logout").on("click", function () {
        location.href = path + id;
    });

    function checkFileType(filePath) {
        var fileFormat = filePath.split(".");

        if (fileFormat.indexOf("xls") > -1 || fileFormat.indexOf("xlsx") > -1) {
            return true;
        } else {
            return false;
        }
    }

    var option = {
        url: "/admin/upload",
        TYPE: "POST",
        success: function (res) {
            if (res == "success") {
                alert('업로드 성공');
            } else {
                alert('업로드 실패');
            }
        }
    }

    $("#frm").submit(function () {
        var file = $("#fileExcel").val();

        if (file == "" || file == null) {
            alert("파일을 선택해주세요.");
            return false;
        } else if (!checkFileType(file)) {
            alert("엑셀 파일만 업로드 가능합니다.");
            $("#fileExcel").val('');
            return false;
        }
        $(this).ajaxSubmit(option); //옵션값대로 ajax비동기 동작을 시키고
        return false; //기본 동작인 submit의 동작을 막아 페이지 reload를 막는다.
    });
</script>
</body>
</html>
