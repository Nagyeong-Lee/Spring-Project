let id = $("#sessionID").val();
//커뮤니티로 이동
$("#btn1").on("click", function () {
    location.href = '/board/list?currentPage=1&count=10';
});

//계정 탈퇴
$("#btn2").on("click", function () {
    if (confirm("탈퇴하시겠습니까?")) {
        location.href = $("#2").val() + id;
    }
});

//로그아웃
$("#logout").on("click", function () {
    if (confirm("로그아웃하시겠습니까?")) {
        location.href = '/member/logout?id=' + id;
    }
});

//정보 수정 페이지로 이동
$("#btn4").on("click", function () {
    location.href = '/member/toUpdateForm?id=' + id;
});

//병원 정보
function api1() {
    $('#frm').html("");
    var form = $('form[name="frm"]')[0];
    var html = '<input type="hidden" value="1" name="currentPage" />';
    html += '<input type="hidden" value="10" id="count" name="count" />';
    html += '<input type="hidden" value="" id="searchType" name="searchType" />';
    html += '<input type="hidden" value="" id="keyword" name="keyword" />';
    $('#frm').append(html);

    form.action = $("#api1").val();
    form.submit();
}

//일별 감염자수
function api2() {
    let form = $('form[name="frm2"]')[0];
    form.action = $("#api2").val();
    form.submit();
}

//월별 감염자수
function api3() {
    let form = $("#frm3")[0];
    form.action = $("#api3").val();
    form.submit();
}

$("#toCart").click(function () {
    let newForm = document.createElement("form");
    newForm.setAttribute("method", "post");
    newForm.setAttribute("action", "/product/cart");
    let newInput = document.createElement("input");
    newInput.setAttribute("type", "hidden");
    newInput.setAttribute("name", "id");
    newInput.setAttribute("value", $("#sessionID").val());
    newForm.appendChild(newInput);
    document.body.append(newForm);
    newForm.submit();
})