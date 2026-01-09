package kr.or.ddit.mohaeng.vo;

import lombok.Data;

@Data
public class TripSchedulePlaceVO {
	private int schdlPlcNo; // 여행일정 방문지 키
	private int schdlDetailsNo; // 여행일정 상세키
	private String placeType; // 방문지 타입
	private int placeId; // 방문지 키
	private int placeOrder; // 순서
	private String placeStartTime; // 방문시간
	private String placeEndTime; // 방문종료시간
	private String allDayYn; // 종일여부(Y,N)
	private String destType; // 도착지 타입
	private int destId; // 도착지 키
	private String moveType; // 이동수단(도보,차량 등)
	private Integer planCost; // 지출예산
	
	private String plcNm;
	private TourPlaceVO tourPlace;
	
	public TripSchedulePlaceVO() {}

	public TripSchedulePlaceVO(int schdlDetailsNo, String placeType, int placeId, int placeOrder, String placeStartTime,
			String placeEndTime, String allDayYn, String destType, Integer planCost) {
		super();
		this.schdlDetailsNo = schdlDetailsNo;
		this.placeType = placeType;
		this.placeId = placeId;
		this.placeOrder = placeOrder;
		this.placeStartTime = placeStartTime;
		this.placeEndTime = placeEndTime;
		this.allDayYn = allDayYn;
		this.destType = destType;
		this.planCost = planCost;
	}

}
