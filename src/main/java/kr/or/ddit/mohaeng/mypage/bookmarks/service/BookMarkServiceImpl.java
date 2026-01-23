package kr.or.ddit.mohaeng.mypage.bookmarks.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.bookmarks.mapper.IBookMarkMapper;
import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BookMarkServiceImpl implements IBookMarkService {

	@Autowired
	private IBookMarkMapper bookMarkMapper;

	@Override
	public List<BookmarkVO> selectBookMarkList() {
		return bookMarkMapper.selectBookMarkList();
	}

	@Override
	public int selectBookMarkCount(PaginationInfoVO<BookmarkVO> pagingVO) {
		return bookMarkMapper.selectBookMarkCount(pagingVO);
	}

	@Override
	public List<BookmarkVO> selectBookMarkList(PaginationInfoVO<BookmarkVO> pagingVO) {
		List<BookmarkVO> bookMarkList = bookMarkMapper.selectBookMarkList(pagingVO);
		log.debug("지수 체킁: {}",bookMarkList);
		return bookMarkList;
	}

	@Override
	public Map<String, Object> selectBookmarkStats(int memNo) {
		return bookMarkMapper.selectBookmarkStats(memNo);
	}

	@Override
	public int deleteBookmarks(int memNo, List<Integer> bmkNos) {
		return bookMarkMapper.deleteBookmarks(memNo, bmkNos);
	}

}
