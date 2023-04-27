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
    <input type="hidden" value="${map.productDTO.pd_seq}" id="pd_seq">
    <h3>상품 수정</h3>
    <form action="/product/addPd" method="post" enctype="multipart/form-data" id="frm">
        <div>상품명 : <input type="text" id="name" name="name" value="${map.productDTO.name}"></div>
        <div>상품 설명 : <input type="text" id="description" name="description" value="${map.productDTO.description}"
        ></div>
        <div>가격 : <input type="number" min="1" id="price" name="price" value="${map.productDTO.price}"
        ></div>
        <div>재고 : <input type="number" min="1" id="stock" name="stock" value="${map.productDTO.stock}"
        ></div>
        <div>
            <img src="/resources/img/products/${map.productDTO.img}" style="width: 200px; height: 200px;"
                 id="pdImg"><br>
            <input type="file" id="img" name="img"><br>
        </div>
        <input type="hidden" id="img_name" name="img_name">

        <div id="mainCategory">
            <select name="category1" id="category1">
                <option value="여성" <c:out value="${map.pdMainCategory eq '여성' ? 'selected' : ''}"/>>여성</option>
                <option value="남성" <c:out value="${map.pdMainCategory eq '남성' ? 'selected' : ''}"/>>남성</option>
                <option value="신상품"<c:out value="${map.pdMainCategory eq '신상품' ? 'selected' : ''}"/>>신상품</option>
            </select>
        </div>
        <div id="subCategory">
            <select name="category2" id="category2">
                <option value="아우터"<c:out value="${map.pdSubCategory eq '아우터' ? 'selected' : ''}"/>>아우터</option>
                <option value="상의"<c:out value="${map.pdSubCategory eq '상의' ? 'selected' : ''}"/>>상의</option>
                <option value="하의"<c:out value="${map.pdSubCategory eq '하의' ? 'selected' : ''}"/>>하의</option>
                <option value="악세사리"<c:out value="${map.pdSubCategory eq '악세사리' ? 'selected' : ''}"/>>악세사리</option>
            </select>
        </div>

        <div class="btn">
            <button type="button" id="addOption">옵션 추가</button>
        </div>

        <c:choose>
            <c:when test="${!empty map.optionDTOList}">
                <c:forEach var="i" items="${map.optionDTOList}">
                    <div class="optionBox">카테고리 : <input type="text" class="optionCategory" value="${i.category}"
                    ><br>
                        이름 : <input type="text" class="optionName" value="${i.name}"><br>
                        재고:<input type="number" min="1" class="optionStock" value="${i.stock}">
                        <button type="button" class="delBtn" onclick="remove(${i.option_seq},this)">삭제</button>
                            <%--                        <button type="button" class="addOptionBtn">수정하기</button>--%>
                        <button type="button" class="updOptionBtn" onclick="update(${i.option_seq},this)">수정하기</button>
                    </div>
                    <br>
                </c:forEach>
            </c:when>
        </c:choose>

        <button type="button" id="updBtn">상품 수정하기</button>
        <button type="button" id="reset">취소</button>
        <button type="button" id="toList">목록으로</button>
    </form>
</div>

