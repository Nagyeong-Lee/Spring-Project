<%--
  Created by IntelliJ IDEA.
  User: weaver-gram-0020
  Date: 2023-03-23
  Time: 오후 5:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>404에러</title>
    <style>
        body {
            margin-top: 20px;
        }

        .error-page {
            text-align: center;
            background: #fff;
            border-top: 1px solid #eee;
        }

        .error-page .error-inner {
            display: inline-block;
        }

        .error-page .error-inner h1 {
            font-size: 140px;
            text-shadow: 3px 5px 2px #3333;
            color: #006DFE;
            font-weight: 700;
        }

        .error-page .error-inner h1 span {
            display: block;
            font-size: 25px;
            color: #333;
            font-weight: 600;
            text-shadow: none;
        }

        .error-page .error-inner p {
            padding: 20px 15px;
        }
    </style>
</head>
<body>
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"/>
<section class="error-page section">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 offset-lg-3 col-12">
                <!-- Error Inner -->
                <div class="error-inner">
                    <h1>404<span>Oop's  sorry we can't find that page!</span></h1>
                </div>
            </div>
        </div>
    </div>
</section>
</body>
</html>
