<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>정보수정페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
    </script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        img {
            width: 200px;
            height: 200px;
        }
    </style>
</head>
<body>
<c:if test="${not empty memberDTO}">
    <div class="updateInfoBox">
        <form action="/member/update" method="post" id="frm" enctype="multipart/form-data">
            <div>아이디
                <input type="hidden" id="id" name="id" value="${memberDTO.id}">
                <input type="text" disabled="disabled" placeholder="영어,숫자 6-10" value=${memberDTO.getId()}>
                <span id="checkId"></span>
            </div>
            <div class="idDupleCheck"></div>
            <div>비밀번호
                <input type="password" id="pw" name="pw" placeholder="영어,숫자,~,!,@,$,^ 8-15">
                <span id="checkPw"></span>
            </div>
            <div>비밀번호 확인
                <input type="password" id="checkPwOk" name="checkPwOk">
                <span id="equalPw"></span>
            </div>
            <div>
                이름<input type="text" id="name" name="name" placeholder="2~5자">
                <span id="checkName"></span>
            </div>
            <div>
                <input type="hidden" id="email" name="email" value="${memberDTO.email}">
                이메일<input type="text" value="${memberDTO.email}" disabled="disabled">
                <span id="checkEmail"></span><br>
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
            </div>
            <div>
                <button type="button" id="updateBtn">수정하기</button>
                <a href="/">
                    <button type="button">취소</button>
                </a>
            </div>
        </form>
    </div>
</c:if>


<script>

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

    //유효성 검사
    $('#updateBtn').on('click', function () {

        let pw = $("#pw").val();
        let checkPwOk = $("#checkPwOk").val();
        let name = $("#name").val();
        let phone = $("#phone").val();
        let postcode = $("#postcode").val();
        let roadAddress = $("#roadAddress").val();
        let jibunAddress = $("#jibunAddress").val();
        let file = $("#file").val();

        //정규식
        let regexPw = /^[a-zA-Z0-9\~\!\@\$\^]{8,15}$/;
        let regexName = /^[가-힣]{2,5}$/;
        let regexPhone = /^010\d{4}\d{4}$/;

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

                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = '';

                if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                    extraRoadAddr += data.bname;
                }

                if (data.buildingName !== '' && data.apartment === 'Y') {
                    extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }

                if (extraRoadAddr !== '') {
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }

                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("roadAddress").value = roadAddr;
                document.getElementById("jibunAddress").value = data.jibunAddress;
            }
        }).open();
    }

</script>
</body>
</html>