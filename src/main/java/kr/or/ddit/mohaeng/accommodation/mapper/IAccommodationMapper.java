package kr.or.ddit.mohaeng.accommodation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
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

	/**
	 * 숙소 상세정보 API 저장
	 * @param vo
	 */
	public List<AccommodationVO> selectListForDetailUpdate();

	/**
	 * DB 업데이트
	 * @param acc
	 */
	public void updateAccommodationDetail(AccommodationVO acc);

	/**
	 * 시설 정보 MERGE INTO 실행
	 * @param facilityVO
	 */
	public void upsertAccFacility(AccFacilityVO facilityVO);

	public void insertRoomType(RoomTypeVO roomType);

	public void insertRoomFacility(RoomFacilityVO facility);

	public void insertRoomFeature(RoomFeatureVO feature);

}
