<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>남성 하의</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
  <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>
<%@ include file="/WEB-INF/views/product/pdListUtil.jsp"%>
<script>

  $("#search").on("click",function(){
    let keyword = $("#keyword").val();
    location.href='/product/searchPd?keyword='+keyword;
  });

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
