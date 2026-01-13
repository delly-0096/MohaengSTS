package kr.or.ddit.mohaeng.admin.contents.tripschedule.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.util.Params;

public interface IAdminTripscheduleService {

//	public List<Map<String, Object>> selectAdminScheduleList();
	public List<Params> selectAdminScheduleList();
}
