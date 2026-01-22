package kr.or.ddit.mohaeng.community.travellog.likes.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.travellog.likes.service.ILikesService;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/community/travel-log/likes")
public class LikesApiController {

	private static final String CAT_TRIP_RECORD = "TRIP_RECORD";

	private final ILikesService likesService;

	// 좋아요 토글 (일반회원만)
	@PreAuthorize("hasAuthority('ROLE_MEMBER')")
	@PostMapping("/toggle")
	public ResponseEntity<?> toggle(@RequestBody ToggleReq req, Authentication authentication) {
		if (req == null || req.getRcdNo() == null) {
			return ResponseEntity.badRequest().body(Map.of("message", "rcdNo is required"));
		}

		Long memNo = likesService.resolveMemNo(authentication);

		boolean liked = likesService.toggleLike(req.getRcdNo(), CAT_TRIP_RECORD, memNo);
		int likeCount = likesService.countLikes(req.getRcdNo(), CAT_TRIP_RECORD);

		Map<String, Object> body = new HashMap<>();
		body.put("liked", liked);
		body.put("likeCount", likeCount);
		return ResponseEntity.ok(body);
	}

	// 초기 상태 조회(하트 채움 여부 + 총 좋아요 수)
	@GetMapping("/status")
	public ResponseEntity<?> status(@RequestParam("rcdNo") Long rcdNo, Authentication authentication) {
		int likeCount = likesService.countLikes(rcdNo, CAT_TRIP_RECORD);

		boolean liked = false;
		if (authentication != null && authentication.isAuthenticated()
				&& !"anonymousUser".equals(String.valueOf(authentication.getPrincipal()))) {
			// 로그인인데 ROLE_MEMBER가 아니면 liked는 false로만 처리(기업/관리자 등)
			if (authentication.getAuthorities().stream().anyMatch(a -> "ROLE_MEMBER".equals(a.getAuthority()))) {
				Long memNo = likesService.resolveMemNo(authentication);
				liked = likesService.isLiked(rcdNo, CAT_TRIP_RECORD, memNo);
			}
		}

		return ResponseEntity.ok(Map.of("liked", liked, "likeCount", likeCount));
	}

	// 에러를 간단히 내려주기
	@ExceptionHandler(IllegalStateException.class)
	public ResponseEntity<?> handleIllegalState(IllegalStateException e) {
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("message", e.getMessage()));
	}

	@Data
	public static class ToggleReq {
		private Long rcdNo;
	}
}
