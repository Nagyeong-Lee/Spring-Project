<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>ID 찾기</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
    <div class="searchIdBox">
            <div>
                 이메일 &nbsp<input type="text" placeholder='이메일을 입력해주세요' id="email" name="email">
                 <button type="button" id="searchIdBtn">찾기</button>
            </div>
            <div class="text" id="text"></div>
        <a href="/"><button type="button">목록으로</button></a>
    </div>

    <script>
    $("#searchIdBtn").on("click",function(){
        let email = $("#email").val();
        $.ajax({
            url:"/member/searchId",
            type:"post",
            data:{"email" : email},
            async:false
        }).done(function(data){
            if(data != 'NONE'){
                $("#text").text("ID : "+data);
            }else{
                $("#text").text("아이디가 존재하지 않습니다.");
            }
        });
    });
    </script>
</body>
</html>