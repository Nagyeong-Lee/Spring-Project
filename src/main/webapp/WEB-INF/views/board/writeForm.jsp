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

    <script>
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
                    console.log("img_name : " + img_name);
                    $(el).summernote('editor.insertImage', img_name);
                }
            });
        }
    </script>
</head>
<body>
<input type="file" id="file" name="file" multiple="multiple" style="display: none;">

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
    <input type="hidden" value="${id}" id="writer" name="writer" disabled>
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
            console.log(files[i].name); //파일 이름
            arr.push(files[i]);

            let str = '<div id="i">' + files[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
            $(".fileDiv").append(str);
        }
        console.log("arr : " + arr);
        file = arr;  //복사
        $('input[name="file"]').val("");  //인풋 초기화
    });

    function removeFile(i) {   //x버튼 클릭 시 삭제
        $("#i").remove();
        let splice = arr.splice(i, 1);
        console.log("splice: " + splice);
        console.log("arr: " + arr);
        console.log("arr_length : " + arr.length);
        file = arr;
        console.log("file length : " + file.length);
        console.log("file : " + file);
        let str = '';
        $(".fileDiv").empty();
        for(let i = 0 ; i < file.length ; i++){
            console.log("file_name : " + file[i]);
            str += '<div id="i">' + file[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
        }
        $(".fileDiv").append(str);

    }


    $("#writeBtn").on("click", function () {

        let writer = $("#writer").val();
        let content = $("#content").val();
        let title = $("#title").val();

        console.log("title : "+title);
        console.log("content : "+content);

        let frm = $('#frm')[0];

        // Create an FormData object
        let data = new FormData(frm);

        for (var i = 0; i < file.length; i++) {
            console.log(file[i].name);
            data.append("file", file[i]);
        }
        console.log("form file : " + data.get("file"));


        data.append("writer", writer);
        data.append("content", content);
        data.append("title", title);
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
                location.href="/board/list?currentPage=1&count=10"
            }, error: function (e) {

            }
        });
    });
</script>
</body>
</html>