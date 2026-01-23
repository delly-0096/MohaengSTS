package kr.or.ddit.mohaeng.accommodation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.accommodation.service.AccommodationBatchService;
import kr.or.ddit.mohaeng.accommodation.service.TourApiService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
@RequiredArgsConstructor
public class AdminBatchController {

    private final AccommodationBatchService service;

    @Autowired
    private TourApiService apiService;
    
    @GetMapping("/batch/load-acc-detail")
    @ResponseBody
    public String loadAccDetail() {
        service.updateAccommodationDetailsBatch();
        return "숙소 상세 데이터 로딩 완료";
    }
    
    /**
     * <p>api에 존재하는 숙소 정보 가져오기</p>
     * @author sdg
     * @date 2026-01-23
     * @param accommodation	accName, ldongRegnCd
     * @return
     */
    @GetMapping("/batch/accommodation/search")
    @ResponseBody
    public ResponseEntity<AccommodationVO> searchAccommodation(AccommodationVO accommodation) {
    	log.info("accommodation : {}", accommodation);
    	
    	String areaCode = accommodation.getLdongRegnCd();				// 법정동 시도코드
    	
    	accommodation.setAreaCode(convertToTourApiAreaCode(areaCode));	// 지역코드로 변경
    	
    	// 시군구 코드를 지역코들로 맞추기
    	
    	AccommodationVO result = apiService.getDetailedAccommodation(accommodation);
    	log.info("result : {}", result);
        return ResponseEntity.ok(result);
    }
    
    
    /**
     * <p>법정동 코드 앞 2자리를 관광 API 전용 지역 코드로 변환</p>
     * @author sdg
     * @date 2026-01-23
     * @param sidoCode 법정동 시도코드
     * @return Tour API areaCode
     */
    private String convertToTourApiAreaCode(String sidoCode) {
        if (sidoCode == null) return "";
        
        switch (sidoCode) {
            case "11": return "1";  // 서울특별시
            case "26": return "6";  // 부산광역시
            case "27": return "4";  // 대구광역시
            case "28": return "2";  // 인천광역시
            case "29": return "5";  // 광주광역시
            case "30": return "3";  // 대전광역시
            case "31": return "7";  // 울산광역시
            case "36": return "8";  // 세종특별자치시
            case "41": return "31"; // 경기도
            case "42": return "32"; // 강원특별자치도
            case "43": return "33"; // 충청북도
            case "44": return "34"; // 충청남도
            case "45": return "35"; // 전라북도 (전북특별자치도)
            case "46": return "36"; // 전라남도
            case "47": return "37"; // 경상북도
            case "48": return "38"; // 경상남도
            case "50": return "39"; // 제주특별자치도
            default:   return "";   // 매핑 안될 경우 전체 검색
        }
    }
}
