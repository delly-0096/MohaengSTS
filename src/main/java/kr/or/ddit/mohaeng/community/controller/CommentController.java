package kr.or.ddit.mohaeng.community.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.community.service.CommentService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.CommentVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/talk")
public class CommentController {

    private final CommentService commentService;

    @GetMapping("/{boardNo}/comments")
    public List<CommentVO> list(@PathVariable int boardNo) {
        return commentService.getTalkComments(boardNo);
    }

    @PostMapping("/{boardNo}/comments")
    public ResponseEntity<?> write(
            @PathVariable int boardNo,
            @RequestBody Map<String, String> body,
            @AuthenticationPrincipal CustomUserDetails user
    ) {
    	log.info("write 실행 {}" );
        if (user == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("success", false, "message", "로그인이 필요합니다."));
        }
        log.info("boardNo: {}", boardNo);
        log.info("body: {}", body);
        String content = body.get("cmntContent");
        if (content == null || content.trim().isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", "내용을 입력하세요."));
        }
   
        int writerNo = user.getMember().getMemNo();

        Integer parent = (body.get("parentCmntNo") == null)
                ? null
                : Integer.valueOf(body.get("parentCmntNo").toString());

        commentService.addTalkComment(boardNo, writerNo, content, parent);
        return ResponseEntity.ok(Map.of("success", true));
    }

}
