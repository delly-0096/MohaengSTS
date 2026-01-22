package kr.or.ddit.mohaeng.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class AccResvVO {

	/**
	 * 예약일시
	 */	
	private Date regDt; 
	/**
	 * 객실예약키
	 */
	private int accResvNo; 
	/**
	 * 객실타입키
	 */
	private int roomTypeNo; 
	/**
	 * 예약자키
	 */
	private int resvMemNo;
	/**
	 * 숙박시작일
	 */
	private Date startDt; 
	/**
	 * 숙박종료일
	 */
	private Date endDt;
	/**
	 * 숙박일수
	 */
	private int stayDays; 
	/**
	 * 예약상태
	 */
	private String resvStatus;
	/**
	 * 예상 도착 시간
	 */
	private String arriveTime;
	/**
	 * 성인 인원
	 */
	private int adultCnt;
	/**
	 * 아동 인원
	 */
	private int childCnt;
	/**
	 * 유아 인원
	 */
	private int infantCnt;
	/**
	 * 요청 사항
	 */
	private String resvRequest;
	/**
	* 결제 번호
	*/
	private int payNo;
	   /**
	* 결제 동의
	*/
	private AccResvAgreeVO accResvAgree;
	   /**
	*  숙박 이용약관 동의 여부 (Y/N)
	*/   
	private String stayTermYn;
	   /**
	* 개인정보 수집 및 이용 동의 여부 (Y/N)
	*/
	private String privacyAgreeYn; 
	   /**
	*  취소 및 환불 규정 동의 여부 (Y/N)
	*/
	private String refundAgreeYn; 
	   /**
	* 마케팅 정보 수신 동의 여부 (Y/N) 
	*/
	private String marketAgreeYn; 
	
	// 숙소 예약 옵션
	private List<AccResvOptionVO> accResvOptionList;
	
	// 여행상품일련번호
	private int tripProdNo;
	
	// 객실가격
	private int price;
	
	// 할인율
	private int discount;  
}
