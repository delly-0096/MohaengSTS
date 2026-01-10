package kr.or.ddit.mohaeng.community.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface ITalkService {

	public List<BoardVO> selectTalkList();

	public static int selectBoardCount(PaginationInfoVO<BoardVO> pagingVO) {
		
		return 0;
	}

	public static List<BoardVO> selectNoticeList(PaginationInfoVO<BoardVO> pagingVO) {
		
		return null;
	}
		

}
