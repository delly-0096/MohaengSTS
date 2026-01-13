package kr.or.ddit.mohaeng.community.travellog.likes.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.community.travellog.likes.service.ILikesService;
import kr.or.ddit.mohaeng.vo.LikesStatusVO;

@RestController
@RequestMapping("/api/community/travel-log/likes")
public class LikesApiController {

    private final ILikesService likesService;

    public LikesApiController(ILikesService likesService) {
        this.likesService = likesService;
    }

    // 1) 토글 (일반회원만)
    @PreAuthorize("hasRole('ROLE_MEMBER')")
    @PostMapping("/toggle")
    public ResponseEntity<LikesStatusVO> toggle(@RequestBody ToggleReq req, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        LikesStatusVO res = likesService.toggleTripRecordLike(memNo, req.getRcdNo());
        return ResponseEntity.ok(res);
    }

    // 2) 상태 조회 (상세에서 isLiked + likeCount)
    @PreAuthorize("hasRole('ROLE_MEMBER')")
    @GetMapping("/status")
    public ResponseEntity<LikesStatusVO> status(@RequestParam("rcdNo") Long rcdNo, Authentication authentication) {
        Long memNo = extractMemNo(authentication);
        LikesStatusVO res = likesService.getTripRecordLikeStatus(memNo, rcdNo);
        return ResponseEntity.ok(res);
    }

    // 3) 카운트만 (목록/집계용으로 필요하면 사용)
    @GetMapping("/count")
    public ResponseEntity<Long> count(@RequestParam("rcdNo") Long rcdNo) {
        return ResponseEntity.ok(likesService.countTripRecordLikes(rcdNo));
    }

    // ===== 요청 DTO =====
    public static class ToggleReq {
        private Long rcdNo;
        public Long getRcdNo() { return rcdNo; }
        public void setRcdNo(Long rcdNo) { this.rcdNo = rcdNo; }
    }

    // ===== 로그인 사용자 memNo 추출 (SecurityUserUtil 제거 버전) =====
    private Long extractMemNo(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) {
            throw new IllegalStateException("인증 정보가 없습니다.");
        }

        Object principal = authentication.getPrincipal();

        // 1) 프로젝트에서 사용하는 CustomUser 우선
        try {
            if (principal instanceof kr.or.ddit.mohaeng.vo.CustomUser customUser) {
                Object memNoObj = customUser.getMember().getMemNo();
                return ((Number) memNoObj).longValue(); // int/long 모두 안전 처리
            }
        } catch (Throwable ignored) {}

        // 2) 혹시 CustomUserDetails를 쓰는 경우 대비
        try {
            if (principal instanceof kr.or.ddit.mohaeng.security.CustomUserDetails cud) {
                Object memNoObj = cud.getMember().getMemNo();
                return ((Number) memNoObj).longValue();
            }
        } catch (Throwable ignored) {}

        throw new IllegalStateException("principal에서 memNo를 추출할 수 없습니다. principal 타입: " + principal.getClass());
    }
}
