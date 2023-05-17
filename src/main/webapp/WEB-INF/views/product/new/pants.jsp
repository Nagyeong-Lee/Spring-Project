<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>신상 하의</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
<%--  link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
  <!-- Bootstrap icons-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
  <!-- Core theme CSS (includes Bootstrap)-->
  <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
</head>
<body>
<input type="hidden" value="${keyword}" id="key" name="key">
<%--<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>--%>
<%@ include file="/WEB-INF/views/product/pdListUtil.jsp"%>

<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>

  $("#keyword").val($("#key").val());

  $("#search").on("click",function(){
    let keyword = $("#keyword").val();
    location.href='/product/searchPd?keyword='+keyword;
  });

  $("#cart").click(function(){
    let newForm = document.createElement("form");
    newForm.setAttribute("method","post");
    newForm.setAttribute("action","/product/cart");
    let newInput = document.createElement("input");
    newInput.setAttribute("type","hidden");
    newInput.setAttribute("name","id");
    newInput.setAttribute("value",$("#id").val());
    newForm.appendChild(newInput);
    document.body.append(newForm);
    newForm.submit();
  })
</script>
</body>
</html>
