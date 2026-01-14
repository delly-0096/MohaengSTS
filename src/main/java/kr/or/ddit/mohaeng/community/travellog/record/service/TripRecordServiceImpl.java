package kr.or.ddit.mohaeng.community.travellog.record.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
}
