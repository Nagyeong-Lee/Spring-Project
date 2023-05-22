<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-16
  Time: 오후 5:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>리뷰 조회</title>
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
        img {
            width: 300px;
            height: 300px;
        }

        #QnATable {
            text-align: center;
        }

        .tdStyle {
            line-height: 100px;
        }

        table {
            table-layout: fixed;
        }

        .question {
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }

        .content, .question {
            width: 600px;
        }

        .qText {
            word-break: break-all
        }

        a {
            text-decoration: none;
        }


        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        .filter {
            flex: 1 0 auto;
        }

        #footer {
            flex-shrink: 0;
        }
    </style>
<body>
<%@include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
<div class="filter">
    <form action="/admin/chgOption" method="post">
        <div class="searchDiv">
            <select name="type">
                <option value="pdName">상품명</option>
                <option value="content">내용</option>
                <option value="writer">작성자</option>
            </select>
            <input type="text" id="keyword" name="keyword"> <%--상품명/내용/작성자--%>
            <button type="button" id="searchBtn" class="btn btn-light">검색</button>
        </div>
        <div class="optionDiv">
            <c:choose>
                <c:when test="${!empty parentCategory && !empty childCategory}">
                    상위 카테고리 :
                    <c:forEach var="i" items="${parentCategory}" varStatus="status">
                        ${i}<input type="checkbox" id="parentCategory${status.count}" class="parentCategory"
                                   checked="checked"
                        <c:out value="${i eq '여성'?'name=W': (i eq '남성'?'name=M': (i eq '신상품'?'name=NEW':''))}"/>
                    >
                    </c:forEach>
                    <br>
                    하위 카테고리 :
                    <c:forEach var="i" items="${childCategory}" varStatus="status">
                        ${i}<input type="checkbox" id="childCategory${status.count}" class="childCategory"
                                   checked="checked"
                        <c:out
                                value="${i eq '악세사리'?'name=accessory':(i eq '아우터'?'name=outer':(i eq '상의'?'name=top':(i eq '하의'?'name=pants':'')))}"/>
                    >
                    </c:forEach>
                    <br>
                    별점 :
                    <c:forEach var="i" begin="1" end="5" varStatus="status">
                        ${status.count}<input type="checkbox" id="star${status.count}" name="${status.count}"
                                              class="star" checked="checked"
                    >
                    </c:forEach>
                </c:when>
            </c:choose>
            <br>
            작성일 :
            오름차순<input type="radio" name="writeTime" id="writeTimeAsc">
            내림차순<input type="radio" name="writeTime" id="writeTimeDesc" checked>
        </div>
    </form>
    <table id="QnATable" class="table table-striped">
        <thead>
        <th>카테고리</th>
        <th>이미지</th>
        <th style="width: 300px;">상품 정보</th>
        <th>별점</th>
        <th class="content">내용</th>
        <th>작성자</th>
        <th>작성시간</th>
        <th></th>
        </thead>
        <tbody id="tbody">
        <c:choose>
            <c:when test="${!empty reviewList}">
                <c:forEach var="i" items="${reviewList}" varStatus="status">
                    <tr>
                        <td>
