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
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.product.inquiry.service.ITripProdInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.manage.service.IProductManageService;
import kr.or.ddit.mohaeng.product.review.service.IProdReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tour.service.IProdTimeInfoService;
import kr.or.ddit.mohaeng.tour.service.ISearchLogService;
import kr.or.ddit.mohaeng.tour.service.ITripProdInfoService;
import kr.or.ddit.mohaeng.tour.service.ITripProdSaleService;
import kr.or.ddit.mohaeng.tour.service.ITripProdService;
import kr.or.ddit.mohaeng.tour.vo.ProdTimeInfoVO;
import kr.or.ddit.mohaeng.tour.vo.SearchLogVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdInfoVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdPlaceVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdSaleVO;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProductManageController {

	
	@Autowired
    private ITripProdService tripProdService;
    
    @Autowired
    private ITripProdSaleService saleService;
    
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
	private IProductManageService manageService;
	
	/**
	 * <p>기업 상품 관리 페이지</p>
	 * @param tp	memNo가 담긴 데이터
	 * @param model	상품 목록을 담을 데이터
	 * @return	본인 기업의 상품 정보를 담은 페이지
	 */
	@GetMapping("/product/manage")
	public String productManage(
			@AuthenticationPrincipal CustomUserDetails customUser, 
			TripProdVO tripProd, Model model) {
		
		log.info("productManage customUser {}", customUser.getMember().getMemNo());
		log.info("productManage tripProd {}", tripProd);
		int memNo = customUser.getMember().getMemNo();
		tripProd.setMemNo(memNo);	// memNo담기
		 
        List<TripProdVO> tripProdList = manageService.getProductlist(tripProd);
        int totalCount = tripProdService.getTotalCount(tripProd);
        
        // 인기 키워드 조회
//        List<SearchLogVO> keywords = searchLogService.getKeywords();
        
        model.addAttribute("tripProdList", tripProdList);
        model.addAttribute("totalCount", totalCount);	// 이거없이 front에서 실행 하기
        model.addAttribute("tripProd", tripProd);
//        model.addAttribute("keywords", keywords);
        
		return "product/manage";
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
	@GetMapping("/product/manage/tourDetail/{tripProdNo}")
	public String productDetailPage(@PathVariable("tripProdNo") int tripProdNo, Model model, RedirectAttributes ra) {
        TripProdVO tp = manageService.detailProduct(tripProdNo);
        log.info("productDetailPage 집입 {}", tripProdNo);
        if (tp == null) {
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
        CompanyVO seller = tripProdService.getSellerStats(tp.getCompNo());
        
        // 문의 목록
        List<TripProdInquiryVO> inquiry = inquiryService.getInquiryPaging(tripProdNo, 1, 5);
        int inquiryCount = inquiryService.getInquiryCount(tripProdNo);
        
        // 상품 이미지 목록
        if (tp.getAttachNo() != null && tp.getAttachNo() > 0) {
            List<AttachFileDetailVO> productImages = fileService.getAttachFileDetails(tp.getAttachNo());
            model.addAttribute("productImages", productImages);
        }
        
        // 예약 가능 시간 조회
        List<ProdTimeInfoVO> availableTimes = timeInfoService.getAvailableTimes(tripProdNo);
        
        model.addAttribute("tp", tp);
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
	 * @param prodVO	tripProdNo, approveStatus
	 * @return 상태 변화 리턴
	 */
	@ResponseBody
	@PostMapping("/product/manage/changeProductStatus")
	public ResponseEntity<String> changeProductStatus(@RequestBody TripProdVO prodVO) {
		log.info("updateProductStatus : {}", prodVO);
		ServiceResult result = manageService.updateProductStatus(prodVO);
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
	 * @param prodVO tripProdNo
	 * @return 상태 변화 리턴
	 */
	@ResponseBody
	@PostMapping("/product/manage/removeProduct")
	public ResponseEntity<String> removeProduct(@RequestBody TripProdVO prodVO){
		log.info("deleteProduct : {}", prodVO);
		ServiceResult result = manageService.deleteProductStatus(prodVO);
		if (result == ServiceResult.OK) {
			return new ResponseEntity<String>(result.toString(), HttpStatus.OK);
		} else {
			return new ResponseEntity<String>(HttpStatus.BAD_REQUEST);
		}
	}
	
}
