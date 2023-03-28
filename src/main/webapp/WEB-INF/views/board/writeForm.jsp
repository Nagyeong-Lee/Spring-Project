<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>글 작성 페이지</title>
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
        * {
            box-sizing: border-box;
        }
    </style>

</head>
<body>
<input type="file" id="file" name="file" multiple="multiple" style="display: none;">
<input type="hidden" id="count" name="count" value="${count}">
<input type="hidden" id="currPage" name="currPage" value="${currentPage}">
<form action="/board/insert" method="post" enctype="multipart/form-data" id="frm">
    <div class="title">
        제목 <input type="text" id="title" name="title">
    </div>
    <div class="writer">
        작성자 : ${id}
    </div>
    <textarea id="content" name="content" class="summernote"></textarea>

    <div class="fileDiv"></div>
    <button type="button" id="fileBtn" onclick="$('#file').click();">첨부파일</button>
    <button type="button" id="writeBtn">글작성</button>
    <button type="button" id="toMain">목록으로</button>
    <input type="hidden" value="${id}" id="writer" name="writer">
</form>

<script>
    $("#toMain").on("click", function () {  //게시글 메인 페이지로 이동
        location.href = "/board/list?currentPage=1&count=10";
    });

    let arr = [];  //복사한 파일 배열
    let file = []; //보낼 파일 배열

    $("#file").on("change", function () {
        let inputFile = $('input[name="file"]');
        let files = inputFile[0].files;
        for (let i = 0; i < files.length; i++) {
            arr.push(files[i]);
            let str = '<div id="i">' + files[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
            $(".fileDiv").append(str);
        }
        file = arr;  //복사
        $('input[name="file"]').val("");  //input 초기화
    });

    function removeFile(i) {  //x버튼 클릭 시 삭제
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


    $("#writeBtn").on("click", function () {  //글 작성 버튼 클릭 시

        let count=$("#count").val();
        let currPage=$("#currPage").val();
        let writer = $("#writer").val();
        let content = $("#content").val();
        let title = $("#title").val();

        console.log("count : "+count);
        console.log("currPage : "+currPage);
        let frm = $('#frm')[0];

        let data = new FormData(frm);

        for (var i = 0; i < file.length; i++) {
            data.append("file", file[i]);
        }
        alert('글 작성 완료');

        $.ajax({
            url: "/board/insert"
            , type: "POST"
            , enctype: 'multipart/form-data'
            , data: data
            , processData: false
            , contentType: false
            , cache: false
            , isModal: true
            , isModalEnd: true
            , success: function (data) {
                location.href = "/board/list?currentPage="+currPage+"&count="+count;
            }, error: function (e) {

            }
        });
    });

    $(function () {
        $('.summernote').summernote({
            minHeight: 500,             // 최소 높이
            maxHeight: null,             // 최대 높이
            focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
            lang: "ko-KR",					// 한글 설정
            callbacks: {
                onImageUpload: function (files, editor, welEditable) {
                    for (var i = files.length - 1; i >= 0; i--) {
                        sendFile(files[i], this);
                    }
                }
            }
        });
    });

    function sendFile(file, el) {
        var form_data = new FormData();
        form_data.append('file', file);
        $.ajax({
            data: form_data,
            type: "POST",
            url: '/board/img',
            cache: false,
            contentType: false,
            enctype: 'multipart/form-data',
            processData: false,
            success: function (img_name) {
                $(el).summernote('editor.insertImage', img_name);
            }
        });
    }
</script>
</body>
</html>