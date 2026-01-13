package kr.or.ddit.mohaeng.community.travellog.comments.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.CommentItemVO;

@Mapper
public interface ICommentsMapper {

    List<CommentItemVO> selectTripRecordComments(@Param("rcdNo") long rcdNo);

    int insertTripRecordComment(
            @Param("rcdNo") long rcdNo,
            @Param("writerNo") long writerNo,
            @Param("parentCmntNo") Long parentCmntNo,
            @Param("content") String content
    );

    // 작성자만 삭제 가능하게 where writerNo 걸어둠
    int softDeleteTripRecordComment(
            @Param("cmntNo") long cmntNo,
            @Param("writerNo") long writerNo
    );
}
