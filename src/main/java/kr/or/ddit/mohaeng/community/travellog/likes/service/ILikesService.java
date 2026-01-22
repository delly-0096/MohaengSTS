package kr.or.ddit.mohaeng.community.travellog.likes.service;

import org.springframework.security.core.Authentication;

public interface ILikesService {

	Long resolveMemNo(Authentication authentication);

	boolean toggleLike(Long likesKey, String likesCatCd, Long memNo);

	boolean isLiked(Long likesKey, String likesCatCd, Long memNo);

	int countLikes(Long likesKey, String likesCatCd);

}
