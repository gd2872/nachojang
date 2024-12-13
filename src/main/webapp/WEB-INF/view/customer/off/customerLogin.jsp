<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <meta charset="UTF-8">
    <title>LOGIN</title>
    <style>
        body { 
            background-color: #f8f9fa;
        }
        .card {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border: none;
            border-radius: 10px;
        }
        .card-header {
            background-color: #ffffff;
            border-bottom: none;
            padding: 30px;
        }
        h1 {
            color: #333;
            font-weight: bold;
        }
        .form-label {
            font-weight: 500;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        #btnAddCustomer {
            margin-top: 10px;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <!-- 헤더 고정 -->
    <div class="header-menu">
        <c:import url="/WEB-INF/view/customer/on/inc/header.jsp"></c:import>
    </div>
    
    <!-- 로그인 폼 -->
    <h1 class="text-center mt-5">LOGIN</h1>
    
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card card-header">
                    <!-- 로그인 오류 메세지 -->
                    <span class="text-danger mb-3">${msg}</span>
                    
                    <form id="formLogin" action="${pageContext.request.contextPath}/customer/off/customerLogin" method="post" class="form-container">
                        <div class="mb-3">
                            <label for="customerMail" class="form-label">MAIL</label> 
                            <input id="customerMail" type="email" name="customerMail" class="form-control" value="goodee@naver.com">
                        </div>
                        <div class="mb-3">
                            <label for="customerPw" class="form-label">PW</label> 
                            <input id="customerPw" type="password" name="customerPw" class="form-control" value="1234">
                        </div>
                       
                        <button id="btnLogin" type="button" class="btn btn-outline-primary w-100">로그인</button>
                    </form>
                    
                    <!-- 회원가입 버튼 -->
                    <div class="d-flex justify-content-center">
                        <a href="${pageContext.request.contextPath}/customer/off/addCustomer" class="w-100">
                            <button id="btnAddCustomer" type="button" class="btn btn-outline-primary w-100">회원가입</button>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 고정 (회사정보) -->
    <div>    
        <c:import url="/WEB-INF/view/company.jsp"></c:import>
    </div>
    
</body>

<script>
    $('#btnLogin').click(function(){
        console.log('click');
        if ($('#customerMail').val() == '') {
            alert('메일을 입력하세요');
        } else if ($('#customerPw').val() == '') {
        	alert('비밀번호를 입력하세요');
    	} else {
            $('#formLogin').submit();
        }
    });
</script>

</html>