<script>

    //삭제 클릭 시
    $(document).on("click", ".delBtn", function () {
        $(this).closest(".optionBox").remove();
        let optionCategory = $(this).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(this).closest(".optionBox").find(".optionName").val();
        let optionStock = $(this).closest(".optionBox").find(".optionStock").val();
        console.log(optionCategory);
        console.log(optionName);
        console.log(optionStock);

    });

    let key = -1;
    $("#img").on("change", function () {
        //사진 확장자 체크
        var str = $(this).val();
        var fileName = str.split('\\').pop().toLowerCase();
        $("#img_name").val(fileName);
        console.log($("#img_name").val());
        checkFileName(fileName);

        //이미지 미리보기
        readURL(this);
    });

    let extension = true;

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

    var deleteOpt = []; //삭제할 옵션 배열
    var updOpt = []; //수정한 옵션 배열
    // var newOpt = [];//새로 추가한 옵션 배열
    // 옵션 새로 추가


    //옵션 수정
    function update(key, e) {
        console.log('업데이트');
        console.log('key : ' + key);
        let optionCategory = $(e).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(e).closest(".optionBox").find(".optionName").val();
        let optionStock = $(e).closest(".optionBox").find(".optionStock").val();

        console.log(optionCategory);
        console.log(optionName);
        console.log(optionStock);

        let map = new Map();
        map.set("key", key);
        map.set("category", optionCategory);
        map.set("name", optionName);
        map.set("stock", optionStock);
        updOpt.push(map);
        alert('옵션 수정 완료');
    }

    $(document).on("click", ".delBtn", function () {
        $(this).closest(".optionBox").remove();
    });

    //옵션 삭제 키워드
    function remove(key, e) {
        console.log('key : ' + key);
        let optionCategory = $(e).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(e).closest(".optionBox").find(".optionName").val();
        let optionStock = $(e).closest(".optionBox").find(".optionStock").val();

        let map = new Map();
        map.set("key", key);
        map.set("category", optionCategory);
        map.set("name", optionName);
        map.set("stock", optionStock);
        deleteOpt.push(map);

        $(e).closest(".optionBox").remove();
    }

    //옵션 추가 클릭 시
    $("#addOption").on("click", function () {
        let optionBox = '<div class="optionBox">카테고리 : <input type="text" class="optionCategory" ><br>이름 : <input type="text" class="optionName"><br>재고: <input type="number" min="1" class="optionStock"><button type="button" class="delBtn" onclick="remove(' + key + '),this">삭제</button><button type="button" class="addOptionBtn">추가하기</button></div><br>';
        $(".btn").after(optionBox);
    });

    var optionArr = [];
    var testArray = new Array(); //삭제할 옵션 //map이 form으로 안넘어가서 object변경하고 배열담아야함
    var testArray2 = new Array(); //수정할 옵션
    var testArray3 = new Array(); //새로운 옵션

    //추가 클릭 시
    $(document).on("click", ".addOptionBtn", function () {
        let optionCategory = $(this).closest(".optionBox").find(".optionCategory").val();
        let optionName = $(this).closest(".optionBox").find(".optionName").val();
        let optionStock = $(this).closest(".optionBox").find(".optionStock").val();

        console.log(optionCategory);
        console.log(optionName);
        console.log(optionStock);

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
        console.log(optionArr);
        key--;
    });

    //초기화 클릭 시
    $("#reset").click(function () {
        location.reload();
    });

    //목록으로
    $("#toList").click(function () {
        location.href = '/admin/registeredPd';
    });

    //상품 수정하기 클릭 시
    $("#updBtn").on("click", function () {

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
        //상품재고보다 옵션재고 많을때
        // if(optStockSum>Number(pdStock)){
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
        // if ($("#img").val().length == 0) {
        //     alert('이미지를 추가해주세요');
        //     return;
        // }
        //파일 확장자 안맞을때
        if (extension == false) {
            return false;
        }

        // 삭제한 옵션 배열
        for (let i = 0; i < deleteOpt.length; i++) {
            var param = Object.fromEntries(deleteOpt[i]);
            testArray.push(param);
        }

        // 수정한 옵션 배열
        for (let i = 0; i < updOpt.length; i++) {
            var param1 = Object.fromEntries(updOpt[i]);
            testArray2.push(param1);
        }

        // 새로 추가한 옵션 배열
        for (let i = 0; i < optionArr.length; i++) {
            var param3 = Object.fromEntries(optionArr[i]);
            testArray3.push(param3);
        }

        let name = $("#name").val();
        let description = $("#description").val();
        let price = $("#price").val();
        let stock = $("#stock").val();
        let img = $("#img_name").val();
        let category1 = $("#category1 option:selected").val();
        let category2 = $("#category2 option:selected").val();

        console.log(name);
        console.log(description);
        console.log(price);
        console.log(stock);
        console.log(img);
        console.log(category1);
        console.log(category2);

        let frm = $('#frm')[0];
        let data = new FormData(frm);
        data.append("pd_seq", $("#pd_seq").val()); //상품 seq
        data.append("name", name);
        data.append("description", description);
        data.append("price", price);
        data.append("stock", stock);
        data.append("img", img);
        data.append("category1", category1);
        data.append("category2", category2);
        data.append("deleteOpt", JSON.stringify(testArray));  //삭제할 옵션
        data.append("updOpt", JSON.stringify(testArray2));    //수정할 옵션
        data.append("newOpt", JSON.stringify(testArray3));    //새로운 옵션

        $.ajax({
            url: "/product/updProduct"
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
                    alert('상품 수정이 완료되었습니다.');
                    location.href = '/admin/registeredPd';
                }
            }
        });

    });
</script>
</body>
</html>
