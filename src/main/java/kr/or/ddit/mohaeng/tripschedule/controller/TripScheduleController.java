package kr.or.ddit.mohaeng.tripschedule.controller;

import java.io.Console;
import java.net.URI;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.admin.login.controller.ConnetController;
import kr.or.ddit.mohaeng.community.travellog.comments.service.CommentsServiceImpl;
import kr.or.ddit.mohaeng.login.controller.LoginController;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.tripschedule.enums.RegionCode;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.vo.CustomUser;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleDetailsVO;
import kr.or.ddit.mohaeng.vo.TripSchedulePlaceVO;
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
		
		return "schedule/planner_edit";
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
	@GetMapping("/common/initTourPlaceList")
	public ResponseEntity<Map<String, Object>> initTourPlaceList(HttpServletRequest req ,Model model) {
		Params params = Params.of(req);
		RestClient restClient = RestClient.create();

		String urlString = "https://apis.data.go.kr/B551011/KorService2/areaBasedList2?MobileOS=WEB&MobileApp=mohaeng&_type=json"
				+ "&arrange=Q"
				+ "&pageNo=1&numOfRows=15"
				+ "&areaCode=" + params.get("areaCode")
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";

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
		RestClient restClient = RestClient.create();
		params.put("contentId", contentId);
		params.put("contenttypeId", contenttypeId);
		
		TourPlaceVO myTourPlaceVO = new TourPlaceVO();
		myTourPlaceVO.setPlcNo(contentId);
		myTourPlaceVO =	tripScheduleService.searchPlaceDetail(myTourPlaceVO);

		if(StringUtils.hasText(myTourPlaceVO.getPlcDesc())) {
			return new ResponseEntity<TourPlaceVO>(myTourPlaceVO, HttpStatus.OK);
		}
		
		String introUrlString = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&contentTypeId=" + contenttypeId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		String detailUrlString = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		// 2. URI 객체로 변환 (이러면 RestClient가 내부에서 자동 인코딩을 안 합니다)
		URI introUri = URI.create(introUrlString);
		URI detailUri = URI.create(detailUrlString);
		
		JsonNode introNode = restClient.get()
			    .uri(introUri)
			    .retrieve()
			    .body(JsonNode.class);
		
		JsonNode introItemNode = introNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		JsonNode detailNode = restClient.get()
				.uri(detailUri)
				.retrieve()
				.body(JsonNode.class);
		
		JsonNode detailItemNode = detailNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		//어떤 키값에 비용과 이용시간 정보가 있는건지 체킹 후 params 에 넣음
		tripScheduleService.contentIdCheck(params);
		
		System.out.println("		JsonNode detailItemNode : "+ detailItemNode);
		
		String plcDesc = detailItemNode.get("overview")+"";
		String plcNm = detailItemNode.get("title")+"";
		String operationHours = introItemNode.get(params.getString("operationhours"))+"";
		String plcPrice = introItemNode.get(params.getString("plcprice"))+"";
		String defaultImg = detailItemNode.get("firstimage")+"";
		String plcAddr1 = detailItemNode.get("addr1")+"";
		
		TourPlaceVO tourPlaceVO = new TourPlaceVO();
		tourPlaceVO.setPlcNo(contentId);
		tourPlaceVO.setPlcNm(plcNm);
		tourPlaceVO.setPlcDesc(plcDesc.replace("\"", ""));
		tourPlaceVO.setOperationHours(operationHours.replace("\"", ""));
		tourPlaceVO.setPlcPrice(plcPrice.replace("\"", ""));
		tourPlaceVO.setDefaultImg(defaultImg.replace("\"", ""));
		tourPlaceVO.setPlcAddr1(plcAddr1.replace("\"", ""));
		
		int cnt = tripScheduleService.saveTourPlacInfo(tourPlaceVO);
		
		System.out.println("tourPlaceVO : " + tourPlaceVO);
		
		return new ResponseEntity<TourPlaceVO>(tourPlaceVO, HttpStatus.OK);
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
	
}
