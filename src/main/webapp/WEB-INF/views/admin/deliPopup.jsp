<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-09
  Time: 오후 5:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>배송상태 변경</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
  <style>
    .popup{
      margin-top: 100px;
      text-align: center;
    }
  </style>

  <script>
    $(function(){
      $("#close").click(function(){
        window.close();
      });

      var flag = false;
      //택배 옵션 선택
      $("select").on("change",function(){
        flag= true;
        let checkedName = $("select option:checked").val();
        console.log(checkedName);
      });

      //변경 클릭시
      $("#sbn").on("click",function(){
        let name = $("select option:checked").val();
        $.ajax({
          url:'/product/chgDeliveryStatus',
          type:'post',
          data:{
            "courier":name,
            "sales_seq":$("#sales_seq").val()
          },
          success:function(data){
            console.log(data);
            if(data == 'success'){
              window.close();
              opener.parent.location.reload();
            }
          }
        })
      });
    })
  </script>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<div class="popup">
  <form action="/product/chgDeliveryStatus" method="post" id="frm">
    <input type="hidden" value="${sales_seq}" name="sales_seq" id="sales_seq">
    <c:if test="${!empty courierDTOS}">
      <select name="courier">
        <c:forEach items="${courierDTOS}" var="i">
          <option value="${i.name}">${i.name}</option>
        </c:forEach>
      </select>
    </c:if>
    <div>
      <button type="button" id="sbn">변경</button> <%--배송중으로 변경--%>
      <button type="button" id="close">취소</button>
    </div>
  </form>
</div>
</body>
</html>
