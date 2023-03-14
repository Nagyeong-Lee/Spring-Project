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

        .box, .b_contents {
            border: 1px solid black;
        }

        /*대댓글*/
        .replyDiv {
            border: 1px solid black;
            width: 70%;
            height: 5%;
        }
    </style>

</head>
<body>

<%--작성자==로그인 아이디 일때 삭제.수정 보여주기--%>
<form action="/board/update" id="frm" method="post">
    <div class="container">

        <input type="hidden" name="b_seq" id="b_seq" value="${boardDTO.b_seq}">
        <input type="hidden" name="writer" id="writer" value="${boardDTO.writer}">
        <input type="hidden" name="write_date" id="write_date" value="${boardDTO.write_date}">
        <input type="hidden" name="id" id="id" value="${id}">


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
                        <div class="content">
                                ${i.content}
                            <button type="button" class="cmt" onclick="cmtOpen('${i.cmt_seq}')">대댓글 달기</button>
                            <input type="hidden" value="${i.cmt_seq}" class="p_cmt">
                        </div>
                        <div class="info">
                                ${i.writer}
                            <fmt:formatDate pattern='YYYY-MM-dd hh:mm'
                                            value="${i.write_date}"/>
                        </div>
                        <div class="cmtBox" id="${i.cmt_seq}"></div>
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
    let no = '${boardDTO.write_date}';

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
            comment.text(content);   //댓글 작성
            $("#comment").val('');   //댓글 작성칸 초기화

            let info = $("<div></div>");
            let infoText = writer + " " + $("#write_date").val();
            info.text(infoText);
            console.log(infoText);
            $(".showComments").append(comment);
            $(".showComments").append(info);
        });
    });

    //대댓글
    let replyCmtNum; //대댓글의 cmt_seq

    function cmtOpen(cmtNum) {

        replyCmtNum = cmtNum;

        $(".cmt").remove();
        let parent_cmt_seq = cmtNum;


        let btn = '<button type="button" class="completeCmt" id="complete" onClick="writeReply(' + cmtNum + ')">대댓글 작성완료</button>'
        let div = '<textarea class="box" id="textArea" name="textArea"></textarea>'

        $("#" + cmtNum).append(div); //textarea
        $("#" + cmtNum).append(btn); //작성완료 btn

        console.log("대댓글의 cmt_seq : " + replyCmtNum);

    }


    //대댓글 작성 함수
    function writeReply(parent_cmt_seq) {

        console.log('parent_cmt_seq : ' + parent_cmt_seq);
        let writer = $("#id").val();
        let content = $("#textArea").val();
        let b_seq = $("#b_seq").val();

    }

    $(document).on("click", ".completeCmt", function () {
        console.log('클릭');
        let writer = $("#id").val();
        let content = $("#textArea").val();
        let b_seq = $("#b_seq").val();
        let parent_cmt_seq = replyCmtNum;

        console.log("writer : " + writer);
        console.log("content : " + content);
        console.log("b_seq : " + b_seq);
        console.log("parent_cmt_seq : " + replyCmtNum);

        $.ajax({
            url: "/comment/reply",
            type: "post",
            data: {
                "writer": writer,
                "content": content,
                "b_seq": b_seq,
                "parent_cmt_seq": replyCmtNum
            }
        }).done(function (resp) {
            console.log('eoeoeo');
            location.href = "/board/list?currentPage=1&count=10";
        });
    })
</script>
</body>
</html>

