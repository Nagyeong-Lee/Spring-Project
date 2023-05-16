$(".myQnA").click(function () {
    let id = $("#loginID").val();
    let newForm = document.createElement("form");
    newForm.setAttribute("action", "/QnA");
    newForm.setAttribute("method", "post");

    let input = document.createElement("input");
    input.setAttribute("name", "id");
    input.setAttribute("type", "hidden");
    input.setAttribute("value", id);

    newForm.appendChild(input);
    document.body.append(newForm);
    newForm.submit();
})