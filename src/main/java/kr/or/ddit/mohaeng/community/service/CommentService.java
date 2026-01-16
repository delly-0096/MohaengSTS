package kr.or.ddit.mohaeng.community.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.mapper.ICommentMapper;
import kr.or.ddit.mohaeng.vo.CommentVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final ICommentMapper commentMapper;

    // 목록
    public List<CommentVO> getTalkComments(int boardNo) {
        return commentMapper.selectTalkCommentTree(boardNo); // #{value}로 받게 했지?
    }

    // 등록 (댓글/대댓글)
    @Transactional
    public void addTalkComment(int boardNo, int writerNo, String content, Integer parentCmntNo) {

        // 대댓글이면: 부모가 같은 게시글(TALK, boardNo)에 존재하는지 검증
        if (parentCmntNo != null && parentCmntNo != 0) {
            int cnt = commentMapper.countValidParentInSameBoard(parentCmntNo, boardNo);
            if (cnt == 0) {
                throw new IllegalArgumentException("부모 댓글이 없거나 다른 글의 댓글입니다.");
            }
        } else {
            parentCmntNo = null;
        }

        CommentVO vo = new CommentVO();
        vo.setTargetType("TALK");
        vo.setTargetNo(boardNo);
        vo.setWriterNo(writerNo);
        vo.setParentCmntNo(parentCmntNo);
        vo.setCmntContent(content);

        commentMapper.insertTalkComment(vo);
    }

    @Transactional
    public int updateTalkComment(CommentVO vo) {
        return commentMapper.updateTalkComment(vo);
    }

    @Transactional
    public int deleteTalkComment(int cmntNo) {
        return commentMapper.deleteTalkComment(cmntNo);
    }
}
