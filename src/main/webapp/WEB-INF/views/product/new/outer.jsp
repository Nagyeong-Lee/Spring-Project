<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 10:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>신상 아우터</title>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js"
          integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous">
  </script>
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
    .img{
      width: 200px;
      heigth: 200px;
    }
  </style>
</head>
<body>


<ul class="menu">
  <li>
    <a href="/product/list">전체 상품</a>
  </li>
  <li>
    <a href="/product/women">여성</a>
    <ul class="submenu">
      <li><a href="/product/women/outer">아우터</a></li>
      <li><a href="/product/women/top">상의</a></li>
      <li><a href="/product/women/pants">하의</a></li>
      <li><a href="/product/women/accessories">악세사리</a></li>
    </ul>
  </li>
  <li>
    <a href="/product/men">남성</a>
    <ul class="submenu">
      <li><a href="/product/men/outer">아우터</a></li>
      <li><a href="/product/men/top">상의</a></li>
      <li><a href="/product/men/pants">하의</a></li>
      <li><a href="/product/men/accessories">악세사리</a></li>
    </ul>
  </li>
  <li>
    <a href="/product/new">신상품</a>
    <ul class="submenu">
      <li><a href="/product/new/outer">아우터</a></li>
      <li><a href="/product/new/top">상의</a></li>
      <li><a href="/product/new/pants">하의</a></li>
      <li><a href="/product/new/accessories">악세사리</a></li>
    </ul>
  </li>
</ul>

<div class="product-list">
  <c:choose>
    <c:when test="${!empty productDTOList}">
      <c:forEach var="i" items="${productDTOList}">
        <div class="product">
          <img src="/resources/img/products/${i.img}" width="225" class="img">
          <div class="product-name">
            <a href="/product/detail?pd_seq=${i.pd_seq}">${i.name}</a>
          </div>
          <div class="product-price">
              ${i.price}원
          </div>
        </div>
      </c:forEach>
    </c:when>
  </c:choose>
</div>
</body>
</html>
