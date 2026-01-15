package kr.or.ddit.mohaeng.tripschedule.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.tripschedule.controller.TripScheduleController.ThumbnailData;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripSchedulePlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;
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

	public int insertTripSchedule(Params params);

	public int insertTripScheduleDetails(Map<String, Object> plannerDay);

	public int insertTripSchedulePlace(TripSchedulePlaceVO placeVO);

	public List<TripScheduleVO> selectTripScheduleList(int memNo);

	public boolean toggleBookmark(Params params);

	public TripScheduleVO selectTripSchedule(TripScheduleVO params);

	public int deleteTripSchedule(int schdlNo);
	
	public void refreshScheduleStates();

	public int updateTripSchedule(Params params);

	public int updateScheduleThumbnail(ThumbnailData thumbnailData);

	public List<Params> tourContentList();

	public void updateTripScheduleState();
}
