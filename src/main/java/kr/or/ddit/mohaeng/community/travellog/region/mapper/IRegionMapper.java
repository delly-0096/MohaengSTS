package kr.or.ddit.mohaeng.community.travellog.region.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.RegionVO;

@Mapper
public interface IRegionMapper {

    // 자동완성 검색 (RGN_NM 기준)
    List<RegionVO> selectRegionAutoComplete(
            @Param("keyword") String keyword,
            @Param("size") int size
    );
}
