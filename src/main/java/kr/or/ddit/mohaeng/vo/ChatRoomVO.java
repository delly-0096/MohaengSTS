package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatRoomVO {
	/**
	 * 채팅방 키
	 */
	private int chatId;
	/**
	 * 채팅방 명
	 */
	private String chatName;
	private String chatCtgryName;
	private int currentUsers;
	private String createdBy;
	
	/**
	 * 등록자
	 */
	private String regId;
	/**
	 * 채팅방 등록 시점
	 */
	private Date regDt; 
	/**
	 * 최대 인원 수
	 */
	private int chatMax; 
	/**
	 * 유형별 카테고리 (하드코딩)
	 */
	private String chatCtgry; 
}
