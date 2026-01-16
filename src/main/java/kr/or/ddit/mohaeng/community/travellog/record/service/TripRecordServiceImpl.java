package kr.or.ddit.mohaeng.community.travellog.record.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mohaeng.community.travellog.record.dto.PagedResponse;
import kr.or.ddit.mohaeng.community.travellog.record.dto.TripRecordBlockReq;
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

    @Override
    public void updateWithCover(long rcdNo, TripRecordUpdateReq req, Long loginMemNo, MultipartFile coverFile) {
        // 1) 내용 업데이트(기존 update 재사용)
        update(rcdNo, req, loginMemNo);

        // 2) coverFile이 있을 때만 커버 교체
        if (coverFile != null && !coverFile.isEmpty()) {
            // TODO: 기존 커버 삭제/교체 로직(attachNo 갱신 포함) 구현
            // 예: fileService.replaceCover(rcdNo, coverFile, loginMemNo);
        }
    }

	/*
	 * @Override
	 * 
	 * @Transactional public long createWithBlocks( TripRecordCreateReq req, Long
	 * memNo, MultipartFile coverFile, List<MultipartFile> bodyFiles,
	 * List<TripRecordBlockReq> blocks ) {
	 * 
	 * if (memNo == null) throw new RuntimeException("로그인 정보가 없습니다.");
	 * 
	 * // 기본값 if (req.getOpenScopeCd() == null) req.setOpenScopeCd("PUBLIC"); if
	 * (req.getMapDispYn() == null) req.setMapDispYn("Y"); if (req.getReplyEnblYn()
	 * == null) req.setReplyEnblYn("Y");
	 * 
	 * // 1) 커버 파일 저장 -> attachNo 세팅 if (coverFile != null && !coverFile.isEmpty())
	 * { Long coverAttachNo = attachService.saveAndReturnAttachNo(coverFile, memNo);
	 * req.setAttachNo(coverAttachNo); }
	 * 
	 * // 2) TRIP_RECORD insert (너 XML은 parameterType=map 구조) int cnt =
	 * mapper.insertTripRecord(req, memNo); if (cnt != 1) throw new
	 * RuntimeException("여행기록 등록 실패");
	 * 
	 * Long rcdNoObj = req.getRcdNo(); if (rcdNoObj == null || rcdNoObj <= 0) {
	 * throw new RuntimeException("RCD_NO 생성 실패(Mapper selectKey 확인 필요)"); } long
	 * rcdNo = rcdNoObj;
	 * 
	 * // 3) blocks 저장 (없으면 스킵) if (blocks != null && !blocks.isEmpty()) { int order
	 * = 1;
	 * 
	 * for (TripRecordBlockReq b : blocks) { String type = (b.getType() == null ? ""
	 * : b.getType().trim().toLowerCase());
	 * 
	 * long connNo = mapper.nextConnNo();
	 * 
	 * // 기본: targetPk는 null 가능하게 처리 (테이블이 NOT NULL이면 알려줘!) Long targetPk = null;
	 * 
	 * // (A) image 블록: bodyFiles[fileIdx] 저장 -> attachNo -> TRIP_RECORD_IMG if
	 * ("image".equals(type)) { Integer fileIdx = b.getFileIdx(); if (fileIdx ==
	 * null) { // fileIdx가 없으면 JSON 저장으로 fallback String json = writeJsonSafe(b);
	 * mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", null);
	 * mapper.insertTripRecordTxt(connNo, json); continue; }
	 * 
	 * MultipartFile bodyFile = getFileByIndex(bodyFiles, fileIdx); if (bodyFile ==
	 * null || bodyFile.isEmpty()) { // 파일이 없으면 JSON 저장으로 fallback String json =
	 * writeJsonSafe(b); mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT",
	 * null); mapper.insertTripRecordTxt(connNo, json); continue; }
	 * 
	 * Long attachNo = attachService.saveAndReturnAttachNo(bodyFile, memNo);
	 * targetPk = attachNo;
	 * 
	 * mapper.insertTripRecordSeq(connNo, rcdNo, order++, "IMAGE", targetPk);
	 * mapper.insertTripRecordImg(connNo, attachNo, b.getCaption()); continue; }
	 * 
	 * // (B) 나머지는 전부 TEXT로 저장(구조 유지를 위해 JSON으로 저장 권장) String textToSave; if
	 * ("text".equals(type)) { textToSave = (b.getContent() == null ? "" :
	 * b.getContent()); } else if ("divider".equals(type)) { // divider도 형태를 보존하려고
	 * JSON 저장 textToSave = writeJsonSafe(b); } else if ("day-header".equals(type)
	 * || "place".equals(type)) { textToSave = writeJsonSafe(b); } else { // 알 수 없는
	 * 타입도 JSON으로 저장 textToSave = writeJsonSafe(b); }
	 * 
	 * mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", null);
	 * mapper.insertTripRecordTxt(connNo, textToSave); } }
	 * 
	 * // 4) 해시태그 저장(기존 create() 로직 그대로 가져옴) List<String> tags = req.getTags(); if
	 * (tags != null && !tags.isEmpty()) { List<String> cleaned = tags.stream()
	 * .filter(t -> t != null && !t.trim().isEmpty()) .map(t ->
	 * t.trim().replace("#", "")) .distinct() .toList();
	 * 
	 * if (!cleaned.isEmpty()) { mapper.insertHashtags(rcdNo, cleaned); } }
	 * 
	 * return rcdNo; }
	 */
    
    @Override
    @Transactional
    public long createWithBlocks(
            TripRecordCreateReq req,
            Long memNo,
            MultipartFile coverFile,
            List<MultipartFile> bodyFiles,
            List<TripRecordBlockReq> blocks
    ) {
        if (memNo == null) throw new RuntimeException("로그인 정보가 없습니다.");

        // 기본값
        if (req.getOpenScopeCd() == null) req.setOpenScopeCd("PUBLIC");
        if (req.getMapDispYn() == null) req.setMapDispYn("Y");
        if (req.getReplyEnblYn() == null) req.setReplyEnblYn("Y");

        // 1) 커버 저장 -> attachNo 세팅
        if (coverFile != null && !coverFile.isEmpty()) {
            Long attachNo = attachService.saveAndReturnAttachNo(coverFile, memNo);
            req.setAttachNo(attachNo);
        }

        // 2) TRIP_RECORD INSERT (selectKey로 rcdNo 세팅됨)
        int cnt = mapper.insertTripRecord(req, memNo);
        if (cnt != 1) throw new RuntimeException("여행기록 등록 실패");

        Long rcdNoObj = req.getRcdNo();
        if (rcdNoObj == null || rcdNoObj <= 0) throw new RuntimeException("RCD_NO 생성 실패");
        long rcdNo = rcdNoObj;

        // 3) 블록 저장
        if (blocks != null && !blocks.isEmpty()) {
            int order = 1;

            for (TripRecordBlockReq b : blocks) {
                String type = (b.getType() == null) ? "" : b.getType().trim().toLowerCase();

                long connNo = mapper.nextConnNo();

                // ✅ 핵심: targetPk는 "connNo 문자열"로 저장 (PK 못 받아도 됨)
                String targetPk = String.valueOf(connNo);

                switch (type) {
                    case "image": {
                        Integer fileIdx = b.getFileIdx();
                        MultipartFile img = (bodyFiles != null && fileIdx != null
                                && fileIdx >= 0 && fileIdx < bodyFiles.size())
                                ? bodyFiles.get(fileIdx)
                                : null;

                        if (img != null && !img.isEmpty()) {
                            Long attachNo = attachService.saveAndReturnAttachNo(img, memNo);

                            mapper.insertTripRecordSeq(connNo, rcdNo, order++, "IMAGE", targetPk);
                            mapper.insertTripRecordImg(connNo, attachNo, b.getCaption());
                        } else {
                            // 파일 매칭 실패하면 텍스트로 저장(깨지지 않게)
                            String fallback = writeJsonSafe(b);
                            mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
                            mapper.insertTripRecordTxt(connNo, fallback);
                        }
                        break;
                    }

                    case "divider": {
                        // 구분선은 targetPk NULL
                        mapper.insertTripRecordSeq(connNo, rcdNo, order++, "DIVIDER", null);
                        break;
                    }

                    case "day-header": {
                        // day-header는 TEXT로 저장(빠른 방식)
                        String day = (b.getDay() == null) ? "" : b.getDay().trim();
                        String date = (b.getDate() == null) ? "" : b.getDate().trim();
                        String text = (day + " " + date).trim();

                        mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
                        mapper.insertTripRecordTxt(connNo, text);
                        break;
                    }

                    case "place": {
                        // 아직 plcNo 연동 전이면 JSON으로 TEXT 저장 추천
                        String json = writeJsonSafe(b);
                        mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
                        mapper.insertTripRecordTxt(connNo, json);
                        break;
                    }

                    case "text":
                    default: {
                        String text = (b.getContent() == null) ? "" : b.getContent();
                        mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
                        mapper.insertTripRecordTxt(connNo, text);
                        break;
                    }
                }
            }
        }

        // 4) 해시태그 저장 (기존 create() 로직과 동일)
        List<String> tags = req.getTags();
        if (tags != null && !tags.isEmpty()) {
            List<String> cleaned = tags.stream()
                    .filter(t -> t != null && !t.trim().isEmpty())
                    .map(t -> t.trim().replace("#", ""))
                    .distinct()
                    .toList();

            if (!cleaned.isEmpty()) mapper.insertHashtags(rcdNo, cleaned);
        }

        return rcdNo;
    }

	/*
	 * private MultipartFile getFileByIndex(List<MultipartFile> files, int idx) { if
	 * (files == null || files.isEmpty()) return null; if (idx < 0 || idx >=
	 * files.size()) return null; return files.get(idx); }
	 */

    private String writeJsonSafe(Object o) {
        try {
            return objectMapper.writeValueAsString(o);
        } catch (Exception e) {
            return String.valueOf(o);
        }
    }
    
    @Override
    public List<kr.or.ddit.mohaeng.vo.TripRecordBlockVO> blocks(long rcdNo) {
        return mapper.selectTripRecordBlocks(rcdNo);
    }


}
