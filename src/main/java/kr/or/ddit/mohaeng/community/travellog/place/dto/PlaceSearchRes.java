package kr.or.ddit.mohaeng.community.travellog.place.dto;

import lombok.Data;

@Data
public class PlaceSearchRes {
	private Long plcNo;
	private Long rgnNo;
	private String plcNm;
	private String plcAddr1;
	private String plcAddr2;
	private String defaultImg;
	private String placeType;
}
