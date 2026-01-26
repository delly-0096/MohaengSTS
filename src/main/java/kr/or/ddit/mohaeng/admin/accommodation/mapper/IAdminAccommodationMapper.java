package kr.or.ddit.mohaeng.admin.accommodation.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccOptionVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

@Mapper
public interface IAdminAccommodationMapper {

	/**
	 * 숙박 목록 카운트
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public Integer getAccommodationCount(PaginationInfoVO<AccommodationVO> pagInfoVO);

	/**
	 * 숙박 목록 전체 조회
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public List<AccommodationVO> getAccommodationList(PaginationInfoVO<AccommodationVO> pagInfoVO);

	/**
	 * 여행 상품 1:1 숙박 
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public AccommodationVO selectAccommodationBase(int tripProdNo);

	/**
	 * 객실 목록 select 
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public List<RoomTypeVO> selectRoomTypesByTripProdNo(int tripProdNo);

	/**
	 * 숙박 시설 정보 select 
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public AccFacilityVO selectAccommodationFacilityByTripProdNo(int tripProdNo);

	/**
	 * 객실 시설 정보 select 
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public List<RoomFacilityVO> selectRoomFacilitiesByTripProdNo(int tripProdNo);

	/**
	 * 객실 추가옵션 정보 select
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public List<AccOptionVO> selectAccommodationOptionByTripProdNo(int tripProdNo);

	/**
	 * 객실 이미지 정보 select
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public List<AttachFileDetailVO> selectAccommodationImages(int accFileNo);
	
}
