package kr.or.ddit.mohaeng.flight.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AirlineVO;
import kr.or.ddit.mohaeng.vo.AirportVO;

@Mapper
public interface IFlightMapper {
	public int registerAirport(AirportVO vo);					// 공항 등록
	public List<AirportVO> selectAirportList(String keyword);	// 공항 목록 검색
	public int registerAirline(AirlineVO vo);					// 항공 등록
	
	
	public List<AirportVO> getAirportList();
	public List<AirlineVO> getAirlineList();
	
}
