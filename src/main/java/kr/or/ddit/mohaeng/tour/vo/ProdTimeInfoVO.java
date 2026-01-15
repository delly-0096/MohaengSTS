package kr.or.ddit.mohaeng.tour.vo;

import lombok.Data;

@Data
public class ProdTimeInfoVO {
    private int timeInfoNo;        		// TIME_INFO_NO
    private int tripProdNo;        		// TRIP_PROD_NO
    private String rsvtAvailableTime;  	// RSVT_AVAILABLE_TIME (예: "09:00")
}
