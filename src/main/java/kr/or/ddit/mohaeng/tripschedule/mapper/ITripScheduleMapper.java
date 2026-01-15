package kr.or.ddit.mohaeng.tripschedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.tripschedule.controller.TripScheduleController.ThumbnailData;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleDetailsVO;
import kr.or.ddit.mohaeng.vo.TripSchedulePlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;
import kr.or.ddit.util.Params;

@Mapper
public interface ITripScheduleMapper {

	public List<Map<String, Object>> selectRegionList();

	public List<Map<String, Object>> selectPopRegionList();

	public List<Map<String, Object>> selectTourPlaceList();

	public Params searchRegion(Params params);

	public void mergeSearchTourPlace(List<TourPlaceVO> dataList);

	public TourPlaceVO searchPlaceDetail(TourPlaceVO tourPlaceVO);

	public int saveTourPlacInfo(TourPlaceVO tourPlaceVO);

	public int insertTripSchedule(TripScheduleVO tripScheduleVO);

	public int insertTripScheduleDetails(TripScheduleDetailsVO detailsVO);

	public int insertTripSchedulePlace(TripSchedulePlaceVO placeVO);

	public List<TripScheduleVO> selectTripScheduleList(int memNo);
	
	public TripScheduleVO selectTripSchedule(TripScheduleVO tripScheduleVO);

	public int checkBookmarkExists(Params params);

	public int deleteBookmark(Params params);

	public int insertBookmark(Params params);

	public int deleteTripSchedule(int schdlNo);

	public int updateTripSchedule(TripScheduleVO tripScheduleVO);

	public void deleteScheduleDetails(int schdlNo);

	public void deleteSchedulePlace(int schdlNo);

	public int updateScheduleThumbnail(ThumbnailData thumbnailData);

	public List<Params> tourContentList();

	public void scheduleOngoing();

	public void scheduleCompleted();

}
