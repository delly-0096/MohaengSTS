package kr.or.ddit.mohaeng.admin.accommodation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.accommodation.mapper.IAdminAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AdminAccommodationServiceImpl implements IAdminAccommodationService{
	
	@Autowired
	private IAdminAccommodationMapper adminAccMapper;
	
	@Override
	public void getAccommodationList(PaginationInfoVO<AccommodationVO> pagInfoVO) {
		// TODO Auto-generated method stub
		
	}

}
