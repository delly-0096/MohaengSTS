package kr.or.ddit.mohaeng.community.travellog.bookmark.service;

import kr.or.ddit.mohaeng.vo.BookmarkStatusVO;
import kr.or.ddit.mohaeng.vo.BookmarkMyListItemVO;

import java.util.List;

public interface IBookmarkService {

    // 토글: 없으면 insert, 있으면(DEL_YN=N) 삭제, 있으면(DEL_YN=Y) 복구
    BookmarkStatusVO toggleTripRecordBookmark(Long memNo, Long rcdNo);

    // 상태 조회(상세에서 isBookmarked 용)
    BookmarkStatusVO getTripRecordBookmarkStatus(Long memNo, Long rcdNo);

    // 내 북마크 목록
    MyBookmarkPageResult listMyTripRecordBookmarks(Long memNo, int page, int size);

    // 내 목록 응답 DTO (VO 규칙상 vo 패키지에 안 두고 service 내부 static 사용)
    class MyBookmarkPageResult {
        public int page;
        public int size;
        public int totalCount;
        public List<BookmarkMyListItemVO> list;

        public MyBookmarkPageResult(int page, int size, int totalCount, List<BookmarkMyListItemVO> list) {
            this.page = page;
            this.size = size;
            this.totalCount = totalCount;
            this.list = list;
        }
    }
}
