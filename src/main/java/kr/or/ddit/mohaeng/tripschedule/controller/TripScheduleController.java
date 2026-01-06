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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestClient;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.mohaeng.login.controller.LoginController;
import kr.or.ddit.mohaeng.tripschedule.service.ITripScheduleService;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.util.Params;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/schedule")
public class TripScheduleController {
	
	@Autowired
	ITripScheduleService tripScheduleService;
	
	@GetMapping("/search")
	public String search(Model model) {
//		Params params = new Params();
//		List<Map<String, Object>> regionList = tripScheduleService.selectRegionList();
		model.addAttribute("popRegionList", tripScheduleService.selectPopRegionList());
//		System.out.println(regionList);
		return "schedule/search";
	}
	
	@ResponseBody
	@GetMapping("/regionList")
	public ResponseEntity<List> searchRegionList(Model model) {
		return new ResponseEntity<List>(tripScheduleService.selectRegionList(), HttpStatus.OK);
	}
	
	@ResponseBody
	@GetMapping("/searchRegion")
	public ResponseEntity<Params> searchRegion(HttpServletRequest req ,Model model) {
		Params params = Params.of(req);
		System.out.println(params);
		params = tripScheduleService.searchRegion(params);
		System.out.println(params);
		return new ResponseEntity<Params>(params, HttpStatus.OK);
	}
	
	@GetMapping("/planner")
	public String planner(Model model) {
//		List<Map<String, Object>> tourPlaceList = tripScheduleService.selectTourPlaceList();
//		System.out.println(tourPlaceList.get(1));
//		model.addAttribute("tourPlaceList", tourPlaceList);
		
		return "schedule/planner";
	}
	
	@ResponseBody
	@GetMapping("/initTourPlaceList")
	public ResponseEntity<Map<String, Object>> initTourPlaceList(HttpServletRequest req ,Model model) {
		Params params = Params.of(req);
		RestClient restClient = RestClient.create();

		String urlString = "https://apis.data.go.kr/B551011/KorService2/areaBasedList2?MobileOS=WEB&MobileApp=mohaeng&_type=json&arrange=O"
				+ "&pageNo=1&numOfRows=15"
				+ "&contentTypeId=14"
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
	@GetMapping("/searchPlaceDetail")
	public ResponseEntity<TourPlaceVO> searchPlaceDetail(HttpServletRequest req ,Model model) {
		Params params = Params.of(req);
		RestClient restClient = RestClient.create();
		
		int contentId = params.getInt("contentId");
		
		TourPlaceVO myTourPlaceVO = new TourPlaceVO();
		myTourPlaceVO.setPlcNo(contentId);
		myTourPlaceVO =	tripScheduleService.searchPlaceDetail(myTourPlaceVO);
		
		Map<String, Object> resultMap = new HashMap<>();

		if(StringUtils.hasText(myTourPlaceVO.getPlcDesc())) {
			return new ResponseEntity<TourPlaceVO>(myTourPlaceVO, HttpStatus.OK);
		}
		
		String contenttypeId = params.getString("contenttypeId");
		
		String introUrlString = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&contentTypeId=" + contenttypeId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		String detailUrlString = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + params.get("contentId")
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
		
//		JsonNode resultItem = null;
//		if (introItemNode.isArray() && !introItemNode.isEmpty()) {
//		    resultItem = introItemNode.get(0);
//		} else {
//		    // 데이터가 없을 때의 처리 (로그를 남기거나 빈 객체 반환 등)
//		    System.out.println("데이터가 존재하지 않습니다.");
//		}
		
		JsonNode detailNode = restClient.get()
				.uri(detailUri)
				.retrieve()
				.body(JsonNode.class);
		
		JsonNode detailItemNode = detailNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		
//		ObjectMapper introObjectMapper = new ObjectMapper();
//		Map<String, String> tourPlaceIntro = introObjectMapper.convertValue(introItemNode, new TypeReference<>() {});
//		resultMap.put("tourPlaceIntro", tourPlaceIntro);
//		System.out.println("tourPlaceIntro : " + tourPlaceIntro);
//		
//		ObjectMapper detailObjectMapper = new ObjectMapper();
//		Map<String, String> tourPlaceDetail = detailObjectMapper.convertValue(detailItemNode, new TypeReference<>() {});
//		resultMap.put("tourPlaceDetail", tourPlaceDetail);
//		System.out.println("tourPlaceDetail : " + tourPlaceDetail);
		
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
	
	@GetMapping("/my")
	public String mySchedule() {
		
		return "/schedule/my";
	}
	
	@GetMapping("/bookmark")
	public String bookmark() {
		
		return "/schedule/bookmark";
	}
}
