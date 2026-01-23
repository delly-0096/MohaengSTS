package kr.or.ddit.mohaeng.tripschedule.controller;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StopWatch;
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
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tripschedule.enums.AccommType;
import kr.or.ddit.mohaeng.tripschedule.enums.ActivityLevel;
import kr.or.ddit.mohaeng.tripschedule.enums.BudgetPreference;
import kr.or.ddit.mohaeng.tripschedule.enums.RegionCode;
import kr.or.ddit.mohaeng.tripschedule.enums.TransportCode;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.util.CommUtil;
import kr.or.ddit.mohaeng.util.TravelClusterer;
import kr.or.ddit.mohaeng.util.TravelClusterer.Location;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;
import kr.or.ddit.util.Params;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/schedule")
public class TripScheduleController {
    
	private final ChatClient chatClient;
	
	@Autowired
	ITripScheduleService tripScheduleService;

    TripScheduleController(ChatClient.Builder builder) {
        this.chatClient = builder.build();
    }
    
	public record Recommendation(String title, String description, String reason) {
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
	) throws Exception {
	    int memNo = customUser.getMember().getMemNo();

	    TripScheduleVO params = new TripScheduleVO();
	    params.setSchdlNo(schdlNo);
	    params.setMemNo(memNo);

	    TripScheduleVO schedule = tripScheduleService.selectTripSchedule(params);
	    
	    System.out.println("schedule :" + schedule);
	    
	    model.addAttribute("schedule", schedule);

	    //일정 전체(일차/장소 포함) JSON을 함께 내려준다
	    ObjectMapper om = new ObjectMapper();

	    String scheduleJson = om.writeValueAsString(schedule);
	    String scheduleJsonB64 = Base64.getEncoder().encodeToString(scheduleJson.getBytes(StandardCharsets.UTF_8));
	    model.addAttribute("scheduleJsonB64", scheduleJsonB64);

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
				+ "&pageNo=" + page + "&numOfRows=100"
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
	
	@GetMapping("/rcmd-result")
	public String RcmdResult() {
		return "schedule/rcmd-result";
	}
	
	@ResponseBody
	@PostMapping("/rcmd-result")
//	public String mySchedule(String preferenceData, Model model) {
	public ResponseEntity<List<Map<String, Object>>> mySchedule(@RequestBody String preferenceData, Model model) {
		AccommType accommType = null;
		ActivityLevel activityLevel = null;
		BudgetPreference budgetPreference = null;
		TransportCode transportCode = null;
		
		ObjectMapper objectMapper = new ObjectMapper();
	    try {
	    	// 1. String으로 받은 JSON을 Map으로 변환
//	        Map<String, Object> preferenceMap = objectMapper.readValue(preferenceData, new TypeReference<Map<String, Object>>(){});
	        JsonNode preferenceNode = objectMapper.readTree(preferenceData);
	        
	        System.out.println("preferenceNode : " + preferenceNode.toPrettyString());
	        
	        String dateItem = preferenceNode.get("travelDates").asText();
	        
	        String dates[] = dateItem.split(" ~ ");
	        
	        String tripStyleCatList[] = objectMapper.convertValue(
        		preferenceNode.get("tripStyleCatList"), 
        	    new TypeReference<String[]>() {}
        	);
	        
	        String excludeList[] = null;
	        String exclude = "";
	        if(preferenceNode.get("excludeList") != null) {
		        excludeList = objectMapper.convertValue(
	        		preferenceNode.get("excludeList"), 
	        		new TypeReference<String[]>() {}
	        	);
		        
		        for(int i = 0; i < excludeList.length; i++) {
		        	if(i != 0) {
		        		exclude += ", ";
		        	}
		        	
		        	exclude += excludeList[i];
		        }
		        
	        }
	        

	        List<Params> tripStyleList = tripScheduleService.selectTripStyleList(tripStyleCatList);
	        
	        String styles = "";
	        for(int i = 0; i < tripStyleList.size(); i++) {
	        	if(i != 0) {
	        		styles += ", ";
	        	}
	        	styles += tripStyleList.get(i).getString("style");
	        }
	        
	        
	        Params params = new Params();
	        params.put("tripStyleCatList", tripStyleCatList);
	        params.put("rgnNo", preferenceNode.get("destinationcode").asText());
	        
	        //스타일 키워드에 맞는 관광지리스트
	        List<TourPlaceVO> styleMatchPlaceList = tripScheduleService.selectStyleMatchPlace(params);
	        
	        //관광지 번호로 바로 꺼낼 수 있는 구조의 데이터 생성
	        Map<String, TourPlaceVO> setKeyPlaceList = new HashMap<>();
	        
	        
	        
	        System.out.println("styleMatchPlaceList : " + styleMatchPlaceList.size());
	        int placeListSize = styleMatchPlaceList.size();
	        List<Map<String, String>> promptDataList = new ArrayList<>();
	        List<Location> locationList = new ArrayList<>();
	        
	        if(placeListSize > 0) {
	        	for(TourPlaceVO place : styleMatchPlaceList) {
	        		setKeyPlaceList.put(String.valueOf(place.getPlcNo()), place);
	        		Map<String, String> prompt = new HashMap<>();
	        		prompt.put("plcNo", String.valueOf(place.getPlcNo()));
	        		prompt.put("plcNm", place.getPlcNm());
	        		prompt.put("plcDesc", place.getPlcDesc());
	        		prompt.put("plcAddr1", place.getPlcAddr1());
	        		prompt.put("latitude", place.getLatitude());
	        		prompt.put("longitude", place.getLongitude());
	        		prompt.put("operationHours", place.getOperationHours() != null? place.getOperationHours() : "");
	        		prompt.put("plcPrice", place.getPlcPrice() != null? place.getPlcPrice() : "");
	        		prompt.put("ldongRegnCd", String.valueOf(place.getLdongRegnCd()));
	        		prompt.put("ldongRegnNm", place.getLdongRegnNm());
	        		prompt.put("ldongSignguCd", String.valueOf(place.getLdongSignguCd()));
	        		prompt.put("ldongSignguNm", place.getLdongSignguNm());
	        		
	        		promptDataList.add(prompt);
	        		
	        		Location location = new Location(place.getPlcNo(), place.getPlcNm(), (Double.parseDouble(place.getLatitude())), (Double.parseDouble(place.getLongitude())));
	        		locationList.add(location);
	        	}
	        }
	        
	        String aiInputData = promptDataList.stream()
	        	    .map(map -> String.format("%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s", 
	        	        map.get("plcNo"), 
	        	        map.get("plcNm"), 
	        	        map.get("plcDesc"), 
	        	        map.get("ldongRegnCd"), 
	        	        map.get("ldongRegnNm"), 
	        	        map.get("ldongSignguCd"), 
	        	        map.get("ldongSignguNm"), 
	        	        map.get("plcAddr1"), 
	        	        map.get("latitude"), 
	        	        map.get("longitude"), 
	        	        map.get("operationHours"), 
	        	        map.get("plcPrice")))
	        	    .collect(Collectors.joining("\n"));
	        
	        String prompt = "(ID|이름|설명|주소|위도|경도|운영시간|비용):\n" + aiInputData;
	        
	        //여행기간
	        int duration = 0;
	        if(dates.length > 1) {
	        	duration = CommUtil.calculateDaysBetween(dates[0], dates[1]);
	        }

	        Map<Integer, List<Location>> clusters = TravelClusterer.groupLocationsByDay(locationList, duration+1);
	        
	        StringBuilder promptData = new StringBuilder();

	        clusters.forEach((dayIdx, list) -> {
	            promptData.append(String.format("\n[%d일차 후보군]\n", dayIdx + 1));
	            list.forEach(loc -> promptData.append(String.format("%d|%s|%.4f|%.4f\n", loc.id(), loc.name(), loc.lat(), loc.lon())));
	        });
	        
	        System.out.println("promptData.toString() : " + promptData.toString());
	        
	        String finalPrompt = "아래 일자별 후보군 내에서만 동선을 최적화해서 시간을 배정해줘.\n" + promptData.toString();
	        
	        
	        String durationStr = duration + "박"+ (duration+1) +"일";
	        
	        //도착지
	        int destinationcode = Integer.parseInt(preferenceNode.get("destinationcode").asText());
	        String region = RegionCode.getNameByNo(destinationcode);
	        String[] accommodation = null;
	        String accommodations = "";
	        
	        //여행 페이스
	        String pace = preferenceNode.get("pace").asText().toUpperCase();
	        activityLevel = ActivityLevel.valueOf(pace);
	        String paceStr = activityLevel.getName() + "(" + activityLevel.getDescription() + ")" ;
	        
	        //예산계획
	        String budget = preferenceNode.get("budget").asText().toUpperCase();
	        budgetPreference = BudgetPreference.valueOf(budget);
	        String budgetStr = budgetPreference.getName() + "(" + budgetPreference.getDescription() + ")" ;
	        
	        //선호 숙소
	        if(preferenceNode.get("accommodation") != null) {
	        	accommodation = objectMapper.convertValue(
		        		preferenceNode.get("accommodation"), 
		        	    new TypeReference<String[]>() {}
		        	);
	        	
	        	for(int i = 0; i < accommodation.length; i++) {
	        		accommType = AccommType.valueOf(accommodation[i].toUpperCase());
	        		if(i != 0) {
	        			accommodations += ", ";
	        		}
	        		accommodations += accommType.getDescription();
	        	}
	        }
	        
	        //이동수단
	        String transport = preferenceNode.get("transport").asText().toUpperCase();
	        transportCode = TransportCode.valueOf(transport);
	        String transportStr = transportCode.getDescription();
	        
	        //여행인원
	        String travelers = preferenceNode.get("travelers").asText();
	        
	     // 1. 한국 시간대 설정
	        ZoneId seoulZone = ZoneId.of("Asia/Seoul");

	        // 2. 현재 한국 날짜 가져오기
	        LocalDate now = LocalDate.now(seoulZone);

	        // 3. AI 프롬프트용 포맷팅 (예: 2026년 1월 21일)
	        String formattedDate = now.format(DateTimeFormatter.ofPattern("yyyy년 M월 d일"));
	        
	        Params regionData = tripScheduleService.searchRegion(params);
	        
	        String coordinate = regionData.get("latitude")+"(위도), "+regionData.get("longitude") + "(경도)";
	        
	        String message = String.format("""
	        		너는 한국 여행 전문가야!
	        		
	        		여행일정 추천해줘
	        		현재일자 : '%s'
		            여행지역 : '%s'
		            여행인원 : '%s'명
		            여행기간 %s일
		            [참고할 관광지 DB 데이터] 값 역할 : (ID|이름|설명|시/도 코드|시/도|시군구 코드|시군구|주소|위도|경도|운영시간|비용)
		            
		            [선호하는 여행 스타일]
		            '%s'
		            
		            [여행페이스]
		            '%s'
		            
		            [예산수준]
		            '%s'
		            
		            [선호하는 숙소 유형]
		           ' %s'
		            
		            [이동 수단]
		            '%s'
		            
		            [위치 클러스터별 동선]
		            '%s'
		            
		            [참고할 관광지 DB 데이터]
		            '%s'
		            
		            [사용자가 재요청한 관광지 리스트]
		            '%s'
		            
					[지시사항]
					1. 후보군 내에서 위경도 기반으로 가장 가까운 순서대로 동선을 짜라.
					2. 순수 JSON만 출력하라.
					3. 예시데이터 설명 : (No : 관광지 키, Nm : 관광지명, S : 방문시간, T: 방문지 떠나는 시간, O : 방문순서).
					4. 예시데이터에 없는 항목에 대해서는 데이터 생성하지 말것.
					5. [참고할 관광지 DB 데이터]의 설명은 정보가 판단 근거가 부족할때 참고할 후순위 참고 데이터로 삼을것.
					6. 정확도가 다소 떨어져도 괜찮으니 응답속도를 높이는 방향으로 연산할 것
					7. 좌표를 기준으로 동선을 짜라
					8. 첫날 시작 좌표는 '%s'이다.
					9. [참고할 관광지 DB 데이터]는 시/도, 시군구 로 정렬되어있다.
					10. 일별로 여행의 제목을 지을 수 있으면 지어줘
					11. 여행자가 [사용자가 재요청한 관광지 리스트]는 관광지 키값들이 추천순서대로존재하는 항목이야 해당 항목에 데이터가 있을경우
						되도록 해당 관광지들은 추천 우선순위에서 후순위로 둘 것
					
		        	예시형태 : {result : [{
		        		schdlDt : 1,
		        		schdlNm : 1일차 여행,
		        		tourPlaceList : [
			        		{
			        		    No : 125994,
			        		    Nm : 관광지명,
			        		    S : 방문시간,
								T : 해당 방문지 떠나는 시간,
								O : 방문순서
			        		},
		        		    {
			        		    No : 126003,
			        		    Nm : 관광지명,
			        		    S : 방문시간,
								T : 해당 방문지 떠나는 시간,
								O : 방문순서
			        		},
		        		]
		        	},
		        	{
		        		schdlDt : 2,
		        		schdlNm : 경복궁 근처 탐방,
		        		tourPlaceList : [
			        		{
			        		    No : 128213,
			        		    Nm : 관광지명,
			        		    S : 방문시간,
								T : 해당 방문지 떠나는 시간,
								O : 방문순서
			        		},
		        		    {
			        		    No : 128513,
			        		    Nm : 관광지명,
			        		    S : 방문시간,
								T : 해당 방문지 떠나는 시간,
								O : 방문순서
			        		},
		        		]
		        	},
		        	],
		        	check : 판단에 시간이 가장 오래걸린 작업정보}
		            """,formattedDate, region, travelers, duration+1, styles
		               , paceStr, budgetStr, accommodations, transportStr
		               , finalPrompt, aiInputData, exclude, coordinate);
//			9. check 라는 key로 가장 시간이 오래소요된 작업에 대한 설명과 개선방향이나 추가할 프롬프트 관련 피드백을 해줘 (초단위 시간 알려줄 수 있으면 더 좋음)
//			12. 만약 축제나 행사등의 경우 운영 기간 외의 장소는 제외해
//			13. 운영기간이나 비용정보가 정형화가 부족할 경우 너의 내부정보가 더 정형화가 잘 되어있으면 그쪽에 따를 것
	        
//	        String message = String.format("""
//	        		여행일정 추천해줘
//	        		현재일자 : '%s'
//		            여행지역 : '%s'
//		            여행인원 : '%s'명
//		            여행기간 %s일
//		            [참고할 관광지 DB 데이터] 값 역할 : (ID|이름|설명|시/도 코드|시/도|시군구 코드|시군구|주소|위도|경도|운영시간|비용)
//		            
//		            [선호하는 여행 스타일]
//		            '%s'
//		            
//		            [여행페이스]
//		            '%s'
//		            
//		            [예산수준]
//		            '%s'
//		            
//		            [선호하는 숙소 유형]
//		           ' %s'
//		            
//		            [이동 수단]
//		            '%s'
//		            
//		            [위치 클러스터별 동선]
//		            '%s'
//		            
//		            [참고할 관광지 DB 데이터]
//		            '%s'
//		            
//					[지시사항]
//					1. 후보군 내에서 위경도 기반으로 가장 가까운 순서대로 동선을 짜라.
//					2. 운영 시간 정보가 있으면 준수하되 부족한 데이터는 니가 가진 데이터를 참고해서 짜줘.
//					3. 순수 JSON만 출력하라.
//					4. 예시데이터 설명 : (No : 관광지 키, Nm : 관광지명, S : 방문시간, T: 방문지 떠나는 시간, O : 방문순서).
//					5. 예시데이터에 없는 항목에 대해서는 데이터 생성하지 말것.
//					6. [참고할 관광지 DB 데이터]의 설명은 정보가 판단 근거가 부족할때 참고할 후순위 참고 데이터로 삼을것.
//					7. 정확도가 다소 떨어져도 괜찮으니 응답속도를 높이는 방향으로 연산할 것
//					8. check 라는 key로 가장 시간이 오래소요된 작업에 대한 설명과 개선방향이나 추가할 프롬프트 관련 피드백을 해줘 (초단위 시간 알려줄 수 있으면 더 좋음)
//					9. 후보군은 거리순으로 장소를 지정하면 그 장소에서 제일 가까운 추천지를 우선순위로 두고
//					   일별 데이터가 요구사항보다 적을 경우 다른 일자에 있는 후보군도 거리상 가까우면 넣어도 괜찮음
//					10. 주소항목을 이용해서 후보지로 삼을 동선을 좁힐 때 사용할 것
//					11. 운영시간은 판단이 정말 힘들 경우 경우 무시할 것
//					12. 시군구 간 인접 행렬은 니가 가지고있는 지역정보 참조해줘
//					13. 첫날 시작 좌표는 '%s' 라고 생각할 것
//					
//		        	예시형태 : {result : [{
//		        		schdlDt : 1,
//		        		tourPlaceList : [
//			        		{
//			        		    No : 125994,
//			        		    Nm : 관광지명,
//			        		    S : 방문시간,
//								T : 해당 방문지 떠나는 시간,
//								O : 방문순서
//			        		},
//		        		    {
//			        		    No : 126003,
//			        		    Nm : 관광지명,
//			        		    S : 방문시간,
//								T : 해당 방문지 떠나는 시간,
//								O : 방문순서
//			        		},
//		        		]
//		        	},
//		        	{
//		        		schdlDt : 2,
//		        		tourPlaceList : [
//			        		{
//			        		    No : 128213,
//			        		    Nm : 관광지명,
//			        		    S : 방문시간,
//								T : 해당 방문지 떠나는 시간,
//								O : 방문순서
//			        		},
//		        		    {
//			        		    No : 128513,
//			        		    Nm : 관광지명,
//			        		    S : 방문시간,
//								T : 해당 방문지 떠나는 시간,
//								O : 방문순서
//			        		},
//		        		]
//		        	},
//		        	],
//		        	check : 판단에 시간이 가장 오래걸린 작업정보}
//		            """,formattedDate, region, travelers, duration+1, styles
//		            , paceStr, budgetStr, accommodations, transportStr
//		            , finalPrompt, aiInputData, coordinate);
	        
	        
	        StopWatch stopWatch = new StopWatch();
	        stopWatch.start("Task1");
	        // 4. AI 호출
	        JsonNode aiResult = chatClient.prompt()
	                .user(message)
	                .call()
	                .entity(new ParameterizedTypeReference<JsonNode>() {});
	        stopWatch.stop();
////	        
	        System.out.println(aiResult.toPrettyString());
	        
	        System.out.println(stopWatch.prettyPrint()); // 전체적인 소요 시간 및 태스크별 비율
	        System.out.println("Total Time: " + stopWatch.getTotalTimeMillis() + "ms");
	        
	        // 3. 모델에 담아 JSP 등으로 전달
	        model.addAttribute("data", preferenceData);
	        model.addAttribute("result", aiResult);
	        
	        System.out.println("message : " + message);
	        
	        
			ObjectMapper mapper = new ObjectMapper();
			Map<String, Object> aiResultMap = mapper.convertValue(aiResult, Map.class);
			List<Map<String, Object>> resultList = (List<Map<String, Object>>) aiResultMap.get("result");
			
			System.out.println("resultList : " + resultList);
			
			for(Map<String, Object> resultMap : resultList) {
				List<Map<String, Object>> tourPlaceList = (List<Map<String, Object>>) resultMap.get("tourPlaceList");
				System.out.println("tourPlaceList : " + tourPlaceList);
				for(Map<String, Object> tourPlace : tourPlaceList) {
					String No = tourPlace.get("No").toString();
					TourPlaceVO placeData =  setKeyPlaceList.get(No);
					
					tourPlace.put("placeInfo", placeData);
				}
			}
			
	        return new ResponseEntity<List<Map<String, Object>>>(resultList, HttpStatus.OK);
	    } catch (Exception e) {
	        e.printStackTrace();
//	        return "error-page";
	        return new ResponseEntity<List<Map<String, Object>>>(HttpStatus.BAD_REQUEST);
	    }
		
//		return "schedule/rcmd-result";
	}
}
