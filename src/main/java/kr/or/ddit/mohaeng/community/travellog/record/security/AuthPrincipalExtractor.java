package kr.or.ddit.mohaeng.community.travellog.record.security;

import org.springframework.security.core.Authentication;

public final class AuthPrincipalExtractor {
	private AuthPrincipalExtractor() {
	}

	public static Long getMemNo(Authentication authentication) {
		if (authentication == null || authentication.getPrincipal() == null)
			return null;

		Object principal = authentication.getPrincipal();

		if (principal instanceof kr.or.ddit.mohaeng.vo.CustomUser cu && cu.getMember() != null) {
			return Long.valueOf(cu.getMember().getMemNo());
		}

		if (principal instanceof kr.or.ddit.mohaeng.security.CustomUserDetails cud && cud.getMember() != null) {
			return Long.valueOf(cud.getMember().getMemNo());
		}

		return null;
	}
}
