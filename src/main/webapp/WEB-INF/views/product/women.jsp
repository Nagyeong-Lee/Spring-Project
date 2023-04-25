<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 9:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>여성 상품</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>
<%@ include file="/WEB-INF/views/product/pdListUtil.jsp"%>
<script>
    function toCart(){
        let newForm = document.createElement("form");
        newForm.setAttribute("method","post");
        newForm.setAttribute("action","/product/cart");
        let newInput = document.createElement("input");
        newInput.setAttribute("type","hidden");
        newInput.setAttribute("name","id");
        newInput.setAttribute("value",$("#session").val());
        newForm.appendChild(newInput);
        document.body.append(newForm);
        newForm.submit();
    }
</script>
</body>
</html>
