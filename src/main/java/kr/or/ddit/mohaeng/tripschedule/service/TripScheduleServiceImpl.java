package kr.or.ddit.mohaeng.tripschedule.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.tripschedule.mapper.ITripScheduleMapper;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.util.Params;

@Service
public class TripScheduleServiceImpl implements ITripScheduleService {
	
	@Autowired
	ITripScheduleMapper iTripScheduleMapper;
	
	@Override
	public List<Map<String, Object>> selectRegionList() {
		return iTripScheduleMapper.selectRegionList();
	}
	
	@Override
	public List<Map<String, Object>> selectPopRegionList() {
		return iTripScheduleMapper.selectPopRegionList();
	}

	@Override
	public List<Map<String, Object>> selectTourPlaceList() {
		return iTripScheduleMapper.selectTourPlaceList();
	}

	@Override
	public Params searchRegion(Params params) {
		return iTripScheduleMapper.searchRegion(params);
	}
	
	@Async("asyncTaskExecutor")
	@Override
	public void mergeSearchTourPlace(List<Map<String, String>> dataList) {

		List<TourPlaceVO> tourPlaceList = new ArrayList<>();
		for(Map<String, String> tourPlace : dataList) {
			int contentid = Integer.parseInt(tourPlace.get("contentid"));
			int areacode = Integer.parseInt(tourPlace.get("areacode"));
			String contenttypeid = tourPlace.get("contenttypeid");
			String title = tourPlace.get("title");
			String zip = tourPlace.get("zipcode");
			String addr1 = tourPlace.get("addr1");
			String addr2 = tourPlace.get("addr2");
			String mapy = tourPlace.get("mapy");
			String mapx = tourPlace.get("mapx");
			String defaultImg = tourPlace.get("firstimage2");
			
			TourPlaceVO tourPlaceVO = new TourPlaceVO(contentid, areacode, contenttypeid, title, zip, addr1, addr2
					, mapy, mapx, "0", defaultImg);
			tourPlaceList.add(tourPlaceVO);
		}
		
		iTripScheduleMapper.mergeSearchTourPlace(tourPlaceList);
	}
	
	

}
