<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>정보수정페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
</head>
<body>
<c:if test="${not empty memberDTO}">
    <div class="updateInfoBox">
        <form action="/member/update" method="post" id="frm">
            <div>아이디
                <input type="text" id="id" name="id" placeholder="영어,숫자 6~10자" value=${memberDTO.getId()}>
                <span id="checkId"></span>
            </div>
            <div class="idDupleCheck"></div>
            <div>
                <button type="button" id="tempPwBtn">임시 비밀번호 받기</button>
            </div>
            <div>임시 비밀번호
                <input type="text" id="tempPw" name="tempPw">
                <span id="changedPw"></span>
            </div>
            <div>
                이름<input type="text" id="name" name="name" placeholder="2~5자" value=${memberDTO.getName()}>
                <span id="checkName"></span>
            </div>
            <div>
                이메일<input type="text" id="email" name="email" value=${memberDTO.getEmail()}>
                <span id="checkEmail"></span><br>
                <input type="button" id="authenticBtn" name="authenticBtn" value="인증하기">
            </div>
            <div>
                인증번호<input type="text" id="authenticNum" name="authenticNum" placeholder="인증번호 입력">
                <span id="checkAuthenticNum" name="checkAuthenticNum"></span>
            </div>
            <div>
                전화번호<input type="text" id="phone" name="phone" placeholder="숫자만 입력" value=${memberDTO.getPhone()}>
                <span id="checkPhone"></span>
            </div>

            <input type="text" id="postcode" name="postcode" placeholder="우편번호" value=${memberDTO.getPostcode()}>
            <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
            <input type="text" id="roadAddress" name="roadAddress" placeholder="도로명주소"
                   value=${memberDTO.getRoadAddress()}><br>
            <input type="text" id="jibunAddress" name="jibunAddress" placeholder="지번주소"
                   value=${memberDTO.getJibunAddress()}><br>
            <input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소"
                   value=${memberDTO.getDetailAddress()}>

            <div>프로필 사진<br>
                <input type="file" id="file" name="file"><br>
                <span id="isFileExist" name="isFileExist"></span>
            </div>
            <div>
                <button type="button" id="updateBtn">수정하기</button>
                <a href="/">
                    <button type="button">취소
                </a>
            </div>
        </form>
    </div>
</c:if>


<script>

    //8글자 랜덤 숫자 생성
    function randomString() {
        const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz';
        const stringLength = 8;
        let randomstring = '';
        for (let i = 0; i < stringLength; i++) {
            const rnum = Math.floor(Math.random() * chars.length);
            randomstring += chars.substring(rnum, rnum + 1);
        }
        return randomstring;
    }

    // 임시 비번 발송

    let tempPw = randomString();
    let email = $("#email").val();

    $("#tempPwBtn").on("click", function () {
        $.ajax({
            url: "/mail",
            type: "post",
            data: {
                "address": email,
                "title": '임시 비밀번호',
                "tempPw": tempPw
            }
        }).done(function (resp) {
            alert("임시 비밀번호를 발송했습니다.");
        });
    });


    $("#updateBtn").on("click", function () {


        $("#frm").submit();
    });
</script>
</body>
</html>