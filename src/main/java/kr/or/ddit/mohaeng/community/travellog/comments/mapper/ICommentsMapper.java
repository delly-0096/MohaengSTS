package kr.or.ddit.mohaeng.community.travellog.comments.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.mohaeng.vo.CommentsVO;

@Mapper
public interface ICommentsMapper {

    List<CommentsVO> selectCommentsByTarget(
        @Param("targetType") String targetType,
        @Param("targetNo") Long targetNo,
        @Param("loginMemberNo") Long loginMemberNo
    );

    int insertComment(CommentsVO vo);

    int updateCommentContent(
        @Param("cmntNo") Long cmntNo,
        @Param("writerNo") Long writerNo,
        @Param("content") String content
    );

    int softDeleteComment(
        @Param("cmntNo") Long cmntNo,
        @Param("writerNo") Long writerNo
    );

    int countByTarget(
        @Param("targetType") String targetType,
        @Param("targetNo") Long targetNo
    );

}
