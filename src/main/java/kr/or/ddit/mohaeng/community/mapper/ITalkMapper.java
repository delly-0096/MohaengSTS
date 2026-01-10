package kr.or.ddit.mohaeng.community.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.BoardVO;

@Mapper
public interface ITalkMapper {

 public	int incrementHit(int boardNo);

 public BoardVO selectTalk(int boardNo);
 
 public int insertTalk(BoardVO board);
 
 public int updateTalk(BoardVO boardNo);
 
 public int deleteTalk(int boardNo);

 public BoardVO selectTalkList(int boardNo);
 
 

}
