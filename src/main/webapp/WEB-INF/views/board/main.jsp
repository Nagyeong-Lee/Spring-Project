<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>게시판</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        #myTable {
            border: 1px solid black;
        }

        /*제목 길이 넘치는거 자름*/
        .title {
            overflow: hidden;
            white-space: nowrap;
            word-break: break-word;
            text-overflow: ellipsis;
            max-width: 270px;
        }

        #footer {
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>

    <link rel="stylesheet" type="text/css" href="/resources/asset/css/util.css">
</head>
<body>
<%@ include file="/WEB-INF/views/product/communityNavUtil.jsp" %>
<table id="myTable" class="table">
    <input type="hidden" id="pageCount" name="pageCount" value="${count}">
    <input type="hidden" id="currPage" name="currPage" value="${currPage}">
    <tr>
        <th scope="col">작성자</th>
        <th scope="col">제목</th>
        <th scope="col">작성일자</th>
        <th scope="col">수정일자</th>
        <th scope="col">조회수</th>
    </tr>
    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="i" items="${list}">
                <tr scope="row">
                    <td>${i.writer}</td>
                    <td class="title"><a
                            href="/board/detail?b_seq=${i.b_seq}&currentPage=${currPage}&count=${count}">${i.title}</a>
                    </td>
                    <input type="hidden" value="${i.b_seq}" class="b_seq">
                    <td><fmt:formatDate pattern='yyyy-MM-dd hh:mm' value="${i.write_date}"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty i.update_date}">
                                <fmt:formatDate pattern='yyyy-MM-dd hh:mm' value="${i.update_date}"/>
                            </c:when>
                        </c:choose>
                    </td>
                    <td>${i.count}</td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="5">출력할 게시글이 없습니다.</td>
            </tr>
        </c:otherwise>
    </c:choose>

</table>

<div style="text-align: center">${paging}</div>

<input type=hidden value="${currPage}" name="cpage" id="cpage">
<div class="btn" style="margin-left: 750px;">
    <form action="/board/list?" method="get">
        <input type=hidden value="${count}" name="count" id="count">
        <input type=hidden value="1" name="currentPage" id="currentPage">
        <select name="postNum" id="postNum">
            <option value="5" <c:out value="${count eq '5' ? 'selected' : ''}"/>>5</option>
            <option value="10" <c:out value="${count eq '10' ? 'selected' : ''}"/>>10</option>
            <option value="15" <c:out value="${count eq '15' ? 'selected' : ''}"/>>15</option>
        </select>
        <select name="searchType" id="searchType">
            <option value="title" <c:out value="${searchType eq 'title' ? 'selected' : ''}"/>>제목</option>
            <option value="writer" <c:out value="${searchType eq 'writer' ? 'selected' : ''}"/>>작성자</option>
            <option value="content" <c:out value="${searchType eq 'content' ? 'selected' : ''}"/>>내용</option>
        </select>
        <input type="text" id="keyword" name="keyword" value="${keyword}">
        <button type="submit" id="searchBtn" class="btn btn-primary">글 검색</button>
        <button type="button" id="writeBtn" class="btn btn-primary">글 작성</button>
        <a href="/member/myPage">
            <button type="button" id="toMyPage" class="btn btn-primary">마이페이지로 이동</button>
        </a>
    </form>
</div>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer" >
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<script src="/resources/asset/js/util.js"></script>
<script>
    let b_seq = $(".b_seq").val();
    let count = $("#pageCount").val();
    let currPage = $("#cpage").val();
    $("#writeBtn").on("click", function () {  //글작성 폼으로 이동
        location.href = "/board/toWriteForm?b_seq=" + b_seq + "&count=" + count + "&currentPage=" + currPage;
    });

    $("#postNum").on("change", function () {
        let postNum = $("#postNum").val();
        location.href = "/board/list?currentPage=1&count=" + postNum + "&searchType=&keyword=";
    });
</script>
</body>
</html>