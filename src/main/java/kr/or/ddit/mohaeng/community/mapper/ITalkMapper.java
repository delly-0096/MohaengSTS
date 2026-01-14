package kr.or.ddit.mohaeng.community.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.BoardFileVO;
import kr.or.ddit.mohaeng.vo.BoardTagVO;
import kr.or.ddit.mohaeng.vo.BoardVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Mapper
public interface ITalkMapper {

 public	int incrementHit(int boardNo);

 public BoardVO selectTalk(int boardNo);
 
 public int insertTalk(BoardVO boardNo);
 
 public int updateTalk(BoardVO boardNo);
 
 public int deleteTalk(int boardNo);

 public List<BoardVO> selectTalkList(PaginationInfoVO<BoardVO> pagingVO);
 
 public BoardFileVO getFileInfo(int fileNo);

 public List<BoardFileVO> selectNoticeFileList(int attachNo);

 public int selectTalkCount(PaginationInfoVO<BoardVO> pagingVO);

	/* public List<BoardVO> selectBoardList(PaginationInfoVO<BoardVO> pagingVO); */

 public int insertTalkTags(@Param("list") List<BoardTagVO> tagList);

 public int deleteTalkTags(int boardNo);
 


}
