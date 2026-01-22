package kr.or.ddit.mohaeng.community.travellog.likes.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ILikesMapper {

	// fallback: memId(username)로 memNo 조회
	Long selectMemNoByMemId(@Param("memId") String memId);

	int existsLike(@Param("likesKey") Long likesKey, @Param("likesCatCd") String likesCatCd,
			@Param("memNo") Long memNo);

	int insertLike(@Param("likesKey") Long likesKey, @Param("likesCatCd") String likesCatCd,
			@Param("memNo") Long memNo);

	int deleteLike(@Param("likesKey") Long likesKey, @Param("likesCatCd") String likesCatCd,
			@Param("memNo") Long memNo);

	int countLikes(@Param("likesKey") Long likesKey, @Param("likesCatCd") String likesCatCd);
}
