package kr.or.ddit.mohaeng.mypage.bookmarks.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface IBookMarkMapper {
	public List<BookmarkVO> selectBookMarkList();
	public int selectBookMarkCount(PaginationInfoVO<BookmarkVO> pagingVO);
	public List<BookmarkVO> selectBookMarkList(PaginationInfoVO<BookmarkVO> pagingVO);
	public Map<String, Object> selectBookmarkStats(int memNo);
	public int deleteBookmarks(@Param("memNo") int memNo, @Param("bmkNos") List<Integer> bmkNos);
}
