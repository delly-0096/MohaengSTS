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
	public PagedResponse<TripRecordListVO> list(int page, int size, String keyword, String openScopeCd, String filter,
			Long loginMemNo) {
		int safePage = Math.max(page, 1);
		int safeSize = Math.min(Math.max(size, 1), 50);
		int offset = (safePage - 1) * safeSize;

		// filter 정규화
		filter = normalizeFilter(filter);

		// my-spot은 로그인 없으면 빈 결과
		if ("my-spot".equals(filter) && loginMemNo == null) {
			return new PagedResponse<>(List.of(), 0L, safePage, safeSize, 0);
		}

		Map<String, Object> param = new HashMap<>();
		param.put("keyword", keyword);
		param.put("openScopeCd", openScopeCd);
		param.put("loginMemNo", loginMemNo);
		param.put("offset", offset);
		param.put("size", safeSize);

		// 추가된 필터
		param.put("filter", filter);

		long total = mapper.selectTripRecordListCount(param);
		List<TripRecordListVO> list = (total > 0) ? mapper.selectTripRecordList(param) : List.of();

		int totalPages = (int) Math.ceil((double) total / safeSize);

		return new PagedResponse<>(list, total, safePage, safeSize, totalPages);
	}

	// ====== 아래 유틸 메소드 2개 추가 ======
	private String normalizeFilter(String filter) {
		if (filter == null || filter.isBlank())
			return "all";
		switch (filter) {
		case "all":
		case "popular-spot":
		case "my-spot":
			return filter;
		default:
			return "all";
		}
	}

	@Override
	@Transactional
	public TripRecordDetailVO detail(long rcdNo, Long loginMemNo, boolean increaseView) {
		if (increaseView)
			mapper.increaseViewCnt(rcdNo);

		Map<String, Object> param = new HashMap<>();
		param.put("rcdNo", rcdNo);
		param.put("loginMemNo", loginMemNo);

		return mapper.selectTripRecordDetail(param);
	}

	@Override
	@Transactional
	public long create(TripRecordCreateReq req, long loginMemNo) {

		// 기본값
		if (req.getOpenScopeCd() == null)
			req.setOpenScopeCd("PUBLIC");
		if (req.getMapDispYn() == null)
			req.setMapDispYn("Y");
		if (req.getReplyEnblYn() == null)
			req.setReplyEnblYn("Y");

		int cnt = mapper.insertTripRecord(req, loginMemNo);
		if (cnt != 1)
			throw new RuntimeException("여행기록 등록 실패");

		Long rcdNoObj = req.getRcdNo();
		if (rcdNoObj == null || rcdNoObj <= 0) {
			throw new RuntimeException("RCD_NO 생성 실패(Mapper selectKey 설정 확인 필요)");
		}

		long rcdNo = rcdNoObj; 

		List<String> tags = req.getTags();
		System.out.println("[DEBUG] rcdNo=" + rcdNo + ", tags=" + tags);

		List<String> cleaned = java.util.Collections.emptyList();
		if (tags != null && !tags.isEmpty()) {
			cleaned = tags.stream().filter(t -> t != null && !t.trim().isEmpty()).map(t -> t.trim().replace("#", ""))
					.distinct().toList();
		}

		System.out.println("[DEBUG] cleaned=" + cleaned);

		if (!cleaned.isEmpty()) {
			String tagText = String.join(",", cleaned); 
			mapper.upsertHashtagText(rcdNo, tagText);
		}

		return rcdNo;
	}

	@Override
	@Transactional
	public long createWithFiles(TripRecordCreateReq req, long loginMemNo,
			org.springframework.web.multipart.MultipartFile coverFile,
			java.util.List<org.springframework.web.multipart.MultipartFile> images) {

		if (coverFile != null && !coverFile.isEmpty()) {
			Long attachNo = attachService.saveAndReturnAttachNo(coverFile, loginMemNo);
			req.setAttachNo(attachNo); 
		}
		return create(req, loginMemNo); 
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

		mapper.deleteLikesByRcdNo(rcdNo);
		mapper.deleteBookmarkByRcdNo(rcdNo);
		mapper.deleteCommentsByRcdNo(rcdNo);

		// 블록 관련 제거
		mapper.deleteTourPlaceReviewByRcdNo(rcdNo);
		mapper.deleteTripRecordImgByRcdNo(rcdNo);
		mapper.deleteTripRecordTxtByRcdNo(rcdNo);
		mapper.deleteTripRecordSeqByRcdNo(rcdNo);

		// 태그 제거
		mapper.deleteHashtagByRcdNo(rcdNo);

		// 마지막 TRIP_RECORD
		mapper.deleteTripRecord(rcdNo);
	}

	@Override
	public boolean isWriter(long rcdNo, Long loginMemNo) {
		if (loginMemNo == null)
			return false;
		Long writer = mapper.selectWriterMemNo(rcdNo);
		return writer != null && writer.equals(loginMemNo);
	}

	@Override
	public void updateWithCover(long rcdNo, TripRecordUpdateReq req, Long loginMemNo, MultipartFile coverFile) {
		// 1) 내용 업데이트(기존 update 재사용)
		update(rcdNo, req, loginMemNo);

		// 2) coverFile이 있을 때만 커버 교체
		if (coverFile != null && !coverFile.isEmpty()) {
		}
	}

	@Override
	@Transactional
	public long createWithBlocks(TripRecordCreateReq req, Long memNo, MultipartFile coverFile,
			List<MultipartFile> bodyFiles, List<TripRecordBlockReq> blocks) {
		if (memNo == null)
			throw new RuntimeException("로그인 정보가 없습니다.");

		// 기본값
		if (req.getOpenScopeCd() == null)
			req.setOpenScopeCd("PUBLIC");
		if (req.getMapDispYn() == null)
			req.setMapDispYn("Y");
		if (req.getReplyEnblYn() == null)
			req.setReplyEnblYn("Y");

		// 1) 커버 attachNo 결정 (insert 전에 딱 1번만!)
		if (coverFile != null && !coverFile.isEmpty()) {
			Long attachNo = attachService.saveAndReturnAttachNo(coverFile, memNo);
			req.setAttachNo(attachNo);
		} else if (req.getCoverAttachNo() != null && req.getCoverAttachNo() > 0) {
			req.setAttachNo(req.getCoverAttachNo());
		}

		// 2) TRIP_RECORD INSERT
		int cnt = mapper.insertTripRecord(req, memNo);
		if (cnt != 1)
			throw new RuntimeException("여행기록 등록 실패");

		Long rcdNoObj = req.getRcdNo();
		if (rcdNoObj == null || rcdNoObj <= 0)
			throw new RuntimeException("RCD_NO 생성 실패");
		long rcdNo = rcdNoObj;

		// 3) 블록 저장
		insertBlocks(rcdNo, memNo, bodyFiles, blocks);

		// 4) 해시태그 저장
		List<String> tags = req.getTags();
		if (tags != null && !tags.isEmpty()) {
			List<String> cleaned = tags.stream().filter(t -> t != null && !t.trim().isEmpty())
					.map(t -> t.trim().replace("#", "")).distinct().toList();

			if (!cleaned.isEmpty()) {
				String tagText = String.join(",", cleaned);
				mapper.upsertHashtagText(rcdNo, tagText);
			}
		}

		return rcdNo;
	}

	private String writeJsonSafe(Object o) {
		try {
			return objectMapper.writeValueAsString(o);
		} catch (Exception e) {
			return String.valueOf(o);
		}
	}

	private double safeRating(Double r) {
		if (r == null)
			return 0.0;
		if (r < 0)
			return 0.0;
		if (r > 5)
			return 5.0;
		return r;
	}

	@Override
	public List<kr.or.ddit.mohaeng.vo.TripRecordBlockVO> blocks(long rcdNo) {
		return mapper.selectTripRecordBlocks(rcdNo);
	}

	@Override
	@Transactional
	public void updateWithBlocks(long rcdNo, TripRecordUpdateReq req, Long memNo, MultipartFile coverFile,
			List<MultipartFile> bodyFiles, List<TripRecordBlockReq> blocks) {
		if (memNo == null)
			throw new RuntimeException("로그인 정보가 없습니다.");

		// 1) TRIP_RECORD 업데이트 (제목/기간/공개범위 등)
		TripRecordVO vo = new TripRecordVO();
		vo.setRcdNo(rcdNo);
		vo.setMemNo(memNo);

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

		// 2) 커버 교체(파일이 들어온 경우만)
		if (coverFile != null && !coverFile.isEmpty()) {
			Long newAttachNo = attachService.saveAndReturnAttachNo(coverFile, memNo);
			mapper.updateCoverAttachNo(rcdNo, newAttachNo);
		}

		// 3) 기존 블록 전부 삭제 (TRIP_RECORD만 남기고)
		mapper.deleteTourPlaceReviewByRcdNo(rcdNo);
		mapper.deleteTripRecordImgByRcdNo(rcdNo);
		mapper.deleteTripRecordTxtByRcdNo(rcdNo);
		mapper.deleteTripRecordSeqByRcdNo(rcdNo);

		// 4) 새 블록 재삽입
		insertBlocks(rcdNo, memNo, bodyFiles, blocks);

		// 5) 해시태그 업데이트
		List<String> tags = req.getTags(); 

		// tags가 null/빈배열이면: 기존 태그 삭제
		if (tags == null || tags.isEmpty()) {
			mapper.deleteHashtagByRcdNo(rcdNo);
		} else {
			List<String> cleaned = tags.stream().filter(t -> t != null && !t.trim().isEmpty())
					.map(t -> t.trim().replace("#", "")).distinct().toList();

			if (!cleaned.isEmpty()) {
				String tagText = String.join(",", cleaned);
				mapper.upsertHashtagText(rcdNo, tagText);
			} else {
				mapper.deleteHashtagByRcdNo(rcdNo);
			}
		}

	}

	private void insertBlocks(long rcdNo, long memNo, List<MultipartFile> bodyFiles, List<TripRecordBlockReq> blocks) {
		if (blocks == null || blocks.isEmpty())
			return;

		int order = 1;

		for (TripRecordBlockReq b : blocks) {
			String type = (b.getType() == null) ? "" : b.getType().trim().toLowerCase();

			long connNo = mapper.nextConnNo();
			String targetPk = String.valueOf(connNo);

			// text인데 비어있으면 스킵
			if ("text".equals(type)) {
				String content = b.getContent();
				if (content == null || content.trim().isEmpty())
					continue;
			}

			switch (type) {
			case "image": {
				Integer fileIdx = b.getFileIdx();
				MultipartFile img = (bodyFiles != null && fileIdx != null && fileIdx >= 0 && fileIdx < bodyFiles.size())
						? bodyFiles.get(fileIdx)
						: null;

				// 1) 새 파일이 있으면 새로 저장
				if (img != null && !img.isEmpty()) {
					Long attachNo = attachService.saveAndReturnAttachNo(img, memNo);
					mapper.insertTripRecordSeq(connNo, rcdNo, order++, "IMAGE", targetPk);
					mapper.insertTripRecordImg(connNo, attachNo, b.getCaption());
					break;
				}

				// 2) 새 파일이 없고, 기존 attachNo가 오면 그대로 유지
				if (b.getAttachNo() != null) {
					mapper.insertTripRecordSeq(connNo, rcdNo, order++, "IMAGE", targetPk);
					mapper.insertTripRecordImg(connNo, b.getAttachNo(), b.getCaption());
					break;
				}

				// 3) 둘 다 없으면 fallback 
				String fallback = writeJsonSafe(b);
				mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
				mapper.insertTripRecordTxt(connNo, fallback);
				break;
			}

			case "divider": {
				mapper.insertTripRecordSeq(connNo, rcdNo, order++, "DIVIDER", null);
				break;
			}

			case "day-header": {
				String json = writeJsonSafe(b);
				mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
				mapper.insertTripRecordTxt(connNo, json);
				break;
			}

			case "place": {
				if (b.getPlcNo() == null || b.getPlcNo() <= 0) {
					String json = writeJsonSafe(b);
					mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
					mapper.insertTripRecordTxt(connNo, json);
					break;
				}

				Long placeReviewNo = mapper.nextTourPlaceReviewSeq();
				String reviewConn = (b.getContent() == null) ? null : b.getContent().trim();
				double rating = (b.getRating() == null) ? 0.0 : safeRating(b.getRating());

				mapper.insertTourPlaceReview(placeReviewNo, connNo, memNo, b.getPlcNo(), reviewConn, rating);

				mapper.insertTripRecordSeq(connNo, rcdNo, order++, "PLACE", String.valueOf(placeReviewNo));
				break;
			}

			case "text":
			default: {
				String text = (b.getContent() == null) ? "" : b.getContent().trim();
				String toSave = text.isEmpty() ? writeJsonSafe(b) : text;

				mapper.insertTripRecordSeq(connNo, rcdNo, order++, "TEXT", targetPk);
				mapper.insertTripRecordTxt(connNo, toSave);
				break;
			}
			}
		}
	}

}
