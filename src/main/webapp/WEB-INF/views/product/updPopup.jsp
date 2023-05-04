<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-04
  Time: 오후 1:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>배송지 수정</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
</head>
<body>
<input type="hidden" value="${id}" id="id" name="id">
<input type="hidden" value="${deliDTO.seq}" id="seq" name="seq">
<form action="/product/addDeli" method="post" id="frm">
  <div>이름 <input type="text" name="name" id="name" value="${deliDTO.name}"></div>
  <div>번호 <input type="text" name="phone" id="phone" value="${deliDTO.phone}"></div>
  <div>주소 <input type="text" name="address" id="address" value="${deliDTO.address}"></div>
  <div>별칭 <input type="text" name="nickname" id="nickname" value="${deliDTO.nickname}"></div>
  <div>기본 여부 <input type="checkbox" name="default" id="default"<c:out value="${deliDTO.status eq 'Y'? 'checked' : ''}"/>></div>
  <div>
    <button type="button" id="sbn">수정</button>
    <button type="button" id="close">취소</button>
  </div>
</form>

<script>
  // $("#frm").onsubmit(function () {
  //     window.close();
  // });
  //수정 클릭 시
  $("#sbn").on("click",function(){

    let regexName = /^[가-힣]{2,5}$/;
    let regexPhone = /^010\d{4}\d{4}$/;

    let name = $("#name").val();
    let phone = $("#phone").val();
    let address =$("#address").val();
    let nickname =$("#nickname").val();
    let flag = $("#default").is(':checked');  //기본 주소 체크 여부
    let id = $("#id").val();
    let seq = $("#seq").val();
    if(flag == true){
      $("#default").val(1);
    }else{
      $("#default").val(0);
    }
    if (name == '') {
      alert("이름을 입력해주세요.");
      return false;
    }

    if (regexName.test(name) == false) {
      alert("이름 형식이 맞지 않습니다.");
      return false;
    }

    if (phone == '') {
      alert("전화번호를 입력해주세요.");
      return false;
    }

    //전화번호 유효성
    if (regexPhone.test(phone) == false) {
      alert("전화번호 형식이 맞지 않습니다.");
      return false;
    }

    if (address == '') {
      alert("주소를 입력해주세요.");
      return false;
    }

    if (nickname == '') {
      alert("별칭을 입력해주세요.");
      return false;
    }

    $.ajax({
      url:'/product/updDelivery',
      type:'post',
      data:{
        "name":name,
        "phone":phone,
        "address":address,
        "nickname":nickname,
        "def":flag,
        "id":id,
        "seq":seq
      },
      success:function(data){
        if(data == 'success'){
          console.log(data);
          alert('배송지 수정 완료');
          window.close();
          opener.parent.location.reload();
        }
      }
    })

  })

  $("#close").click(function(){
    window.close();
  })
</script>
</body>
</html>
