package kr.or.ddit.mohaeng.accommodation.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

@Service
public class AccommodationServiceImpl implements IAccommodationService{
	
	@Autowired
	private IAccommodationMapper accMapper;

	/**
	 *	<p> 숙소 정보 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public AccommodationVO getAccommodationDetail(int accNo) {
		return accMapper.getAccommodationDetail(accNo);
	}

	/**
	 *	<p> 숙소 타입 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public List<RoomTypeVO> getRoomList(int accNo) {
		return accMapper.getRoomList(accNo);
	}

	@Override
	public List<AccommodationVO> selectAccommodationListWithPaging(AccommodationVO acc) {
		return accMapper.selectAccommodationListWithPaging(acc);
	}

	@Override
	public int selectTotalCount(AccommodationVO acc) {
		return accMapper.selectTotalCount(acc);
	}

	/**
	 *	<p> 숙소 보유 시설 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public AccFacilityVO getAccFacility(int accNo) {
		return accMapper.getAccFacility(accNo);
	}

	/**
	 *	<p> 숙소 판매자 정보 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public CompanyVO getSellerStatsByAccNo(int compNo) {
		return accMapper.getSellerStatsByProdNo(compNo);
	}

	/**
	 *	<p> 숙소 상세 타입 가져오기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public RoomTypeVO getRoomTypeDetail(int roomTypeNo) {
		return accMapper.getRoomTypeDetail(roomTypeNo);
	}

	/**
	 *	<p> 목적지로 검색하기 </p>
	 *	@date 2026.01.18
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public List<Map<String, Object>> searchLocation(String keyword) {
		return accMapper.searchLocation(keyword);
	}

}
