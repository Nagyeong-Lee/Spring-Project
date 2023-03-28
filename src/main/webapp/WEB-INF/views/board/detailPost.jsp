<%@ page import="static jdk.javadoc.internal.doclets.formats.html.markup.RawHtml.nbsp" %>
<%@ page import="com.example.Spring_Project.dto.ReplyDTO" %>
<%@ page import="java.util.List" %>
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

        #file {
            visibility: hidden;
        }
    </style>

</head>
<body>
<input type="hidden" value="${count}" id="count" name="count">
<input type="hidden" value="${currPage}" id="currpage" name="currpage">
<input type="file" id="file" name="file" multiple="multiple" class="file" style="display: none">
<%--작성자==로그인 아이디 일때 삭제.수정 보여주기--%>
<form action="/board/update" id="frm" method="post" enctype="multipart/form-data">

    <div class="container">
        <input type="hidden" name="b_seq" id="b_seq" value="${boardDTO.b_seq}">
        <input type="hidden" name="writer" id="writer" value="${boardDTO.writer}">
        <input type="hidden" name="write_date" id="write_date" value="${boardDTO.write_date}">
        <input type="hidden" name="update_date" id="update_date" value="${boardDTO.update_date}">
        <input type="hidden" name="id" id="id" value="${id}">
        <div class="title">제목 :
            <input type="text" id="title" name="title" value="${boardDTO.title}" readonly="readonly"></div>
        <div class="info">
            작성자 : ${boardDTO.writer}<br>
            조회수 : ${boardDTO.count}<br>
            작성 시간 : <fmt:formatDate pattern="yyyy-MM-dd hh:mm"
                                    value="${boardDTO.write_date}"/><br>
            <c:if test="${boardDTO.update_date != null}">
                수정 시간 : <fmt:formatDate pattern="yyyy-MM-dd hh:mm"
                                        value="${boardDTO.update_date}"/>
            </c:if>
        </div>
        <div class="board_contents_div">
            <div class="b_contents">${boardDTO.content}</div>
        </div>
        <c:choose>
            <c:when test="${not empty file}">
                <c:forEach var="i" items="${file}">
                    <button type="button" onclick="fileDown(${i.f_seq})" class="down"
                            id="fileName${i.f_seq}">${i.oriname}</button>
                    <button type="button" onclick="deleteFile(${i.f_seq})" class="deleteFile" id="${i.f_seq}">x</button>
                    <input type="hidden" value="${i.oriname}" id="${i.f_seq}" class="oriname" disabled>
                    <br>
                </c:forEach>
            </c:when>
        </c:choose>
        <br>
        <!--댓글 영역-->
        <div class="showComments">
            <c:choose>
                <c:when test="${not empty commentList}">
                    <c:forEach var="i" items="${commentList}">
                        <div class="content" id="${i.cmt_seq}">
                            <c:if test="${i.status eq 'Y' }">
                                <c:forEach var="k" begin="2" end="${i.level}">
                                    &nbsp
                                </c:forEach>
                                <span id="originalContent${i.cmt_seq}">${i.content}</span>
                            </c:if>
                            <c:if test="${i.status eq 'N'}">
                                =============삭제된 댓글입니다.=============
                            </c:if>
                            <c:if test="${i.status eq 'Y' }">
                                <button type="button" class="cmt" onclick="cmtOpen('${i.cmt_seq}')">대댓글 달기</button>
                                <%-- 댓글 작성자 != 로그인 아이디--%>
                                <c:if test="${i.writer eq id}">
                                    <button type="button" onclick="cmtDel('${i.cmt_seq}')">댓글 삭제</button>
                                    <button type="button" onclick="cmtUpd('${i.cmt_seq}')">댓글 수정</button>
                                </c:if>
                            </c:if>
                            <input type="hidden" value="${i.cmt_seq}" class="p_cmt"><br>
                            <div class="info" id="info${i.cmt_seq}">
                                <c:if test="${i.status eq 'Y' }">
                                    ${i.writer}
                                    <fmt:formatDate pattern='YYYY-MM-dd hh:mm'
                                                    value="${i.write_date}"/>
                                </c:if>
                            </div>
                        </div>
                        <div class="cmtBox" id="${i.cmt_seq}"></div>
                    </c:forEach>
                </c:when>
            </c:choose>
        </div>
        <hr>
        <!--댓글 작성 영역-->
        <input type="hidden" id="cmtWriter" value="${id}">
        <div id="b_comments" name="b_comments">
            <textarea class="comment" id="comment" class="comment"></textarea>
            <button type="button" id="replyBtn">댓글달기</button>
        </div>
        <br>
        <%--새로운 파일--%>
        <div class="fileDiv"></div>
        <div class="btns">
            <c:if test="${boardDTO.writer ne id}">
                <button type="button"><a href="/board/list?currentPage=${currPage}&count=${count}">목록으로</a></button>
            </c:if>
            <c:if test="${boardDTO.writer eq id}">
                <button type="button"><a href="/board/list?currentPage=${currPage}&count=${count}">목록으로</a></button>
                <button type="button"><a
                        href="/board/delete?b_seq=${boardDTO.b_seq}&currentPage=${currPage}&count=${count}">삭제하기</a></button>
                <button id="updBtn" type="button">게시글 수정하기</button>
                <button type="button" onclick="$('#file').click();" id="attach">첨부파일</button>
            </c:if>
        </div>
    </div>
