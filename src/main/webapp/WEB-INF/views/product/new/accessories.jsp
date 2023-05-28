<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 10:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
  <title>신상 악세사리</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
<%--  <link rel="stylesheet" type="text/css" href="/resources/navUtil.css">--%>
  <link rel="icon" type="image/x-icon" href="assets/favicon.ico"/>
  <!-- Bootstrap icons-->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css" rel="stylesheet"/>
  <!-- Core theme CSS (includes Bootstrap)-->
  <link href="/resources/asset/css/styles.css" rel="stylesheet"/>
  <style>
    * {
      padding: 0;
      margin: 0
    }

    li {
      list-style: none
    }

    a {
      text-decoration: none;
      font-size: 14px
    }

    .menu {
      width: 800px;
      overflow: hidden;
      margin: auto;
    }

    .menu > li {
      width: 25%; /*20*5=100%*/
      float: left;
      text-align: center;
      line-height: 40px;
      /*background-color: black;*/
    }

    .menu a {
      color: black;
    }

    .submenu > li {
      line-height: 50px;
      /*background-color: black;*/
    }

    .submenu {
      height: 0; /*ul의 높이를 안보이게 처리*/
      overflow: hidden;
    }

    .menu > li:hover {
      /*background-color: black;*/
      transition-duration: 0.1s;
      font-weight: bold;
    }

    .menu > li:hover .submenu {
      height: 250px; /*서브메뉴 li한개의 높이 50*5*/
      transition-duration: 1s;
    }

    .product-list {
      width: 735px;
      margin-left: auto;
      margin-right: auto;
    }

    .products h3 {
      font-size: 24px;
      color: #545454;
      margin-top: 60px;
      margin-bottom: 60px;
      text-align: center;
    }

    .product {
      display: block;
      width: 225px;
      text-align: center;
      text-decoration: none;
      color: black;
      float: left;
      margin-left: 10px;
      margin-right: 10px;
      margin-bottom: 30px;
    }

    .product-name {
      margin-top: 20px;
      margin-bottom: 4px;
    }

    .clearfix {
      clear: both;
    }

    .img {
      width: 200px;
      heigth: 200px;
    }

    html, body {
      height: 100%;
    }
    body {
      display: flex;
      flex-direction: column;
    }
    .detailDiv{
      flex: 1 0 auto;
    }
    #footer {
      position: fixed;
      left: 0;
      bottom: 0;
      width: 100%;
      background-color: #343a40; /* 배경색상 */
      color: white; /* 글자색상 */
      text-align: center; /* 가운데 정렬 */
      padding: 15px; /* 위아래/좌우 패딩 */
    }

    .pagingDiv {
      position: fixed;
      left: 0;
      bottom: 130px;
      width: 100%;
      color: white; /* 글자색상 */
      text-align: center; /* 가운데 정렬 */
      /*padding: 15px; !* 위아래/좌우 패딩 *!*/
    }
  </style>
</head>
<body>
<input type="hidden" value="${keyword}" id="key" name="key">
<%--<%@ include file="/WEB-INF/views/product/navUtil.jsp" %>--%>
<div class="detailDiv">
  <%@ include file="/WEB-INF/views/product/pdListUtil.jsp"%>
  <div class="pagingDiv" style="text-align: center;">
    <c:if test="${paging.needPrev eq true}">
      <a href="javascript:void(0); onclick=paging(${paging.startNavi-1}});"><</a>
      <a href="javascript:void(0); onclick=paging(1);">맨 처음</a>
    </c:if>
    <c:forEach var="i" begin="${paging.startNavi}" end="${paging.endNavi}" varStatus="var">
      <c:if test="${paging.cpage eq i}">
        <a href="javascript:void(0); onclick=paging(${i});" style="font-weight: bold;">${i}</a>
      </c:if>
      <c:if test="${paging.cpage ne i}">
        <a href="javascript:void(0); onclick=paging(${i});">${i}</a>
      </c:if>
    </c:forEach>
    <c:if test="${paging.needNext eq true}">
      <a href="javascript:void(0); onclick=paging(${paging.endNavi+1});">></a>
      <a href="javascript:void(0); onclick=paging(${paging.totalPageCount});">맨끝</a>
    </c:if>
  </div>
  <footer class="py-5 bg-dark" id="footer">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
  </footer>
