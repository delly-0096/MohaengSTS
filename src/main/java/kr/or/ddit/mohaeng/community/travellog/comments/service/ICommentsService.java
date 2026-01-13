package kr.or.ddit.mohaeng.community.travellog.comments.service;

import java.util.List;

import kr.or.ddit.mohaeng.vo.CommentItemVO;

public interface ICommentsService {
    List<CommentItemVO> list(long rcdNo);
    void create(long rcdNo, long writerNo, String content, Long parentCmntNo);
    boolean delete(long cmntNo, long writerNo);
}
