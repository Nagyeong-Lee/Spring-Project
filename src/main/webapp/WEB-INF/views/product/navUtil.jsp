<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-04-18
  Time: 오후 11:04
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<input type="hidden" value="${id}" id="session">
<div style="text-align: right">
    <a href="/member/logout?id=${id}">로그아웃</a>
    <a href="#" onclick="toCart()">장바구니로</a>
</div>
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