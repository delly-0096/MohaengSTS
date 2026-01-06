package kr.or.ddit.mohaeng.tripschedule.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.util.Params;

public interface ITripScheduleService {

	public List<Map<String, Object>> selectRegionList();

	public List<Map<String, Object>> selectPopRegionList();

	public List<Map<String, Object>> selectTourPlaceList();

	public Params searchRegion(Params params);

	public void mergeSearchTourPlace(List<Map<String, String>> dataList);

	public Params contentIdCheck(Params params);

	public TourPlaceVO searchPlaceDetail(TourPlaceVO tourPlaceVO);

	public int saveTourPlacInfo(TourPlaceVO tourPlaceVO);
	
}
