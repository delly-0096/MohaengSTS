package kr.or.ddit.mohaeng.admin.contents.tripschedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.util.Params;

@Mapper
public interface IAdminTripscheduleMapper {

	public List<Params> selectAdminScheduleList();
	
}
