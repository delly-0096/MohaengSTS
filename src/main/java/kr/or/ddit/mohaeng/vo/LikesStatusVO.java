package kr.or.ddit.mohaeng.vo;

public class LikesStatusVO {
    private boolean liked;     // isLiked
    private long likeCount;

    public LikesStatusVO() {}

    public LikesStatusVO(boolean liked, long likeCount) {
        this.liked = liked;
        this.likeCount = likeCount;
    }

    public boolean isLiked() {
        return liked;
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
    }

    public long getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(long likeCount) {
        this.likeCount = likeCount;
    }
}
