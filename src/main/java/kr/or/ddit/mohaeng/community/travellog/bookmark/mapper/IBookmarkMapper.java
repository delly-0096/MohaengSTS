package kr.or.ddit.mohaeng.community.travellog.bookmark.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.BookmarkMyListItemVO;
import kr.or.ddit.mohaeng.vo.BookmarkVO;

@Mapper
public interface IBookmarkMapper {

    // 1) 사용자+타겟 북마크 단건 조회 (상태/복구/중복방지)
    BookmarkVO selectOneByUserAndTarget(
            @Param("memNo") Long memNo,
            @Param("bmkType") String bmkType,
            @Param("prdtNo") Long prdtNo
    );

    // 2) 신규 등록 (SEQ_BOOKMARK 사용)
    int insertBookmark(
            @Param("memNo") Long memNo,
            @Param("bmkType") String bmkType,
            @Param("prdtNo") Long prdtNo
    );

    // 3) 복구(DEL_YN=Y → N)
    int restoreBookmark(@Param("bmkNo") Long bmkNo);

    // 4) 소프트 삭제(DEL_YN=N → Y)
    int softDeleteBookmark(@Param("bmkNo") Long bmkNo);

    // 5) 대상별 북마크 카운트
    int countByTarget(
            @Param("bmkType") String bmkType,
            @Param("prdtNo") Long prdtNo
    );

    // 6) 내 북마크 목록(페이징)
    List<BookmarkMyListItemVO> selectMyBookmarksPaged(
            @Param("memNo") Long memNo,
            @Param("bmkType") String bmkType,
            @Param("offset") int offset,
            @Param("size") int size
    );

    // 7) 내 북마크 목록 totalCount
    int countMyBookmarks(
            @Param("memNo") Long memNo,
            @Param("bmkType") String bmkType
    );
}
