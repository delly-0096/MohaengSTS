package kr.or.ddit.mohaeng.community.travellog.region.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.travellog.region.service.IRegionService;
import kr.or.ddit.mohaeng.vo.RegionVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/regions")
public class RegionApiController {

	private final IRegionService regionService;

	@GetMapping
	public List<RegionVO> search(@RequestParam(name = "keyword", required = false) String keyword,
			@RequestParam(name = "size", defaultValue = "10") int size) {
		return regionService.searchRegions(keyword, size);
	}
}
