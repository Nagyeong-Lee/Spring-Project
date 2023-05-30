<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-24
  Time: 오후 3:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>교환 승인 팝업</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.css" rel="stylesheet">
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/js/all.min.js"></script>
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
    <style>
        .popup {
            margin-top: 50px;
            text-align: center;
        }

        input {
            white-space: pre-line;
        }

        h5 {
            margin-top: 30px;
            margin-bottom: 30px;
            text-align: center;
        }

        img {
            width: 100px;
            height: 100px;
        }

        textarea {
            width: 300px;
            height: 100px;
        }
        .popup{
            margin-top: 100px;
            text-align: center;
        }
    </style>
</head>
<body>
<input type="hidden" value="${payPd_seq}" id="payPd_seq" name="payPd_seq">
<input type="hidden" value="${refund_seq}" id="refund_seq" name="refund_seq">
<h5>교환 승인</h5>
<div class="popup">
<form action="/admin/apprRefund" method="post">
    송장번호 : <input type="text" name="invoiceNum" id="invoiceNum" maxlength="13"><br>
    <c:if test="${!empty courierDTOS}">
        <select name="courier">
            <c:forEach items="${courierDTOS}" var="i">
                <option value="${i.name}">${i.name}</option>
            </c:forEach>
        </select>
    </c:if><br>

    <button type="button" id="approveBtn" class="btn btn-light">승인</button>
    <button type="button" id="cancleBtn" class="btn btn-light">취소</button>
</form>
</div>

<script>
    $("#cancleBtn").click(function () {
        window.close();
    })

    var flag = false;
    //택배 옵션 선택
    $("select").on("change", function () {
        flag = true;
        let checkedName = $("select option:checked").val();
    });

    $("#approveBtn").click(function () {
        let name = $("select option:checked").val();
        let invoiceNum = $("#invoiceNum").val();
        const regex = /^\d{13}$/
        if (invoiceNum.length === 0) {
            alert('송장번호를 입력해주세요.');
            return false;
        }
        if (regex.test(invoiceNum) === false) {
            alert('송장번호 형식이 아닙니다.');
            return false;
        } else {
            $.ajax({
                url: '/admin/appreExchg',
                type: 'post',
                data: {
                    "courier": name,
                    "payPd_seq": $("#payPd_seq").val(),
                    "invoiceNum": invoiceNum,
                    "refund_seq":$("#refund_seq").val()
                },
                success: function (data) {
                    if (data === 'success') {
                        window.close();
                        opener.parent.location.reload();
                    }
                }
            })
        }
    });
</script>
</body>
</html>