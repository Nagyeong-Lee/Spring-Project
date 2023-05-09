<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-24
  Time: 오후 5:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>상품 등록</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.4.1.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
    <script src="https://malsup.github.io/jquery.form.js"></script>
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
    <style>
        .registerFrm{
            text-align: center;
            margin-top: 50px;
        }
        .registerFrm *{
            text-align: center;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<div class="registerFrm">
    <form action="/product/addPd" method="post" enctype="multipart/form-data" id="frm">
        <div>상품명 : <input type="text" id="name" name="name"></div>
        <div>상품 설명 : <input type="text" id="description" name="description"></div>
        <div>가격 : <input type="number" min="1" id="price" name="price"></div>
        <div id="cnt">재고 : <input type="number" min="1" id="stock" name="stock"></div>
        <%--        <div>이미지 : <input type="file" id="img" name="img"></div>--%>
        <%--        <img src="" style="width: 200px; height: 200px;"--%>
        <%--             id="pdImg">--%>
        <input type="file" id="img" name="img"><br>
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
        <div class="optBtn">
            <button type="button" id="addOption" class="btn btn-light">옵션 추가</button>
        </div>

        <button type="button" id="addPdBtn" class="btn btn-light">상품 등록</button>
        <button type="button" id="reset" class="btn btn-light">초기화</button>
<%--        <button type="button" id="toList">관리자 메인페지로</button>--%>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>
    let key = 0;

    //사진 확장자 체크
    let extension = true;
    $("#img").on("change", function () {
        var str = $(this).val();
        var fileName = str.split('\\').pop().toLowerCase();
        $("#img_name").val(fileName);
        checkFileName(fileName);
        readURL(this);

        var html = '<img src="" style="width: 200px; height: 200px;"id="pdImg">';
        $("#cnt").after(html);
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

    //사진 미리보기
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#pdImg').attr('src', e.target.result);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    //옵션 추가 클릭 시
    $("#addOption").on("click", function () {
        let optionBox = '<div class="optionBox" style="text-align: center;">카테고리 : <input type="text" class="optionCategory" ><br>이름 : <input type="text" class="optionName"><br>재고: <input type="number" min="1" class="optionStock"><br><button type="button" class="delBtn btn btn-light" onclick="remove(' + key + ')">삭제</button><button type="button" class="addOptionBtn btn btn-light">추가하기</button></div><br>';
        $(".optBtn").after(optionBox);
    });

    var optionArr = [];
    var testArray = new Array(); //map이 form으로 안넘어가서 object변경하고 배열담아야함

    //추가 클릭 시
    $(document).on("click", ".addOptionBtn", function () {

        let $this = $(this);
        let optionCategory = $(this).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(this).closest(".optionBox").find(".optionName").val();
        let optionStock = $(this).closest(".optionBox").find(".optionStock").val();
        if (optionCategory.length != 0 && optionName.length != 0 && optionStock.length != 0) {
            let map = new Map();
            map.set("key", key);
            map.set("category", optionCategory);
            map.set("name", optionName);
            map.set("stock", optionStock);
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
        alert("옵션 추가 완료");
        key++;
    });

    function remove(key) {
        let newArr = [];
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

    //관리자 메인으로
    // $("#toList").click(function () {
    //     location.href = '/admin/main';
    // });

    var tmp = 0;
    //상품 등록 버튼 클릭 시
    $("#addPdBtn").on("click", function () {

        let optStockSum = 0;
        console.log($(".optionBox").length);
        for (let i = 0; i < $(".optionBox").length; i++) {
            let optionBox = $(".optionBox")[i];
            let optionStock = $(optionBox).find(".optionStock")[0];
            let optionCategory = $(optionBox).find(".optionCategory")[0];
            console.log("optionCategory");
            console.log($(optionCategory).val());
            console.log($(optionStock).val());
            optStockSum += Number($(optionStock).val());
            console.log('옵션 재고 : ');
            console.log(optionStock);
        }
        console.log("optStockSum");
        console.log(optStockSum);

        let pdStock = $("#stock").val(); //상품 재고
        // //상품재고보다 옵션재고 많을때
        // if (optStockSum > Number(pdStock)) {
        //     alert('옵션 재고가 상품 재고보다 많을 수 없습니다.');
        //     return;
        // }

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
        data.append("category1", category1);
        data.append("category2", category2);
        data.append("option", JSON.stringify(testArray));
        data.append("img", img);

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
                    location.href = '/admin/registeredPd';
                }
            }
        });
    });
</script>
</body>
</html>