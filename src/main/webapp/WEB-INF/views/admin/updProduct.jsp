<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-25
  Time: 오후 6:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>상품 수정</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
</head>
<body>
<div>
    <h3>상품 수정</h3>
    <form action="/product/addPd" method="post" enctype="multipart/form-data" id="frm">
        <div>상품명 : <input type="text" id="name" name="name" value="${map.productDTO.name}" readonly="readonly"></div>
        <div>상품 설명 : <input type="text" id="description" name="description" value="${map.productDTO.description}"
                            readonly="readonly"></div>
        <div>가격 : <input type="number" min="1" id="price" name="price" value="${map.productDTO.price}"
                         readonly="readonly"></div>
        <div>재고 : <input type="number" min="1" id="stock" name="stock" value="${map.productDTO.stock}"
                         readonly="readonly"></div>
        <div>이미지 : <input type="file" id="img" name="img" value="${map.productDTO.img}"></div>
        <input type="hidden" id="img_name" name="img_name">
        카테고리
        <div id="mainCategory">
            <select name="category1" id="category1">
                <option value="여성">여성</option>
                <option value="남성">남성</option>
                <option value="신상품">신상품</option>
            </select>
        </div>
        <div id="subCategory">
            <select name="category2" id="category2">
                <option value="아우터">아우터</option>
                <option value="상의">상의</option>
                <option value="하의">하의</option>
                <option value="악세사리">악세사리</option>
            </select>
        </div>
        <c:choose>
            <c:when test="${!empty map.optionDTOList}">
                <c:forEach var="i" items="${map.optionDTOList}">
                    <div class="optionBox">카테고리 : <input type="text" class="optionCategory"><br>
                    이름 : <input type="text" class="optionName"><br>
                    재고:<input type="number" min="1" class="optionStock">
                    <button type="button" class="delBtn" onclick="remove(' + key + ')">삭제</button>
                    <button type="button" class="addOptionBtn">추가하기</button>
                    </div><br>;
                </c:forEach>
            </c:when>
        </c:choose>
        <div class="btn">
            <button type="button" id="addOption">옵션 추가</button>
        </div>

        <button type="button" id="updBtn">상품 수정하기</button>
        <button type="button" id="reset">취소</button>
    </form>
</div>

<script>
    let key = 0;

    //사진 확장자 체크
    let extension = true;
    $("#img").on("change", function () {
        var str = $(this).val();
        var fileName = str.split('\\').pop().toLowerCase();
        $("#img_name").val(fileName);
        console.log($("#img_name").val());
        checkFileName(fileName);
    });

    function checkFileName(str) {
        //1. 확장자 체크
        var ext = str.split('.').pop().toLowerCase();
        if ($.inArray(ext, ['jpg', 'png', 'jpeg']) == -1) {
            alert('jpg, png, jpeg 파일만 업로드 가능합니다.');
            $("#img").val('');
            extension = false;
        } else {
            extension = true;
            return;
        }
    }

    //옵션 추가 클릭 시
    $("#addOption").on("click", function () {
        let optionBox = '<div class="optionBox">카테고리 : <input type="text" class="optionCategory" ><br>이름 : <input type="text" class="optionName"><br>재고: <input type="number" min="1" class="optionStock"><button type="button" class="delBtn" onclick="remove(' + key + ')">삭제</button><button type="button" class="addOptionBtn">추가하기</button></div><br>';
        $(".btn").after(optionBox);
    });

    var optionArr = [];
    var testArray = new Array(); //map이 form으로 안넘어가서 object변경하고 배열담아야함

    //추가 클릭 시
    $(document).on("click", ".addOptionBtn", function () {
        // let arr = [];
        $(this).hide();
        let optionCategory = $(this).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(this).closest(".optionBox").find(".optionName").val();
        let optionStock = $(this).closest(".optionBox").find(".optionStock").val();
        if (optionCategory.length != 0 && optionName.length != 0 && optionStock.length != 0) {
            let map = new Map();
            map.set("key", key);
            map.set("category", optionCategory);
            map.set("name", optionName);
            map.set("stock", optionStock);
            // arr.push(map);
            optionArr.push(map);
        } else {
            if (optionCategory.length == 0) {
                alert('옵션 카테고리를 입력해주세요');
                return;
            }
            if (optionName.length == 0) {
                alert('옵션 이름을 입력해주세요');
                return;
            }
            if (optionStock.length == 0) {
                alert('옵션 재고를 숫자로 입력해주세요');
                return;
            }
        }
        console.log(optionArr);
        key++;
    });

    function remove(key) {
        //let splice = optionArr.splice(key, 1);
        let newArr = [];
        console.log(optionArr.length)
        for (let i = 0; i < optionArr.length; i++) {
            console.log(optionArr[i]);
            console.log(optionArr[i].get('key'));
            if (optionArr[i].get('key') != key) {
                newArr.push(optionArr[i]);
            }
        }
        optionArr = newArr;
        console.log(JSON.stringify(optionArr));
    }

    //삭제 클릭 시
    $(document).on("click", ".delBtn", function () {
        $(this).closest(".optionBox").remove();
        let optionCategory = $(this).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(this).closest(".optionBox").find(".optionName").val();
        let optionStock = $(this).closest(".optionBox").find(".optionStock").val();
    });

    //초기화 클릭 시
    $("#reset").click(function () {
        location.reload();
    });

    //상품 등록 버튼 클릭 시
    $("#addPdBtn").on("click", function () {

        if ($("#name").val().length == 0) {
            alert('상품명을 입력하세요');
            return;
        }
        if ($("#description").val().length == 0) {
            alert('상품 설명을 입력하세요');
            return;
        }
        if ($("#price").val().length == 0) {
            alert('가격을 입력하세요');
            return;
        }
        if ($("#stock").val().length == 0) {
            alert('재고를 숫자로 입력하세요');
            return;
        }
        if ($("#img").val().length == 0) {
            alert('이미지를 추가해주세요');
            return;
        }
        //파일 확장자 안맞을때
        if (extension == false) {
            return false;
        }

        for (let i = 0; i < optionArr.length; i++) {
            var param = Object.fromEntries(optionArr[i]);
            testArray.push(param);
        }

        console.log("testARR");
        console.log(testArray);

        let name = $("#name").val();
        let description = $("#description").val();
        let price = $("#price").val();
        let stock = $("#stock").val();
        let img = $("#img_name").val();
        let category1 = $("#category1 option:selected").val();
        let category2 = $("#category2 option:selected").val();


        let frm = $('#frm')[0];
        let data = new FormData(frm);
        data.append("name", name);
        data.append("description", description);
        data.append("price", price);
        data.append("stock", stock);
        data.append("img", img);
        data.append("category1", category1);
        data.append("category2", category2);
        data.append("option", JSON.stringify(testArray));

        $.ajax({
            url: "/product/addPd"
            , type: "POST"
            , enctype: 'multipart/form-data'
            , data: data
            , processData: false
            , contentType: false
            , cache: false
            , isModal: true
            , isModalEnd: true
            , success: function (data) {
                if (data === 'success') {
                    alert('상품 등록이 완료되었습니다.');
                    location.reload();
                }
            }
        });
    });


    //상품 수정하기
    $("#updBtn").on("click", function () {
        let completeBtn = '<button type="button" id="completeBtn">수정완료</button>';
        $(this).remove();
        $("#reset").before(completeBtn);
    });
</script>
</body>
</html>
