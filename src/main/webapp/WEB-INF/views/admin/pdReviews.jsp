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
    </style>
<body>
<%@include file="/WEB-INF/views/admin/adminNavUtil.jsp" %>
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
                    <%--                    ${i}<input type="checkbox" id="parentCategory${status.count}" name="parentCategory${status.count}"--%>
                    <%--                               class="parentCategory">--%>
                    ${i}<input type="checkbox" id="parentCategory${status.count}" class="parentCategory"
                    <c:out value="${i eq '여성'?'name=W': (i eq '남성'?'name=M': (i eq '신상품'?'name=NEW':''))}"/>
                    <c:out value="${i eq optionMap.parentCtgOption?'checked':''}"/>
                >
                </c:forEach>
                <br>
                하위 카테고리 :
                <c:forEach var="i" items="${childCategory}" varStatus="status">
                    ${i}<input type="checkbox" id="childCategory${status.count}" class="childCategory"
                    <c:out
                            value="${i eq '악세사리'?'name=accessory':(i eq '아우터'?'name=outer':(i eq '상의'?'name=top':(i eq '하의'?'name=pants':'')))}"/>
                    <c:out value="${i eq optionMap.childCtgOption?'checked':''}"/>
                >
                </c:forEach>
                <br>
                별점 :
                <c:forEach var="i" begin="1" end="5" varStatus="status">
                    ${status.count}<input type="checkbox" id="star${status.count}" name="${status.count}"
                                          class="star"
                    <c:out value="${i eq optionMap.star?'checked':''}"/>
                >
                </c:forEach>
            </c:when>
        </c:choose>
        <br>
        작성일 :
        오름차순<input type="radio" name="writeTime" id="writeTimeAsc" checked>
        내림차순<input type="radio" name="writeTime" id="writeTimeDesc">
    </div>
</form>

<table id="QnATable" class="table table-striped">
    <thead>
    <th>카테고리</th>
    <th>이미지</th>
    <th>상품 정보</th>
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
                        <p>${categoryMap.PARENTCATEGORY}</p>
                        <p>&nbsp${categoryMap.CHILDCATEGORY}</p>
                    </td>
                    <td>
<%--                            ${i}--%>
                        <a href="/product/detail?pd_seq=${i.reviewDTOS.PD_SEQ}">
                            <img src="/resources/img/products/${i.reviewDTOS.PDNAME}"
                                 style="width: 100px; height: 100px;">
                        </a>
                    </td>
                    <td>
                        <p>${i.reviewDTOS.NAME}-${i.reviewDTOS.STOCK}개</p>
                        <c:if test="${i.option != null}">
                            <c:forEach var="k" items="${i.option.optionMapList}">
                               <c:forEach var="j" items="#{k}">
                                   <p>${j.key} : ${j.value}</p>
                               </c:forEach>
                            </c:forEach>
                        </c:if>
                            <%--                                                       옵션.개수 출력--%>
                        <p><fmt:formatNumber value="${i.totalPrice}" pattern="#,###"/>원</p>
                    </td>
                    <td class="tdStyle">
                        <c:forEach var="star" begin="1" end="5">
                            <c:set var="starColor" value="#ddd"/>
                            <c:if test="${star le i.reviewDTOS.STAR}">
                                <c:set var="starColor" value="rgba(250, 208, 0, 0.99)"/>
                            </c:if>
                            <label for="1-star" id="star_${star}" class="startext">
                                <i class="fa-solid fa-star" style="position:relative;color:${starColor};"></i>
                            </label>
                        </c:forEach>
                    </td>
                    <td class="question" style="text-overflow: ellipsis;"><a href="javascript:;"
                                                                             onclick="showAns(${status.index})">${i.reviewDTOS.CONTENT}</a>
                    </td>
                    <td class="tdStyle">${i.reviewDTOS.ID}</td>
                    <td class="tdStyle">${i.reviewDTOS.WRITEDATE}</td>
                    <input type="hidden" value="${i.reviewDTOS.REVIEW_SEQ}" class="r_seq">
                    <td class="tdStyle">
                        <button type="button" class="btn btn-light delBtn">삭제</button>
                    </td>
                </tr>
                <tr class="answer_${status.index} answer" style="display:none;">
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td class="qText">${i.reviewDTOS.CONTENT}</td>
                    <td>${i.reviewDTOS.ID}</td>
                    <td>${i.reviewDTOS.WRITEDATE}</td>
                    <td></td>
                </tr>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
<script>

    //옵션 바뀔때
    function chgOptions() {
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
            parentCategoryArr: parentCategoryArr,
            childCategoryArr: childCategoryArr,
            starArr: starArr,
            time: $("input[type=radio]:checked").attr("id")
        }
        return data;
    }

    //select box change
    $("select[name='type']").on("change", function () {
        let data = chgOptions();
        $.ajax({
            url:'/admin/reviewsByOption',
            type:'post',
            data:data,
            success:function(data){
                console.log(data);
                //뿌리기
                $("#tbody").children().remove();
                var html = '';
            }
        })
        console.log(data);
    })
    //상위 카테고리 change
    $(".parentCategory").on("change", function () {
        let data = chgOptions();
        console.log(data);
    })
    //하위 카테고리 change
    $(".childCategory").on("change", function () {
        let data = chgOptions();
        console.log(data);
    })
    //별점 change
    $(".star").on("change", function () {
        let data = chgOptions();
        console.log(data);
    })
    //작성일 change
    $("input[name=writeTime]").on("change", function () {
        let data = chgOptions();
        console.log(data);
    })

    //검색 클릭시
    $("#searchBtn").on("click", function () {
        let data = chgOptions();
        console.log(data);
    })

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

    $(".delBtn").click(function () {
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
</script>
</body>
</html>
