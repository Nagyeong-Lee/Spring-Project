<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>PW 찾기</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
    <div class="searchPwBox">
           <div>
                아이디 &nbsp<input type="text" placeholder='아이디를 입력해주세요' id="id" name="id">
                <button type="button" id="searchPwBtn">찾기</button>
           </div>
           <div class="text" id="text"></div>
           <a href="/"><button type="button">목록으로</div></button>
    </div>

    <script>
    $("#searchPwBtn").on("click",function(){
        let id = $("#id").val();
        $.ajax({
            url:"/member/searchPw",
            type:"post",
            data:{"id" : id},
            async:false
        }).done(function(data){
            console.log(data);
            if(data!="NONE"){
                $("#text").text("PW : "+data);
            }else{
                $("#text").text("비밀번호가 존재하지 않습니다.");
            }
        });
    });
    </script>
</body>
</html>