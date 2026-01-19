package kr.or.ddit.mohaeng.business.controller;

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
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BusinessProductController {

	
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
    private ISearchLogService searchLogService;
    
    @Autowired
    private IFileService fileService;

	@Autowired
	private IProdTimeInfoService timeInfoService;
	
	@Autowired
	private IMemberService memberService;
	
	@Autowired
	private IBusinessProductService businessService;
	
	/**
	 * <p>기업 상품 관리 페이지</p>
	 * @param tp	memNo가 담긴 데이터
	 * @param model	상품 목록을 담을 데이터
	 * @return	본인 기업의 상품 정보를 담은 페이지
	 */
	@GetMapping("/business/product")
	public String productManage(
			@AuthenticationPrincipal CustomUserDetails customUser, 
			TripProdVO tripProd, Model model) {
		
		log.info("productManage customUser {}", customUser.getMember().getMemNo());
		log.info("productManage tripProd {}", tripProd);
		int memNo = customUser.getMember().getMemNo();
		tripProd.setMemNo(memNo);	// memNo담기
		 
        List<TripProdVO> prodList = businessService.getProductlist(tripProd);	
        TripProdVO prodAggregate = businessService.getProductAggregate(tripProd);
        
        // 인기 키워드 조회
//        List<SearchLogVO> keywords = searchLogService.getKeywords();
        
        model.addAttribute("prodList", prodList);
        model.addAttribute("prodAggregate", prodAggregate);
        model.addAttribute("tripProd", tripProd);	// memNo담김
//        model.addAttribute("keywords", keywords);
        
		return "product/business";
	}
	
	/**
	 * <p>투어상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-17
	 * @param tripProdNo	투어 상품 번호
	 * @param model			
	 * @param ra
	 * @return 투어 상품 상세 페이지
	 */
	@GetMapping("/business/product/tourDetail/{tripProdNo}")
	public String productDetailPage(@PathVariable int tripProdNo, Model model, RedirectAttributes ra) {
        TripProdVO tripProd = businessService.detailProduct(tripProdNo);
        log.info("productDetailPage 집입 {}", tripProdNo);
        
        if (tripProd == null) {
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
        CompanyVO seller = tripProdService.getSellerStats(tripProd.getCompNo());
        
        // 문의 목록
        List<TripProdInquiryVO> inquiry = inquiryService.getInquiryPaging(tripProdNo, 1, 5);
        int inquiryCount = inquiryService.getInquiryCount(tripProdNo);
        
        // 상품 이미지 목록
        if (tripProd.getAttachNo() != null && tripProd.getAttachNo() > 0) {
            List<AttachFileDetailVO> productImages = fileService.getAttachFileDetails(tripProd.getAttachNo());
            model.addAttribute("productImages", productImages);
        }
        
        // 예약 가능 시간 조회
        List<ProdTimeInfoVO> availableTimes = timeInfoService.getAvailableTimes(tripProdNo);
        
        model.addAttribute("tp", tripProd);
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
	@PostMapping("/business/product/changeProductStatus")
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
	@PostMapping("/business/product/removeProduct")
	public ResponseEntity<String> removeProduct(@RequestBody TripProdVO tripProd){
		log.info("deleteProduct : {}", tripProd);
		ServiceResult result = businessService.deleteProductStatus(tripProd);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
	// 그냥 위에꺼 쓸지 고민
	@ResponseBody
	@PostMapping("/business/product/editProduct")
	public ResponseEntity<String> editProduct(@RequestBody TripProdVO tripProd){
		log.info("editProduct : {}", tripProd);
		// modifyProduct(tripProd);
		
		
		ServiceResult result = businessService.deleteProductStatus(tripProd);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
	/**
	 * <p>투어상품 상세 조회</p>
	 * @author sdg
	 * @date 2026-01-18
	 * @param tripProdNo	 상품 번호
	 * @param model			
	 * @param ra
	 * @return 상품 상세 정보
	 */
	@ResponseBody
	@PostMapping("/business/product/productDetail")
	public TripProdVO productDetail(@RequestBody TripProdVO tripProd){
		log.info("productDetail : {}", tripProd);
		// businessService.detailProduct(tripProd);
		
		// 정보 만든다 -- 1대1만 join해서 담기 상품, 상품 가격, 
		TripProdVO product = businessService.retrieveProductDetail(tripProd);
		
		// 1 대 다는 여기다가
		
		return product;
	}
	
}
