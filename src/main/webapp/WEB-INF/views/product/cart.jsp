<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-04-18
  Time: 오전 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>장바구니</title>
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

        .img {
            width: 500px;
            height: 500px;
        }
    </style>
</head>
<body>

</body>
</html>
