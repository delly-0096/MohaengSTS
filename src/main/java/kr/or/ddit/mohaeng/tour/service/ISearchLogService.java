package kr.or.ddit.mohaeng.tour.service;

import java.util.List;

import kr.or.ddit.mohaeng.tour.vo.SearchLogVO;

public interface ISearchLogService {
	public List<SearchLogVO> getKeywords();
	public void insertSearchLog(SearchLogVO logVO);
}
