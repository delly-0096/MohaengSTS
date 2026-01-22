package kr.or.ddit.mohaeng.community.travellog.record.dto;

import lombok.Data;

@Data
public class TripRecordBlockReq {
	// 공통
	private String id; 
	private String type; // TEXT/IMAGE/PLACE/DIVIDER
	private int order;

	// text
	private String content;

	// image
	private String caption;
	private int fileIdx; 

	// PLACE
	private Long plcNo;
	private int day;
	private String date;
	private String name;
	private String address;
	private String image;
	private Double rating;

	private Long attachNo;
}
