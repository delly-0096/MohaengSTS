package kr.or.ddit.mohaeng.accommodation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
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

	/**
	 *	<p> 숙소 정보 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public AccommodationVO getAccommodationDetail(int accNo);

	/**
	 *	<p> 숙소 타입 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
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

	/**
	 *	<p> 숙소 보유 시설 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public AccFacilityVO getAccFacility(int accNo);

	/**
	 *	<p> 숙소 판매자 정보 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public CompanyVO getSellerStatsByProdNo(long tripProdNo);

	/**
	 *	<p> 숙소 상세 타입 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public RoomTypeVO getRoomTypeDetail(int roomTypeNo);

}
