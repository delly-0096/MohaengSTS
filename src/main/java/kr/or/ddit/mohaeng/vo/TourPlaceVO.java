package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class TourPlaceVO {
	private int plcNo;
	private int rgnNo;
	private String placeType;
	private String placeName;
	private String plcNm;
	private String plcDesc;
	private String plcZip;
	private String plcAddr1;
	private String plcAddr2;
	private int attachNo;
	private String latitude;
	private String longitude;
	private String operationHours;
	private String plcPrice;
	private String regId;
	private Date regDt;
	private String modId;
	private Date modDt;
	private String pclStatusCd;
	private String popTrvlYn;
	private String defaultImg;
	
	public TourPlaceVO () {}
	
	public TourPlaceVO(int plcNo, int rgnNo, String placeType, String plcNm, String plcZip, String plcAddr1, String plcAddr2,
			String latitude, String longitude, String regId, String defaultImg) {
		super();
		this.plcNo = plcNo;
		this.rgnNo = rgnNo;
		this.placeType = placeType;
		this.plcNm = plcNm;
		this.plcZip = plcZip;
		this.plcAddr1 = plcAddr1;
		this.plcAddr2 = plcAddr2;
		this.latitude = latitude;
		this.longitude = longitude;
		this.regId = regId;
		this.defaultImg = defaultImg;
	}
	
}
