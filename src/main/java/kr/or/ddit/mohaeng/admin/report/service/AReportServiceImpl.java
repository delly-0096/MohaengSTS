package kr.or.ddit.mohaeng.admin.report.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.report.mapper.IAReportMapper;
import kr.or.ddit.mohaeng.vo.BlacklistVO;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AReportServiceImpl implements IAReportService {

	@Autowired
	private IAReportMapper reportMapper;

	@Override
	 public List<CodeVO> getCodeByGroup(String cdgr) {
        return reportMapper.getCodeByGroup(cdgr);
    }


	@Override
	public ReportVO getReportDetail(Long rptNo) {
		//***************************************************
		ReportVO report = reportMapper.getReportDetail(rptNo);

		// ✅ 원본 콘텐츠 URL 생성
	   if (report != null) {
		String contentUrl = generateContentUrl(report);
		report.setContentUrl(contentUrl);
	   }
	   return report;
		//***************************************************
		//return reportMapper.getReportDetail(rptNo);
	}

	//실제로 신고글을 숨기거나 사용자를 블랙리스트로 올리기
	@Override
	@Transactional
	public int processReport(ReportVO reportVO) {
		// 1. REPORT 테이블 업데이트
		int updated = reportMapper.updateReportProcess(reportVO);
		if (updated == 0) {
			throw new IllegalStateException("신고 처리 실패");
		}

		// 2. 신고 정보 조회 (TARGET_TYPE, TARGET_NO, TARGET_MEM_NO 필요)
		ReportVO reportDetail = reportMapper.getReportDetail(reportVO.getRptNo());

		String procResult = reportVO.getProcResult(); //내가 지금 결정한 벌칙
		String targetType = reportDetail.getTargetType(); //신고가 온 장소(ex)게시글)
		Long targetNo = reportDetail.getTargetNo(); //신고가 온 글 번호(ex)50번 글)
		Long targetMemNo = reportDetail.getTargetMemNo(); //신고에 적힌 작성자 번호

		// 3. 제재 유형별 처리
		switch(procResult){
			case "REJECTED":// 기각 - 아무것도 안 함
	            break;
			case "WARNING":
            case "BAN_7":
            case "BAN_30": hideContent(targetType, targetNo); // 콘텐츠만 숨김
            	break;
            case "BLACKLIST" : hideContent(targetType, targetNo); // 콘텐츠 숨김 + 블랙리스트에 영구 정지 기록
            				   String memberType = reportMapper.getMemberType(targetMemNo);// 회원 타입 확인 (MEM_USER or MEM_COMP)
            				   insertBlackList(targetMemNo, reportVO.getAdminMemo(), memberType);// 블랙리스트 INSERT
            	break;
            default:
                throw new IllegalArgumentException("유효하지 않은 제재 유형: " + procResult);
		}
		return updated;
	}

	@Override
	public int rejectReport(ReportVO reportVO) {
		return reportMapper.rejectReport(reportVO);
	}

	@Override
	@Transactional
	public int releaseBlackList(int blacklistNo) {
		return reportMapper.releaseBlackList(blacklistNo);
	}

	//신고 목록 페이지별로 나눠서 가져오기
	@Override
	public void getReportList(PaginationInfoVO<ReportVO> pagInfoVO) {
		//전체 신고 몇건 인지 세어보기
		int totalRecord = reportMapper.getReportCount(pagInfoVO);
		pagInfoVO.setTotalRecord(totalRecord);
		//그 중에서 딱 n개만 가져오기
		List<ReportVO> dataList = reportMapper.getReportList(pagInfoVO);
		pagInfoVO.setDataList(dataList);

	}

	 // ========== Private Helper Methods ==========

	// 콘텐츠 숨김 처리
	private void hideContent(String targetType, Long targetNo) {
		switch(targetType) {
			case "PROD_REVIEW":
				// 상품 리뷰 REVIEW_STATUS = 'HIDDEN'
				reportMapper.hideProdReview(targetNo);
				break;
			case "TRIP_RECORD":
				// 여행 기록 DELETE_YN='H'
				reportMapper.hideTripRecord(targetNo);
				break;
			case "BOARD":
				// 게시판 HIDE_YN='H'
				reportMapper.hideBoard(targetNo);
				break;
			case "COMMENTS":
				// 댓글 CMNT_STATUS='3' (0/1/3)
				reportMapper.hideComment(targetNo);
				break;
			case "CHAT":
				// 채팅 CHAT_DEL='Y'
				reportMapper.hideChat(targetNo);
				break;
			default:
				log.warn("알 수 없는 신고 대상 타입: {}", targetType);
                break;
		}
	}

	// MEM_BLACKLIST 테이블 INSERT (영구 정지만)
	private void insertBlackList(Long targetMemNo, String adminMemo, String memberType) {
		if (targetMemNo == null) {
			log.warn("TARGET_MEM_NO가 없어서 블랙리스트 추가를 건너뜁니다.");
            return;
		}

		BlacklistVO blacklist = new BlacklistVO();
		blacklist.setBlacklistMemNo(targetMemNo);
		blacklist.setPenaltyTypeCd("BLACKLIST"); // 영구 정지 고정
		blacklist.setMemberType(memberType);     // MEM_USER or MEM_COMP
		blacklist.setBanReason(adminMemo);
		blacklist.setStartDt(new Date());   	 // 시작일 = 현재
		blacklist.setEndDt(null);
		blacklist.setReleaseYn("N");

		reportMapper.insertBlacklist(blacklist);

		log.info("블랙리스트 추가 완료 - 회원번호: {}, 회원타입: {}", targetMemNo, memberType);
	}

	// ✅ 이 메서드를 클래스 맨 아래에 추가 (private 메서드들 있는 곳)
	private String generateContentUrl(ReportVO report) {
		if (report.getTargetNo() == null) return null;
		switch(report.getTargetType()) {
			case "BOARD":
				return "/community/talk/detail?boardNo=" + report.getTargetNo();
	        case "TRIP_RECORD":
	        	return "/community/travel-log/detail?rcdNo=" + report.getTargetNo();
	        case "PROD_REVIEW":
	        	return "/tour/" + report.getTargetNo();
	        case "CHAT":
	        	// 채팅은 모달이라 직접 링크 불가능
	            return "/community/talk"; // 여행톡 페이지로만 이동
	        case "COMMENTS":
	        	// 1. 댓글 정보를 DB에서 조회 (TARGET_NO와 TARGET_TYPE이 담긴 Map 반환)
	            Map<String, Object> commentInfo = reportMapper.getCommentSourceInfo(report.getTargetNo());

	            if (commentInfo != null) {
	                // DB 컬럼명에 맞춰 데이터 추출 (MyBatis Map은 대문자가 기본인 경우가 많음)
	                // .toString()이나 형변환 시 발생할 수 있는 오류를 방지하기 위해 안전하게 처리
	                String parentNo = String.valueOf(commentInfo.get("TARGET_NO"));
	                String commentTargetType = (String) commentInfo.get("TARGET_TYPE");

	                // 2. 게시글 타입에 맞는 URL 생성
	                if ("TRIP_RECORD".equals(commentTargetType)) {
	                    return "/community/travel-log/detail?rcdNo=" + parentNo;
	                } else if ("BOARD".equals(commentTargetType)) {
	                    return "/community/talk/detail?boardNo=" + parentNo;
	                }
	            }
	            return null;
	        default:
	            return null;
		}
	}
}
