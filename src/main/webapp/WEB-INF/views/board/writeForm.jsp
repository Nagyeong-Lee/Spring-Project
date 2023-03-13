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
             $(".summernote").summernote({
                           height: 300,                 // 에디터 높이
                           minHeight: null,             // 최소 높이
                           maxHeight: null,             // 최대 높이
                           focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
                           lang: "ko-KR",					// 한글 설정
                           placeholder: '글을 입력하세요.'	//placeholder 설정
             });
        });
    </script>
</head>
<body>
    <form action="/board/insert" method="post">
        <div class="title">
           제목 <input type="text" id="title" name="title">
        </div>
        <div class="writer">
           작성자 : ${id}
        </div>
        <textarea id="content" name="content" class="summernote"></textarea>
        <input type="file">
        <button type="submit">글작성</button>
        <button type="button" id="toMain">목록으로</button>
        <input type="hidden" value="${id}" id="writer" name="writer">
    </form>

    <script>
      $("#toMain").on("click",function(){  //게시글 메인 페이지로 이동
            location.href="/board/list?currentPage=1&count=10";
        });
    </script>
</body>
</html>