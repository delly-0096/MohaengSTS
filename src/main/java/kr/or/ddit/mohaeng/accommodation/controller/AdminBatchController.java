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
     * @param accommodation	accName, 시군구 코드
     * @return
     */
    @GetMapping("/batch/accommodation/search")
    @ResponseBody
    public ResponseEntity<AccommodationVO> searchAccommodation(AccommodationVO accommodation) {
    	log.info("accommodation : {}", accommodation);
    	
    	// 시군구 코드를 지역코들로 맞추기
    	
    	AccommodationVO result = apiService.getDetailedAccommodation(accommodation);
        return ResponseEntity.ok(result);
    }
}
