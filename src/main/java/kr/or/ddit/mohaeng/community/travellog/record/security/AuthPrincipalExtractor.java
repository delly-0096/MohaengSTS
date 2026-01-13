package kr.or.ddit.mohaeng.community.travellog.record.security;

import org.springframework.security.core.Authentication;

public final class AuthPrincipalExtractor {
    private AuthPrincipalExtractor() {}

    public static Long getMemNo(Authentication authentication) {
        if (authentication == null || authentication.getPrincipal() == null) return null;

        Object principal = authentication.getPrincipal();

        // 1) 팀 프로젝트 principal: kr.or.ddit.mohaeng.vo.CustomUser
        if (principal instanceof kr.or.ddit.mohaeng.vo.CustomUser cu && cu.getMember() != null) {
            // memNo가 int라면 Long으로 변환
            return Long.valueOf(cu.getMember().getMemNo());
        }

        // 2) 다른 principal 타입 (예: CustomUserDetails 등)
        if (principal instanceof kr.or.ddit.mohaeng.security.CustomUserDetails cud && cud.getMember() != null) {
            return Long.valueOf(cud.getMember().getMemNo());
        }

        return null;
    }
}
