package kr.or.ddit.mohaeng.community.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.vo.BoardFileVO;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.LikesVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface ITalkService {

	//페이징이용
	/* public int selectBoardCount(PaginationInfoVO<BoardVO> pagingVO); */

	public int selectTalkCount(PaginationInfoVO<BoardVO> pagingVO);

	public List<BoardVO> selectTalkList(PaginationInfoVO<BoardVO> pagingVO);
	
	public BoardVO selectTalk(int boardNo);

	public BoardVO selectBoard(int boardNo);
	
	public ServiceResult insertTalk(BoardVO vo);

	public int updateTalk(BoardVO vo);

	public int deleteTalk(int boardNo);

	public BoardFileVO getFileInfo(int fileNo);

	public int saveFileList(List<MultipartFile> boardFile, Map<String, String> uploadInfo, int int1);

	public ServiceResult toggleLike(LikesVO likesVO);
		

}
