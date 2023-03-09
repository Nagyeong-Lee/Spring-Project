<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>회원가입 페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<div class="signUpBox">
    <form action="/member/signUp" method="post" id="frm" name="signUp_form" enctype="multipart/form-data">

        <div>아이디
            <input type="text" id="id" name="id" placeholder="영어,숫자 6~10자">
            <span id="checkId"></span>
        </div>
        <div class="idDupleCheck"></div>
        <div>비밀번호
            <input type="text" id="pw" name="pw" placeholder="영어,숫자,~,!,@,$,^ 8~15자">
            <span id="checkPw"></span>
        </div>
        <div>비밀번호 확인
            <input type="text" id="checkPwOk" name="checkPwOk">
            <span id="equalPw"></span>
        </div>
        <div>
            이름<input type="text" id="name" name="name" placeholder="2~5자">
            <span id="checkName"></span>
        </div>
        <div>
            이메일<input type="text" id="email" name="email">
            <span id="checkEmail"></span><br>
            <input type="button" id="authenticBtn" name="authenticBtn" value="인증하기">
        </div>
        <div class="emailDupleCheck"></div>
        <div>
            인증번호<input type="text" id="authenticNum" name="authenticNum" placeholder="인증번호 입력">
            <span id="checkAuthenticNum" name="checkAuthenticNum"></span>
        </div>
        <div>
            전화번호<input type="text" id="phone" name="phone" placeholder="숫자만 입력">
            <span id="checkPhone"></span>
        </div>

        <input type="text" id="postcode" name="postcode" placeholder="우편번호">
        <input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기"><br>
        <input type="text" id="roadAddress" name="roadAddress" placeholder="도로명주소"><br>
        <input type="text" id="jibunAddress" name="jibunAddress" placeholder="지번주소"><br>
        <input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소">

        <div>프로필 사진<br>
            <input type="file" id="file" name="file"><br>
            <span id="isFileExist" name="isFileExist"></span>
        </div>
        <div>

            <button type="button" id="btn">회원가입</button>

            <a href="/">
                <button type="button">취소
            </a>
        </div>
    </form>
</div>


