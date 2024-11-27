package com.example.nachojang.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.nachojang.service.OrdersService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class OrdersController {
	@Autowired OrdersService ordersService;
	
	// 세영) 댓글 목록(페이징)
	@GetMapping("/staff/on/boardList")
	public String boardList(Model model
						, @RequestParam(defaultValue = "1") Integer currentPage
						, @RequestParam(defaultValue = "5") Integer rowPerPage
						, HttpSession session) {
		// 세션에서 customerMail을 가져옴
		String customerMail = (String) session.getAttribute("customerMail");
		
		// 페이징 처리하여 서비스에서 댓글 목록 가져옴
		Map<String, Object> resultMap = ordersService.getOrdersList(currentPage, rowPerPage, customerMail);
		
		// 디버깅
		log.debug(resultMap.toString());
		
		// 마지막 페이지 가져옴
		// Integer lastPage = boardService.getLastPage(rowPerPage);
		
		// 페이징 관련 번호 모델에 추가
		// model.addAttribute("lastPage", lastPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("rowPerPage", rowPerPage);
		model.addAttribute("startPagingNum", resultMap.get("startPagingNum"));
		model.addAttribute("endPagingNum", resultMap.get("endPagingNum"));

		// 댓글 목록을 모델에 추가
		model.addAttribute("ordersList", resultMap.get("ordersList"));
		
		// jsp 페이지로 이동
		return "staff/on/ordersList";
	}
		
}
