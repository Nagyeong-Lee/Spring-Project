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
        #footer {
            position: relative;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
            transform: translatY(-100%);
        }

        #wrapper {
            height: auto;
            min-height: 550px;
        }

        img {
            width: 300px;
            height: 300px;
        }

        .dashBoard {
            margin-top: 20px;
            text-align: center;
        }

        .reviewDiv, .QnADiv {
            margin-top: 50px;
            text-align: center;
        }

        h4 {
            font-weight: bold;
        }

        .reviewImg {
            width: 80px;
            height: 80px;
        }

        .reviewImg:hover {
            transform: scale(1.5, 1.5); /* 가로2배 새로 1.5배 로 커짐 */
        }

        #QnATable {
            text-align: center;
        }

        .content, .question.qText, .aText {
            width: 600px;
        }

        table {
            table-layout: fixed;
        }

        .question {
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }

        .qText, .aText {
            word-break: break-all
        }
    </style>
</head>
<body>
<input type="hidden" value="${keyword}" id="key" name="key">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<input type="hidden" value="${optionDTO.size()}" id="optionYN">
<div class="productDetail" style="text-align: center;">
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
<input type="hidden" value="${productDTO.stock}" id="originalTotalStock">

<c:choose>
    <c:when test="${!empty optionList}">
        <div style="margin-left: 1190px;">
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
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </c:forEach>
        </div>
    </c:when>
</c:choose>

<div class="count" style="margin-left: 1180px;">
    <input type="text" style="width: 40px;" value="0" id="count" readonly>
    <button style="width: 30px;" id="plus" class="btn btn-light">+</button>
    <button style="width: 30px;" id="minus" class="btn btn-light">-</button>
    <button type="button" id="addItems" class="btn btn-dark">담기</button>
</div>

<%--좋아요--%>
<button type="button" id="likeBtn" style="margin-left: 1250px;"><i class="far fa-thumbs-up" id="like"></i></button>
<button type="button" id="likeBtn2" style="margin-left: 1250px;"><i class="fas fa-thumbs-up" id="like2"></i></button>

<hr>

<button type="button" id="back" style="margin-left: 1150px;" class="btn btn-dark">상품 목록으로</button>
<button type="button" id="toCart" class="btn btn-dark">장바구니로</button>

<div class="dashBoard" style="text-align: center;">
    <c:if test="${!empty reviewInfoList}">
    <div>별점 평균 &nbsp
        <c:forEach var="star" begin="1" end="5">
            <c:set var="starColor" value="#ddd"/>
            <c:if test="${star le starAvg}">
                <c:set var="starColor" value="rgba(250, 208, 0, 0.99)"/>
            </c:if>
            <label for="1-star" id="star_${star}" class="startext">
                <i class="fa-solid fa-star" style="position:relative;color:${starColor};"></i>
            </label>
        </c:forEach>
        <div> 리뷰수 ${reviewCnt}개</div>
        </c:if>
    </div>

    <div class="dashBoardImgs">
        <c:if test="${!empty dashBoardImgs}">
            <c:forEach var="i" items="${dashBoardImgs}" varStatus="status">
                <c:if test="${status.count <= 10}">
                    <img src="/resources/img/products/pdReview/${i}" class="reviewImg">
                </c:if>
                <c:if test="${status.count == 11}">
                    &nbsp&nbsp ...
                </c:if>
            </c:forEach>
        </c:if>
    </div>
</div>

