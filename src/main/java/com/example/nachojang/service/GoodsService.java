package com.example.nachojang.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.nachojang.controller.GoodsController;
import com.example.nachojang.mapper.GoodsCategoryMapper;
import com.example.nachojang.mapper.GoodsFileMapper;
import com.example.nachojang.mapper.GoodsMapper;
import com.example.nachojang.vo.Goods;
import com.example.nachojang.vo.GoodsCategory;
import com.example.nachojang.vo.GoodsFile;
import com.example.nachojang.vo.GoodsForm;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class GoodsService {
	@Autowired
	GoodsMapper goodsMapper;
	@Autowired
	GoodsFileMapper goodsFileMapper;
	@Autowired
	GoodsCategoryMapper goodsCategoryMapper;

	// 페이징
	public List<Map<String, Object>> selectGoodsList(int currentPage, int rowPerPage) {
		int beginRow = (currentPage - 1) * rowPerPage;
		int totalRow = goodsMapper.selectGoodsCount();
		int lastPage = totalRow / rowPerPage;
		if(totalRow % rowPerPage != 0) {
			lastPage++;
		}

		Map<String, Object> params = new HashMap<>();
		params.put("rowPerPage", rowPerPage);
		params.put("beginRow", beginRow);
		params.put("lastPage", lastPage);

		return goodsMapper.selectGoodsList(params);

	}

	// 우림) 상품상세 : customer/goodsOne
	public Map<String, Object> selectGoodsOne(Integer goodsNo) {
		return goodsMapper.selectGoodsOne(goodsNo);
	}

	// 우림) 카테고리별 상품리스트(+페이징) : customer/goodsList
	public Map<String, Object> selectCategoryGoodsList(Integer categoryNo, Integer currentPage,
			Integer rowPerPage) {
		Integer beginRow = (currentPage - 1) * rowPerPage;
		Integer totalRow = goodsMapper.selectCategoryGoodsCount();
		Integer lastPage = totalRow / rowPerPage;
		if (totalRow % rowPerPage != 0) {
			lastPage++;
		}

		Map<String, Object> params = new HashMap<>();
		params.put("categoryNo", categoryNo);
		params.put("rowPerPage", rowPerPage);
		params.put("beginRow", beginRow);
		
	    // 상품 목록 조회
	    List<Map<String, Object>> goodsList = goodsMapper.selectCategoryGoodsList(params);
	    
	    // 결과를 Map에 담아서 반환
	    Map<String, Object> result = new HashMap<>();
	    result.put("goodsList", goodsList);
	    result.put("lastPage", lastPage);

		return result;
	}

	// 우림) 신규상품 : customer/main
	public List<Map<String, Object>> selectNewGoodsList() {
		return goodsMapper.selectNewGoodsList();
	}

	// 우림) 인기상품 : customer/main
	public List<Map<String, Object>> selectBestGoodsList() {
		return goodsMapper.selectBestGoodsList();
	}

	// 우림_상품 추가 : staff/on/addGoods
	public void addGoods(GoodsForm goodsForm, String path) {
		// 상품 기본 항목 (상품명, 상품설명, 상품금액, 상품재고)
		Goods goods = new Goods();
		goods.setGoodsTitle(goodsForm.getGoodsTitle());
		goods.setGoodsMemo(goodsForm.getGoodsMemo());
		goods.setGoodsPrice(goodsForm.getGoodsPrice());
		goods.setGoodsState(goodsForm.getGoodsState());

		// 상품 no 생성
		Integer addGoodsRow = goodsMapper.insertGoods(goods);
		// 키값
		Integer goodsNo = goods.getGoodsNo();
		Integer categoryNo = goodsForm.getCategoryNo();

		if (addGoodsRow == 1 && goodsForm.getGoodsFile() != null) {
			// 파일 입력
			MultipartFile file = goodsForm.getGoodsFile();
			GoodsFile goodsFile = new GoodsFile();

			goodsFile.setGoodsNo(goodsNo);
			goodsFile.setGoodsFileType(file.getContentType());
			goodsFile.setGoodsFileSize(file.getSize());
			String filename = UUID.randomUUID().toString().replace("-", "");
			goodsFile.setGoodsFileName(filename);
			int dotIdx = file.getOriginalFilename().lastIndexOf("."); // (해당하는 점을 찾아내서
			String originname = file.getOriginalFilename().substring(0, dotIdx);
			String ext = file.getOriginalFilename().substring(dotIdx + 1);
			goodsFile.setGoodsFileOrigin(originname);
			goodsFile.setGoodsFileExt(ext);

			int goodsFileRow = goodsFileMapper.insertGoodsFile(goodsFile);
			if (goodsFileRow == 1) {
				// 물리적 파일 저장
				try {
					file.transferTo(new File(path + filename + "." + ext));
				} catch (Exception e) {
					e.printStackTrace();
					// 예외 발생하고 예외처리 하지 않아야지 @Transactional 작동한다
					// so... RuntimeException을 인위적으로 발생
					// -> try에서 작동하는 예외 말고 다른 예외를 인위적으로 발생시켜서 알림
					throw new RuntimeException();
				}
			}
		}
		GoodsCategory goodsCategory = new GoodsCategory();
		goodsCategory.setGoodsNo(goodsNo);
		goodsCategory.setCategoryNo(categoryNo);

		Integer categoryRow = goodsCategoryMapper.insertGoodsByCategory(goodsCategory);
		log.debug("categoryRow ==========> " + categoryRow);
	}

	// 우림) 상품 수정 : staff/on/modifyGoods
	public void modifyGoods(GoodsForm goodsForm, String path) {
		// 상품 기본 항목 (상품명, 상품설명, 상품금액, 상품재고)
		Goods goods = new Goods();
		goods.setGoodsTitle(goodsForm.getGoodsTitle());
		goods.setGoodsMemo(goodsForm.getGoodsMemo());
		goods.setGoodsPrice(goodsForm.getGoodsPrice());
		goods.setGoodsState(goodsForm.getGoodsState());

		// 상품 no 생성
		Integer modifyGoodsRow = goodsMapper.updateGoods(goodsForm);

		if (modifyGoodsRow >= 1 && !(goodsForm.getGoodsFile().isEmpty())) {
			// 파일 입력
			MultipartFile file = goodsForm.getGoodsFile();
			// 기존 파일 삭제
			GoodsFile goodsfile = goodsFileMapper.selectGoodsFile(goodsForm.getGoodsNo());
			String fullname = path + goodsfile.getGoodsFileName() + "." + goodsfile.getGoodsFileExt();
			File f = new File(fullname);
			f.delete();

			// 파일 추가
			GoodsFile goodsFile = new GoodsFile();
			goodsFile.setGoodsNo(goodsForm.getGoodsNo());
			goodsFile.setGoodsFileType(file.getContentType());
			goodsFile.setGoodsFileSize(file.getSize());
			String filename = UUID.randomUUID().toString().replace("-", "");
			goodsFile.setGoodsFileName(filename);
			int dotIdx = file.getOriginalFilename().lastIndexOf("."); // (해당하는 점을 찾아내서
			String originname = file.getOriginalFilename().substring(0, dotIdx);
			String ext = file.getOriginalFilename().substring(dotIdx + 1);
			goodsFile.setGoodsFileOrigin(originname);
			goodsFile.setGoodsFileExt(ext);

			
			int goodsFileRow = goodsFileMapper.updateGoodsFile(goodsFile);
			if (goodsFileRow == 1) {
				// 물리적 파일 저장
				try {
					file.transferTo(new File(path + filename + "." + ext));
				} catch (Exception e) {
					e.printStackTrace();
					// 예외 발생하고 예외처리 하지 않아야지 @Transactional 작동한다
					// so... RuntimeException을 인위적으로 발생
					// -> try에서 작동하는 예외 말고 다른 예외를 인위적으로 발생시켜서 알림
					throw new RuntimeException();
				}
			}
		}
	}
}
