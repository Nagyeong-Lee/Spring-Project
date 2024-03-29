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
                        <li><a class="dropdown-item" href="/product/list?cpage=1">전체 상품</a></li>
                        <li>
                            <hr class="dropdown-divider"/>
                        </li>
                        <li><a class="dropdown-item" href="/product/women" style="font-weight: bold">여성</a></li>
                        <li><a class="dropdown-item" href="/product/women/outer">ㄴ아우터</a></li>
                        <li><a class="dropdown-item" href="/product/women/top">ㄴ상의</a></li>
                        <li><a class="dropdown-item" href="/product/women/pants">ㄴ하의</a></li>
                        <li><a class="dropdown-item" href="/product/women/accessories">ㄴ악세사리</a></li>
                        <li><a class="dropdown-item" href="/product/men" style="font-weight: bold">남성</a></li>
                        <li><a class="dropdown-item" href="/product/men/outer">ㄴ아우터</a></li>
                        <li><a class="dropdown-item" href="/product/men/top">ㄴ상의</a></li>
                        <li><a class="dropdown-item" href="/product/men/pants">ㄴ하의</a></li>
                        <li><a class="dropdown-item" href="/product/men/accessories">ㄴ악세사리</a></li>
                        <li><a class="dropdown-item" href="/product/new" style="font-weight: bold">신상품</a></li>
                        <li><a class="dropdown-item" href="/product/new/outer">ㄴ아우터</a></li>
                        <li><a class="dropdown-item" href="/product/new/top">ㄴ상의</a></li>
                        <li><a class="dropdown-item" href="/product/new/pants">ㄴ하의</a></li>
                        <li><a class="dropdown-item" href="/product/new/accessories">ㄴ악세사리</a></li>
                    </ul>
                </li>
            </ul>
            <span style="margin-left: 150px;">
                <input type="text" id="keyword" name="keyword" placeholder="상품명을 입력해주세요.">
                <button type="button" id="search" class="btn btn-dark">검색</button>
            </span>
            <button class="btn btn-outline-dark" type="button" id="cart" style="margin-left: 10px; width: 110px;">
                <i class="bi-cart-fill me-1"></i>
                Cart
            </button>
            <a href="/product/history?id=${id}&cpage=1">
                <button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;"
                        id="history">
                    구매 내역
                </button>
            </a>
            <a href="/member/toUpdateForm?id=${id}">
                <button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;" id="mypage">
                    내 정보
                </button>
            </a>
            <a href="/member/logout?id=${id}">
                <button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;" id="logout">
                    로그아웃
                </button>
            </a>
            <a href="/board/list?currentPage=1&count=10">
                <button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;">
                    커뮤니티로
                </button>
            </a>
            <button class="btn btn-outline-dark myQnA" type="button" style="margin-left: 10px; width: 110px;">
                나의 Q&A
            </button>
        </div>
    </div>
</nav>


<header class="bg-dark py-5">
    <div class="container px-4 px-lg-5 my-5">
        <div class="text-center text-white">
        </div>
    </div>
</header>
<!-- Section-->
<section class="py-5" style="margin-top: -80px;">
    <div class="container px-4 px-lg-5 mt-5">
        <div class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center" id="row" style="margin-bottom: 50px;">
            <c:choose>
                <c:when test="${!empty productDTOList}">
                    <c:forEach var="i" items="${productDTOList}">
                        <div class="col mb-5">
                            <div class="card h-100">
                                <img class="card-img-top img" src="/resources/img/products/${i.img}"
                                     style="width: 225px;">
                                <div class="card-body p-4">
                                    <div class="text-center">
                                        <h5 class="fw-bolder">
                                            <a href="/product/detail?pd_seq=${i.pd_seq}">${i.name}</a>
                                        </h5>
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
