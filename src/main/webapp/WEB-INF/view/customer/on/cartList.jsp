<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>장바구니</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        body {
            background: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .card {
            margin: 30px auto;
            max-width: 1000px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .card-header {
            background-color: #007bff;
            color: white;
            text-align: center;
            padding: 20px;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        .card-body {
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #dee2e6;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        img {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        #totalPrice {
            font-size: 1.2rem;
            font-weight: bold;
            color: #007bff;
        }
    </style>
</head>
<body>
    <header>
        <c:import url="/WEB-INF/view/customer/on/inc/header.jsp"></c:import>
    </header>

    <div class="card">
        <div class="card-header">
            <h2>회원님 장바구니</h2>
        </div>
        <div class="card-body">
            <form method="post" id="cartForm" action="${pageContext.request.contextPath}/customer/on/ordersPayment">
                <input type="hidden" name="customerMail" value="${customerMail}">
                <table class="table">
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>이미지</th>
                            <th>상품명</th>
                            <th>수량</th>
                            <th>금액</th>
                            <th>삭제</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cartList}" var="c">
                            <tr>
                                <td><input type="checkbox" name="selectedCartNos" value="${c.cartNo}"></td>
                                <td><img src="${pageContext.request.contextPath}/upload/${c.goodsFileName}.${c.goodsFileExt}" alt="${c.goodsTitle}"></td>
                                <td>${c.goodsTitle}</td>
                                <td>${c.cartAmount}</td>
                                <td>${c.totalPrice}</td>
                                <td><a class="btn btn-danger btn-sm" href="${pageContext.request.contextPath}/customer/cart/delete?cartNo=${c.cartNo}">삭제</a></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="text-end mt-3">
                    <p>총 결제 금액: <span id="totalPrice">0</span> 원</p>
                </div>
                <div class="text-center mt-4">              
                    <button type="button" id="checkoutAllBtn" class="btn btn-primary">전체 주문</button>
                    <button type="button" id="checkoutSelectedBtn" class="btn btn-primary">선택 주문</button>
                </div>
            </form>
        </div>
    </div>

    <footer>
        <c:import url="/WEB-INF/view/company.jsp"></c:import>
    </footer>

<script>
	$(document).ready(function () {
	    function calculateTotalPrice() {
	        let totalPrice = 0;
	        $('input[name="selectedCartNos"]:checked').each(function () {
	            const price = parseInt($(this).closest('tr').find('td').eq(4).text().trim());
	            totalPrice += isNaN(price) ? 0 : price;
	        });
	        $('#totalPrice').text(totalPrice.toLocaleString());
	    }
	    $('input[name="selectedCartNos"]').on('change', calculateTotalPrice);
	    calculateTotalPrice();
	    
	    $('#checkoutSelectedBtn').on('click', function () {
	        if ($('input[name="selectedCartNos"]:checked').length === 0) {
	            alert('선택된 상품이 없습니다. 체크박스를 선택해주세요.');
	        } else {
	            $('#cartForm').submit();
	        }
	    });
	    
	    $('#checkoutAllBtn').on('click', function () {
	        if ($('input[name="selectedCartNos"]').length === 0) {
	            alert('상품을 추가해 주세요.');
	        } else {
	            $('input[name="selectedCartNos"]').prop('checked', true);
	            $('#cartForm').submit();
	        }
	    });
});
</script>

</body>
</html>