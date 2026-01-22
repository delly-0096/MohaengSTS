package kr.or.ddit.mohaeng.community.travellog.place.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.community.travellog.place.dto.PlaceSearchRes;
import kr.or.ddit.mohaeng.community.travellog.place.mapper.IPlaceMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements IPlaceService {

	private final IPlaceMapper mapper;

	@Override
	public List<PlaceSearchRes> searchPlaces(String keyword, String rgnNo, Integer size) {
		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword == null ? "" : keyword.trim());
		param.put("rgnNo", (rgnNo == null || rgnNo.isBlank()) ? null : rgnNo.trim());
		param.put("size", (size == null || size <= 0) ? 20 : size);

		return mapper.selectPlaces(param);
	}
}
