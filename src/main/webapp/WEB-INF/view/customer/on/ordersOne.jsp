<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
<!DOCTYPE html>
<html>
<head>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<meta charset="UTF-8">
<title>주문상세</title>

</head>
<body>
	
	<!-- 헤더 고정 -->
	
	<!-- main -->
	<h1> 주문별 상세 내역 </h1>
	<div class="col-sm-10">
		<!-- main content -->
		<table class="table">
			<tr>
				<td>결제 번호</td>
				<td>주문 번호</td>
				<td>상품 번호</td>
				<td>이미지</td>
				<td>상품 이름</td>
				<td>주문 개수</td>
				<td>총합 가격</td>
				<td>결제 수단</td>
				<td>후기</td>
			</tr>
			<c:forEach var="o" items="${orderOne}">
				<tr>
					<td>${o.paymentNo}</td>
					<td>${o.ordersNo}</td>
					<td>${o.goodsNo}</td>
					<td>
						<img src="${pageContext.request.contextPath}/upload/${o.goodsFileName}.${o.goodsFileExt}" width="100" height="100">
					</td>
					<td>${o.goodsTitle}</td>					
					<td>${o.ordersAmount}</td>
					<td>${o.totalPrice}</td>
					<td>
						<c:if test="${o.paymentState == '배송완료'}">
							<form id="formComment" method = "post" action="${pageContext.request.contextPath}/customer/on/ordersOne">
								<input type="text" name="boardContent" id="boardContent">
							</form>
							<button type="button" id="btnAddComment" class="btn btn-primary"> 입력 </button>
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
	
	<!-- 고정 (회사정보) -->
    <div>
    		<c:import url="/WEB-INF/view/company.jsp"></c:import>
    </div>
</body>
<script>

	$('#btnAddComment').click(function() {
		if($('#boardContent').val() == '') {
			alert('후기를 작성하세요');
		} else {
			$('#formComment').submit();
		}
	});
	
</script>
</html>