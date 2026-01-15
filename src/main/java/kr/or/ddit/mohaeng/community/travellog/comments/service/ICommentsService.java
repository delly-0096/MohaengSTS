package kr.or.ddit.mohaeng.community.travellog.comments.service;

import java.util.List;
import kr.or.ddit.mohaeng.vo.CommentsVO;

public interface ICommentsService {

    List<CommentsVO> list(String targetType, Long targetNo, Long loginMemberNo);

    int write(String targetType, Long targetNo, Long writerNo, String content, Long parentCmntNo);

    boolean update(Long cmntNo, Long writerNo, String content);

    boolean delete(Long cmntNo, Long writerNo);
}
