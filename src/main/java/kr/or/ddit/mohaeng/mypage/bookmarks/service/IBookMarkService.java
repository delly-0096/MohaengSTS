package kr.or.ddit.mohaeng.mypage.bookmarks.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IBookMarkService {
	// 일반적인 목록 조회시
	public List<BookmarkVO> selectBookMarkList();

	// 페이징VO를 활용한 목록 조회시
	public int selectBookMarkCount(PaginationInfoVO<BookmarkVO> pagingVO);
	public List<BookmarkVO> selectBookMarkList(PaginationInfoVO<BookmarkVO> pagingVO);
	
	public Map<String, Object> selectBookmarkStats(int memNo);
}
