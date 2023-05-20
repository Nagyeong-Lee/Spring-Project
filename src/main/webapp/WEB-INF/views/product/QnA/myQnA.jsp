<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-05-16
  Time: 오전 12:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>나의 Q&A </title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.css" rel="stylesheet">
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/resources/cart.css">
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>

    <style>

        .pagingDiv {
            position: fixed;
            left: 0;
            bottom: 100px;
            width: 100%;
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }

        #tbody * {
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

        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .cart {
            flex: 1 0 auto;
        }

        #footer {
            flex-shrink: 0;
        }
    </style>
</head>
<body>
<%--<input type="hidden" id="id" name="id" value="${id}">--%>
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<div class="cart">
    <table class="cart__list">
        <thead>
        <th>상품</th>
        <th>답변 상태</th>
        <th class="content">제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th></th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty qNaList}">
                <c:forEach var="i" items="${qNaList}" varStatus="status">
                    <tr>
                        <td>
                            <a href="/product/detail?pd_seq=${i.productDTO.pd_seq}">
                                <img src="/resources/img/products/${i.productDTO.img}"
                                     style="width: 100px; height: 100px;">
                            </a>
                            <p>${i.productDTO.name}</p>
                        </td>
                        <c:choose>
                            <c:when test="${i.answerYN != null && i.answerYN == 'N'}">
                                <td>미답변</td>
                            </c:when>
                            <c:otherwise>
                                <td>답변 완료</td>
                            </c:otherwise>
                        </c:choose>
                        <td class="question"><a href="javascript:;"
                                                onclick="showAns(${status.index})">${i.questionDTO.content}</a></td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                        <input type="hidden" value="${i.questionDTO.q_seq}" class="q_seq">
                        <input type="hidden" value="${paging.cpage}" class="cpage">
                        <td>
                            <button type="button" class="updQuestion btn btn-light">수정</button>
                            <button type="button" class="delQuestion btn btn-light">삭제</button>
                        </td>
                    </tr>
                    <tr class="answer_${status.index} answer" style="display:none;">
                        <td></td>
                        <td></td>
                        <td class="qText">${i.questionDTO.content}</td>
                        <td>${i.questionDTO.id}</td>
                        <td>${i.questionDTO.writeDate}</td>
                        <td></td>
                    </tr>
                    <c:if test="${i.answerYN == 'Y'}">
                        <tr class="answer_${status.index} answer" style="display:none;">
                            <td></td>
                            <td></td>
                            <td class="aText">
                                <i class="fa-solid fa-pen"></i>
                                    ${i.answerDTO.answer}
                            </td>
                            <td>${i.answerDTO.writer}</td>
                            <td>${i.answerDTO.writeDate}</td>
                            <td></td>
                        </tr>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td></td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tr>
        </tbody>
    </table>
</div>
<div class="pagingDiv" style="text-align: center;">
    <c:if test="${paging.needPrev eq true}">
        <a href="javascript:void(0); onclick=paging(${paging.startNavi-1}});"><</a>
        <a href="javascript:void(0); onclick=paging(1);">맨 처음</a>
    </c:if>
    <c:forEach var="i" begin="${paging.startNavi}" end="${paging.endNavi}" varStatus="var">
        <c:if test="${paging.cpage eq i}">
            <a href="javascript:void(0); onclick=paging(${i});" style="font-weight: bold;">${i}</a>
        </c:if>
        <c:if test="${paging.cpage ne i}">
            <a href="javascript:void(0); onclick=paging(${i});">${i}</a>
        </c:if>
    </c:forEach>
    <c:if test="${paging.needNext eq true}">
        <a href="javascript:void(0); onclick=paging(${paging.endNavi+1});">></a>
        <a href="javascript:void(0); onclick=paging(${paging.totalPageCount});">맨끝</a>
    </c:if>
