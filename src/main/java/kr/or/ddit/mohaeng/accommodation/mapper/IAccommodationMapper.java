package kr.or.ddit.mohaeng.accommodation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

@Mapper
public interface IAccommodationMapper {

	/**
	 * 숙소 API 정보 저장
	 * @param vo
	 */
	public void insertAccommodation(AccommodationVO vo);

	public int checkDuplicate(String contentid);

	/**
	 * 숙소 전체 목록 조회
	 * @return
	 */
	public List<AccommodationVO> selectAccommodationList();

	public AccommodationVO getAccommodationDetail(int accNo);

	public List<RoomTypeVO> getRoomList(int accNo);

	public List<AccommodationVO> selectAccommodationListWithPaging(AccommodationVO acc);

	public int selectTotalCount(AccommodationVO acc);

}
