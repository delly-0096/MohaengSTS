package kr.or.ddit.mohaeng.admin.accommodation.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.admin.accommodation.dto.AdminAccommodationDTO;
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

	/**
	 * 상품 최종 승인
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int updateApproveStatus(int tripProdNo);

	/**
	 * 판매 상태 토글
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int toggleSaleStatus(Map<String, Object> params);

	/**
     * 여행 상품 공통 정보 수정 (판매 기간 등)
     * @author kdrs
     * @date 2026.01.25
     */
    public void updateTripProduct(AdminAccommodationDTO accDto);

    /**
     * 숙소 상세 정보 수정 (이름, 시간, 주소 등)
     * @author kdrs
     * @date 2026.01.25
     */
    public int updateAccommodation(AdminAccommodationDTO accDto);

    /**
     * 숙소 편의시설 정보 수정 (Wi-Fi, 주차 등)
     * @author kdrs
     * @date 2026.01.25
     */
    public void updateAccFacility(AccFacilityVO accFacility);

    /**
     * 특정 숙소의 모든 객실 타입 삭제 (수정 시 초기화 용도)
     * @author kdrs
     * @date 2026.01.25
     */
    public void deleteRoomTypesByAccNo(int accNo);

    /**
     * 객실 타입 신규 등록 (수정 시 재등록 용도)
     * @author kdrs
     * @date 2026.01.25
     */
    public void insertRoomType(RoomTypeVO room);

    /**
     * 상품 삭제 처리 (DEL_YN = 'Y' 논리 삭제)
     * @author kdrs
     * @date 2026.01.25
     */
    public int logicalDeleteTripProduct(int tripProdNo);
	
}