</div>

<!-- Bootstrap core JS-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Core theme JS-->
<script src="/resources/asset/js/scripts.js"></script>
<script src="/resources/asset/js/shopUtil.js"></script>
<script>

  $("#keyword").val($("#key").val());

  $("#search").on("click",function(){
    let keyword = $("#keyword").val();
    location.href='/product/searchPd?keyword='+keyword;
  });

  $("#cart").click(function(){
    let newForm = document.createElement("form");
    newForm.setAttribute("method","post");
    newForm.setAttribute("action","/product/cart");
    let newInput = document.createElement("input");
    newInput.setAttribute("type","hidden");
    newInput.setAttribute("name","id");
    newInput.setAttribute("value",$("#id").val());
    newForm.appendChild(newInput);
    document.body.append(newForm);
    newForm.submit();
  })

  //페이징 다시 그려줌
  function paging(startNavi) {
    let parentCategory = '신상품';
    let childCategory = '악세사리';
    $.ajax({
      url: '/product/repagingList',
      type: 'post',
      data: {
        "parentCategory": parentCategory,
        "childCategory": childCategory,
        "cpage": startNavi
      },
      success: function (data) {
        $(".pagingDiv").children().remove();
        createPaging(data);
      }
    })
  }

  function createPaging(data) {
    let startNavi = data.paging.startNavi;
    let endNavi = data.paging.endNavi;
    let needPrev = data.paging.needPrev;
    let needNext = data.paging.needNext;
    let productDTOList = data.productDTOList;
    $("#row").children().remove();
    for (let i = 0; i < productDTOList.length; i++) {
      var newHtml = createHtml(productDTOList[i], startNavi);
      $("#row").append(newHtml);
    }
    if (needPrev) {
      var html = createPrev(startNavi);
      $(".pagingDiv").append(html);
    }
    for (let k = startNavi; k <= endNavi; k++) {
      if (startNavi == k) {
        var html = createNewPage1(k);
        $(".pagingDiv").append(html);
      } else {
        var html = createNewPage2(k);
        $(".pagingDiv").append(html);
      }
    }
    if (needNext) {
      var html = createNext(endNavi, totalPageCount);
      $(".pagingDiv").append(html);
    }
  }

  function createHtml(item, cpage) {
    let pdName = item.name;
    let pd_seq = item.pd_seq;
    var HTML = '<div class="col mb-5"><div class="card h-100">';
    HTML += '<img class="card-img-top img" src="/resources/img/products/' + item.img + '" style="width: 225px;">';
    HTML += '<div class="card-body p-4"><div class="text-center"><h5 class="fw-bolder">';
    HTML += '<a href="/product/detail?pd_seq=' + pd_seq + '">' + pdName + '</a></h5>';
    HTML += item.price.toLocaleString() + '원';
    HTML += '</div></div></div></div>';
    return HTML;
  }

  function createPrev(startNavi) {
    var html = '';
    html += '<a href="javascript:void(0);" onclick="paging(' + (startNavi - 1) + ');">' + "<" + '</a>';
    html += '<a href="javascript:void(0);" onclick="paging(' + (1) + ');">' + "맨 처음" + '</a>';
    return html;
  }

  function createNewPage1(k) {
    var html = '';
    html += '<a href="javascript:void(0);" onclick="paging(' + k + ')"> ' + k + ' </a>';
    return html;
  }

  function createNewPage2(k) {
    var html = '';
    html += '<a href="javascript:void(0);" onclick="paging(' + k + ')" style="font-weight: bold;"> ' + k + ' </a>';
    return html;
  }

  function createNext(endNavi, totalPageCount) {
    var html = '';
    html += '<a href="javascript:void(0);" onclick="paging(' + (endNavi + 1) + ');">' + ">" + '</a>';
    html += '<a href="javascript:void(0);" onclick="paging(' + (totalPageCount) + ');">' + "맨끝" + '</a>';
    return html;
  }
</script>
</body>
</html>