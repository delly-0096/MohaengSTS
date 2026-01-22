package kr.or.ddit.mohaeng.community.travellog.place.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.community.travellog.place.dto.PlaceSearchRes;

@Mapper
public interface IPlaceMapper {
	List<PlaceSearchRes> selectPlaces(Map<String, Object> param);
}
