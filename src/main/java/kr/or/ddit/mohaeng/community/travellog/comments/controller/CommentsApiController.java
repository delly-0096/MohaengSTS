package kr.or.ddit.mohaeng.community.travellog.comments.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.travellog.comments.service.ICommentsService;
import kr.or.ddit.mohaeng.community.travellog.likes.service.ILikesService;
import kr.or.ddit.mohaeng.vo.CommentsVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/community/travel-log")
public class CommentsApiController {

	private final ICommentsService service;
	private final ILikesService likesService;

	private Long getLoginMemberNo(Authentication auth) {
		if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(String.valueOf(auth.getPrincipal()))) {
			return null;
		}

		try {
			return likesService.resolveMemNo(auth);
		} catch (Exception e) {
			return null;
		}
	}

	// ===== 목록 =====
	@GetMapping("/comments")
	public ResponseEntity<List<CommentsVO>> list(@RequestParam("rcdNo") Long rcdNo, Authentication auth) {
		Long loginMemberNo = getLoginMemberNo(auth);
		List<CommentsVO> list = service.list("TRIP_RECORD", rcdNo, loginMemberNo);
		return ResponseEntity.ok(list);
	}

	// ===== 작성(댓글/대댓글) : 일반회원만 =====
	public record WriteReq(String content, Long parentCmntNo) {
	}

	@PreAuthorize("hasRole('ROLE_MEMBER')")
	@PostMapping("/comments")
	public ResponseEntity<?> write(@RequestParam("rcdNo") Long rcdNo, @RequestBody WriteReq req, Authentication auth) {
		Long writerNo = getLoginMemberNo(auth);
		if (writerNo == null)
			return ResponseEntity.status(401).body("UNAUTHORIZED");

		String content = (req.content() == null) ? "" : req.content().trim();
		if (content.isEmpty())
			return ResponseEntity.badRequest().body("EMPTY_CONTENT");

		service.write("TRIP_RECORD", rcdNo, writerNo, content, req.parentCmntNo());
		return ResponseEntity.ok().build();
	}

	// ===== 수정(본인만) =====
	public record UpdateReq(String content) {
	}

	@PreAuthorize("hasRole('ROLE_MEMBER')")
	@PutMapping("/comments/{cmntNo}")
	public ResponseEntity<?> update(@PathVariable("cmntNo") Long cmntNo, @RequestBody UpdateReq req,
			Authentication auth) {
		Long writerNo = getLoginMemberNo(auth);
		if (writerNo == null)
			return ResponseEntity.status(401).body("UNAUTHORIZED");

		String content = (req.content() == null) ? "" : req.content().trim();
		if (content.isEmpty())
			return ResponseEntity.badRequest().body("EMPTY_CONTENT");

		boolean ok = service.update(cmntNo, writerNo, content);
		return ok ? ResponseEntity.ok().build() : ResponseEntity.status(403).body("FORBIDDEN");
	}

	// ===== 삭제(본인만) =====
	@PreAuthorize("hasRole('ROLE_MEMBER')")
	@DeleteMapping("/comments/{cmntNo}")
	public ResponseEntity<?> delete(@PathVariable("cmntNo") Long cmntNo, Authentication auth) {
		Long writerNo = getLoginMemberNo(auth);
		if (writerNo == null)
			return ResponseEntity.status(401).body("UNAUTHORIZED");

		boolean ok = service.delete(cmntNo, writerNo);
		return ok ? ResponseEntity.ok().build() : ResponseEntity.status(403).body("FORBIDDEN");
	}

	// 댓글 좋아요 토글 (일반회원만)
	@PreAuthorize("hasAuthority('ROLE_MEMBER')")
	@PostMapping("/comments/{cmntNo}/likes/toggle")
	public ResponseEntity<?> toggleCommentLike(@PathVariable("cmntNo") Long cmntNo, Authentication authentication) {
		final String CAT_COMMENT = "COMMENT";

		Long memNo = likesService.resolveMemNo(authentication);

		boolean liked = likesService.toggleLike(cmntNo, CAT_COMMENT, memNo);
		int likeCount = likesService.countLikes(cmntNo, CAT_COMMENT);

		return ResponseEntity.ok(Map.of("liked", liked, "likeCount", likeCount));
	}

}
