package kr.or.ddit.mohaeng.community.travellog.place.service;

import java.util.List;

import kr.or.ddit.mohaeng.community.travellog.place.dto.PlaceSearchRes;

public interface IPlaceService {
    List<PlaceSearchRes> searchPlaces(String keyword, String rgnNo, Integer size);
}
