package kr.or.ddit.mohaeng.flight.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class FlightController {

	@Autowired
	private IFlightService service;
	
	/**
	 * <p>항공권 조회 페이지</p>
	 * @author sdg
	 * @return 항공권 조회 페이지
	 */
	@GetMapping("/product/flight")
	public String flightPage(Model model) {
		// 이 데이터 json으로 보낼지, 그냥 객체로 보낼지
		List<AirportVO> airportList = service.getAirportList();
		ObjectMapper objectMapper = new ObjectMapper();
		String airportListJson;
		
		try {
			airportListJson = objectMapper.writeValueAsString(airportList);
			model.addAttribute("airportList", airportListJson);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		}
		
		return "product/flight";
	}
	
	/**
	 * <p>항공권 검색</p>
	 * @param flightProduct api 입력 정보
	 * @return 조건에 맞는 항공권 정보
	 */
	@ResponseBody
	@PostMapping("/product/flight/searchFlight")
	public List<FlightProductVO> searchFlight(@RequestBody FlightProductVO flightProduct){
		log.info("flightController.searchFlight => {}", flightProduct);
		return service.getFlightList(flightProduct);
	}
	
	/**
	 * <p>결제자 정보 가져오기</p>
	 * @author sdg
	 * @param memberVO 회원 id
	 * @return memNo, memName, memEmail, tel, point
	 */
	@ResponseBody
	@PostMapping("/product/flight/user")
	public MemberVO flighterInfo(@RequestBody MemberVO memberVO) {
		log.info("결제할 정보 가져오기 {}", memberVO.getMemId());
		MemberVO member = service.getPayPerson(memberVO.getMemId());
		return member;
	}
	
	/**
	 * <p>예약페이지 이동 컨트롤러</p>		-- 결제자 정보도 보내자
	 * @author sdg
	 * @return 예약페이지
	 */
	@GetMapping("/product/flight/booking")
	public String flightBooking() {
		return "product/flightBooking";
	}
	
	/**
	 * <p>좌석 정보 가져오기</p>
	 * @param flightProductVO 항공권 정보(항공편명, 출발, 도착시간, 시간정보)
	 * @return 좌석정보
	 */
	@ResponseBody
	@PostMapping("/product/flight/seat")
	public List<String> flightSeat(@RequestBody FlightProductVO flightProductVO){
		log.info("flightProductVO : {}", flightProductVO);
		return service.getFlightSeat(flightProductVO);
	}
	
}
