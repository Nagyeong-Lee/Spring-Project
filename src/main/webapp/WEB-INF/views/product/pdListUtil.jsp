<%--
  Created by IntelliJ IDEA.
  User: 이나경
  Date: 2023-04-18
  Time: 오후 11:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<input type="hidden" value="${id}" id="id" name="id">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container px-4 px-lg-5">
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">Shop</a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="/product/list">전체 상품</a></li>
                        <li>
                            <hr class="dropdown-divider"/>
                        </li>
                        <li><a class="dropdown-item" href="/product/women">여성</a></li>
                        <li><a class="dropdown-item" href="/product/women/outer">여성-아우터</a></li>
                        <li><a class="dropdown-item" href="/product/women/top">여성-상의</a></li>
                        <li><a class="dropdown-item" href="/product/women/pants">여성-하의</a></li>
                        <li><a class="dropdown-item" href="/product/women/accessories">여성-악세사리</a></li>
                        <li><a class="dropdown-item" href="/product/men">남성</a></li>
                        <li><a class="dropdown-item" href="/product/men/outer">남성-아우터</a></li>
                        <li><a class="dropdown-item" href="/product/men/top">남성-상의</a></li>
                        <li><a class="dropdown-item" href="/product/men/pants">남성-하의</a></li>
                        <li><a class="dropdown-item" href="/product/men/accessories">남성-악세사리</a></li>
                        <li><a class="dropdown-item" href="/product/new">신상품</a></li>
                        <li><a class="dropdown-item" href="/product/new/outer">신상품-아우터</a></li>
                        <li><a class="dropdown-item" href="/product/new/top">신상품-상의</a></li>
                        <li><a class="dropdown-item" href="/product/new/pants">신상품-하의</a></li>
                        <li><a class="dropdown-item" href="/product/new/accessories">신상품-악세사리</a></li>
                    </ul>
                </li>
            </ul>
            <span style="margin-left: 400px;">
                <input type="text" id="keyword" name="keyword" placeholder="상품명을 입력해주세요.">
                <button type="button" id="search" class="btn btn-dark">찾기</button>
            </span>
            <button class="btn btn-outline-dark" type="button" id="cart" style="margin-left: 10px;" >
                <i class="bi-cart-fill me-1"></i>
                Cart
            </button>
            <a href="/member/toUpdateForm?id=${id}"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px;" id="mypage">
                내 정보
            </button></a>
            <a href="/member/logout?id=${id}"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px;" id="logout">
                로그아웃
            </button></a>
            <a href="/board/list?currentPage=1&count=10"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px;">
                커뮤니티로
            </button></a>
        </div>
    </div>
</nav>

<!-- Header-->
<header class="bg-dark py-5">
    <div class="container px-4 px-lg-5 my-5">
        <div class="text-center text-white">
            <%--            <h1 class="display-4 fw-bolder">Shop in style</h1>--%>
            <%--            <p class="lead fw-normal text-white-50 mb-0">With this shop hompeage template</p>--%>
        </div>
    </div>
</header>
<!-- Section-->
<section class="py-5">
    <div class="container px-4 px-lg-5 mt-5">
        <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center">
            <c:choose>
                <c:when test="${!empty productDTOList}">
                    <c:forEach var="i" items="${productDTOList}">
                        <div class="col mb-5">
                            <div class="card h-100">
                                <!-- Product image-->
                                <img class="card-img-top img" src="/resources/img/products/${i.img}"
                                     style="width: 225px;">
                                <!-- Product details-->
                                <div class="card-body p-4">
                                    <div class="text-center">
                                        <!-- Product name-->
                                        <h5 class="fw-bolder">
                                            <a href="/product/detail?pd_seq=${i.pd_seq}">${i.name}</a>
                                        </h5>
                                        <!-- Product price-->
                                        <fmt:formatNumber value="${i.price}" pattern="#,###"/>원
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
            </c:choose>
        </div>
    </div>
</section>
<!-- Footer-->
<footer class="py-5 bg-dark" id="ft">
    <div class="container"><p class="m-0 text-center text-white">Copyright &copy; Your Website 2023</p></div>
</footer>


<%--<div class="product-list">--%>
<%--    <c:choose>--%>
<%--        <c:when test="${!empty productDTOList}">--%>
<%--            <c:forEach var="i" items="${productDTOList}">--%>
<%--                <div class="product">--%>
<%--                    <img src="/resources/img/products/${i.img}" width="225" class="img">--%>
<%--                    <div class="product-name">--%>
<%--                        <a href="/product/detail?pd_seq=${i.pd_seq}">${i.name}</a>--%>
<%--                    </div>--%>
<%--                    <div class="product-price">--%>
<%--                        <fmt:formatNumber value="${i.price}" type="number"/>원<br>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </c:forEach>--%>
<%--        </c:when>--%>
<%--    </c:choose>--%>
<%--</div>--%>
