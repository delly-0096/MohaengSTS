package kr.or.ddit.mohaeng.accommodation.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccommodationVO;

@Service
public class AccommodationServiceImpl implements IAccommodationService{
	
	@Autowired
	private IAccommodationMapper accMapper;

	@Override
	public List<AccommodationVO> selectAccommodationList() {
		return accMapper.selectAccommodationList();
	}

}
