package kr.or.ddit.mohaeng.vo;

import java.util.Date;

public class TourPlaceVO {
	private int plcNo;
	private int rgnNo;
	private String placeType;
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

	public int getPlcNo() {
		return plcNo;
	}
	public void setPlcNo(int plcNo) {
		this.plcNo = plcNo;
	}
	public int getRgnNo() {
		return rgnNo;
	}
	public void setRgnNo(int rgnNo) {
		this.rgnNo = rgnNo;
	}
	public String getPlaceType() {
		return placeType;
	}
	public void setPlaceType(String placeType) {
		this.placeType = placeType;
	}
	public String getPlcNm() {
		return plcNm;
	}
	public void setPlcNm(String plcNm) {
		this.plcNm = plcNm;
	}
	public String getPlcDesc() {
		return plcDesc;
	}
	public void setPlcDesc(String plcDesc) {
		this.plcDesc = plcDesc;
	}
	public String getPlcZip() {
		return plcZip;
	}

	public void setPlcZip(String plcZip) {
		this.plcZip = plcZip;
	}

	public String getPlcAddr1() {
		return plcAddr1;
	}

	public void setPlcAddr1(String plcAddr1) {
		this.plcAddr1 = plcAddr1;
	}

	public String getPlcAddr2() {
		return plcAddr2;
	}

	public void setPlcAddr2(String plcAddr2) {
		this.plcAddr2 = plcAddr2;
	}
	public int getAttachNo() {
		return attachNo;
	}
	public void setAttachNo(int attachNo) {
		this.attachNo = attachNo;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getOperationHours() {
		return operationHours;
	}
	public void setOperationHours(String operationHours) {
		this.operationHours = operationHours;
	}
	public String getPlcPrice() {
		return plcPrice;
	}
	public void setPlcPrice(String plcPrice) {
		this.plcPrice = plcPrice;
	}
	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public Date getRegDt() {
		return regDt;
	}
	public void setRegDt(Date regDt) {
		this.regDt = regDt;
	}
	public String getModId() {
		return modId;
	}
	public void setModId(String modId) {
		this.modId = modId;
	}
	public Date getModDt() {
		return modDt;
	}
	public void setModDt(Date modDt) {
		this.modDt = modDt;
	}
	public String getPclStatusCd() {
		return pclStatusCd;
	}
	public void setPclStatusCd(String pclStatusCd) {
		this.pclStatusCd = pclStatusCd;
	}
	public String getPopTrvlYn() {
		return popTrvlYn;
	}
	public void setPopTrvlYn(String popTrvlYn) {
		this.popTrvlYn = popTrvlYn;
	}
	public String getDefaultImg() {
		return defaultImg;
	}
	public void setDefaultImg(String defaultImg) {
		this.defaultImg = defaultImg;
	}

	@Override
	public String toString() {
		return "TourPlaceVO [plcNo=" + plcNo + ", rgnNo=" + rgnNo + ", placeType=" + placeType + ", plcNm=" + plcNm
				+ ", plcDesc=" + plcDesc + ", plcZip=" + plcZip + ", plcAddr1=" + plcAddr1 + ", plcAddr2=" + plcAddr2
				+ ", attachNo=" + attachNo + ", latitude=" + latitude + ", longitude=" + longitude + ", operationHours="
				+ operationHours + ", plcPrice=" + plcPrice + ", regId=" + regId + ", regDt=" + regDt + ", modId="
				+ modId + ", modDt=" + modDt + ", pclStatusCd=" + pclStatusCd + ", popTrvlYn=" + popTrvlYn
				+ ", defaultImg=" + defaultImg + "]";
	}
	
	
	
}