</form>

<script>
    $("#attach").hide();
    $(".fileDiv").hide();
    $(".deleteFile").hide();

    //파일 수정

    let deleteSeq = []; //삭제할 파일 f_seq
    let file = []; //실제 보낼 파일
    let arr = [];

    let no = '${boardDTO.write_date}';

    $("#updBtn").on("click", function () { //게시글 수정하기 클릭 시


        $("#attach").show();
        $(".fileDiv").show();
        $("#file").show();
        $(".deleteFile").show();

        $("#title").attr("readonly", false);

        let completeUpdBtn = $("<button type='button' >수정완료</button>");
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
            focus: true,
            lang: "ko-KR",					// 한글 설정
            placeholder: '글을 입력하세요.'
        });
    });

    $("#file").on("change", function () {
        let inputFile = $("#file");
        let files = inputFile[0].files;
        for (let i = 0; i < files.length; i++) {
            arr.push(files[i]);
            let str = '<div id="i">' + files[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
            $(".fileDiv").append(str);
        }
        file = arr;  //복사
        $('input[name="file"]').val("");  //인풋 초기화
    });

    function deleteFile(i) {
        $("#" + i).remove();  //x 버튼 삭제
        $("#fileName" + i).remove(); //파일 이름 버튼 삭제
        deleteSeq.push(i);  //status=n으로 변경
    }

    function removeFile(i) {   //x버튼 클릭 시 삭제
        $("#i").remove();
        let splice = arr.splice(i, 1);
        file = arr;
        let str = '';
        $(".fileDiv").empty();
        for (let i = 0; i < file.length; i++) {
            str += '<div id="i">' + file[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
        }
        $(".fileDiv").append(str);
    }

    $(document).on("click", "#completeUpdBtn", function () { //수정완료 버튼 클릭시 배열보내기

        let currPage = $("#currpage").val();
        let count = $("#count").val();
        let b_seq = $("#b_seq").val();
        let writer = $("#id").val();
        let content = $("#content").val();
        let title = $("#title").val();
        let frm = $('#frm')[0];
        let data = new FormData(frm);
        for (var i = 0; i < file.length; i++) {
            data.append("file", file[i]);
        }

        data.append("b_seq", b_seq);
        data.append("writer", writer);
        data.append("deleteSeq", deleteSeq);
        alert('글 수정 완료');

        $.ajax({
            url: "/board/update"
            , type: "POST"
            , enctype: 'multipart/form-data'
            , data: data
            , processData: false
            , contentType: false
            , cache: false
            , isModal: true
            , isModalEnd: true
            , async: false
            , success: function (data) {
                location.href = "/board/detail?b_seq=" + b_seq + "&currentPage=" + currPage+"&count="+count;
            }, error: function (e) {
            }
        });
    });

    //댓글 작성
    $("#replyBtn").on("click", function () {
        let content = $("#comment").val(); //댓글내용
        let writer = $("#cmtWriter").val(); //작성자
        let b_seq = $("#b_seq").val(); //게시글 번호

        $.ajax({
            url: "/comment/insert",
            type: "post",
            data:
                {
                    "content": content,
                    "writer": writer,
                    "b_seq": b_seq
                },
            success: function (data) {
                let comment = $("<div id=\"" + data + "\"></div>");
                comment.text(content);   //댓글 작성
                $("#comment").val('');   //댓글 작성칸 초기화

                let str = '<button type="button" class="cmt" onclick="cmtOpen(\'' + data + '\')">대댓글 달기</button> ';
                str += '<button type="button" onclick="cmtDel(\'' + data + '\')">댓글 삭제</button> ';
                str += '<button type="button" onclick="cmtUpd(\'' + data + '\')">댓글 수정</button>';
                comment.append(str);
                let info = $("<div></div>");
                let infoText = writer + " " + $("#write_date").val();
                info.text(infoText);
                comment.append(info);
                $(".showComments").append(comment);
                // $(".showComments").append(info);
            }
        })
    });

    //대댓글
    let replyCmtNum; //대댓글의 cmt_seq

    function cmtOpen(cmtNum) {
        replyCmtNum = cmtNum;
        // $(".cmt").remove();
        let parent_cmt_seq = cmtNum;

        let btn = '<button type="button" class="completeCmt" id="complete" onClick="writeReply(' + cmtNum + ')">대댓글 작성완료</button><br>'
        let div = '<textarea class="box" id="textArea" name="textArea"></textarea>'

        $("#" + cmtNum).append(div); //textarea
        $("#" + cmtNum).append(btn); //작성완료 btn

    }

    function cmtDel(cmtNum) {  //댓글 삭제
        let cmt_seq = cmtNum;
        let b_seq = $("#b_seq").val();
        $.ajax({
            url: "/comment/deleteCmt",
            type: "post",
            data: {"cmt_seq": cmt_seq},
            success: function (data) {
                location.href = "/board/detail?b_seq=" + b_seq;
            }
        });
    }

    let cmt_num;

    //댓글 수정
    function cmtUpd(cmtNum) {
        let originalContent = $("#originalContent" + cmtNum).text();
        cmt_num = cmtNum;
        // $("#" + cmtNum).remove();
        // $("#info" + cmtNum).remove();

        let btn = '<button type="button" class="upd" id="upd">수정 완료</button>'
        let div = '<textarea class="box" id="updtextArea" name="updtextArea">' + originalContent + ' </textarea>'
        // $("#originalContent"+cmtNum).remove();
        $("#updTextArea").text(originalContent);
        $("#" + cmt_num).append(div); //textarea
        $("#" + cmt_num).append(btn); //작성완료 btn
    }

    //댓글 수정 완료 클릭 시
    $(document).on("click", ".upd", function () {

        let writer = $("#id").val();
        let content = $("#updtextArea").val();
        let cmt_seq = cmt_num;
        let b_seq = $("#b_seq").val();

        $.ajax({
            url: "/comment/updCmt",
            type: "post",
            data: {
                "content": content,
                "b_seq": b_seq,
                "cmt_seq": cmt_seq
            },
            success: function (data) {
                location.href = "/board/detail?b_seq=" + b_seq;
            }
        });
    })


    //대댓글 작성 함수
    function writeReply(parent_cmt_seq) {

        let writer = $("#id").val();
        let content = $("#textArea").val();
        let b_seq = $("#b_seq").val();

    }

    $(document).on("click", ".completeCmt", function () {
        let writer = $("#id").val();
        let content = $("#textArea").val();
        let b_seq = $("#b_seq").val();
        let parent_cmt_seq = replyCmtNum;

        $.ajax({
            url: "/comment/reply",
            type: "post",
            data: {
                "writer": writer,
                "content": content,
                "b_seq": b_seq,
                "parent_cmt_seq": replyCmtNum
            },
            success: function (data) {
                location.href = "/board/detail?b_seq=" + b_seq;
            }
        });
    })

    function fileDown(key) {   // 파일 다운로드 (ajax말고 form 만들어서 submit)

        let f_seq = key;

        let form = document.createElement("form");
        form.setAttribute("charset", "UTF-8");
        form.setAttribute("method", "Post");
        form.setAttribute("action", "/file/download");

        let hiddenField = document.createElement("input");
        hiddenField.setAttribute("type", "hidden");
        hiddenField.setAttribute("name", "f_seq");
        hiddenField.setAttribute("value", key);
        form.appendChild(hiddenField);
        document.body.appendChild(form);
        form.submit();
    }
</script>
</body>
</html>
