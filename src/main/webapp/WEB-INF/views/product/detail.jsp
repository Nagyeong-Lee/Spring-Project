<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-17
  Time: 오후 6:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>

    <title>상품 상세</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>

<div class="productDetail">
    <div class="img">
        <img src="/resources/img/products/${productDTO.img}" class="img">
    </div>
    <div class="productInfo">
        상품명 : ${productDTO.name}<br>
        상품 소개 : ${productDTO.description}<br>
        가격 : <fmt:formatNumber value="${productDTO.price}" type="number"/>원<br>
        재고 : <span id="totalStock">${productDTO.stock}</span>개
    </div>
</div>

<input type="hidden" value="${id}" id="id" name="id">
<input type="hidden" value="${productDTO.pd_seq}" id="pd_seq" name="pd_seq">
<input type="hidden" value="${productDTO.stock}" id="originalTotalStock" >

<c:choose>
    <c:when test="${!empty optionList}">
        <c:forEach var="i" items="${optionList}" varStatus="status">
            <select name="${i.key}">
                <option value="option" class="option">--option--</option>
                <c:forEach var="k" items="${i.value}">
                    <c:choose>
                        <c:when test="${k.status eq 'N'}"> <%--품절일때--%>
                            <option value="${k.name}" disabled="disabled">${k.name}(${k.stock})</option>
                        </c:when>
                        <c:otherwise>
                            <option value="${k.name}">${k.name}(${k.stock})</option>
                            <%--                ${i.value.get(0).name}--%>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </select>
        </c:forEach>
    </c:when>
</c:choose>

<div class="count">
    <input type="text" style="width: 40px;" value="0" id="count" readonly>
    <button style="width: 20px;" id="plus">+</button>
    <button style="width: 20px;" id="minus">-</button>
    <button type="button" id="addItems">담기</button>
</div>


<hr>
<div class="price">

</div>

<button type="button" id="back">목록으로</button>

<form id="frm" method="post" action="/product/cart">
    <input type="hidden" name="id" value="${id}" id="sessionId">
</form>

<script>

    var optionCount = 0;
    var changFlag=false;
    //카테고리 개수 가져오는 함수
    $("select").change(function () {
        optionCount = $("select option:selected").text();
        console.log(optionCount);
        // console.log($("select option:selected").text()); //text값 가져오기
        //옵션 변경 시 초기화
        $("#count").val(0);
        $("#totalStock").text($("#originalTotalStock").val());
        changFlag=true;

    });


    //수량 +
    $("#plus").click(async function () {
        let str = optionCount;
        if(str==0){
            alert('옵션을 먼저 선택해주세요');
            return;
            // console.log('index : '+str.indexOf("--option--"))
        }
        let numbers = str.match(/\d+/g);
        // console.log(numbers); // ["40", "50"]
        let count = parseInt($("#count").val());

        //옵션 모두 선택하게


        let integerArray = [];
        for (let i = 0; i < numbers.length; i++) {
            integerArray.push(parseInt(numbers[i]));
        }
        // console.log(integerArray);
        // console.log("count : " + count);

        //제일 작은 값 구하기
        let min = Math.min.apply(Math, integerArray);
        // console.log(min);

        if (count >= 0 && count < min) {
            count++
            $("#count").val(count);
            // console.log("count : " + count);
            //총 수량 -
            let totalStock = parseInt($("#totalStock").text());
            totalStock--;
            // console.log(totalStock);
            console.log("totalStock : "+totalStock);
            // if (totalStock >= 0) { //전체 수량 0개일때
            //     alert('구매가 불가능한 상품입니다.');
            // } else {
                $("#totalStock").text(totalStock);
            // }
        } else if (!(count >= 0 && count < min)) {
            alert('개수를 다시 선택해주세요');
        }
    });

    //수량 -
    $("#minus").click(async function () {
        let str = optionCount;
        if(str==0){
            alert('수량은 1개 이상 선택 가능합니다.');
            return;
            // console.log('index : '+str.indexOf("--option--"))
        }
        let numbers = str.match(/\d+/g);
        // console.log(numbers); // ["40", "50"]s
        let count = parseInt($("#count").val());

        let integerArray = [];
        for (let i = 0; i < numbers.length; i++) {
            integerArray.push(parseInt(numbers[i]));
        }
        // console.log(integerArray);

        //제일 작은 값 구하기
        let min = Math.min.apply(Math, integerArray);
        // console.log(min);
        if (count == 0) {
            alert('수량을 1개 이상 선택해주세요.');
        } else if (count >= 0) {
            count--
            $("#count").val(count);
            // console.log("count : " + count);
            //총 수량 +
            let totalStock = parseInt($("#totalStock").text());
            totalStock++;
            console.log("- totalStock : "+totalStock);
            // if (totalStock > parseInt($("#totalStock").text())) { //원래 전체 수량 보다 많을때
            //     alert('구매가능한 수량이 아닙니다.');
            // } else {
                $("#totalStock").text(totalStock);
            // }
        }
    });

    $("#addItems").on("click", function () {
        let test=false;
        if(changFlag == false){
            alert('옵션을 선택해주세요.');
            return;
        }

        let str = optionCount;
        console.log("str : "+str);
        if(str.indexOf("--option--") != -1){
            alert('옵션을 모두 선택해주세요');
            return;
            // console.log('index : '+str.indexOf("--option--"))
        }

        if($("#count").val() == 0){ //수량 0일때
            alert('수량을 1개 이상 선택해주세요.');
            return;
        }

        let regex = /([A-Z]+\(\d+\))/g;
        let numbers = str.match(regex);
        console.log(numbers); //
        let count = parseInt($("#count").val());
        let integerArray2 = [];
        for (let i = 0; i < numbers.length; i++) {
            integerArray2.push(numbers[i]);
        }
        let cnt=$("#count").val(); //수량
        let id=$("#id").val(); //아이디
        let pd_seq=$("#pd_seq").val(); //상품 seq
        console.log("count : "+count);
        console.log("id : "+id);
        console.log("pd_seq : "+pd_seq);
        console.log(integerArray2);

        $.ajax({
           url:'/product/addProduct',
           type:'post',
           data:{
               "count":cnt,
               "id":id,
               "pd_seq":pd_seq,
               "optionList" : integerArray2.toString()
           },
           success:function(data){
               console.log("data : "+data);
               if(data == 'success'){
                   alert('상품을 장바구니에 추가했습니다.');
                   $("#frm").submit();
                   // location.href = "/product/cart";
               }
           }
        });
        //장바구니 db 저장
        //옵션들 -1
        //총 수량 -1
        //만약 수량이 0이면 N처리
        //만약 옵션 수량이 0이면 N처리
    });

    $("#cart").on("click", function () { //장바구니 클릭

    });

    $("#back").on("click", function () {
        history.back();
    });

</script>
</body>
</html>