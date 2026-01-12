package kr.or.ddit.mohaeng.flight.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AirlineVO;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightPassengersVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.FlightReservationVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Mapper
public interface IFlightMapper {
	public int registerAirport(AirportVO vo);					// 공항 등록
	public int registerAirline(AirlineVO vo);					// 항공 등록
	
	public AirlineVO selectAirline(String airlineNm);			// 항공사 id 가져오기 위한 것
	
	
	public List<AirportVO> getAirportList();					// 전체 공항 목록 조회
	public List<AirlineVO> getAirlineList();					// 전체 항공사 조회
	public MemberVO getPayPerson(String memId);					// 결제자 정보 조회
	
	public int insertFlight(FlightProductVO flightProductVO);						// 항공권 정보 추가 
	public int insertFlightReservation(FlightReservationVO flightReservationVO);	// 예약정보 추가
	public int insertPassengers(FlightPassengersVO flightPassengersVO);				// 탑승객 정보 추가
}
