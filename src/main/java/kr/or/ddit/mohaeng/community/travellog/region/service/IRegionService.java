package kr.or.ddit.mohaeng.community.travellog.region.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.RegionVO;

public interface IRegionService {
    List<RegionVO> searchRegions(String keyword, int size);
}
