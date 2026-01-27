package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import lombok.Data;

@Data
public class ReportVO {
    private Long rptNo;
    private String mgmtType;    // 관리 유형 (REPORT: 신고, APPLY: 접수)
    private String targetType;  // 대상 유형 (TRIP_PROD, TRIP_RECORD, BOARD, COMMENTS, CHAT 등)
    private Long targetNo;		// 대상 테이블에서의 해당 데이터 키값
    private Long reqMemNo;		// 신고자
    private Long targetMemNo;	// 피신고자
    private String ctgryCd;		// 신고 사유
    private String content;		// 신고 상세 내용
    private String reqDt;		// 신고 요청 일시
    private String procStatus;	// 처리 상태(WAIT: 대기, DONE: 완료)
    private String procResult;  // 처리 결과 (WARNING: 경고, BAN_7: 7일 정지, BAN_30: 30일 정지, BLACKLIST: 영구정지, REJECTED:기각)
    private Long procMemNo;		// 신고 처리를 담당한 관리자 번호
    private String prodDt;		// 신고 처리 완료 일시
    private String rejRsn;		// 기각 시 작성하는 사유
    private String adminMemo;	// 관리자 메모 (제재를 가한 구체적인 이유 등)
    private Date regDt;			// 등록 일시 (최신순 정렬 기준)
    private Date modDt;			// 수정 일시


    // 추가: 화면에 표시할 아이디 필드
    private String reqMemId;    // 신고자 아이디
    private String targetMemId; // 피신고자 아이디
    
}
