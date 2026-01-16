package kr.or.ddit.mohaeng.community.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.CommentVO;

@Mapper
public interface ICommentMapper {
    List<CommentVO> selectTalkCommentTree(int boardNo);

    int countValidParentInSameBoard(Map<String, Object> param);

    int insertTalkComment(CommentVO vo);

	int updateTalkComment(CommentVO vo);

	int deleteTalkComment(int cmntNo);

	int countValidParentInSameBoard(Integer parentCmntNo, int boardNo);
}
