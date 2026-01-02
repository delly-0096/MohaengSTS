package kr.or.ddit.mohaeng.tripschedule.controller;

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
		System.out.println(tripScheduleService.selectRegionList());
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
				+ "&pageNo=1&numOfRows=10"
				+ "&contentTypeId=12"
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
	
}
