$(".myQnA").click(function () {
    let id = $("#id").val();
    let newForm = document.createElement("form");
    newForm.setAttribute("action", "/QnA");
    newForm.setAttribute("method", "post");

    let input = document.createElement("input");
    input.setAttribute("name", "id");
    input.setAttribute("type", "hidden");
    input.setAttribute("value", $("#id").val());


    let input2 = document.createElement("input");
    input2.setAttribute("name", "cpage");
    input2.setAttribute("type", "hidden");
    input2.setAttribute("value", 1);

    newForm.appendChild(input);
    newForm.appendChild(input2);
    document.body.append(newForm);
    newForm.submit();
})