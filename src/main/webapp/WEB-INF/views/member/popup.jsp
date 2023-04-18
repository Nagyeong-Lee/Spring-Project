<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-15
  Time: 오후 7:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>일정 등록</title>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<input type="file" id="file" name="file" multiple="multiple" style="display: none;">
<form action="/member/addEvent" method="post" enctype="multipart/form-data" id="frm">
    <div>${id}님</div>
    제목 : <input type="text" id="title" name="title"><br>
    <input type="date" id="startDate" name="startDate"><input type="time" id="startTime" name="startTime">~
    <input type="date" id="endDate" name="endDate"><input type="time" id="endTime" name="endTime"><br>
    <input type="content" style="width: 500px; height: 200px;" id="content" name="content"><br>
    <div class="fileDiv"></div>
    <button type="button" id="fileBtn" onclick="$('#file').click();">첨부파일</button>
    <div class="btns">
        <button type="button" id="register">등록</button>
        <button type="button" id="cancle">취소</button>
    </div>
    <input type="hidden" id="id" name="id" value="${id}">
</form>

<script>

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

    //등록 클릭 시
    $("#register").on("click", function () {
        let id = $("#id").val();
        let title = $("#title").val();
        let startDate = $("#startDate").val();
        let startTime = $("#startTime").val();
        let endDate = $("#endDate").val();
        let endTime = $("#endTime").val();
        let content = $("#content").val();
        let file_length = $("#file")[0].files.length;
        let frm = $('#frm')[0];

        let data = new FormData(frm);

        for (var i = 0; i < file.length; i++) {
            console.log(file[i]);
            data.append("file", file[i]);
        }

        $.ajax({
            url: "/member/addEvent"
            , type: "POST"
            , enctype: 'multipart/form-data'
            , data: data
            , processData: false
            , contentType: false
            , cache: false
            , isModal: true
            , isModalEnd: true
            ,success:function(data){
                if(data==='success'){
                    alert('글 작성 완료');
                    window.close();
                    location.href='/member/toDoList';
                }
            }
        });
    });

    //취소 클릭
    $("#cancle").on("click", function () {
        window.close();
    });
</script>
</body>
</html>
