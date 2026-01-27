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
    	log.info("accommodation.lDongRegnCd : {}", accommodation.getLdongRegnCd());
    	log.info("accommodation.ldongSignguCd : {}", accommodation.getLdongSignguCd());
    	log.info("accommodation.zone : {}", accommodation.getZone());
    	log.info("accommodation .roadAddress: {}", accommodation.getRoadAddress());
    	log.info("accommodation.address : {}", accommodation.getAddress());
    	log.info("accommodation.jibunAddress : {}", accommodation.getJibunAddress());
    	log.info("accommodation.sido : {}", accommodation.getSido());	// 도시명
    	
    	String sido = accommodation.getSido();
    	String areaCode = convertToTourApiAreaCode(sido);
    	accommodation.setAreaCode(areaCode);
    	log.info("accommodation.areaCode : {}", accommodation.getAreaCode());	// 도시명
//    	return null;
    	AccommodationVO result = apiService.getDetailedAccommodation(accommodation);
    	log.info("result : {}", result);
    	if(result == null) {
    		return ResponseEntity.badRequest().build();
    	}else {
    		return ResponseEntity.ok(result);
    	}
    }
    
    
    /**
     * <p>법정동 코드 앞 2자리를 관광 API 전용 지역 코드로 변환</p>
     * @author sdg
     * @date 2026-01-23
     * @param sidoName 도시명 ('대전', '서울')
     * @return Tour API areaCode
     */
    private String convertToTourApiAreaCode(String sidoName) {
//        if (sidoCode == null) return "";
//        
//        switch (sidoCode) {
//            case "11": return "1";  // 서울특별시
//            case "26": return "6";  // 부산광역시
//            case "27": return "4";  // 대구광역시
//            case "28": return "2";  // 인천광역시
//            case "29": return "5";  // 광주광역시
//            case "30": return "3";  // 대전광역시
//            case "31": return "7";  // 울산광역시
//            case "36": return "8";  // 세종특별자치시
//            case "41": return "31"; // 경기도
//            case "42": return "32"; // 강원특별자치도
//            case "43": return "33"; // 충청북도
//            case "44": return "34"; // 충청남도
//            case "45": return "35"; // 전라북도 (전북특별자치도)
//            case "46": return "36"; // 전라남도
//            case "47": return "37"; // 경상북도
//            case "48": return "38"; // 경상남도
//            case "50": return "39"; // 제주특별자치도
//            default:   return "";   // 매핑 안될 경우 전체 검색
//        }
        
        if (sidoName == null || sidoName.isEmpty()) return "";

        // 관광공사 API 지역코드 규격
        if (sidoName.contains("서울")) return "1";
        if (sidoName.contains("인천")) return "2";
        if (sidoName.contains("대전")) return "3";  // 대전은 3
        if (sidoName.contains("대구")) return "4";
        if (sidoName.contains("광주")) return "5";
        if (sidoName.contains("부산")) return "6";
        if (sidoName.contains("울산")) return "7";
        if (sidoName.contains("세종")) return "8";
        if (sidoName.contains("경기")) return "31";
        if (sidoName.contains("강원")) return "32";
        if (sidoName.contains("충북")) return "33";
        if (sidoName.contains("충남")) return "34";
        if (sidoName.contains("경북")) return "35";
        if (sidoName.contains("경남")) return "36";
        if (sidoName.contains("전북")) return "37";
        if (sidoName.contains("전남")) return "38";
        if (sidoName.contains("제주")) return "39";
        
        return "";
    }
}
