<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>글 상세보기</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>

    <!-- include libraries(jQuery, bootstrap) -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <!-- include summernote css/js -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>

    <style>
        .container {
            margin: auto;
        }

        * {
            box-sizing: border-box;
        }

        .container {
            width: 1000px;
            margin-left: auto;
        }

        /*버튼*/
        .btns * {
            float: left;
        }

        /*댓글영역*/
        .comment {
            width: auto;
            height: 100px;
        }

        /*글 내용*/
        #b_contents {
            border: 1px solid black;
            height: 50%;
            width: 100%;
        }

        /*댓글*/
        .comment {
            width: 80%;
            height: 10%;
        }


        .b_contents {
            border: 1px solid black;
        }
    </style>

</head>
<body>

<%--작성자==로그인 아이디 일때 삭제.수정 보여주기--%>
<form action="/board/update" id="frm" method="post">
    <div class="container">

        <input type="hidden" name="b_seq" id="b_seq" value="${boardDTO.b_seq}">
        <input type="hidden" name="writer" id="writer" value="${boardDTO.writer}">

        <div class="title">제목 :
            <input type="text" id="title" name="title" value="${boardDTO.title}" readonly="readonly"></div>
        <div class="info">
            작성자 : ${boardDTO.writer}<br>
            조회수 : ${boardDTO.count}<br>
            작성 시간 : <fmt:formatDate pattern="yyyy-MM-dd HH:mm"
                                    value="${boardDTO.write_date}"/><br>
            <c:if test="${boardDTO.update_date != null}">
                수정 시간 : <fmt:formatDate pattern="yyyy-MM-dd HH:mm"
                                        value="${boardDTO.update_date}"/>
            </c:if>
        </div>
        <div class="board_contents_div">
            <div class="b_contents">${boardDTO.content}</div>
        </div>

        <!--댓글 보이는 영역-->
        <hr>
        <div class="showComments">
            <c:choose>
                <c:when test="${not empty commentList}">
                    <c:forEach var="i" items="${commentList}">
                        <div class="row">
                                ${i.content}
                        </div>
                    </c:forEach>
                </c:when>
            </c:choose>
        </div>
        <hr>

        <!--댓글 작성 영역-->
        <div id="b_comments" name="b_comments">
            <textarea class="comment" id="comment" class="comment"></textarea>
            <button type="button" id="replyBtn">댓글달기</button>
        </div>
        <br>

        <div class="btns">
            <c:if test="${boardDTO.writer ne id}">
                <button type="button"><a href="/board/list?currentPage=1&count=10">목록으로</a></button>
            </c:if>
            <button type="button"><a href="/board/list?currentPage=1&count=10">목록으로</a></button>
            <button type="button"><a
                    href="/board/delete?b_seq=${boardDTO.b_seq}">삭제하기</a></button>
            <button id="updBtn" type="button">게시글 수정하기</button>
        </div>
    </div>
</form>

<script>
    $("#updBtn").on("click", function () {

        console.log('버튼클릭');

        $("#title").attr("readonly", false);

        let completeUpdBtn = $("<button>수정완료</button>");
        completeUpdBtn.attr("id", "completeUpdBtn");
        $(".btns").append(completeUpdBtn);

        $("hr").remove();
        $(".showComments").remove();
        $("#b_comments").remove();


        $("#updBtn").remove();
        $(".b_contents").remove();

        let editor = $('<textarea>${boardDTO.content}</textarea>');
        editor.addClass("summernote");
        editor.attr("id", "content");
        editor.attr("name", "content");

        $(".board_contents_div").append(editor);

        $(".summernote").summernote({
            height: 300,                 // 에디터 높이
            minHeight: null,             // 최소 높이
            maxHeight: null,             // 최대 높이
            focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
            lang: "ko-KR",					// 한글 설정
            placeholder: '글을 입력하세요.'	//placeholder 설정
        });

    });

    $("#completeUpdBtn").on("click", function () {
        $("#frm").submit();
    });

    //댓글 작성
    $("#replyBtn").on("click", function () {
        console.log('댓글작성버튼 클릭');

        let content = $("#comment").val(); //댓글내용
        let writer = $("#writer").val(); //작성자
        let b_seq = $("#b_seq").val(); //게시글 번호

        console.log("댓글 내용 : " + content);
        console.log(writer);
        console.log(b_seq);

        $.ajax({
            url: "/comment/insert",
            type: "post",
            data:
                {
                    "content": content,
                    "writer": writer,
                    "b_seq": b_seq
                }
        }).done(function (resp) {
            let comment = $("<div></div>");
            let button = $("<button>대댓글 작성하기</button>");
            button.attr("type", "button");
            comment.text(content);   //댓글 작성
            $("#comment").val('');   //댓글 작성칸 초기화
            $(".showComments").append(comment);
            $(".showComments").append(button);
        });
    });


</script>
</body>
</html>