<%--리뷰 영역--%>
<div class="reviewDiv" id="wrapper">
    <h4>리뷰</h4>
    <c:choose>
        <c:when test="${!empty reviewInfoList}">
            <c:forEach var="i" items="${reviewInfoList}">
                ${i.reviewInPdDetail.ID}
                <c:forEach var="star" begin="1" end="5">
                    <c:set var="starColor" value="#ddd"/>
                    <c:if test="${star le i.reviewInPdDetail.STAR}">
                        <c:set var="starColor" value="rgba(250, 208, 0, 0.99)"/>
                    </c:if>
                    <label for="1-star" id="star_${star}" class="startext">
                        <i class="fa-solid fa-star" style="position:relative;color:${starColor};"></i>
                    </label>
                </c:forEach>
                <br>
                ${i.reviewInPdDetail.WRITEDATE}<br>
                <c:if test="${i.optionMapList != null}">
                    <c:forEach var="k" items="${i.optionMapList}">
                        <c:forEach var="j" items="${k}">
                            ${j.key} : ${j.value}&nbsp
                        </c:forEach>
                    </c:forEach>
                    ${i.reviewInPdDetail.STOCK}개
                </c:if><br>
                <c:if test="${i.imgSysname != null}">
                    <c:forEach var="k" items="${i.imgSysname}">
                        <img src="/resources/img/products/pdReview/${k}" class="reviewImg">
                    </c:forEach>
                </c:if>
                ${i.reviewInPdDetail.CONTENT}
                <hr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            리뷰가 없습니다.
        </c:otherwise>
    </c:choose>
</div>

<div class="QnADiv">
    <h4>Q&A</h4>
    <form action="/QnA/popup" method="post" id="qnaFrm" name="qnaFrm">
        <input type="hidden" value="${id}" id="loginID" name="loginID">
        <input type="hidden" value="${productDTO.pd_seq}" id="pdSeq" name="pdSeq">
        <button class="btn btn-light writeQnABtn" onclick="popup()" type="button">상품 Q&A 작성하기</button>
        <button class="btn btn-light myQnA" type="button">나의 Q&A 조회</button>
    </form>

    <table id="QnATable" class="table table-striped">
        <thead>
        <th>답변 상태</th>
        <th class="content">제목</th>
        <th>작성자</th>
        <th>작성일</th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty qNaList}">
                <c:forEach var="i" varStatus="status" items="${qNaList}">
                    <tr class="table-active">
                        <c:choose>
                            <c:when test="${!empty i.answerYN && i.answerYN == 'N'}">
                                <td>미답변</td>
                            </c:when>
                            <c:otherwise>
                                <td>답변 완료</td>
                            </c:otherwise>
                        </c:choose>
                        <td class="question">
                            <a href="javascript:void(0);"
                               onclick="openAnswer('${status.index}')">${i.questionDTO.content}</a>
                        </td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                    </tr>
                    <tr class="content_${status.index} content_tr" style="display: none;">
                        <td></td>
                        <td class="qText">${i.questionDTO.content}</td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                    </tr>
                    <c:if test="${i.answerYN == 'Y'}">
                        <tr class="content_${status.index} content_tr" style="display: none;">
                            <td></td>
                            <td class="aText">${i.answerDTO.answer}</td>
                            <td>${i.answerDTO.writer}</td>
                            <td>${i.answerDTO.writeDate}</td>
                        </tr>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="table-active">
                    <td colspan="4" class="table-active" style="text-align: center">Q&A가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>

<form id="frm" method="post" action="/product/cart">
    <input type="hidden" name="id" value="${id}" id="sessionId">
</form>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>

