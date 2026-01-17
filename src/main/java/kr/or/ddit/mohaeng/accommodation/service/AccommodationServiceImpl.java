package kr.or.ddit.mohaeng.accommodation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;

@Service
public class AccommodationServiceImpl implements IAccommodationService{
	
	@Autowired
	private IAccommodationMapper accMapper;

	@Override
	public List<AccommodationVO> selectAccommodationList(String areaCode) {
		return accMapper.selectAccommodationList();
	}

	@Override
	public AccommodationVO getAccommodationDetail(int accNo) {
		return accMapper.getAccommodationDetail(accNo);
	}

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

}
