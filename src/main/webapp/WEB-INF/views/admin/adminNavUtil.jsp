<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-05-09
  Time: 오전 10:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<input type="hidden" value="${id}" id="id" name="id">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container px-4 px-lg-5">
    <div class="collapse navbar-collapse" id="navbarSupportedContent" style="margin-left: 25%;">
     <a href="/admin/registerPd"><button class="btn btn-outline-dark" type="button" id="cart" style="margin-left: 10px; width: 150px;">
        상품 등록
      </button></a>
      <a href="/admin/registeredPd?cpag=1"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 150px;" id="history">
        등록 상품 조회
      </button></a>
      <a href="/admin/salesList?cpage=1"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 150px;">
        판매 정보 조회
      </button></a>
      <a href="/member/logout?id=${id}"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;" id="logout">
        로그아웃
      </button></a>
      <a href="/admin/qNa"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;" id="qNa">
            Q&A조회
      </button></a>
      <a href="/admin/reviews"><button class="btn btn-outline-dark" type="button" style="margin-left: 10px; width: 110px;" id="reviews">
           리뷰 조회
      </button></a>
    </div>
  </div>
</nav>
