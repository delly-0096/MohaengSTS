package kr.or.ddit.mohaeng.product.manage.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.business.service.IBusinessProductService;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.product.inquiry.service.ITripProdInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.service.IProdReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tour.service.IProdTimeInfoService;
import kr.or.ddit.mohaeng.tour.service.ISearchLogService;
import kr.or.ddit.mohaeng.tour.service.ITripProdInfoService;
import kr.or.ddit.mohaeng.tour.service.ITripProdSaleService;
import kr.or.ddit.mohaeng.tour.service.ITripProdService;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.BusinessProductsVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProductMangeController {

	
	@Autowired
    private ITripProdService tripProdService;	// 상품
    
    @Autowired
    private ITripProdSaleService saleService;	// 
    
    @Autowired
    private ITripProdInfoService infoService;

    @Autowired
    private IProdReviewService reviewService;

    @Autowired
    private ITripProdInquiryService inquiryService;
    
    @Autowired
    private IFileService fileService;

	@Autowired
	private IProdTimeInfoService timeInfoService;
	
	@Autowired
	private IBusinessProductService businessService;
	
	/**
	 * <p>기업 상품 관리 페이지</p>
	 * @param tp	memNo가 담긴 데이터
	 * @param model	상품 목록을 담을 데이터
	 * @return	본인 기업의 상품 정보를 담은 페이지
	 */
	@GetMapping("/product/manage")
	public String productManage(
			@AuthenticationPrincipal CustomUserDetails customUser, 
			BusinessProductsVO businessProducts, 
			TripProdVO tripProd, Model model) {
		
		log.info("productManage customUser {}", customUser.getMember().getMemNo());
		int memNo = customUser.getMember().getMemNo();
		tripProd.setMemNo(memNo);	// memNo담기
		
		businessProducts.setMemNo(memNo);
		log.info("businessProducts : {}", businessProducts);
        // 투어상품 정보
		List<BusinessProductsVO> prodList = businessService.getProductlist(businessProducts);	// 숙박 상품도 담기긴 함. 그런데 좀 바뀔수도
		log.info("prodList : {}", prodList);
		
		// 숙박 정보
//		BusinessProductsVO businessProd = new BusinessProductsVO();
//		businessProd.setMemNo(memNo);
//		
//		List<AccommodationVO> accommodationList = businessService.getAccommodationList(businessProd);
//		log.info("accommodationList : {}", accommodationList);
		// 숙박 상품을 따로 담을지? 이래야 조건 걸어서 해줄수 있을수도?
		// 회원 번호와 맞는 객실
		
		// 통계. 이거 tripProdList로 받아야됨
        TripProdVO prodAggregate = businessService.getProductAggregate(tripProd);
        
        // 검색은 스크립트에서
        
        model.addAttribute("prodList", prodList);	// 근데 여기에도  memNo가 있음
        model.addAttribute("prodAggregate", prodAggregate);
        
		return "product/manage";
	}
	
	/**
	 * <p>상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param businessProducts	 상품 번호
	 * @return 상품 상세 정보 - 타입이 accommodation일때는 숙소정보, 아닐때는 상품정보
	 */
	@ResponseBody
	@PostMapping("/product/manage/productDetail")
	public BusinessProductsVO productDetail(@RequestBody BusinessProductsVO businessProducts){
		log.info("productDetail : {}", businessProducts);
		BusinessProductsVO product = businessService.getProductDetail(businessProducts);
		
		log.info("product : {}", product);
		return product;
	}
	
	/**
	 * <p>투어상품 상세 조회</p> -> /tour/상세로 이동
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProdNo	투어 상품 번호
	 * @param model			
	 * @param ra
	 * @return 투어 상품 상세 페이지
	 */
	@GetMapping("/product/manage/tourDetail/{tripProdNo}")
	public String productDetailPage(@PathVariable int tripProdNo, Model model, RedirectAttributes ra) {
		BusinessProductsVO product = null;
        log.info("productDetailPage 집입 {}", tripProdNo);
        
        // tripProd설정
        
        if (product == null) {
            ra.addFlashAttribute("message", "존재하지 않는 상품입니다.");
            return "redirect:/tour";
        }
        
        // 판매 정보
        TripProdSaleVO sale = saleService.getSale(tripProdNo);
        
        // 이용 안내
        TripProdInfoVO info = infoService.getInfo(tripProdNo);
        
        // 리뷰 목록 + 통계
        List<ProdReviewVO> review = reviewService.getReviewPaging(tripProdNo, 1, 5);
        ProdReviewVO reviewStat = reviewService.getStat(tripProdNo);
        
        // 판매상품 위치
        TripProdPlaceVO place = tripProdService.getPlace(tripProdNo);
        
        // 판매자 정보
        CompanyVO seller = tripProdService.getSellerStats(product.getCompNo());
        
        // 문의 목록
        List<TripProdInquiryVO> inquiry = inquiryService.getInquiryPaging(tripProdNo, 1, 5);
        int inquiryCount = inquiryService.getInquiryCount(tripProdNo);
        
        // 상품 이미지 목록
        if (product.getAttachNo() != null && product.getAttachNo() > 0) {
            List<AttachFileDetailVO> productImages = fileService.getAttachFileDetails(product.getAttachNo());
            model.addAttribute("productImages", productImages);
        }
        
        // 예약 가능 시간 조회
        List<ProdTimeInfoVO> availableTimes = timeInfoService.getAvailableTimes(tripProdNo);
        
        model.addAttribute("tp", product);
        model.addAttribute("sale", sale);
        model.addAttribute("info", info);
        model.addAttribute("review", review);
        model.addAttribute("reviewStat", reviewStat);
        model.addAttribute("place", place);
        model.addAttribute("seller", seller);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("inquiryCount", inquiryCount);
        model.addAttribute("availableTimes", availableTimes);
        
        return "product/tour-detail";
	}
	
	/**
	 * <p>상품 판매 상태 변경</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd	tripProdNo, approveStatus
	 * @return 상태 변화 리턴
	 */
	@ResponseBody
	@PostMapping("/product/manage/changeProductStatus")
	public ResponseEntity<String> changeProductStatus(@RequestBody TripProdVO tripProd) {
		log.info("updateProductStatus : {}", tripProd);
		ServiceResult result = businessService.updateProductStatus(tripProd);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
	/**
	 * <p>상품 삭제</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProd tripProdNo
	 * @return 상태 변화 리턴
	 */
	@ResponseBody
	@PostMapping("/product/manage/removeProduct")
	public ResponseEntity<String> removeProduct(@RequestBody TripProdVO tripProd){
		log.info("deleteProduct : {}", tripProd);
		ServiceResult result = businessService.deleteProductStatus(tripProd);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
	/**
	 * <p>투어상품 상세 수정</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProd 수정한 상품 정보
	 * @return 성공 여부
	 */
	@ResponseBody
	@PostMapping("/product/manage/editProduct")
	public ResponseEntity<String> editProduct(BusinessProductsVO businessProducts){
		log.info("editProduct : {}", businessProducts);
		 
		ServiceResult result = businessService.modifyProduct(businessProducts);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
}
