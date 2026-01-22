package kr.or.ddit.mohaeng.admin.accommodation.service;

import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IAdminAccommodationService {

	/**
	 * 숙박 관리 목록 조회
	 * @param pagInfoVO
	 */
	public void getAccommodationList(PaginationInfoVO<AccommodationVO> pagInfoVO);

}
