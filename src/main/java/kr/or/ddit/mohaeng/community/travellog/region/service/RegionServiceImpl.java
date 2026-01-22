package kr.or.ddit.mohaeng.community.travellog.region.service;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.community.travellog.region.mapper.IRegionMapper;
import kr.or.ddit.mohaeng.vo.RegionVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegionServiceImpl implements IRegionService {

	private final IRegionMapper regionMapper;

	@Override
	public List<RegionVO> searchRegions(String keyword, int size) {

		// keyword 비면: 전체 리턴 
		if (keyword == null || keyword.trim().isEmpty()) {
			// size는 XML에서 keyword가 비었을 때 FETCH를 안 걸면 무시됨
			return regionMapper.selectRegionAutoComplete("", 0);
		}

		String k = keyword.trim();

		// 1글자부터 검색 허용
		if (k.length() < 1)
			return Collections.emptyList();

		int safeSize = Math.max(1, Math.min(size, 20)); // 1~20 제한
		return regionMapper.selectRegionAutoComplete(k, safeSize);
	}

}
