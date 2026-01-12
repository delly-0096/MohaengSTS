package kr.or.ddit.mohaeng.tour.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.tour.vo.SearchLogVO;

@Mapper
public interface ISearchLogMapper {
	// 검색 로그 저장
    public void insertSearchLog(SearchLogVO vo);
    // 인기 키워드 조회
    public List<SearchLogVO> getKeywords(@Param("days") int days, @Param("limit") int limit);
}
