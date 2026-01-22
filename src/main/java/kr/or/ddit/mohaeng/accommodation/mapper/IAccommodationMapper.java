package kr.or.ddit.mohaeng.accommodation.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccResvVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import kr.or.ddit.mohaeng.vo.SalesVO;
import kr.or.ddit.mohaeng.vo.TripProdListVO;

@Mapper
public interface IAccommodationMapper {

	/**
	 * 숙소 API 정보 저장
	 * @param vo
	 */
	public void insertAccommodation(AccommodationVO vo);

	public int checkDuplicate(String contentid);
	/**
	 *	<p> 숙소 상세 페이지 정보 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public AccommodationVO getAccommodationDetail(int tripProdNo);

	/**
	 *	<p> 숙소 타입 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public List<RoomTypeVO> getRoomList(int accNo);

	/**
	 * 숙소 전체 목록 조회
	 * @return
	 */
	public List<AccommodationVO> selectAccommodationListWithPaging(AccommodationVO acc);

	/**
	 * 숙소 필터 조회
	 * @return
	 */
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
	 * 
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

	/**
	 *	<p> 목적지 검색하기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public List<Map<String, Object>> searchLocation(String keyword);

	/**
	 *	<p> 실 객실 저장 </p>
	 *	@date 2026.01.19
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public void insertRoom(int roomTypeNo);

	/**
	 *	<p> 숙박 예약하기 </p>
	 *	@date 2026.01.19
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public int insertAccommodationReservaion(AccResvVO resvVO);

	/**
	 *	<p> 숙박 예약 시 약관 동의 </p>
	 *	@date 2026.01.21
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public void insertAccResvAgree(AccResvVO resv);

	/**
	 *	<p> 숙박 예약 시 구입상품목록 insert </p>
	 *	@date 2026.01.21
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public void insertProdList(TripProdListVO tripProdListVO);

	/**
	 *	<p> 숙박 예약 시 매출 insert </p>
	 *	@date 2026.01.21
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public void insertSales(SalesVO salesVO);


}
