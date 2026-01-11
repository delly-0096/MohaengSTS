package kr.or.ddit.mohaeng.community.travellog.comments.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.comments.mapper.ICommentsMapper;
import kr.or.ddit.mohaeng.vo.CommentItemVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentsServiceImpl implements ICommentsService {

    private final ICommentsMapper mapper;

    @Override
    public List<CommentItemVO> list(long rcdNo) {
        return mapper.selectTripRecordComments(rcdNo);
    }

    @Override
    @Transactional
    public void create(long rcdNo, long writerNo, String content, Long parentCmntNo) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("댓글 내용이 비어있습니다.");
        }
        mapper.insertTripRecordComment(rcdNo, writerNo, parentCmntNo, content.trim());
    }

    @Override
    @Transactional
    public boolean delete(long cmntNo, long writerNo) {
        return mapper.softDeleteTripRecordComment(cmntNo, writerNo) > 0;
    }
}