<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>
    $("#keyword").val($("#key").val());
    $("#search").on("click", function () {
        let keyword = $("#keyword").val();
        location.href = '/product/searchPd?keyword=' + keyword;
    });
    // function toCart(){
    //     let newForm = document.createElement("form");
    //     newForm.setAttribute("method","post");
    //     newForm.setAttribute("action","/product/cart");
    //     let newInput = document.createElement("input");
    //     newInput.setAttribute("type","hidden");
    //     newInput.setAttribute("name","id");
    //     newInput.setAttribute("value",$("#session").val());
    //     newForm.appendChild(newInput);
    //     document.body.append(newForm);
    //     newForm.submit();
    // }


    $("#cart").click(function () {
        let newForm = document.createElement("form");
        newForm.setAttribute("method", "post");
        newForm.setAttribute("action", "/product/cart");
        let newInput = document.createElement("input");
        newInput.setAttribute("type", "hidden");
        newInput.setAttribute("name", "id");
        newInput.setAttribute("value", $("#id").val());
        newForm.appendChild(newInput);
        document.body.append(newForm);
        newForm.submit();
    })

    //좋아요 여부
    $.ajax({
        url: '/product/likeYN',
        type: 'post',
        data: {
            "id": $("#id").val(),
            "pd_seq": $("#pd_seq").val()
        },
        success: function (data) {
            if (data == 0) {
                $("#likeBtn2").hide();
                $("#likeBtn").show();
            } else {
                $("#likeBtn2").show();
                $("#likeBtn").hide();
            }
        }
    });
    $("#likeBtn").click(function () {
        $.ajax({
            url: '/product/like',
            type: 'post',
            data: {
                "id": $("#id").val(),
                "pd_seq": $("#pd_seq").val()
            },
            success: function (data) {
                $("#likeBtn").hide();
                $("#likeBtn2").show();
            }
        })
    });
    $("#likeBtn2").click(function () {
        $.ajax({
            url: '/product/cancleLike',
            type: 'post',
            data: {
                "id": $("#id").val(),
                "pd_seq": $("#pd_seq").val()
            },
            success: function (data) {
                $("#likeBtn").show();
                $("#likeBtn2").hide();
            }
        })
    });
    var optionCount = '0';
    var changFlag = false;
    //카테고리 개수 가져오는 함수
    $("select").change(function () {
        optionCount = $("select option:selected").text();
        //옵션 변경 시 초기화
        $("#count").val(0);
        $("#totalStock").text($("#originalTotalStock").val());
        changFlag = true;
    });
    var flag;
    //수량 +
    $("#plus").click(async function () {
        flag = true; //담기 눌렀을때 재고보다 수량 많으면 false로
        let str = optionCount;
        if ($("#optionYN").val() != 0) {
            if (str == 0) {
                alert('옵션을 먼저 선택해주세요');
                return;
            }
            let numbers = str.match(/\d+/g);
            // console.log(numbers); // ["40", "50"]
            let count = parseInt($("#count").val());
            //옵션 모두 선택하게
            let integerArray = [];
            for (let i = 0; i < numbers.length; i++) {
                integerArray.push(parseInt(numbers[i]));
            }
            //제일 작은 값 구하기
            let min = Math.min.apply(Math, integerArray);
            if (count >= 0 && count < min) {
                count++
                $("#count").val(count);
                //총 수량 -
                let totalStock = parseInt($("#totalStock").text());
                totalStock--;
                // if (totalStock >= 0) { //전체 수량 0개일때
                //     alert('구매가 불가능한 상품입니다.');
                // } else {
                $("#totalStock").text(totalStock);
                // }
            } else if (!(count >= 0 && count < min)) {
                alert('개수를 다시 선택해주세요');
            }
        } else {
            let count = parseInt($("#count").val());
            count++;
            $("#count").val(count);
            let totalStock = parseInt($("#totalStock").text());
            totalStock--;
            $("#totalStock").text(totalStock);
            if (totalStock == -1) {
                alert('재고보다 많이 구매할 수 없습니다.');
                $("#count").val(--count);
                $("#totalStock").text(0);
                flag = false;
            }
        }
    });
    //수량 -
    $("#minus").click(async function () {
        let str = optionCount;
        if ($("#optionYN").val() != 0) {
            if (str == 0) {
                alert('수량은 1개 이상 선택 가능합니다.');
                return;
            }
            let numbers = str.match(/\d+/g);
            // console.log(numbers); // ["40", "50"]s
            let count = parseInt($("#count").val());
            let integerArray = [];
            for (let i = 0; i < numbers.length; i++) {
                integerArray.push(parseInt(numbers[i]));
            }
            //제일 작은 값 구하기
            let min = Math.min.apply(Math, integerArray);
            if (count == 0) {
                alert('수량을 1개 이상 선택해주세요.');
            } else if (count >= 0) {
                count--
                $("#count").val(count);
                // console.log("count : " + count);
                //총 수량 +
                let totalStock = parseInt($("#totalStock").text());
                totalStock++;
                // if (totalStock > parseInt($("#totalStock").text())) { //원래 전체 수량 보다 많을때
                //     alert('구매가능한 수량이 아닙니다.');
                // } else {
                $("#totalStock").text(totalStock);
                // }
            }
        } else {
            let count = parseInt($("#count").val());
            count--;
            $("#count").val(count);
            let totalStock = parseInt($("#totalStock").text());
            totalStock++;
            $("#totalStock").text(totalStock);
            if (count <= -1) {
                alert('수량은 1개 이상 선택 가능합니다.');
                $("#count").val(0);
                $("#totalStock").text(--totalStock);
            }
        }
    });
    $("#addItems").on("click", function () {
        let test = false;
        if ($("#optionYN").val() != 0) {
            if (changFlag == false) {
                alert('옵션을 선택해주세요.');
                return;
            }
            let str = optionCount;
            if (str.indexOf("--option--") != -1) {
                alert('옵션을 모두 선택해주세요');
                return;
            }
            if ($("#count").val() == 0) { //수량 0일때
                alert('수량을 1개 이상 선택해주세요.');
                return;
            }
            let regex = /([A-Za-z0-9]+\(\d+\))/g;
            var numbers = str.match(regex);
            let count = parseInt($("#count").val());
            var integerArray2 = [];
            for (let i = 0; i < numbers.length; i++) {
                integerArray2.push(numbers[i]);
            }
            var cnt = $("#count").val(); //수량
            var id = $("#id").val(); //아이디
            var pd_seq = $("#pd_seq").val(); //상품 seq
            $.ajax({
                url: '/product/addProduct',
                type: 'post',
                data: {
                    "count": cnt,
                    "id": id,
                    "pd_seq": pd_seq,
                    "optionList": integerArray2.toString()
                },
                success: function (data) {
                    if (data == 'success') {
                        alert('상품을 장바구니에 추가했습니다.');
                        $("#frm").submit();
                    }
                }
            });
        } else {
            if ($("#count").val() == 0) { //수량 0일때
                alert('수량을 1개 이상 선택해주세요.');
                return;
            }
            var cnt = $("#count").val(); //수량
            var id = $("#id").val(); //아이디
            var pd_seq = $("#pd_seq").val(); //상품 seq
            $.ajax({
                url: '/product/addProduct',
                type: 'post',
                data: {
                    "count": cnt,
                    "id": id,
                    "pd_seq": pd_seq
                },
                success: function (data) {
                    if (data == 'success') {
                        alert('상품을 장바구니에 추가했습니다.');
                        $("#frm").submit();
                    }
                }
            });
        }
    });
    $("#toCart").on("click", function () {
        $("#frm").submit();
    });
    $("#back").on("click", function () {
        location.href = "/product/list?cpage=1";
    });

    //QnA 작성 클릭 id,pd_seq
    function popup() {
        var _width = '500';
        var _height = '400';
        var _left = Math.ceil((window.screen.width - _width) / 2);
        var _top = Math.ceil((window.screen.height - _height) / 2);
        window.open("/QnA/ansPopup", "qnaFrm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
        var myForm = $("#qnaFrm")[0];
        myForm.method = "post";
        myForm.target = "qnaFrm";
        myForm.submit();
    }

    function openAnswer(index) {
        console.log(index);
        $('.content_tr').css('display', 'none'); //다 없애고 해당 tr만 보여줌
        $('.content_' + index).css('display', 'table-row');

    }

    $(".myQnA").click(function () {
        let id = $("#loginID").val();
        let newForm = document.createElement("form");
        newForm.setAttribute("action", "/QnA");
        newForm.setAttribute("method", "post");

        let input = document.createElement("input");
        input.setAttribute("name", "id");
        input.setAttribute("type", "hidden");
        input.setAttribute("value", id);

        newForm.appendChild(input);
        document.body.append(newForm);
        newForm.submit();
    })
</script>
</body>
</html>