package kr.or.ddit.mohaeng.accommodation.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;

@Service
public class AccommodationServiceImpl implements IAccommodationService{
	
	@Autowired
	private IAccommodationMapper accMapper;

}
