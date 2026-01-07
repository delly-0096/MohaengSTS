package kr.or.ddit.mohaeng.tripschedule.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

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

}
