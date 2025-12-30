package kr.or.ddit.mohaeng.tripschedule.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tripschedule.mapper.ITripScheduleMapper;
import kr.or.ddit.util.Params;

@Service
public class TripScheduleServiceImpl implements ITripScheduleService {
	
	@Autowired
	ITripScheduleMapper iTripScheduleMapper;
	
	@Override
	public List<Params> selectRegionList() {
		return iTripScheduleMapper.selectRegionList();
	}
	
	@Override
	public List selectPopRegionList() {
		return iTripScheduleMapper.selectPopRegionList();
	}
	
	

}
