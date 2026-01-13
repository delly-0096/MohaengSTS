package kr.or.ddit.mohaeng.community.travellog.likes.service;

import kr.or.ddit.mohaeng.vo.LikesStatusVO;

public interface ILikesService {

    LikesStatusVO toggleTripRecordLike(Long memNo, Long rcdNo);

    LikesStatusVO getTripRecordLikeStatus(Long memNo, Long rcdNo);

    long countTripRecordLikes(Long rcdNo);
}
