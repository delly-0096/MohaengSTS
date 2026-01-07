package kr.or.ddit.mohaeng.vo;

import java.util.List;

import lombok.Data;

@Data
public class TripScheduleDetailsVO {
	private int schdlDetailsNo; // 여행일정 상세키
	private int schdlNo; // 여행일정키
	private String schdlTitle; // 일정명(기본명 : 일차)
	private String schdlStartDt; // 해당 일정 일자
	private String schdlEndDt; // 해당 일자의 끝(시작일자+1일)
	private String bgColor; // 지도 표기 핀의 색
	private int schdlDt; // 전체일정중 몇일
	
	private List<TripSchedulePlaceVO> tripSchedulePlaceList;
	
	public TripScheduleDetailsVO() {
	}
	
	public TripScheduleDetailsVO(int schdlNo, String schdlTitle, int schdlDt) {
		super();
		this.schdlNo = schdlNo;
		this.schdlTitle = schdlTitle;
		this.schdlDt = schdlDt;
	}

	
}