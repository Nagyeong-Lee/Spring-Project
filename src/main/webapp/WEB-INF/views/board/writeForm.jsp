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
<form action="/board/insert" method="post" enctype="multipart/form-data" id="frm">
    <div class="title">
        제목 <input type="text" id="title" name="title">
    </div>
    <div class="writer">
        작성자 : ${id}
    </div>
    <textarea id="content" name="content" class="summernote"></textarea>

    <input type="hidden" id="b_seq" name="b_seq" value="${b_seq}">
    <input type="file" id="file" name="file" multiple="multiple">

    <div class="fileDiv"></div>

    <button type="submit">글작성</button>

    <button type="button" id="toMain">목록으로</button>
    <input type="hidden" value="${id}" id="writer" name="writer">
</form>


<script>
    $("#toMain").on("click", function () {  //게시글 메인 페이지로 이동
        location.href = "/board/list?currentPage=1&count=10";
    });

    // let formData = new FormData();
    // let b_seq = $("#b_seq").val();
    //
    // $("#upload").on("click", function () {
    //
    //     formData.append('b_seq', b_seq);
    //     let inputFile = $('input[name="file"]');
    //     let files = inputFile[0].files;
    //     console.log(files);
    //     for (let i = 0; i < files.length; i++) {
    //         formData.append('file', files[i]);
    //     }
    //     console.log("form-data : " + formData);
    //     $.ajax({
    //         type: "POST",
    //         enctype: 'multipart/form-data',
    //         url: '/file/insert',
    //         data: formData,
    //         processData: false,
    //         contentType: false,
    //         cache: false
    //     }).done(function (resp) {
    //         console.log('파일 업로드 완료');
    //         if (resp.size() > 0) {
    //             for (let i = 0; i < resp.size(); i++) {
    //                 let sysname = resp.get(i).get("sysname");
    //                 let str = '<div>sysname<button type=button id="removeBtn" onclick="removeFile()">X</button></div>';
    //                 $(".fileNameDiv").append(str);
    //             }
    //         }
    //
    //     });

    let arr = [];  //새로운 파일

    $("#file").on("change", function () {
        const dataTransfer = new DataTransfer();
        let inputFile = $('input[name="file"]');
        let files = inputFile[0].files;
        console.log(files.length);  //파일개수
        for (let i = 0; i < files.length; i++) {
            console.log(files[i].name); //파일 이름
            arr.push(files[0].name);

            dataTransfer.items.add(files[i]);

            let str = '<div id="i">' + files[i].name + '<button type="button" onclick="removeFile(' + i + ')">x</button>' + '</div>';
            $(".fileDiv").append(str);
        }
        document.getElementById("file").files = dataTransfer.files;
        console.log("dataTransfer =>", dataTransfer.files);
        console.log("input FIles =>", document.getElementById("file").files);
    });

    function removeFile(i) {   // x버튼 클릭 시 삭제
        console.log("i : " + i)
        const dataTransfer = new DataTransfer();
        $("#i").remove();
        let files = $('#file')[0].files;	//사용자가 입력한 파일을 변수에 할당

        let fileArray = Array.from(files);	//변수에 할당된 파일을 배열로 변환(FileList -> Array)

        fileArray.splice(i, 1);	//해당하는 index의 파일을 배열에서 제거
        let size = files.length;
        console.log("files size : " + size);
        fileArray.forEach(file => {
            dataTransfer.items.add(file);
        });
        //남은 배열을 dataTransfer로 처리(Array -> FileList)

        $('#file')[0].files = dataTransfer.files;	//제거 처리된 FileList를 돌려줌
        console.log(files);
    }

    // 파일 삭제
    // 파일 다운가능
</script>
</body>
</html>