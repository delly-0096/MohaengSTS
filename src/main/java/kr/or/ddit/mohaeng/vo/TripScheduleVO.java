package kr.or.ddit.mohaeng.vo;

import java.util.List;

import lombok.Data;

@Data
public class TripScheduleVO {
	private int schdlNo; // 여행일정키
	private int memNo; // 회원키
	private Integer prefNo; // 선호도키
	private String startPlaceType; // 방문지범위 코드(국가,지역,관광지코드)
	private int startPlaceId; // 기본 방문지 아이디
	private String targetPlaceType; // 여행도착지타입
	private int targetPlaceId; // 여행도착지키
	private String schdlStatus; // 여행일정 상태
	private int attachNo; // 첨부파일고유키
	private String schdlStartDt; // 여행시작일자
	private String schdlEndDt; // 여행종료일자
	private int travelerCnt; // 여행인원
	private String aiRecomYn; // 사용여부 Y(사용),  N(비사용)
	private String publicYn; // 삭제여부 Y(공개),  N(비공개)
	private String regDt; // 등록일자
	private String modDt; // 수정일자
	private String delYn; // 삭제여부 Y(삭제),  N(미삭제)
	private String delDt; // 삭제일자
	private Long totalBudget; // 총 여행 예산
	
	private List<TripScheduleDetailsVO> tripScheduleDetailsList;

	public TripScheduleVO() {}
	
	public TripScheduleVO(int memNo, Integer prefNo, String startPlaceType, int startPlaceId, String targetPlaceType,
			int targetPlaceId, String schdlStatus, String schdlStartDt, String schdlEndDt, int travelerCnt,
			String aiRecomYn, String publicYn, Long totalBudget) {
		super();
		this.memNo = memNo;
		this.prefNo = prefNo;
		this.startPlaceType = startPlaceType;
		this.startPlaceId = startPlaceId;
		this.targetPlaceType = targetPlaceType;
		this.targetPlaceId = targetPlaceId;
		this.schdlStatus = schdlStatus;
		this.schdlStartDt = schdlStartDt;
		this.schdlEndDt = schdlEndDt;
		this.travelerCnt = travelerCnt;
		this.aiRecomYn = aiRecomYn;
		this.totalBudget = totalBudget;
	}

	
}
