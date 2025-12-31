package kr.or.ddit.mohaeng.tripschedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.util.Params;

@Mapper
public interface ITripScheduleMapper {

	public List<Map<String, Object>> selectRegionList();

	public List<Map<String, Object>> selectPopRegionList();

	public List<Map<String, Object>> selectTourPlaceList();

	public Params searchRegion(Params params);

}
