package kr.or.ddit.mohaeng.community.travellog.record.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mohaeng.community.travellog.record.dto.PagedResponse;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordCreateReq;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordUpdateReq;
import kr.or.ddit.mohaeng.community.travellog.record.mapper.ITripRecordMapper;
import kr.or.ddit.mohaeng.vo.TripRecordDetailVO;
import kr.or.ddit.mohaeng.vo.TripRecordListVO;
import kr.or.ddit.mohaeng.vo.TripRecordVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TripRecordServiceImpl implements ITripRecordService {

    private final ITripRecordMapper mapper;
    private final ObjectMapper objectMapper;
    private final IAttachService attachService;

    
    @Override
    public PagedResponse<TripRecordListVO> list(int page, int size, String keyword, String openScopeCd, Long loginMemNo) {
        int safePage = Math.max(page, 1);
        int safeSize = Math.min(Math.max(size, 1), 50);
        int offset = (safePage - 1) * safeSize;

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("openScopeCd", openScopeCd);
        param.put("loginMemNo", loginMemNo);
        param.put("offset", offset);
        param.put("size", safeSize);

        long total = mapper.selectTripRecordListCount(param);
        List<TripRecordListVO> list = mapper.selectTripRecordList(param);

        int totalPages = (int) Math.ceil((double) total / safeSize);
        return new PagedResponse<>(list, total, safePage, safeSize, totalPages);
    }

    @Override
    @Transactional
    public TripRecordDetailVO detail(long rcdNo, Long loginMemNo, boolean increaseView) {
        if (increaseView) mapper.increaseViewCnt(rcdNo);

        Map<String, Object> param = new HashMap<>();
        param.put("rcdNo", rcdNo);
        param.put("loginMemNo", loginMemNo);

        return mapper.selectTripRecordDetail(param);
    }

    /**
     * ✅ 2번 방식(권장): rcdContent는 JSON(에디터 blocks)로 받되,
     * - TRIP_RECORD에는 요약(또는 null)만 저장
     * - TRIP_RECORD_SEQ/TXT/IMG 테이블에 blocks를 분리 저장
     *
     * 프론트 image block 예:
     * { "type":"image", "attachNo":1234, "desc":"..." }
     */
	/*
	 * @Override
	 * 
	 * @Transactional public long create(TripRecordCreateReq req, long loginMemNo) {
	 * 
	 * // 기본값 if (req.getOpenScopeCd() == null) req.setOpenScopeCd("PUBLIC"); if
	 * (req.getMapDispYn() == null) req.setMapDispYn("Y"); if (req.getReplyEnblYn()
	 * == null) req.setReplyEnblYn("Y");
	 * 
	 * // 1) 본문 JSON 파싱 String rawJson = req.getRcdContent(); // 프론트가 JSON 문자열로 보내는
	 * 상태 JsonNode root; try { root = objectMapper.readTree(rawJson); } catch
	 * (Exception e) { throw new RuntimeException("본문 JSON 파싱 실패", e); }
	 * 
	 * // 2) 제목이 비어있으면 JSON title로 채우기 if (req.getRcdTitle() == null ||
	 * req.getRcdTitle().isBlank()) { String title =
	 * root.path("title").asText(null); req.setRcdTitle(title); }
	 * 
	 * // 3) TRIP_RECORD.RCD_CONTENT에는 요약만(또는 null) String summary = null; JsonNode
	 * blocks = root.path("blocks"); if (blocks.isArray()) { for (JsonNode b :
	 * blocks) { if ("text".equalsIgnoreCase(b.path("type").asText())) { summary =
	 * b.path("content").asText(null); break; } } } req.setRcdContent(summary);
	 * 
	 * // 4) TRIP_RECORD insert (중요: insert가 req.rcdNo를 채워줘야 함) int cnt =
	 * mapper.insertTripRecord(req, loginMemNo); if (cnt != 1) throw new
	 * RuntimeException("여행기록 등록 실패");
	 * 
	 * long rcdNo = req.getRcdNo(); if (rcdNo <= 0) { // 여기 걸리면 MyBatis
	 * insertTripRecord 쪽 selectKey 설정이 안 된 거야. throw new
	 * RuntimeException("RCD_NO 생성 실패(Mapper selectKey 설정 확인 필요)"); }
	 * 
	 * // 5) blocks를 SEQ/TXT/IMG로 저장 int order = 1; if (blocks.isArray()) { for
	 * (JsonNode b : blocks) { long connNo = mapper.nextConnNo(); //
	 * SEQ_TRIP_RECORD_CONN.NEXTVAL 같은 시퀀스
	 * 
	 * // 순서 저장 mapper.insertTripRecordSeq(connNo, rcdNo, order++);
	 * 
	 * String type = b.path("type").asText();
	 * 
	 * if ("text".equalsIgnoreCase(type)) { String text =
	 * b.path("content").asText(null); mapper.insertTripRecordTxt(connNo, text);
	 * 
	 * } else if ("image".equalsIgnoreCase(type)) { Long attachNo =
	 * b.hasNonNull("attachNo") ? b.path("attachNo").asLong() : null; String desc =
	 * b.path("desc").asText(null);
	 * 
	 * // attachNo는 "ATTACH_FILE.ATTACH_NO" 값이어야 함
	 * mapper.insertTripRecordImg(connNo, attachNo, desc); } } }
	 * 
	 * return rcdNo; }
	 
	 */
    
    @Override
    @Transactional
    public long create(TripRecordCreateReq req, long loginMemNo) {

        // 기본값
        if (req.getOpenScopeCd() == null) req.setOpenScopeCd("PUBLIC");
        if (req.getMapDispYn() == null) req.setMapDispYn("Y");
        if (req.getReplyEnblYn() == null) req.setReplyEnblYn("Y");

        int cnt = mapper.insertTripRecord(req, loginMemNo);
        if (cnt != 1) throw new RuntimeException("여행기록 등록 실패");

        Long rcdNoObj = req.getRcdNo();
        if (rcdNoObj == null || rcdNoObj <= 0) {
            throw new RuntimeException("RCD_NO 생성 실패(Mapper selectKey 설정 확인 필요)");
        }

        long rcdNo = rcdNoObj; // long으로 변환

		/*
		 * // ✅ 여기! TRIP_RECORD 저장 성공 후 -> HASHTAG 저장 List<String> tags = req.getTags();
		 * 
		 * System.out.println("[DEBUG] rcdNo=" + rcdNo + ", tags=" + tags);
		 * System.out.println("[DEBUG] cleaned=" + cleaned);
		 * 
		 * 
		 * if (tags != null && !tags.isEmpty()) { List<String> cleaned = tags.stream()
		 * .filter(t -> t != null && !t.trim().isEmpty()) .map(t ->
		 * t.trim().replace("#", "")) // # 제거 .distinct() .toList();
		 * 
		 * if (!cleaned.isEmpty()) { mapper.insertHashtags(rcdNo, cleaned); } }
		 */
        
        List<String> tags = req.getTags();
        System.out.println("[DEBUG] rcdNo=" + rcdNo + ", tags=" + tags);

        List<String> cleaned = java.util.Collections.emptyList();

        if (tags != null && !tags.isEmpty()) {
            cleaned = tags.stream()
                .filter(t -> t != null && !t.trim().isEmpty())
                .map(t -> t.trim().replace("#", ""))  // # 제거
                .distinct()
                .toList();
        }

        System.out.println("[DEBUG] cleaned=" + cleaned);

        if (!cleaned.isEmpty()) {
            mapper.insertHashtags(rcdNo, cleaned);
        }


        return rcdNo;
    }
    
    @Override
    @Transactional
    public long createWithFiles(TripRecordCreateReq req, long loginMemNo,
            org.springframework.web.multipart.MultipartFile coverFile,
            java.util.List<org.springframework.web.multipart.MultipartFile> images) {

        // ✅ 본문 이미지(images)는 지금 안 다룸
        if (coverFile != null && !coverFile.isEmpty()) {
            Long attachNo = attachService.saveAndReturnAttachNo(coverFile, loginMemNo);
            req.setAttachNo(attachNo); // TRIP_RECORD.ATTACH_NO
        }
        return create(req, loginMemNo); // create()는 "최소 insert" 버전이어야 함
    }




    @Override
    @Transactional
    public void update(long rcdNo, TripRecordUpdateReq req, long loginMemNo) {
        TripRecordVO vo = new TripRecordVO();
        vo.setRcdNo(rcdNo);
        vo.setMemNo(loginMemNo);
        vo.setSchdlNo(req.getSchdlNo());
        vo.setRcdTitle(req.getRcdTitle());
        vo.setRcdContent(req.getRcdContent());
        vo.setTripDaysCd(req.getTripDaysCd());
        vo.setLocCd(req.getLocCd());
        vo.setAttachNo(req.getAttachNo());
        vo.setStartDt(req.getStartDt());
        vo.setEndDt(req.getEndDt());
        vo.setOpenScopeCd(req.getOpenScopeCd());
        vo.setMapDispYn(req.getMapDispYn());
        vo.setReplyEnblYn(req.getReplyEnblYn());

        mapper.updateTripRecord(vo);
    }

    @Override
    @Transactional
    public void delete(long rcdNo, long loginMemNo) {
        mapper.deleteTripRecord(rcdNo);
    }

    @Override
    public boolean isWriter(long rcdNo, Long loginMemNo) {
        if (loginMemNo == null) return false;
        Long writer = mapper.selectWriterMemNo(rcdNo);
        return writer != null && writer.equals(loginMemNo);
    }
}
