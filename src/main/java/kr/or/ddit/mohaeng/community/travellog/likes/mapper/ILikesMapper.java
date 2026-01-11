package kr.or.ddit.mohaeng.community.travellog.likes.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ILikesMapper {

    int existsTripRecordLike(@Param("memNo") Long memNo, @Param("rcdNo") Long rcdNo);

    int insertTripRecordLike(@Param("memNo") Long memNo, @Param("rcdNo") Long rcdNo);

    int deleteTripRecordLike(@Param("memNo") Long memNo, @Param("rcdNo") Long rcdNo);

    long countTripRecordLikes(@Param("rcdNo") Long rcdNo);
}
