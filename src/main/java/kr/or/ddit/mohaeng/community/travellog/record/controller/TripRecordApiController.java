package kr.or.ddit.mohaeng.community.travellog.record.controller;

import java.util.List;

import org.springframework.http.MediaType;
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
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.community.travellog.record.dto.PagedResponse;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordCreateReq;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordUpdateReq;
import kr.or.ddit.mohaeng.community.travellog.record.security.AuthPrincipalExtractor;
import kr.or.ddit.mohaeng.community.travellog.record.service.ITripRecordService;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import kr.or.ddit.mohaeng.vo.TripRecordListVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/travel-log/records")
public class TripRecordApiController {

    private final ITripRecordService service;

    // 목록: 누구나
    @PreAuthorize("permitAll()")
    @GetMapping
    public ResponseEntity<PagedResponse<TripRecordListVO>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String openScopeCd,
            Authentication authentication
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        return ResponseEntity.ok(service.list(page, size, keyword, openScopeCd, loginMemNo));
    }

    // 상세: 누구나(단, 비공개글은 SQL에서 작성자만 보이게 필터링)
    @PreAuthorize("permitAll()")
    @GetMapping("/{rcdNo}")
    public ResponseEntity<TripRecordDetailVO> detail(
            @PathVariable long rcdNo,
            @RequestParam(defaultValue = "true") boolean increaseView,
            Authentication authentication
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        return ResponseEntity.ok(service.detail(rcdNo, loginMemNo, increaseView));
    }

    // 작성: MEMBER만
	/*
	 * @PreAuthorize("hasRole('MEMBER')")
	 * 
	 * @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE) public
	 * ResponseEntity<Long> create(
	 * 
	 * @RequestPart("req") TripRecordCreateReq req,
	 * 
	 * @RequestPart(value = "coverFile", required = false)
	 * org.springframework.web.multipart.MultipartFile coverFile, Authentication
	 * authentication ) { Long loginMemNo =
	 * AuthPrincipalExtractor.getMemNo(authentication); // hasRole('MEMBER')면 원래
	 * null이 나오면 안 되지만 안전장치 if (loginMemNo == null) return
	 * ResponseEntity.status(401).build();
	 * 
	 * long rcdNo = service.createWithFiles(req, loginMemNo, coverFile, null); //
	 * images는 지금 안씀 return ResponseEntity.ok(rcdNo); }
	 */
    
 // 작성: MEMBER만
    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Long> create(
            @RequestPart("req") TripRecordCreateReq req,
            @RequestPart(value = "coverFile", required = false) MultipartFile coverFile,
            @RequestPart(value = "bodyFiles", required = false) java.util.List<MultipartFile> bodyFiles,
            @RequestPart(value = "blocks", required = false) java.util.List<kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordBlockReq> blocks,
            Authentication authentication
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        if (loginMemNo == null) return ResponseEntity.status(401).build();

        long rcdNo = service.createWithBlocks(req, loginMemNo, coverFile, bodyFiles, blocks);
        return ResponseEntity.ok(rcdNo);
    }

    
    // 수정: MEMBER + 작성자만 (JSON)
    @PreAuthorize("hasRole('MEMBER') and @tripRecordAuth.isWriter(#rcdNo, authentication)")
    @PutMapping(value="/{rcdNo}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Void> updateJson(
        @PathVariable long rcdNo,
        @RequestBody TripRecordUpdateReq req,
        Authentication authentication
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        service.update(rcdNo, req, loginMemNo);
        return ResponseEntity.ok().build();
    }


    // ✅ 수정: MEMBER + 작성자만 (multipart: 커버 변경 지원)
    @PreAuthorize("hasRole('MEMBER') and @tripRecordAuth.isWriter(#rcdNo, authentication)")
    @PutMapping(value = "/{rcdNo}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> updateMultipart(
            @PathVariable long rcdNo,
            @RequestPart("req") TripRecordUpdateReq req,
            @RequestPart(value = "coverFile", required = false) MultipartFile coverFile,
            Authentication authentication
    ) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        service.updateWithCover(rcdNo, req, loginMemNo, coverFile);
        return ResponseEntity.ok().build();
    }

    // 삭제: MEMBER + 작성자만
    @PreAuthorize("hasRole('MEMBER') and @tripRecordAuth.isWriter(#rcdNo, authentication)")
    @DeleteMapping("/{rcdNo}")
    public ResponseEntity<Void> delete(@PathVariable long rcdNo, Authentication authentication) {
        Long loginMemNo = AuthPrincipalExtractor.getMemNo(authentication);
        service.delete(rcdNo, loginMemNo);
        return ResponseEntity.ok().build();
    }
}