</div>
<footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>

    $("#keyword").val($("#key").val());

    $("#search").on("click", function () {
        let keyword = $("#keyword").val();
        location.href = '/product/searchPd?keyword=' + keyword;
    });

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

    function showAns(index) {
        $(".answer").css("display", "none");
        $(".answer_" + index).css("display", "table-row");
    }

    //수정
    $(document).on("click",".updQuestion",function(){
        let q_seq = $(this).parent().closest("tr").find(".q_seq").val();
        let cpage = $(this).parent().closest("tr").find(".cpage").val();
        let id = $("#id").val();
        var _width = '500';
        var _height = '400';

        // 팝업을 가운데 위치시키기 위해 아래와 같이 값 구하기
        var _left = Math.ceil((window.screen.width - _width) / 2);
        var _top = Math.ceil((window.screen.height - _height) / 2);

        let newFrm = document.createElement("form");
        newFrm.setAttribute("method", "post");
        newFrm.setAttribute("action", "/QnA/updPopup");

        let input1 = document.createElement("input");
        input1.setAttribute("type", "hidden");
        input1.setAttribute("value", q_seq);
        input1.setAttribute("name", "q_seq");
        let input2 = document.createElement("input");
        input2.setAttribute("type", "hidden");
        input2.setAttribute("value", id);
        input2.setAttribute("name", "id");

        let input3 = document.createElement("input");
        input3.setAttribute("type", "hidden");
        input3.setAttribute("value", cpage);
        input3.setAttribute("name",cpage );


        newFrm.append(input1);
        newFrm.append(input2);
        newFrm.append(input3);
        document.body.append(newFrm);

        window.open("/QnA/ansPopup", "newFrm", 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);
        var myForm = newFrm;
        myForm.method = "post";
        myForm.target = "newFrm";
        myForm.submit();
    })

    //삭제
    $(document).on("click",".delQuestion",function(){
        if (confirm('삭제하시겠습니까?')) {
            let q_seq = $(this).parent().closest("tr").find(".q_seq").val();
            console.log(q_seq)
            $.ajax({
                url: '/QnA/delete',
                type: "post",
                data: {
                    "q_seq": q_seq
                },
                success: function (data) {
                   location.reload();
                }
            })
        }
    })


    //페이징 다시 그려줌
    function paging(startNavi) {
        $.ajax({
            url: '/QnA/repaging',
            type: 'post',
            data: {
                "cpage": startNavi,
                "id": $("#id").val()
            },
            success: function (data) {
                console.log(data);
                $(".pagingDiv").children().remove();
                createPaging(data);
            }
        })
    }

    function createPaging(data) {
        $("#tbody").children().remove();
        for (let i = 0; i < data.length; i++) {
            var newHtml = createHtml(data[i], data[i].startNavi, i);
            $("#tbody").append(newHtml);
        }

        if (data[0].needPrev) {
            var html = createPrev(startNavi);
            $(".pagingDiv").append(html);
        }
        for (let k = data[0].startNavi; k <= data[0].endNavi; k++) {
            if (data[0].startNavi == k) {
                var html = createNewPage1(k);
                $(".pagingDiv").append(html);
            } else {
                var html = createNewPage2(k);
                $(".pagingDiv").append(html);
            }
        }
        if (data[0].needNext) {
            var html = createNext(data[0].endNavi, data[0].totalPageCount);
            $(".pagingDiv").append(html);
        }
    }

    function createPrev(startNavi) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + (startNavi - 1) + ');">' + "<" + '</a>';
        html += '<a href="javascript:void(0);" onclick="paging(' + (1) + ');">' + "맨 처음" + '</a>';
        return html;
    }

    function createNewPage1(k) {
        console.log(k)
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + k + ')"> ' + k + ' </a>';
        return html;
    }

    function createNewPage2(k) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + k + ')" style="font-weight: bold;"> ' + k + ' </a>';
        return html;
    }

    function createNext(endNavi, totalPageCount) {
        var html = '';
        html += '<a href="javascript:void(0);" onclick="paging(' + (endNavi + 1) + ');">' + ">" + '</a>';
        html += '<a href="javascript:void(0);" onclick="paging(' + (totalPageCount) + ');">' + "맨끝" + '</a>';
        return html;
    }

    function createHtml(item, cpage, i) {
        let pd_seq = item.productDTO.pd_seq;
        var temp = '';
        var HTML = '<tr><td><a href="/product/detail?pd_seq=' + pd_seq + '"><img src="/resources/img/products/' + item.productDTO.img + '" style="width:100px; height: 100px;"></a>';
        HTML += '<p>' + item.productDTO.name + '</p></td>';
        if (item.answerYN == 'N' && item.answerYN != null) { //옵션 없을때
            HTML += '<td>미답변</td>';
        } else {
            HTML += '<td>미답변</td>';
        }
        HTML += '<td class="question"><a href="javascript:;" onclick="showAns(' + i + ')">' + item.questionDTO.content + '</a></td>';
        HTML += '<td>' + item.questionDTO.writeDate + '</td>';
        HTML += '<td>' + item.questionDTO.id + '</td>';
        HTML += '<input type="hidden" value="' + item.questionDTO.q_seq + '" class="q_seq">';
        HTML += '<input type="hidden" value="'+item.cpage+'" class="cpage">';
        HTML += '<td>';
        HTML += '<button type="button" class="updQuestion btn btn-light">수정</button>';
        HTML += '<button type="button" class="delQuestion btn btn-light">삭제</button></td></tr>';
        HTML += '<tr class="answer_' + i + ' answer" style="display:none;"><td></td><td></td>';
        HTML += '<td class="qText">' + item.questionDTO.content + '</td>';
        HTML += '<td>' + item.questionDTO.writeDate + '</td>';
        HTML += '<td>' + item.questionDTO.id + '</td><td></td></tr>';
        if (item.answerYN == 'Y') {
            HTML += '<tr class="answer_' + i + ' answer" style="display:none;"><td></td><td></td>';
            HTML += '<td class="aText"><i class="fa-solid fa-pen"></i>' + item.answerDTO.answer + '</td>';
            HTML += '<td>' + item.answerDTO.writer + '</td>';
            HTML += '<td>' + item.answerDTO.writeDate + '</td><td></td></tr>';
        }
        return HTML;
    }
</script>
</body>
</html>
