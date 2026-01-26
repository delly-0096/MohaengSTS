package kr.or.ddit.mohaeng.admin.accommodation.service;

import java.util.Map;

import kr.or.ddit.mohaeng.admin.accommodation.dto.AdminAccommodationDTO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAdminAccommodationService {

	/**
	 * 숙박 관리 목록 조회
	 * @author kdrs
	 * @date 2026.01.22
	 */
	public void getAccommodationList(PaginationInfoVO<AccommodationVO> pagInfoVO);

	/**
	 * 숙박 정보 상세 조회
	 * @author kdrs
	 * @date 2026.01.23
	 */
	public AccommodationVO getAccommodationDetail(int tripProdNo);

	/**
	 * 상품 최종 승인
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int approveAccommodation(int tripProdNo);

	/**
	 * 판매 상태 토글
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int toggleSaleStatus(Map<String, Object> params);

	/**
	 * 숙소 수정
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int updateAccommodation(AdminAccommodationDTO accDto);

	/**
	 * 숙소 논리 삭제
	 * @author kdrs
	 * @date 2026.01.25
	 */
	public int deleteAccommodation(int tripProdNo);

}
