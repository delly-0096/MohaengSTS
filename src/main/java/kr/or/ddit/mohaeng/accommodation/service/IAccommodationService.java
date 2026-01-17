package kr.or.ddit.mohaeng.accommodation.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.AccommodationVO;

public interface IAccommodationService {

	// DB에서 데이터 리스트 가져오기
	public List<AccommodationVO> selectAccommodationList();

}
