package kr.or.ddit.mohaeng.admin.contents.tripschedule.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.admin.contents.tripschedule.mapper.IAdminTripscheduleMapper;
import kr.or.ddit.util.Params;

@Service
public class AdminTripscheduleServiceImpl implements IAdminTripscheduleService{
	
	@Autowired
	IAdminTripscheduleMapper tripscheduleMapper;
	
	@Override
	public List<Params> selectAdminScheduleList() {
		return tripscheduleMapper.selectAdminScheduleList();
	}
	
}
