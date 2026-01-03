package kr.or.ddit.mohaeng.flight.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.DefaultUriBuilderFactory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mohaeng.flight.mapper.IFlightMapper;
import kr.or.ddit.mohaeng.vo.AirlineVO;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightScheduleVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FlightServiceImpl implements IFlightService {

	@Autowired
	private IFlightMapper mapper;
	
	// api 서비스키
	public static final String serviceKey = "a7bc76e60824b232ff8273a1191a079f36c11cee6fdbe0be73f54b73d5c510f9";
	
	// 공항 조회 - 검색시
	@Override
	public List<AirportVO> selectAirportList(String keyword) {
		return mapper.selectAirportList(keyword);
	}
	
	// 전체 공항 조회
	@Override
	public List<AirportVO> getAirportList() {
		return mapper.getAirportList();
	}

	// 전체 항공사 조회
	@Override
	public List<AirlineVO> getAirlineList() {
		return mapper.getAirlineList();
	}
	
	
	// 항공권 조회 - db 저장 필요없음
	@Override
	public List<FlightScheduleVO> getFlightList(FlightScheduleVO flightSchedule) {
		List<FlightScheduleVO> flightScheduleList = new ArrayList<>();

		try {
			String baseUrl = "http://apis.data.go.kr/1613000/DmstcFlightNvgInfoService/getFlightOpratInfoList";
	
			StringBuilder urlBuilder = new StringBuilder(baseUrl);
			urlBuilder.append("?serviceKey=" + serviceKey);
			urlBuilder.append("&_type=json");
			urlBuilder.append("&pageNo=" + flightSchedule.getPageNo());
			urlBuilder.append("&numOfRows=" + flightSchedule.getNumOfRows());
			urlBuilder.append("&depAirportId=" + flightSchedule.getDepAirportId());
			urlBuilder.append("&arrAirportId=" + flightSchedule.getArrAirportId());
			urlBuilder.append("&depPlandTime=" + flightSchedule.getStartDt().toString().replaceAll("-", ""));
	
			// 4. RestTemplate 설정
			RestTemplate restTemplate = new RestTemplate();
			DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
			factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
			restTemplate.setUriTemplateHandler(factory);
	
			
			log.info("요청 URL: {}", urlBuilder.toString());
	        String jsonResponse = restTemplate.getForObject(urlBuilder.toString(), String.class);
	        log.info("응답 데이터: {}", jsonResponse);
	
	        // 4. Jackson ObjectMapper를 이용한 파싱
	        ObjectMapper mapper = new ObjectMapper();
	        JsonNode root = mapper.readTree(jsonResponse);
			JsonNode items = root.path("response").path("body").path("items").path("item");
			
			

			
			if (items.isArray()) {
			    for (JsonNode node : items) {
			    	FlightScheduleVO vo = new FlightScheduleVO();
			        
			        vo.setAirlineNm(node.path("airlineNm").asText());       // 항공사명
			        vo.setFlightSymbol(node.path("vihicleId").asText()); 	// 편명
			        vo.setEconomyCharge(node.path("economyCharge").asInt());// 요금
			        
			        vo.setArrAirportNm(flightSchedule.getArrAirportNm());
			        vo.setDepAirportNm(flightSchedule.getDepAirportNm());
			        
			        String rawDepTime = node.path("depPlandTime").asText();
			        timeFormatter(vo ,rawDepTime, 1);
			        
			        String rawArrTime = node.path("arrPlandTime").asText(); 
			        timeFormatter(vo , rawArrTime, 2);
			        
			        flightScheduleList.add(vo);
			    }
			} else if (items.isObject()) {
		    	FlightScheduleVO vo = new FlightScheduleVO();
		        
		        vo.setAirlineNm(items.path("airlineNm").asText());       // 항공사명
		        vo.setFlightSymbol(items.path("vihicleId").asText());       // 편명 데이터 없음
		        vo.setEconomyCharge(items.path("economyCharge").asInt());// 요금
		    	
		        
		        String rawDepTime = items.path("depPlandTime").asText();
		        timeFormatter(vo ,rawDepTime, 1);
		        
		        String rawArrTime = items.path("arrPlandTime").asText(); 
		        timeFormatter(vo ,rawArrTime, 2);
		        
		        flightScheduleList.add(vo);
			}
			
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		if(flightSchedule.getSorting() == "") {
			return flightScheduleList;
		}
		return flightScheduleList;
	}
	
	public void timeFormatter(FlightScheduleVO vo, String rawTime, int form) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmm");
		if(rawTime != null && !rawTime.isEmpty()) {
			if(form == 1) {
				LocalDateTime parseDateTime = LocalDateTime.parse(rawTime, formatter);
				String dayOfWeek = parseDateTime.getDayOfWeek()
                        .getDisplayName(TextStyle.SHORT, Locale.KOREAN);
				vo.setDepTime(parseDateTime);
				vo.setStartDt(parseDateTime.toLocalDate());
				vo.setDomesticDays(dayOfWeek);
			}
			else {
				LocalDateTime parseDateTime = LocalDateTime.parse(rawTime, formatter);
				vo.setArrTime(parseDateTime);;
				vo.setEndDt(parseDateTime.toLocalDate());
				
			}
		}
	}
	
	
	
	
	
	// 공항 등록
	@Override
	public int registerAirport() {
		String url = "http://apis.data.go.kr/1613000/DmstcFlightNvgInfoService/getArprtList?serviceKey="
				+ serviceKey + "&_type=json";
		
		// 공항정보 - vo에 있는 정보와 매칭하는 것
		RestTemplate restTemplate = new RestTemplate();	// 편하게 json끌어오기 가능
		
		// response -> body -> items 구조여서
		Map<String, Object> response = restTemplate.getForObject(url, Map.class);
		Map<String, Object> res = (Map<String, Object>) response.get("response");
		Map<String, Object> body = (Map<String, Object>) res.get("body");
		Map<String, Object> items = (Map<String, Object>) body.get("items");
		List<Map<String, Object>> airportList = (List<Map<String, Object>>) items.get("item");
        
		int status = 0;
		for(Map<String, Object> airport : airportList) {
			AirportVO vo = new AirportVO();
			
			vo.setAirportId((String)airport.get("airportId"));
			vo.setAirportNm((String)airport.get("airportNm"));
			log.info("airportId : ", vo.getAirportId());
			log.info("airportNm : ", vo.getAirportNm());
			// 정보 있는지 조회하는 코드 필요
			status = mapper.registerAirport(vo);
			log.info("registerAirport : regist ", status);
		}
		
		return status;
	}

	// 항공사 등록 - 기업회원용
	@Override
	public int registerAirline() {
		String url = "http://apis.data.go.kr/1613000/DmstcFlightNvgInfoService/getAirmanList?serviceKey="
				+ serviceKey + "&_type=json";
		
		RestTemplate restTemplate = new RestTemplate();
		
		// response -> body -> items 구조여서
		Map<String, Object> response = restTemplate.getForObject(url, Map.class);
		Map<String, Object> res = (Map<String, Object>) response.get("response");
		Map<String, Object> body = (Map<String, Object>) res.get("body");
		Map<String, Object> items = (Map<String, Object>) body.get("items");
		List<Map<String, Object>> airlineList = (List<Map<String, Object>>) items.get("item");
		
		int status = 0;
		for(Map<String, Object> airline : airlineList) {
			AirlineVO vo = new AirlineVO();
			
			vo.setAirlineId((String)airline.get("airlineId"));
			vo.setAirlineNm((String)airline.get("airlineNm"));
			log.info("airlineId : ", vo.getAirlineId());
			log.info("airportNm : ", vo.getAirlineNm());
			status = mapper.registerAirline(vo);
			log.info("registerAirport : regist ", status);
		}
		return status;
	}



}
