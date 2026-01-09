package kr.or.ddit.mohaeng.flight.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.flight.service.IFlightService;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/product/flight")
public class FlightController {

	@Autowired
	private IFlightService service;
	
	@GetMapping("")
	public String flightPage(Model model) {
		
//		List<FlightProductVO> flightList = service.getFlightList();
//		for(FlightProductVO flight : flightList) {
//			System.out.println(flight.getEconomyCharge());
//			log.info("금액");
//		}
//		model.addAttribute("flightList", flightList);
		return "product/flight";
	}
	
	
	@ResponseBody
	@GetMapping("/search")
	public List<AirportVO> searchAirport(@RequestParam(required = false) String keyword){
//		log.info("searchAirport 실행", keyword);
		return service.selectAirportList(keyword);
	}
	
	@ResponseBody
	@PostMapping("/searchFlight")
	public List<FlightProductVO> searchFlight(@RequestBody FlightProductVO flightProduct){
		System.out.println("flight service다 : " + flightProduct);
		log.info("flightController.searchFlight => {}", flightProduct);
		return service.getFlightList(flightProduct);
	}
	
	@ResponseBody
	@PostMapping("/user")
	public MemberVO flighterInfo(@RequestBody MemberVO memberVO) {
		log.info("결제할 정보 가져오기 {}", memberVO.getMemId());
		MemberVO member = service.getPayPerson(memberVO.getMemId());
		return member;
	}
	
	
	
	@GetMapping("/booking")
	public String flightBooking(/* @RequestBody List<FlightProductVO> flightList */) {
		// 여기서 db에 정보를 담을지
		
		return "product/flightBooking";
	}
	
	// 결제 페이지 보내기전에 정보를 여기로 보내서 insert.
	// insert하고 결제 실패하면 없앤다.
	
	
// 결제정보 insert 하고 보내기 -> 성공시 complete 실패시 다른곳으로
		
//		mId: 상점 아이디
//		lastTransactionKey: 마지막 거래의 키값
//		paymentKey: 해당 결제의 고유 키
//		orderId: 상점 주문번호
//		orderName: 주문명
//		status: 결제 처리 상태 (DONE: 완료, CANCELED: 취소, PARTIAL_CANCELED: 부분 취소 등)
//		totalAmount: 총 결제 금액
//		method: 결제 수단 (카드, 가상계좌, 계좌이체 등)
//		approvedAt: 결제 승인 시각 (ISO 8601 형식)
//		card: 카드 결제 시 카드사 정보, 할부 개월 수 등 (결제 수단별 상세 객체 제공)
	
}
