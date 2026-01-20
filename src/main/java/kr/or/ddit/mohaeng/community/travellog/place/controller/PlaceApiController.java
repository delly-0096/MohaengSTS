package kr.or.ddit.mohaeng.community.travellog.place.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.travellog.place.dto.PlaceSearchRes;
import kr.or.ddit.mohaeng.community.travellog.place.service.IPlaceService;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class PlaceApiController {

    private final IPlaceService placeService;

    // ✅ 프론트에서 호출하는 URL과 맞춤:
    // GET /api/community/travel-log/places?keyword=...&rgnNo=...&size=20
    @GetMapping("/api/community/travel-log/places")
    public List<PlaceSearchRes> searchPlaces(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String rgnNo,
            @RequestParam(required = false, defaultValue = "20") Integer size
    ) {
        return placeService.searchPlaces(keyword, rgnNo, size);
    }
}