<script>

    $("#authenticBtn").hide();

    //아이디 중복 체크 (포커스 이동시)
    let idDupleCheck = false;
    $("#id").on("change", function () {

        let id = $("#id").val();

        //아이디 입력 안했을 때
        if (id.length == 0) {
            $(".idDupleCheck").text("아이디를 입력해주세요.");
            return false;
        }
        $(".idDupleCheck").text("");

        $.ajax({
            url: '/member/idDupleCheck',
            type: 'post',
            data: {
                "id": id
            }
        }).done(function (res) {
            if (res == 1) {
                idDupleCheck = false;
            } else {
                idDupleCheck = true;
            }
        });
    });

    //이메일 중복 체크
    let emailDupleCheck = false;
    $("#email").on("change", function () {

        let email = $("#email").val();

        $.ajax({
            url: "/member/emailDupleCheck",
            type: "post",
            data: {"email": email}
        }).done(function (res) {
            if (res == 1) {
                emailDupleCheck = false;
            } else {
                emailDupleCheck = true;
                //인증하기 버튼 보여주기
                $("#authenticBtn").show();
            }
        });
    });

    //pw 일치 여부
    let pwOk = false;

    //6글자 랜덤 숫자 생성
    function randomString() {
        const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz';
        const stringLength = 6;
        let randomstring = '';
        for (let i = 0; i < stringLength; i++) {
            const rnum = Math.floor(Math.random() * chars.length);
            randomstring += chars.substring(rnum, rnum + 1);
        }
        return randomstring;
    }

    let msg = randomString();
    console.log(msg);

    //메일 인증하기 클릭 시
    $("#authenticBtn").on("click", function () {
        console.log('버튼 클릭');
        $.ajax({
            url: "/mail",
            type: "post",
            data: {
                "address": $("#email").val(),
                "title": "회원가입 인증",
                "message": msg
            }
        }).done(function (resp) {
            alert("인증번호를 전송했습니다.");
        });
    });


    //유효성 검사
    $('#btn').on('click', function () {

        let id = $("#id").val();
        let pw = $("#pw").val();
        let checkPwOk = $("#checkPwOk").val();
        let name = $("#name").val();
        let email = $("#email").val();
        let authenticEmail = $("#authenticNum").val();
        let phone = $("#phone").val();
        let postcode = $("#postcode").val();
        let roadAddress = $("#roadAddress").val();
        let jibunAddress = $("#jibunAddress").val();
        let file = $("#file").val();

        console.log("id :" + id);
        console.log("pw :" + pw);
        console.log("checkPwOk :" + checkPwOk);
        console.log("name :" + name);
        console.log("email :" + email);
        console.log("authenticEmail :" + authenticEmail);
        console.log("phone :" + phone);
        console.log("postcode :" + postcode);
        console.log("roadAddress :" + roadAddress);
        console.log("jibunAddress :" + jibunAddress);
        console.log("file :" + file);

        //정규식
        let regexId = /^[a-zA-Z0-9]{6,10}$/;
        let regexPw = /^[a-zA-Z0-9\~\!\@\$\^]{8,15}$/;
        let regexName = /^[가-힣]{2,5}$/;
        let regexEmail = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.com/;
        let regexPhone = /^010\d{4}\d{4}$/;


        //아이디 공백
        if (id == '') {
            alert("아이디를 입력해주세요.");
            return false;
        }

        //아이디 유효성
        if (regexId.test(id) == false) {
            alert("아이디 형식이 맞지 않습니다.");
            return false;
        }

        //아이디 중복 체크
        if (idDupleCheck == false) {
            alert("중복된 아이디입니다.");
            return false;
        }

        //pw 공백
        if (pw == '') {
            alert("비밀번호를 입력해주세요");
            return false;
        }

        //pw 유효성
        if (regexPw.test(pw) == false) {
            alert("비밀번호 형식이 맞지 않습니다.");
            return false;
        }

        //비밀번호 확인칸 공백
        if (checkPwOk == '') {
            alert("비밀번호를 확인해주세요.");
            return false;
        }

        //pw 불일치
        if (pw != checkPwOk) {
            alert("비밀번호가 일치하지 않습니다.");
            return false;
        }

        //이름 공백
        if (name == '') {
            alert("이름을 입력해주세요.");
            return false;
        }

        //이름 유효성
        if (regexName.test(name) == false) {
            alert("이름 형식이 맞지 않습니다.");
            return false;
        }

        //이메일 공백
        if (email == '') {
            $("#email").focus();
            alert("이메일을 입력해주세요");
            return false;
        }

        //이메일 유효성
        if (regexEmail.test(email) == false) {
            alert("이메일 형식이 맞지 않습니다.");
            return false;
        }

        //이메일 중복일때
        if (emailDupleCheck == false) {
            alert("중복된 이메일입니다.");
            return false;
        }


        //이메일 인증 칸 공백
        if (authenticEmail == '') {
            alert("인증번호를 입력해주세요.");
            return false;
        }

        //인증번호 다를때
        if ($("#authenticNum").val() != msg) {
            console.log("인증번호 불일치");
            alert("인증번호가 일치하지 않습니다.");
            return false;
        }

        //전화번호 공백
        if (phone == '') {
            alert("전화번호를 입력해주세요.");
            return false;
        }

        //전화번호 유효성
        if (regexPhone.test(phone) == false) {
            $("#checkPhone").text("전화번호 형식이 맞지 않습니다.");
            alert("전화번호 형식이 맞지 않습니다.");
            return false;
        }

        //우편번호 공백
        if (postcode == '') {
            console.log(postcode);
            alert("우편번호를 입력해주세요.");
            return false;
        }
        //도로명 주소 공백
        if (roadAddress == '') {
            alert("도로명주소를 입력해주세요.");
            return false;
        }
        //지번주소 공백
        if (jibunAddress == '') {
            alert("지번주소를 입력해주세요.");
            return false;
        }

        // 파일 없을 때
        if (file == '') {
            alert("파일을 첨부해주세요.");
            return false;
        }

        $('#frm').submit();
    });

    //카카오 우편번호 api
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if (extraRoadAddr !== '') {
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("roadAddress").value = roadAddr;
                document.getElementById("jibunAddress").value = data.jibunAddress;
            }
        }).open();
    }
</script>
</body>
</html>