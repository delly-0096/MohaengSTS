package kr.or.ddit.mohaeng.accommodation.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

public interface IAccommodationService {

	// DB에서 데이터 리스트 가져오기
	public List<AccommodationVO> selectAccommodationList(String areaCode);

	// 상세 페이지 불러오기
	public AccommodationVO getAccommodationDetail(int accNo);

	// 객실 타입 조회
	public List<RoomTypeVO> getRoomList(int accNo);
	
	// 페이지 데이터
	public List<AccommodationVO> selectAccommodationListWithPaging(AccommodationVO acc);
	
	// 전체 개수 가져오기
	public int selectTotalCount(AccommodationVO acc);

}
