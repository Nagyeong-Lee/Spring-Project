<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>리뷰 작성</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <%--    <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/resources/cart.css">
    <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
    <!-- Core theme CSS (includes Bootstrap)-->
    <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
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

        .pagingDiv {
            position: fixed;
            left: 0;
            bottom: 400px;
            width: 100%;
            color: white; /* 글자색상 */
            text-align: center; /* 가운데 정렬 */
            padding: 15px; /* 위아래/좌우 패딩 */
        }
    </style>
    <script>
        let k = 0;
        let imgArr = [];
        let fileArr = []; //보낼 파일 배열

        function delFile(i) {  //x버튼 클릭 시 삭제
            $("#k").remove();
            let splice = imgArr.splice(i, 1);
            console.log("imgArr : " + imgArr);
            console.log("fileArr : " + fileArr);
            fileArr = imgArr;
            console.log("fileArr : " + fileArr);
            create_html();
        }

        function create_html() {
            let inputFile = $('input[name="file"]');
            let files = inputFile[0].files;
            let str = '';
            $(".fileDiv").empty();
            for (let k = 0; k < fileArr.length; k++) {
                str += '<div id=' + k + '>' + fileArr[k].name + '<button type="button" onclick="delFile(' + k + ')">x</button>' + '</div>';
            }
            $(".fileDiv").append(str);
        }

        $(function () {
            $('.summernote').summernote({
                minHeight: 500,             // 최소 높이
                maxHeight: null,             // 최대 높이
                focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
                lang: "ko-KR", // 한글 설정
                callbacks: {
                    onImageUpload: function (files, editor, welEditable) {
                        for (var i = files.length - 1; i >= 0; i--) {
                            sendFile(files[i], this);
                        }
                    }
                }
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

            //취소 클릭
            $("#cancleBtn").click(function () {
                let id = $("#id").val();
                let form = document.createElement("form");
                form.setAttribute("method", "post");
                form.setAttribute("action", "/product/history");

                let input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.setAttribute("name", "id");
                input.setAttribute("value", id);

                form.appendChild(input);
                document.body.append(form);
                form.submit();
            })

            //파일 변경
            $("#file").on("change", function () {
                let inputFile = $('input[name="file"]');
                let files = inputFile[0].files;
                console.log(files)
                console.log(files.length)
                for (let i = 0; i < files.length; i++) {
                    imgArr.push(files[i]);
                    console.log(imgArr)
                    let str = '<div id=' + k + '>' + files[i].name + '<button type="button" onclick="delFile(' + k + ')">x</button>' + '</div>';
                    k++
                    $(".fileDiv").append(str);
                }
                fileArr = imgArr;  //복사
                $('input[name="file"]').val("");  //input 초기화
            });


            //리뷰 작성
            $("#writeBtn").click(function () {
                let fileArrLength = fileArr.length;
                if($("#content").val().length === 0){
                    alert('리뷰를 작성해주세요');
                    return;
                }
                if (fileArrLength > 5) {  //사진 개수 제한
                    alert('사진은 최대 5개까지 첨부가능합니다.');
                    return;
                }

                let frm = $('#frm')[0];

                let data = new FormData(frm);

                for (var i = 0; i < fileArr.length; i++) {
                    data.append("file", fileArr[i]);
                }

                alert('리뷰 작성 완료');

                $.ajax({
                    url: "/pdReview/insertReview"
                    , type: "POST"
                    , enctype: 'multipart/form-data'
                    , data: data
                    , processData: false
                    , contentType: false
                    , cache: false
                    , isModal: true
                    , isModalEnd: true
                    , success: function (data) {
                        let id = $("#id").val();
                        let form = document.createElement("form");
                        form.setAttribute("method", "post");
                        form.setAttribute("action", "/product/history");

                        let input = document.createElement("input");
                        input.setAttribute("type", "hidden");
                        input.setAttribute("name", "id");
                        input.setAttribute("value", id);

                        form.appendChild(input);
                        document.body.append(form);
                        form.submit();
                    }, error: function (e) {
                    }
                });
            })
        });
    </script>

</head>
<body>
<input type="hidden" id="id" name="id" value="${id}">
<input type="file" name="file" id="file" multiple style="display: none;">
<%@ include file="/WEB-INF/views/product/shopUtil.jsp" %>
<h5>리뷰 작성</h5>
<form action="/pdReview/insertReview" method="post" id="frm">
    <div class="star">
        별점 선택
        <select name="star">
            <c:forEach var="i" begin="1"  end="5">
                <option value="${i}">${i}</option>
            </c:forEach>
        </select>
    </div>
    <input type="hidden" name="payPd_seq" id="payPd_seq" value="${payPd_seq}">
    <input type="hidden" name="pd_seq" id="pd_seq" value="${pd_seq}">
    <input type="hidden" name="loginID" id="loginID" value="${id}">
    <textarea id="content" name="content" class="summernote"></textarea>

    <div class="files">
        <button type="button" onclick="$('#file').click();">첨부파일</button>
    </div>

    <div class="fileDiv"></div>

    <div class="cart__mainbtns btns">
        <button class="btn btn-light"  type="button" id="writeBtn">리뷰 작성</button>
        <button class="btn btn-light"  type="button" id="cancleBtn">취소</button>
    </div>
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/resources/asset/js/scripts.js"></script>
</body>
</html>