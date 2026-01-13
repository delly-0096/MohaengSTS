package kr.or.ddit.mohaeng.community.travellog.bookmark.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.bookmark.mapper.IBookmarkMapper;
import kr.or.ddit.mohaeng.vo.BookmarkStatusVO;
import kr.or.ddit.mohaeng.vo.BookmarkVO;
import kr.or.ddit.mohaeng.vo.BookmarkMyListItemVO;

import java.util.List;

@Service
public class BookmarkServiceImpl implements IBookmarkService {

    private static final String BMK_TYPE_TRIP_RECORD = "TRIP_RECORD";

    private final IBookmarkMapper bookmarkMapper;

    public BookmarkServiceImpl(IBookmarkMapper bookmarkMapper) {
        this.bookmarkMapper = bookmarkMapper;
    }

    @Override
    @Transactional
    public BookmarkStatusVO toggleTripRecordBookmark(Long memNo, Long rcdNo) {
        BookmarkVO existing = bookmarkMapper.selectOneByUserAndTarget(memNo, BMK_TYPE_TRIP_RECORD, rcdNo);

        boolean bookmarked;
        if (existing == null) {
            // 신규 insert
            bookmarkMapper.insertBookmark(memNo, BMK_TYPE_TRIP_RECORD, rcdNo);
            bookmarked = true;
        } else {
            String delYn = existing.getDelYn();
            if ("Y".equalsIgnoreCase(delYn)) {
                // 복구
                bookmarkMapper.restoreBookmark(existing.getBmkNo());
                bookmarked = true;
            } else {
                // 소프트 삭제
                bookmarkMapper.softDeleteBookmark(existing.getBmkNo());
                bookmarked = false;
            }
        }

        int count = bookmarkMapper.countByTarget(BMK_TYPE_TRIP_RECORD, rcdNo);
        return new BookmarkStatusVO(rcdNo, bookmarked, count);
    }

    @Override
    public BookmarkStatusVO getTripRecordBookmarkStatus(Long memNo, Long rcdNo) {
        BookmarkVO existing = bookmarkMapper.selectOneByUserAndTarget(memNo, BMK_TYPE_TRIP_RECORD, rcdNo);
        boolean bookmarked = (existing != null && !"Y".equalsIgnoreCase(existing.getDelYn()));
        int count = bookmarkMapper.countByTarget(BMK_TYPE_TRIP_RECORD, rcdNo);
        return new BookmarkStatusVO(rcdNo, bookmarked, count);
    }

    @Override
    public MyBookmarkPageResult listMyTripRecordBookmarks(Long memNo, int page, int size) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(size, 1);
        int offset = (safePage - 1) * safeSize;

        int total = bookmarkMapper.countMyBookmarks(memNo, BMK_TYPE_TRIP_RECORD);
        List<BookmarkMyListItemVO> list = bookmarkMapper.selectMyBookmarksPaged(memNo, BMK_TYPE_TRIP_RECORD, offset, safeSize);

        return new MyBookmarkPageResult(safePage, safeSize, total, list);
    }
}