<%--                            ${i}--%>
                            <p>${i.parsedReviewDTO2.parentCategory}</p>
                            <p>&nbsp${i.parsedReviewDTO2.childCategory}</p>
                        </td>
                        <td>
                            <img src="/resources/img/products/${i.productDTO.img}"
                                 style="width: 100px; height: 100px;">
                        </td>
                        <td>
                            <p>${i.parsedReviewDTO2.pdName}-${i.parsedReviewDTO2.stock}개</p>
                            <c:if test="${i.optionMapList != null}">
                                <c:forEach var="k" items="${i.optionMapList}">
                                    <c:forEach var="j" items="#{k}">
                                        <p>${j.key} : ${j.value}</p>
                                    </c:forEach>
                                </c:forEach>
                            </c:if>
                            <p><fmt:formatNumber value="${i.parsedReviewDTO2.price}" pattern="#,###"/>원</p>
                        </td>
                        <td class="tdStyle">
                            <c:forEach var="star" begin="1" end="5">
                                <c:set var="starColor" value="#ddd"/>
                                <c:if test="${star le i.parsedReviewDTO2.star}">
                                    <c:set var="starColor" value="rgba(250, 208, 0, 0.99)"/>
                                </c:if>
                                <label for="1-star" id="star_${star}" class="startext">
                                    <i class="fa-solid fa-star" style="position:relative;color:${starColor};"></i>
                                </label>
                            </c:forEach>
                        </td>
                        <td class="question" style="text-overflow: ellipsis;"><a href="javascript:;"
                                                                                 onclick="showAns(${status.index})">${i.parsedReviewDTO2.content}</a>
                        </td>
                        <td class="tdStyle">${i.parsedReviewDTO2.id}</td>
                        <td class="tdStyle">${i.parsedReviewDTO2.writeDate}</td>
                        <input type="hidden" value="${i.parsedReviewDTO2.review_seq}" class="r_seq">
                        <td class="tdStyle">
                            <button type="button" class="btn btn-light delBtn">삭제</button>
                        </td>
                    </tr>
                    <tr class="answer_${status.index} answer" style="display:none;">
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="qText">${i.parsedReviewDTO2.content}</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <%--리뷰 이미지 있으면 --%>
                    <c:if test="${!empty i.revImgSysname}">
                        <tr class="answer_${status.index} answer" style="display:none;">
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td class="qText">
                                <c:forEach items="${i.revImgSysname}" var="k">
                                    <img src="/resources/img/products/pdReview/${k}"
                                         style="width: 100px; height: 100px;">
                                </c:forEach>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="7" style="text-align: center;">리뷰가 없습니다.</td>
                </tr>
            </c:otherwise>
        </c:choose>
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
<script>
    function showAns(index) {
        $(".answer").css("display", "none");
        $(".answer_" + index).css("display", "table-row");
    }

    //동적 html
    function createHtml(data) {
        console.log('데이터');
        console.log(data);
        //카테고리 출력
        var html = '';
        if (data.length !== 0) {
            for (let i = 0; i < data.length; i++) {
                html += '<tr>';
                let parentCtg = data[i].parsedReviewDTO2.parentCategory;  //상위 카테고리
                let childCtg = data[i].parsedReviewDTO2.childCategory; //하위 카테고리
                html += '<td><p>' + parentCtg + '</p><p>' + childCtg + '</p></td>';

                //상품 정보
                html += '<td><img src="/resources/img/products/' + data[i].productDTO.img + '" style="width:100px; height: 100px;"></td>';
                html += '<td><p>' + data[i].productDTO.name + '-' + data[i].parsedReviewDTO2.stock + '개</p>';

                // 옵션 출력
                if (Object.keys(data[i]).includes('optionMapList')) {  //key가 optionMapList 있으면 출력
                    for (let k = 0; k < data[i].optionMapList.length; k++) {
                        console.log(Object.keys(data[i].optionMapList[k]) + ":" + Object.values(data[i].optionMapList[k]));
                        html += '<p>' + Object.keys(data[i].optionMapList[k]) + ":" + Object.values(data[i].optionMapList[k]) + '</p>';
                    }
                }
                html += '<p>' + data[i].parsedReviewDTO2.price.toLocaleString() + '원</p></td>';

                //별점
                html += '<td class="tdStyle">';
                for (let k = 1; k <= 5; k++) {
                    if (k <= data[i].parsedReviewDTO2.star) {
                        html += '<label for="1-star" class="startext"><i class="fa-solid fa-star" style="position:relative;color:rgba(250, 208, 0, 0.99);"></i></label>';
                    } else {
                        html += '<label for="1-star" class="startext"><i class="fa-solid fa-star" style="position:relative;color:#ddd;"></i></label>';
                    }
                }
                //내용
                html += '</td>';
                html += '<td class="question" style="text-overflow: ellipsis;">';
                html += '<a href="javascript:;" onclick="showAns(' + i + ')">' + data[i].parsedReviewDTO2.content + '</a></td>';
                //작성자
                html += '<td class="tdStyle">' + data[i].parsedReviewDTO2.id + '</td>';
                html += '<td class="tdStyle">' + data[i].parsedReviewDTO2.writeDate + '</td>';
                html += '<input type="hidden" value="' + data[i].parsedReviewDTO2.review_seq + '" class="r_seq">';
                html += '<td class="tdStyle"><button type="button" class="btn btn-light delBtn">삭제</button></td</tr>';

                //내용 클릭 시 내용 전체 보여줌
                html += '<tr class="answer_' + i + ' answer" style="display:none;"><td></td><td></td><td></td><td></td>';
                html += '<td class="qText">' + data[i].parsedReviewDTO2.content + '</td>';
                html += '<td>' + data[i].parsedReviewDTO2.id + '</td>';
                html += '<td>' + data[i].parsedReviewDTO2.writeDate + '</td></tr>';

                if (data[i].revImgSysname != null) {
                    //내용 클릭 시 내용 전체 보여줌
                    html += '<tr class="answer_' + i + ' answer" style="display:none;"><td></td><td></td><td></td><td></td><td class="qText">';
                    for (let j = 0; j < data[i].revImgSysname.length; j++) {
                        html += '<img src="/resources/img/products/pdReview/' + data[i].revImgSysname[j] + '" style="width: 100px; height: 100px;">';
                    }
                    html += '</td>';
                    html += '<td></td><td></td><td></td></tr>';
                }
            }
        }
        return html;
    }

    //옵션 바뀔때
    function chgOptions() {
        //옵션 모두 선택 안할때
        if ($("input[class=parentCategory]:checked").length == 0 &&
            $("input[class=childCategory]:checked").length == 0 &&
            $("input[class=star]:checked").length == 0) {
            alert('옵션을 선택해주세요');
            $("input[class=parentCategory]").attr("checked",true);
            $("input[class=childCategory]").attr("checked",true);
            $("input[class=star]").attr("checked",true);
        }
        let parentCategoryArr = []; //상위 카테고리 name
        let childCategoryArr = []; //하위 카테고리 name
        let starArr = []; //별점 arr

        $("input[class=parentCategory]:checked").each(function () {
            parentCategoryArr.push($(this).attr("name"));
        });

        $("input[class=childCategory]:checked").each(function () {
            childCategoryArr.push($(this).attr("name"));
        })

        $("input[class=star]:checked").each(function () {
            starArr.push($(this).attr("name"));
        })

        let data = {
            selectType: $("select[name='type'] option:selected").val(),
            keyword: $("#keyword").val(),
            parentCategoryArr: parentCategoryArr.toString(),
            childCategoryArr: childCategoryArr.toString(),
            starArr: starArr.toString(),
            time: $("input[type=radio]:checked").attr("id")
        }
        return data;
    }

    function getReviews(data) {
        // let data = chgOptions();
        //cpage 추가
        // $(".pagingDiv").children().remove();
        data.cpage = 1;
        $.ajax({
            url: '/admin/reviewsByOption',
            type: 'post',
            data: data,
            success: function (data) {
                console.log(data);
                //뿌리기
                $("#tbody").children().remove();
                if (data.length !== 0) {
                    var html = createHtml(data);
                }
                $("#tbody").append(html);
                console.log(data);
                createPaging(data);
            }
        })
    }

    //상위 카테고리 change
    $(".parentCategory").on("change", function () {
        let data = chgOptions();
        getReviews(data);
    })
    //하위 카테고리 change
    $(".childCategory").on("change", function () {
        let data = chgOptions();
        getReviews(data);
    })
    //별점 change
    $(".star").on("change", function () {
        let data = chgOptions();
        getReviews(data);
    })
    //작성일 change
    $("input[name=writeTime]").on("change", function () {
        let data = chgOptions();
        getReviews(data);
    })

    //검색 클릭시
    $(document).on("click", "#searchBtn", function () {
        let data = chgOptions();
        getReviews(data);
    })

    $("#keyword").val($("#key").val());

    $(document).on("click", "#search", function () {
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

    $(document).on("click", ".delBtn", function () {
        if (confirm('삭제하시겠습니까?')) {
            let r_seq = $(this).parent().closest("tr").find(".r_seq").val();
            $.ajax({
                url: '/admin/delReview',
                type: 'post',
                data: {
                    "r_seq": r_seq
                },
                success: function (data) {
                    location.reload();
                }
            })
        }
    })

    //페이징 다시 그려줌
    function paging(startNavi) {
        $(".pagingDiv").children().remove();
        let data = chgOptions();
        console.log(data);
        data.cpage = startNavi;
        $.ajax({
            url: '/admin/reviewsByOption',
            type: 'post',
            data: data,
            success: function (data) {
                console.log('페이징');
                console.log(data);
                //뿌리기
                $("#tbody").children().remove();
                if (data.length !== 0) {
                    var html = createHtml(data);
                }
                $("#tbody").append(html);
                console.log(data);
                createPaging(data);
            }
        })
    }


    function createPaging(data) {
        $(".pagingDiv").children().remove();
        for (let i = 0; i < data.length; i++) {
            var newHtml = createHtml(data[i], data[i].startNavi);
            $("#tbody").append(newHtml);
        }
        // debugger;
        if (data[0].reMap.needPrev) {
            var html = createPrev(reMap.startNavi);
            $(".pagingDiv").append(html);
        }
        for (let k = data[0].reMap.startNavi; k <= data[0].reMap.endNavi; k++) {
            if (data[0].reMap.startNavi == k) {
                var html = createNewPage1(k);
                $(".pagingDiv").append(html);
            } else {
                var html = createNewPage2(k);
                $(".pagingDiv").append(html);
            }
        }
        if (data[0].reMap.needNext) {
            var html = createNext(data[0].reMap.endNavi, data[0].reMap.totalPageCount);
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

</script>
</body>
</html>
