package kr.or.ddit.mohaeng.community.travellog.likes.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.likes.mapper.ILikesMapper;
import kr.or.ddit.mohaeng.vo.LikesStatusVO;

@Service
public class LikesServiceImpl implements ILikesService {

    private final ILikesMapper likesMapper;

    public LikesServiceImpl(ILikesMapper likesMapper) {
        this.likesMapper = likesMapper;
    }

    @Override
    @Transactional
    public LikesStatusVO toggleTripRecordLike(Long memNo, Long rcdNo) {
        if (memNo == null) throw new IllegalArgumentException("memNo is null");
        if (rcdNo == null) throw new IllegalArgumentException("rcdNo is null");

        int exists = likesMapper.existsTripRecordLike(memNo, rcdNo);
        if (exists > 0) {
            likesMapper.deleteTripRecordLike(memNo, rcdNo);
        } else {
            likesMapper.insertTripRecordLike(memNo, rcdNo);
        }

        boolean liked = likesMapper.existsTripRecordLike(memNo, rcdNo) > 0;
        long likeCount = likesMapper.countTripRecordLikes(rcdNo);

        return new LikesStatusVO(liked, likeCount);
    }

    @Override
    public LikesStatusVO getTripRecordLikeStatus(Long memNo, Long rcdNo) {
        if (memNo == null) throw new IllegalArgumentException("memNo is null");
        if (rcdNo == null) throw new IllegalArgumentException("rcdNo is null");

        boolean liked = likesMapper.existsTripRecordLike(memNo, rcdNo) > 0;
        long likeCount = likesMapper.countTripRecordLikes(rcdNo);

        return new LikesStatusVO(liked, likeCount);
    }

    @Override
    public long countTripRecordLikes(Long rcdNo) {
        if (rcdNo == null) throw new IllegalArgumentException("rcdNo is null");
        return likesMapper.countTripRecordLikes(rcdNo);
    }
}
