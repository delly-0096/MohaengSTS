package kr.or.ddit.mohaeng.admin.accommodation.service;

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

}
