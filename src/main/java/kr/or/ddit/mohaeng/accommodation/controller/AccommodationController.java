package kr.or.ddit.mohaeng.accommodation.controller;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.accommodation.service.IAccommodationService;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.product.inquiry.service.ITripProdInquiryService;
import kr.or.ddit.mohaeng.product.inquiry.vo.TripProdInquiryVO;
import kr.or.ddit.mohaeng.product.review.service.IProdReviewService;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tour.service.ITripProdService;
import kr.or.ddit.mohaeng.tour.vo.TripProdVO;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccResvVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class AccommodationController {

	@Autowired
	private IAccommodationService accService;
	
	@Autowired
	private IProdReviewService reviewService;
	
	@Autowired
	private ITripProdInquiryService inquiryService;
	
	@Autowired
	private IFileService fileService;
	
	@Autowired
	private ITripProdService tripProdService;
	
	
	/**
	 * 전체 목록 가져오기
	 * @param acc
	 * @param areaCode
	 * @param model
	 * @return
	 */
	@GetMapping("/product/accommodation")
	public String accommodationPage(
			AccommodationVO acc,
			@RequestParam(value="accNo", required=false) Integer accNo,
			@RequestParam(value="areaCode", required=false) String areaCode,
			@RequestParam(value="keyword", required=false) String keyword,
			Model model) {
		log.info("검색 객체 확인: " + acc);
	    // 날짜 기본 세팅
	    if(acc.getStartDate() == null || acc.getStartDate().isEmpty()) {
	        acc.setStartDate(LocalDate.now().toString());
	        acc.setEndDate(LocalDate.now().plusDays(1).toString());
	    }
	    
	    if(areaCode != null) acc.setAreaCode(areaCode);
	    if(keyword != null) acc.setKeyword(keyword);
	    if(accNo != null) acc.setAccNo(accNo);
	    
		acc.setPage(1);
	    acc.setPageSize(12);
	    acc.setStartRow(1);
	    acc.setEndRow(12);
		
		List<AccommodationVO> list = accService.selectAccommodationListWithPaging(acc);
		int totalCount = accService.selectTotalCount(acc);
	    
	    model.addAttribute("accList", list);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("searchParam", acc);
	    
	    log.info("필터링된 진짜 숙소 개수: {}", totalCount);
	    log.info("넘어온 키워드: {}, 지역코드: {}, 숙소번호: {}", keyword, areaCode, accNo);
	    
	    
	    return "product/accommodation";

	}
	
	/**
	 * 목적지 자동 완성용 API
	 */
	@GetMapping("/product/accommodation/api/search-location")
	@ResponseBody
	public List<Map<String, Object>> searchLocation(@RequestParam("keyword") String keyword) {
		if (keyword == null || keyword.trim().isEmpty()) {
	        return new ArrayList<>();
	    }
		// 사용자가 입력한 키워드로 지역명 검색
	    // 예: [{"areaCode": "39", "name": "제주도"}, {"areaCode": "1", "name": "서울"}]
	    return accService.searchLocation(keyword);
	}
	
	/**
	 * 숙소 추가 데이터 로드 (인피니티 스크롤용 API)
	 */
	@GetMapping("/product/accommodation/api/loadMore")
	@ResponseBody // 리턴값을 페이지가 아닌 JSON 데이터로 쏴줌!
	public Map<String, Object> loadMore(
			AccommodationVO acc,
			@RequestParam(value="accNo", required=false) Integer accNo, 
	        @RequestParam(value="areaCode", required=false) String areaCode
			) {
	    // 1. 페이징 계산 (AccommodationVO에 page와 pageSize 필드가 있다고 가정)
	    int startRow = (acc.getPage() - 1) * acc.getPageSize() + 1;
	    int endRow = acc.getPage() * acc.getPageSize();
	    
	    acc.setStartRow(startRow);
	    acc.setEndRow(endRow);
	    
	    acc.setAreaCode(areaCode);
	    if (accNo != null) {
	        acc.setAccNo(accNo);
	    } else {
	        acc.setAccNo(0); 
	    }

	    // 2. DB에서 해당 페이지 데이터와 전체 개수 가져오기
	    List<AccommodationVO> accList = accService.selectAccommodationListWithPaging(acc);
	    int totalCount = accService.selectTotalCount(acc);

	    // 3. 응답 데이터 조립 (팀원 스타일!)
	    Map<String, Object> result = new HashMap<>();
	    result.put("accList", accList);
	    result.put("totalCount", totalCount);
	    // 현재까지 불러온 데이터가 전체보다 적으면 true
	    result.put("hasMore", (acc.getPage() * acc.getPageSize()) < totalCount);

	    return result;
	}
	
	/**
	 * 숙박 상품 상세 페이지
	 */
	@GetMapping("/product/accommodation/{tripProdNo}")
	public String accommodationDetail(
			@PathVariable("tripProdNo") int tripProdNo,
			@AuthenticationPrincipal  CustomUserDetails user,
			Model model) {
				
		// 숙소 상세 정보
		AccommodationVO detail = accService.getAccommodationDetail(tripProdNo);
		int accNo = detail.getAccNo();
		
		if (detail == null) {
	        log.error("존재하지 않는 상품 번호입니다: {}", tripProdNo);
	        return "redirect:/product/accommodation"; // 혹은 에러 페이지
	    }
		
		// 숙소 객실 타입 정보
		List<RoomTypeVO> roomList = accService.getRoomList(accNo);
		// 숙소 보유시설 정보
		AccFacilityVO facility = accService.getAccFacility(accNo);
		// 리뷰 목록
		List<ProdReviewVO> review = reviewService.getReviewPaging(tripProdNo, 1, 5); 
	    ProdReviewVO reviewStat = reviewService.getStat(tripProdNo);
        // 문의 목록
        List<TripProdInquiryVO> inquiry = inquiryService.getInquiryPaging(tripProdNo, 1, 5);
        int inquiryCount = inquiryService.getInquiryCount(tripProdNo);
		
		int compNo = detail.getCompNo();
		// 판매자 정보
        CompanyVO seller = accService.getSellerStatsByAccNo(detail.getCompNo());
		
		model.addAttribute("acc", detail);
		model.addAttribute("review", review);
	    model.addAttribute("reviewStat", reviewStat);
		model.addAttribute("roomList", roomList);
	    model.addAttribute("facility", facility);
        model.addAttribute("seller", seller);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("inquiryCount", inquiryCount);
		
		return "product/accommodation-detail";
	}
	
	/**
	 * 숙소 결제 페이지
	 */
	@GetMapping("/product/accommodation/{roomNo}/booking")
	public String accommodationBooking(
			@AuthenticationPrincipal CustomUserDetails user,
			@PathVariable("roomNo") int roomTypeNo,       
	        @RequestParam("tripProdNo") int tripProdNo,
	        @RequestParam("price") int price,
	        @RequestParam Map<String, String> bookingData, // 날짜, 인원 등을 한 번에 맵으로 받기
	        Model model) {
		
		log.info("결제 시도 - 숙소번호: {}, 방번호: {}", tripProdNo, roomTypeNo);
	    
		// 숙소와 객실 정보 가져오기
		RoomTypeVO room = accService.getRoomTypeDetail(roomTypeNo);
		AccommodationVO acc = accService.getAccommodationDetail(tripProdNo);
        
        int accNo = acc.getAccNo();
        
        // 방어 로직: 정보가 없으면 목록으로 튕겨내기
        if (acc == null || room == null) {
            log.error("숙소 또는 방 정보를 찾을 수 없습니다.");
            return "redirect:/product/accommodation";
        }
        
        // 숙박 박수(nights) 계산
        long nights = 1;
        try {
        	// null 체크 추가
            String startStr = bookingData.get("startDate");
            String endStr = bookingData.get("endDate");
            
            if (startStr != null && endStr != null) {
                LocalDate start = LocalDate.parse(startStr);
                LocalDate end = LocalDate.parse(endStr);
                nights = ChronoUnit.DAYS.between(start, end);
                if (nights <= 0) nights = 1; // 최소 1박 보장
            }
        } catch (Exception e) {
            log.error("날짜 파싱 에러: {}", e.getMessage());
        }
        
        // 총 객실 요금 계산
        long totalPayAmount = (long) room.getFinalPrice() * nights;
		
	    // 넘어온 예약 데이터를 모델에 담아서 결제 화면에 뿌려주기
        model.addAttribute("tripProdNo", tripProdNo);
        model.addAttribute("acc", acc);
        model.addAttribute("accNo", accNo);
        model.addAttribute("room", room);
	    model.addAttribute("bookingData", bookingData);
	    model.addAttribute("nights", nights);
	    model.addAttribute("totalPayAmount", totalPayAmount); // 최종가 전달!
	    
	    return "product/accommodation-booking";
	} 

	
	/**
	 * 숙소 결제 프로세스
	 */
	@ResponseBody
	@PostMapping("/product/accommodation/{tripProdNo}/booking")
	public Map<String, Object> bookingProcess(
			@RequestBody AccResvVO resvVO,
			@PathVariable("tripProdNo") int tripProdNo,
			@AuthenticationPrincipal CustomUserDetails user
			){
		log.info("예약 요청 데이터: {}", resvVO);
		
		Map<String, Object> response = new HashMap<>();
		
		// 로그인한 유저 PK 세팅 
	    resvVO.setResvMemNo(user.getMember().getMemNo());
	    
	    // 서비스 호출 (예약 완료 처리)
	    try {
	    	int result = accService.registReservation(resvVO);
	    	
	    	response.put("status", "success");
	    	response.put("message", "예약이 성공적으로 접수되었습니다.");
	    } catch (Exception e) {
	    	response.put("status", "error");
	    	response.put("message", "예약 처리 중 오류가 발생했습니다.");
	    }
	    return response;
	}
	
	/**
     * 상세페이지 리뷰 수정
     */
    @PostMapping("/product/accommodation/{tripProdNo}/review/update")
    @ResponseBody
    public Map<String, Object> updateReview(
            @PathVariable int tripProdNo,
            @RequestBody ProdReviewVO vo,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
        	result.put("success", false);
        	result.put("message", "로그인이 필요합니다.");
        	return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            vo.setMemNo(memNo);
            int updated = reviewService.updateReview(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "리뷰가 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "리뷰 수정에 실패했습니다.");
        }
        
        return result;
    }
	
    /**
     * 상세페이지 리뷰 이미지 조회 (수정 모달용)
     */
    @GetMapping("/product/accommodation/{tripProdNo}/review/{prodRvNo}/images")
    @ResponseBody
    public Map<String, Object> getReviewImages(
            @PathVariable int tripProdNo,
            @PathVariable int prodRvNo,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        try {
            Integer attachNo = reviewService.getReviewAttachNo(prodRvNo);
            
            if (attachNo == null) {
                result.put("success", true);
                result.put("images", new ArrayList<>());
                return result;
            }
            
            List<AttachFileDetailVO> details = fileService.getAttachFileDetails(attachNo);
            
            List<Map<String, Object>> images = new ArrayList<>();
            for (AttachFileDetailVO d : details) {
                Map<String, Object> map = new HashMap<>();
                map.put("FILE_NO", d.getFileNo());
                map.put("FILE_PATH", d.getFilePath());
                map.put("FILE_ORIGINAL_NAME", d.getFileOriginalName());
                images.add(map);
            }
            
            result.put("success", true);
            result.put("images", images);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "이미지 조회에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세페이지 리뷰 이미지 개별 삭제
     */
    @PostMapping("/product/accommodation/{tripProdNo}/review/{prodRvNo}/image/delete")
    @ResponseBody
    public Map<String, Object> deleteReviewImage(
            @PathVariable int tripProdNo,
            @PathVariable int prodRvNo,
            @RequestBody Map<String, Integer> params,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            Integer attachNo = reviewService.getReviewAttachNo(prodRvNo);
            if (attachNo == null) {
                result.put("success", false);
                result.put("message", "이미지가 없습니다.");
                return result;
            }
            
            int fileNo = params.get("fileNo");
            
            // ★ FileService 직접 사용
            int deleted = fileService.softDeleteFile(attachNo, fileNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "이미지가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "이미지 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "이미지 삭제 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 리뷰 이미지 추가 - FileService 직접 사용
     */
    @PostMapping("/product/accommodation/{tripProdNo}/review/{prodRvNo}/image/upload")
    @ResponseBody
    public Map<String, Object> uploadReviewImages(
            @PathVariable int tripProdNo,
            @PathVariable int prodRvNo,
            @RequestParam("files") List<MultipartFile> files,
            @AuthenticationPrincipal CustomUserDetails user
    		) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            Integer attachNo = reviewService.getReviewAttachNo(prodRvNo);
            
            // ★ FileService 직접 사용
            int newAttachNo = fileService.addFilesToAttach(
                attachNo,       // 기존 번호 (null 가능)
                files,          // 업로드 파일들
                "review",       // 폴더명: C:/mohaeng/review/
                "REVIEW",       // 분류 코드
                memNo           // 등록자
            );
            
            // 새로 생성된 경우 리뷰에 연결
            if (attachNo == null && newAttachNo > 0) {
                reviewService.updateReviewAttachNo(prodRvNo, newAttachNo);
            }
            
            // 업로드 후 이미지 목록 반환
            List<AttachFileDetailVO> details = fileService.getAttachFileDetails(newAttachNo);
            
            List<Map<String, Object>> images = new ArrayList<>();
            for (AttachFileDetailVO d : details) {
                Map<String, Object> map = new HashMap<>();
                map.put("FILE_NO", d.getFileNo());
                map.put("FILE_PATH", d.getFilePath());
                map.put("FILE_ORIGINAL_NAME", d.getFileOriginalName());
                images.add(map);
            }
            
            result.put("success", true);
            result.put("message", files.size() + "개의 이미지가 추가되었습니다.");
            result.put("images", images);
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "이미지 업로드 중 오류가 발생했습니다.");
        }
        
        return result;
    }

    
    /**
     * 상세페이지 리뷰 삭제
     */
    @PostMapping("/product/accommodation/{tripProdNo}/review/delete")
    @ResponseBody
    public Map<String, Object> deleteReview(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Integer> params,
            @AuthenticationPrincipal CustomUserDetails user
    		) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            int prodRvNo = params.get("prodRvNo");
            int deleted = reviewService.deleteReview(prodRvNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "리뷰가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "리뷰 삭제에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 리뷰 더보기
     */
    @GetMapping("/product/accommodation/{tripProdNo}/reviews")
    @ResponseBody
    public Map<String, Object> loadMoreReviews(
            @PathVariable int tripProdNo,
            @RequestParam(defaultValue = "2") int page,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        int pageSize = 5;
        List<ProdReviewVO> reviews = reviewService.getReviewPaging(tripProdNo, page, pageSize);
        ProdReviewVO stat = reviewService.getStat(tripProdNo);
        
        int totalCount = stat != null ? stat.getReviewCount() : 0;
        int loadedCount = page * pageSize;
        
        // 로그인 여부에 따라 memNo 가져오기
        Integer loginMemNo = (user != null) ? user.getMember().getMemNo() : null;
        
        Map<String, Object> result = new HashMap<>();
        result.put("reviews", reviews);
        result.put("hasMore", loadedCount < totalCount);
        result.put("loginMemNo", loginMemNo); // 로그인 안 했으면 null이 전달
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 등록
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/insert")
    @ResponseBody
    public Map<String, Object> insertInquiry(
            @PathVariable int tripProdNo,
            @RequestBody TripProdInquiryVO vo,
            @AuthenticationPrincipal CustomUserDetails user
    		) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            vo.setTripProdNo(tripProdNo);
            vo.setInquiryMemNo(memNo);
            
            // ★ Service에서 등록 후 닉네임 포함된 정보를 반환
            TripProdInquiryVO inserted = inquiryService.insertInquiry(vo);
            
            result.put("success", true);
            result.put("message", "문의가 등록되었습니다.");
            result.put("inquiry", inserted);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 등록에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 수정
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/update")
    @ResponseBody
    public Map<String, Object> updateInquiry(
            @PathVariable int tripProdNo,
            @RequestBody TripProdInquiryVO vo,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            vo.setInquiryMemNo(memNo); // 작성자 번호 세팅
            
            //  서비스 호출
            int updated = inquiryService.updateInquiry(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "문의가 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정 권한이 없거나 답변 완료된 문의입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 수정에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 삭제
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/delete")
    @ResponseBody
    public Map<String, Object> deleteInquiry(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Integer> params,
            @AuthenticationPrincipal CustomUserDetails user
    		) {
        
        Map<String, Object> result = new HashMap<>();
        
       
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            // 삭제할 문의 번호 꺼내기
            int prodInqryNo = params.get("prodInqryNo");
            
            // 서비스 호출 (삭제 시 본인 확인 로직 포함)
            int deleted = inquiryService.deleteInquiry(prodInqryNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "문의가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없거나 이미 답변이 완료된 문의입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "문의 삭제 처리 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 더보기
     */
    @GetMapping("/product/accommodation/{tripProdNo}/inquiries")
    @ResponseBody
    public Map<String, Object> loadMoreInquiries(
            @PathVariable int tripProdNo,
            @RequestParam(defaultValue = "2") int page,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        int pageSize = 5;
        List<TripProdInquiryVO> inquiries = inquiryService.getInquiryPaging(tripProdNo, page, pageSize);
        int totalCount = inquiryService.getInquiryCount(tripProdNo);
        int loadedCount = page * pageSize;
        
        // 로그인 사용자 정보
        Integer loginMemNo = (user != null) ? user.getMember().getMemNo() : null;
        
        Map<String, Object> result = new HashMap<>();
        result.put("inquiries", inquiries);
        result.put("hasMore", loadedCount < totalCount);
        result.put("loginMemNo", loginMemNo); 
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 답변 등록
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/reply")
    @ResponseBody
    public Map<String, Object> insertReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            @AuthenticationPrincipal CustomUserDetails user
    		) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        // 기업회원 체크
        boolean isBusiness = user.getAuthorities().stream()
        					 .anyMatch(auth -> auth.getAuthority().equals("ROLE_BUSINESS"));
        
        if (!isBusiness) {
        	result.put("success", false);
        	result.put("message", "기업회원 권한이 필요합니다.");
        	return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
        	int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            String replyCn = (String) param.get("replyCn");
            
            TripProdInquiryVO vo = new TripProdInquiryVO();
            vo.setProdInqryNo(prodInqryNo);
            vo.setReplyCn(replyCn);
            vo.setReplyMemNo(memNo);
            
            int updated = inquiryService.insertReply(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "답변이 등록되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "답변 등록에 실패했습니다.");
            }
        	
        } catch(Exception e) {
        	e.printStackTrace();
        	result.put("success", false);
        	result.put("message", "답변 등록 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 문의 답변 수정
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/reply/update")
    @ResponseBody
    public Map<String, Object> updateReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        boolean isBusiness = user.getAuthorities().stream()
				 .anyMatch(auth -> auth.getAuthority().equals("ROLE_BUSINESS"));
        
        if (!isBusiness) {
        	result.put("success", false);
        	result.put("message", "기업회원 권한이 필요합니다.");
        	return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            String replyCn = (String) param.get("replyCn");
            
            TripProdInquiryVO vo = new TripProdInquiryVO();
            vo.setProdInqryNo(prodInqryNo);
            vo.setReplyCn(replyCn);
            vo.setReplyMemNo(memNo);
            
            int updated = inquiryService.updateReply(vo);
            
            if (updated > 0) {
                result.put("success", true);
                result.put("message", "답변이 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정 권한이 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "답변 수정 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    
    /**
     * 상세 페이지 문의 답변 삭제
     */
    @PostMapping("/product/accommodation/{tripProdNo}/inquiry/reply/delete")
    @ResponseBody
    public Map<String, Object> deleteReply(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Object> param,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        boolean isBusiness = user.getAuthorities().stream()
				 .anyMatch(auth -> auth.getAuthority().equals("ROLE_BUSINESS"));
       
       if (!isBusiness) {
       	result.put("success", false);
       	result.put("message", "기업회원 권한이 필요합니다.");
       	return result;
       }
       
       int memNo = user.getMember().getMemNo();
        
        try {
            int prodInqryNo = Integer.parseInt(param.get("prodInqryNo").toString());
            
            int deleted = inquiryService.deleteReply(prodInqryNo, memNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "답변이 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "삭제 권한이 없거나 이미 삭제된 답변입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "답변 삭제 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세 페이지 상품 이미지 목록 조회
     */
    @GetMapping("/product/accommodation/{tripProdNo}/images")
    @ResponseBody
    public Map<String, Object> getProductImages(@PathVariable int tripProdNo) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            TripProdVO tp = tripProdService.detail(tripProdNo);
            
            if (tp == null || tp.getAttachNo() == null) {
                result.put("success", true);
                result.put("images", new ArrayList<>());
                return result;
            }
            
            List<AttachFileDetailVO> details = fileService.getAttachFileDetails(tp.getAttachNo());
            
            List<Map<String, Object>> images = new ArrayList<>();
            for (AttachFileDetailVO d : details) {
                Map<String, Object> map = new HashMap<>();
                map.put("FILE_NO", d.getFileNo());
                map.put("FILE_PATH", d.getFilePath());
                map.put("FILE_ORIGINAL_NAME", d.getFileOriginalName());
                images.add(map);
            }
            
            result.put("success", true);
            result.put("images", images);
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "이미지 조회에 실패했습니다.");
        }
        
        return result;
    }
    
    /**
     * 상세페이지 상품 이미지 업로드
     */
    @PostMapping("/product/accommodation/{tripProdNo}/image/upload")
    @ResponseBody
    public Map<String, Object> uploadProductImage(
            @PathVariable int tripProdNo,
            @RequestParam("files") List<MultipartFile> files,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            TripProdVO tp = tripProdService.detail(tripProdNo);
            
            if (tp == null) {
                result.put("success", false);
                result.put("message", "상품을 찾을 수 없습니다.");
                return result;
            }
            
            // 본인 상품인지 확인
            if (memNo != tp.getMemNo()) {
                result.put("success", false);
                result.put("message", "본인의 상품만 이미지를 수정할 수 있습니다.");
                return result;
            }
            
            int newAttachNo = fileService.addFilesToAttach(
                tp.getAttachNo(),
                files,
                "product",
                "PRODUCT",
                memNo
            );
            
            // 새로 생성된 경우 상품에 연결
            if (tp.getAttachNo() == null && newAttachNo > 0) {
            	tripProdService.updateAttachNo(tripProdNo, newAttachNo);
            }
            
            result.put("success", true);
            result.put("message", files.size() + "개의 이미지가 업로드되었습니다.");
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "이미지 업로드에 실패했습니다.");
        }
        
        return result;
    }

    /**
     * 상품 이미지 삭제
     */
    @PostMapping("/product/accommodation/{tripProdNo}/image/delete")
    @ResponseBody
    public Map<String, Object> deleteProductImage(
            @PathVariable int tripProdNo,
            @RequestBody Map<String, Integer> params,
            @AuthenticationPrincipal CustomUserDetails user
            ) {
        
        Map<String, Object> result = new HashMap<>();
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            TripProdVO tp = tripProdService.detail(tripProdNo);
            
            if (tp == null || tp.getAttachNo() == null) {
                result.put("success", false);
                result.put("message", "상품 또는 등록된 이미지를 찾을 수 없습니다.");
                return result;
            }
            
            if (memNo != tp.getMemNo()) {
                result.put("success", false);
                result.put("message", "본인이 등록한 상품의 이미지만 삭제할 수 있습니다.");
                return result;
            }
            
            int fileNo = params.get("fileNo");
            int deleted = fileService.softDeleteFile(tp.getAttachNo(), fileNo);
            
            if (deleted > 0) {
                result.put("success", true);
                result.put("message", "이미지가 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "이미지 삭제에 실패했습니다.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "오류가 발생했습니다.");
        }
        
        return result;
    }
    
    // 북마크 토글 (등록/삭제 통합)
    @PostMapping("/product/accommodation/{tripProdNo}/bookmark")
    @ResponseBody
    public Map<String, Object> toggleBookmark(
    		@PathVariable int tripProdNo,
    		@AuthenticationPrincipal CustomUserDetails user
    		) {
        Map<String, Object> result = new HashMap<>();
        
        
        if (user == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        
        int memNo = user.getMember().getMemNo();
        
        try {
            // 현재 북마크 상태 확인
            boolean isBookmarked = tripProdService.checkAccommodationBookmark(memNo, tripProdNo);
            
            if (isBookmarked) {
                // 북마크 삭제
                tripProdService.deleteAccommodationBookmark(memNo, tripProdNo);
                result.put("success", true);
                result.put("bookmarked", false);
                result.put("message", "북마크가 삭제되었습니다.");
            } else {
                // 북마크 등록
                tripProdService.insertAccommodationBookmark(memNo, "ACCOMMODATION", tripProdNo);
                result.put("success", true);
                result.put("bookmarked", true);
                result.put("message", "북마크에 추가되었습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }
        
        return result;
    }
 
}

