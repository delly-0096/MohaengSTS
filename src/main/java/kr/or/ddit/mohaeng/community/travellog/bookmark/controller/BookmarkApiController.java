package kr.or.ddit.mohaeng.community.travellog.bookmark.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.community.travellog.bookmark.service.IBookmarkService;
import kr.or.ddit.mohaeng.vo.BookmarkStatusVO;

@RestController
@RequestMapping("/api/community/travel-log/bookmarks")
public class BookmarkApiController {

    private final IBookmarkService bookmarkService;

    public BookmarkApiController(IBookmarkService bookmarkService) {
        this.bookmarkService = bookmarkService;
    }

    // 1) 토글
    @PreAuthorize("hasAuthority('MEMBER')")
    @PostMapping("/toggle")
    public ResponseEntity<BookmarkStatusVO> toggle(@RequestBody ToggleReq req, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        BookmarkStatusVO res = bookmarkService.toggleTripRecordBookmark(memNo, req.getRcdNo());
        return ResponseEntity.ok(res);
    }

    // 2) 상태 조회(상세용 isBookmarked)
    @PreAuthorize("hasAuthority('MEMBER')")
    @GetMapping("/status")
    public ResponseEntity<BookmarkStatusVO> status(@RequestParam("rcdNo") Long rcdNo, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        BookmarkStatusVO res = bookmarkService.getTripRecordBookmarkStatus(memNo, rcdNo);
        return ResponseEntity.ok(res);
    }

    // 3) 내 북마크 목록
    @PreAuthorize("hasAuthority('MEMBER')")
    @GetMapping("/my")
    public ResponseEntity<IBookmarkService.MyBookmarkPageResult> my(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Authentication authentication
    ) {
        Long memNo = extractMemNo(authentication);
        return ResponseEntity.ok(bookmarkService.listMyTripRecordBookmarks(memNo, page, size));
    }

    // ===== 요청 DTO =====
    public static class ToggleReq {
        private Long rcdNo;
        public Long getRcdNo() { return rcdNo; }
        public void setRcdNo(Long rcdNo) { this.rcdNo = rcdNo; }
    }

    // ===== 로그인 사용자 memNo 추출(유틸 제거) =====
    private Long extractMemNo(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            throw new IllegalStateException("인증 정보가 없습니다.");
        }

        Object principal = authentication.getPrincipal();

        // 1) 프로젝트에서 사용하는 CustomUser 우선
        try {
            // kr.or.ddit.mohaeng.vo.CustomUser (사용자님 코드에 등장)
            if (principal instanceof kr.or.ddit.mohaeng.vo.CustomUser customUser) {
            	return (long) customUser.getMember().getMemNo();
            }
        } catch (Throwable ignored) {}

        // 2) 혹시 CustomUserDetails를 쓰는 경우 대비
        try {
            if (principal instanceof kr.or.ddit.mohaeng.security.CustomUserDetails cud) {
            	return (long) cud.getMember().getMemNo();
            }
        } catch (Throwable ignored) {}

        throw new IllegalStateException("principal에서 memNo를 추출할 수 없습니다. principal 타입: " + principal.getClass());
    }
}
