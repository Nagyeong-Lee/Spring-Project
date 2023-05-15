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
<%--    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">--%>
<%--    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>--%>
<%--    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>--%>

    <!-- include summernote css/js -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
            crossorigin="anonymous"></script>

    <link rel="stylesheet" type="text/css" href="/resources/asset/css/util.css">

    <style>
        * {
            box-sizing: border-box;
        }

        #footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            background-color: #343a40; /* 배경색상 */
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>

</head>
<body>
<%@ include file="/WEB-INF/views/product/communityNavUtil.jsp" %>
<input type="file" id="file" name="file" multiple="multiple" style="display: none;">
<input type="hidden" id="count" name="count" value="${count}">
<input type="hidden" id="currPage" name="currPage" value="${currentPage}">
<form action="/board/insert" method="post" enctype="multipart/form-data" id="frm" style="margin-top: 70px;">
    <div class="title">
        제목 <input type="text" id="title" name="title">
    </div>
    <div class="writer">
        작성자 : ${id}
    </div>
    <textarea id="content" name="content" class="summernote"></textarea>

    <div class="fileDiv"></div>
    <button type="button" id="fileBtn" onclick="$('#file').click();" class="btn btn-dark">첨부파일</button>
    <button type="button" id="writeBtn" class="btn btn-dark">글작성</button>
    <button type="button" id="toMain" class="btn btn-dark">목록으로</button>
    <input type="hidden" value="${id}" id="writer" name="writer">
</form>

<!-- Footer-->
<footer class="py-5 bg-dark" id="footer" >
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>
<script src="/resources/asset/js/util.js"></script>
<script>
    $("#toMain").on("click", function () {  //게시글 메인 페이지로 이동
        let currentPage = $("#currPage").val();
        let count = $("#count").val();
        location.href = "/board/list?currentPage="+currentPage+"&count="+count;
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
                location.href = "/board/list?currentPage=1"+"&count="+count;
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