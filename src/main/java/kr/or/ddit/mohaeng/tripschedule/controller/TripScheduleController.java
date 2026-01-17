package kr.or.ddit.mohaeng.tripschedule.controller;

import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.community.travellog.comments.service.CommentsServiceImpl;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.util.CommUtil;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;
import kr.or.ddit.util.Params;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/schedule")
public class TripScheduleController {

    private final CommentsServiceImpl commentsServiceImpl;
	
	@Autowired
	ITripScheduleService tripScheduleService;

    TripScheduleController(CommentsServiceImpl commentsServiceImpl) {
        this.commentsServiceImpl = commentsServiceImpl;
    }
	
	@GetMapping("/search")
	public String search(Model model) {
//		Params params = new Params();
//		List<Map<String, Object>> regionList = tripScheduleService.selectRegionList();
		model.addAttribute("popRegionList", tripScheduleService.selectPopRegionList());
//		System.out.println(regionList);
		return "schedule/search";
	}
	
	@ResponseBody
	@GetMapping("/common/regionList")
	public ResponseEntity<List> searchRegionList(Model model) {
		return new ResponseEntity<List>(tripScheduleService.selectRegionList(), HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("/common/searchRegion")
	public ResponseEntity<Params> searchRegion(HttpServletRequest req ,Model model) {
		Params params = Params.of(req);
		System.out.println(params);
		params = tripScheduleService.searchRegion(params);
		System.out.println(params);
		return new ResponseEntity<Params>(params, HttpStatus.OK);
	}
	
	@GetMapping("/planner")
	public String planner(Model model) {
		List<Params> tourContentList = tripScheduleService.tourContentList();
		System.out.println("tourContentList : " + tourContentList);
		
		model.addAttribute("tourContentList", tourContentList);
		return "schedule/planner";
	}
	
	@GetMapping("/planner/{schdlNo}")
	public String planner(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@PathVariable int schdlNo,
			Model model
			) {
		System.out.println("schdlNo : " + schdlNo);
		int memNo = customUser.getMember().getMemNo();
		TripScheduleVO scheduleVO = new TripScheduleVO();
		scheduleVO.setSchdlNo(schdlNo);
		scheduleVO.setMemNo(memNo);
		TripScheduleVO schedule = tripScheduleService.selectTripSchedule(scheduleVO);
		
		List<Params> tourContentList = tripScheduleService.tourContentList();
		System.out.println("schedule : " + schedule);
		System.out.println("tourContentList : " + tourContentList);
		
		model.addAttribute("schedule", schedule);
		model.addAttribute("tourContentList", tourContentList);
		
		return "schedule/planner-edit";
	}
	
	@GetMapping("/view/{schdlNo}")
	public String plannerView(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@PathVariable int schdlNo,
			Model model
			) {
		int memNo = customUser.getMember().getMemNo();
		TripScheduleVO params = new TripScheduleVO();
		params.setSchdlNo(schdlNo);
		params.setMemNo(memNo);
		TripScheduleVO schedule = tripScheduleService.selectTripSchedule(params);
		
		System.out.println("schedule :" + schedule);
		
		model.addAttribute("schedule", schedule);
		
		return "schedule/view";
	}
	
	@ResponseBody
	@PostMapping("/common/initTourPlaceList")
	public ResponseEntity<Map<String, Object>> initTourPlaceList(@RequestBody Params params ,Model model) {
//		Params params = Params.of(req);
		RestClient restClient = RestClient.create();
		String page = "1";
		String areaCode = "";
		
		if(params.get("page") != null && !params.get("page").equals("")) {
			page = params.getString("page");
		}
		
		if(params.get("areaCode") != null && !params.get("areaCode").equals("")) {
			areaCode = params.getString("areaCode");
		}
		
		String urlString = "https://apis.data.go.kr/B551011/KorService2/areaBasedList2?MobileOS=WEB&MobileApp=mohaeng&_type=json"
				+ "&arrange=Q"
				+ "&pageNo=" + page + "&numOfRows=15"
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		if(!areaCode.equals("")) {
			urlString  += "&areaCode=" + params.get("areaCode");
		}

		// 2. URI 객체로 변환 (이러면 RestClient가 내부에서 자동 인코딩을 안 합니다)
		URI uri = URI.create(urlString);
		
		JsonNode responseNode = restClient.get()
			    .uri(uri)
			    .retrieve()
			    .body(JsonNode.class);
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> responseMap = mapper.convertValue(responseNode, Map.class);
		
		JsonNode itemsNode = responseNode.path("response")
				.path("body")
				.path("items")
				.path("item");
		
		ObjectMapper objectMapper = new ObjectMapper();
		List<Map<String, String>> tourPlaceList = objectMapper.convertValue(itemsNode, new TypeReference<>() {});
		
		tripScheduleService.mergeSearchTourPlace(tourPlaceList);
		
		return new ResponseEntity<Map<String, Object>>(responseMap, HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("/common/searchPlaceDetail")
	public ResponseEntity<TourPlaceVO> searchPlaceDetail(int contentId, int contenttypeId, Model model) {
		Params params = new Params();
		
		params.put("contentId", contentId);
		params.put("contenttypeId", contenttypeId);
		
		TourPlaceVO myTourPlaceVO = new TourPlaceVO();
		myTourPlaceVO.setPlcNo(contentId);
		myTourPlaceVO =	tripScheduleService.searchPlaceDetail(myTourPlaceVO);

		if(StringUtils.hasText(myTourPlaceVO.getPlcDesc())) {
			return new ResponseEntity<TourPlaceVO>(myTourPlaceVO, HttpStatus.OK);
		}
		
		TourPlaceVO tourPlaceVO = tripScheduleService.updatePlaceDetail(params);

		System.out.println("tourPlaceVO : " + tourPlaceVO);
		
		return new ResponseEntity<TourPlaceVO>(tourPlaceVO, HttpStatus.OK);
	}
	
	@ResponseBody
	@PostMapping("/common/searchTourPlaceList")
	public ResponseEntity<Map<String, Object>> searchTourPlaceList(@RequestBody Params params ,Model model) {
		
		log.info("searchTourPlaceList Params : {}", params);
		
		RestClient restClient = RestClient.create();
		String page = "1";
		String areaCode = "";
		String keyword = "";
		
		if(params.get("page") != null && !params.get("page").equals("")) {
			page = params.getString("page");
		}
		
		if(params.get("areaCode") != null && !params.get("areaCode").equals("")) {
			areaCode = params.getString("areaCode");
		}
		
		if(params.get("areaCode") != null && !params.get("areaCode").equals("")) {
			keyword = params.getString("keyword");
		}
		
		String urlString = "https://apis.data.go.kr/B551011/KorService2/searchKeyword2?"
				+ "numOfRows=15"
				+ "&pageNo=" + page
				+ "&arrange=O"
				+ "&MobileOS=web&MobileApp=mohaeng&_type=json"
				+ "&keyword=" + keyword
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
				
				
		if(!areaCode.equals("")) {
			urlString  += "&areaCode=" + params.get("areaCode");
		}

		// 2. URI 객체로 변환 (이러면 RestClient가 내부에서 자동 인코딩을 안 합니다)
		URI uri = URI.create(urlString);
		
		JsonNode responseNode = restClient.get()
			    .uri(uri)
			    .retrieve()
			    .body(JsonNode.class);
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> responseMap = mapper.convertValue(responseNode, Map.class);
		
		JsonNode itemsNode = responseNode.path("response")
				.path("body")
				.path("items")
				.path("item");
		
		ObjectMapper objectMapper = new ObjectMapper();
		List<Map<String, String>> tourPlaceList = objectMapper.convertValue(itemsNode, new TypeReference<>() {});
		
		System.out.println("tourPlaceList  :" + tourPlaceList);
		
		tripScheduleService.mergeSearchTourPlace(tourPlaceList);
		
		List<TourPlaceVO> popularPlaceList = tripScheduleService.selectPopularPlaceList(tourPlaceList);
		
		responseMap.put("popularPlaceList", popularPlaceList);
		
		return new ResponseEntity<Map<String, Object>>(responseMap, HttpStatus.OK);
	}
	
	@PostMapping("/insert")
	@ResponseBody
	public ResponseEntity<?> insertTourSchedule(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@RequestBody Params params
			) {
		System.out.println("params : " + params);

	    int memNo = customUser.getMember().getMemNo();
	    params.put("memNo", memNo);
	    
	    int resultSchedule = tripScheduleService.insertTripSchedule(params);
	    
	    return ResponseEntity.ok(1);
	}
	
	@PostMapping("/update")
	@ResponseBody
	public ResponseEntity<?> updateTourSchedule(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@RequestBody Params params
			) {
		System.out.println("params : " + params);
		
		int memNo = customUser.getMember().getMemNo();
		params.put("memNo", memNo);
		
		int resultSchedule = tripScheduleService.updateTripSchedule(params);
		
		return ResponseEntity.ok(1);
	}
	
	@PostMapping("/delete")
	@ResponseBody
	public ResponseEntity<?> deleteTourSchedule(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@RequestBody Params params
			) {
		int memNo = customUser.getMember().getMemNo();
		int schdlNo = params.getInt("schdlNo");
		
		int result = tripScheduleService.deleteTripSchedule(schdlNo);
		
		return ResponseEntity.ok(1);
	}
	
	@GetMapping("/my")
	public String mySchedule(
			@AuthenticationPrincipal CustomUserDetails customUser, Model model) {
		int memNo = customUser.getMember().getMemNo();
		
		List<TripScheduleVO> scheduleList = tripScheduleService.selectTripScheduleList(memNo);
		model.addAttribute("scheduleList", scheduleList);
		return "schedule/my";
	}
	
	@ResponseBody
	@PostMapping("/schbookmark/modify")
	public ResponseEntity<Map<String, Object>> bookmarkModify(
			@AuthenticationPrincipal CustomUserDetails customUser,
			@RequestBody Params params
			) {
		Map<String, Object> result = new HashMap<>();
		
	    int memNo = customUser.getMember().getMemNo();
	    params.put("memNo", memNo);
	    
		// 1. 파라미터 체크 (Params 활용)
	    if (params.get("schdlNo") == null || params.get("memNo") == null) {
	        result.put("message", "필수 파라미터가 누락되었습니다.");
	        return ResponseEntity.badRequest().body(result); // 400 Bad Request
	    }

	    try {
	        // 2. 서비스 로직 (식별 관계 북마크 토글)
	        // 존재하면 삭제(0), 없으면 등록(1) 후 현재 상태 반환
	        boolean isBookmarked = tripScheduleService.toggleBookmark(params);
	        
	        result.put("success", true);
	        result.put("isBookmarked", isBookmarked);
	        
	        return ResponseEntity.ok(result); // 200 OK
	        
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("error", e.getMessage());
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result); // 500 Error
	    }
	}
	
	@Data
	public static class ThumbnailData {
		private MultipartFile thumbnailFile;
		private int schdlNo;
	    private String linkThumbnail;
	    private String defaultYn;
	    private int attachNo;
	    private int memNo;

        // Lombok 미사용 시 기본 생성자와 Getter/Setter가 반드시 필요합니다.
        public ThumbnailData() {}
    }
	
	@PostMapping("/thumbnail/update")
	@ResponseBody
	public ResponseEntity<?> updateThumbnail(
			@ModelAttribute ThumbnailData thumbnailData
			) {
		System.out.println("ThumbnailData : " + thumbnailData);
		
		int resultSchedule = tripScheduleService.updateScheduleThumbnail(thumbnailData);
		
		return ResponseEntity.ok(1);
	}
	
	@PostMapping("/rcmd-result")
	public String mySchedule(String preferenceData, Model model) {
		
		ObjectMapper objectMapper = new ObjectMapper();
	    try {
	        // 1. String으로 받은 JSON을 Map으로 변환
//	        Map<String, Object> preferenceMap = objectMapper.readValue(preferenceData, new TypeReference<Map<String, Object>>(){});
	        JsonNode preferenceNode = objectMapper.readTree(preferenceData);
	        
	        System.out.println("preferenceNode : " + preferenceNode.toPrettyString());
	        
	        String dateItem = preferenceNode.get("travelDates").asText();
	        
	        String dates[] = dateItem.split(" ~ ");
	        
	        int duration = CommUtil.calculateDaysBetween(dates[0], dates[1]) + 1;
	        System.out.println("duration : "+duration);
	        
	        
	        
	        // 2. 비즈니스 로직 처리 (예: 서비스 호출)
	        // service.getRecommendation(preferenceData);
	        
	        // 3. 모델에 담아 JSP 등으로 전달
	        model.addAttribute("data", preferenceData);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
//	        return "error-page";
	    }
		
		return "schedule/rcmd-result";
	}
}
