package kr.or.ddit.mohaeng.flight.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.AirlineVO;
import kr.or.ddit.mohaeng.vo.AirportVO;
import kr.or.ddit.mohaeng.vo.FlightScheduleVO;

public interface IFlightService {
	public int registerAirport();
	public List<AirportVO> selectAirportList(String keyword);
	public int registerAirline();
	public List<AirportVO> getAirportList();
	public List<AirlineVO> getAirlineList();

	public List<FlightScheduleVO> getFlightList(FlightScheduleVO flightSchedule);
}
