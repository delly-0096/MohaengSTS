package kr.or.ddit.mohaeng.community.travellog.comments.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.travellog.comments.dto.CommentCreateReq;
import kr.or.ddit.mohaeng.community.travellog.comments.service.ICommentsService;
import kr.or.ddit.mohaeng.vo.CommentItemVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/community/travel-log")
public class CommentsApiController {

    private final ICommentsService commentsService;

    // ✅ TODO: 지금은 로그인 연동 전이니까 임시로 파라미터/세션에서 가져오도록 바꿔야 함
    // 여기서는 "writerNo"를 테스트용으로 query param으로 받는 버전도 같이 제공
    private long getLoginMemNoOrThrow(Long writerNoFromParam) {
        if (writerNoFromParam == null) {
            throw new IllegalArgumentException("loginMemNo(writerNo)가 필요합니다. (로그인 연동 전 임시)");
        }
        return writerNoFromParam;
    }

    // 댓글 목록
    @GetMapping("/comments")
    public List<CommentItemVO> list(@RequestParam(required = false) Long rcdNo) {
        if (rcdNo == null) return List.of(); // ✅ 빈 값이면 그냥 빈 배열
        return commentsService.list(rcdNo);
    }


    // 댓글/대댓글 등록
    @PostMapping("/comments")
    public ResponseEntity<?> create(
            @RequestParam long rcdNo,
            @RequestParam(required = false) Long writerNo, // 임시
            @RequestBody CommentCreateReq req
    ) {
        long loginMemNo = getLoginMemNoOrThrow(writerNo);
        commentsService.create(rcdNo, loginMemNo, req.getContent(), req.getParentCmntNo());
        return ResponseEntity.ok(Map.of("ok", true));
    }

    // 댓글 삭제(소프트)
    @DeleteMapping("/comments/{cmntNo}")
    public ResponseEntity<?> delete(
            @PathVariable long cmntNo,
            @RequestParam(required = false) Long writerNo // 임시
    ) {
        long loginMemNo = getLoginMemNoOrThrow(writerNo);
        boolean ok = commentsService.delete(cmntNo, loginMemNo);
        return ResponseEntity.ok(Map.of("ok", ok));
    }
}
