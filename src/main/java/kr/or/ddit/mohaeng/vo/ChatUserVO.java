package kr.or.ddit.mohaeng.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ChatUserVO {

	/**
	 * 채팅방 키
	 */
	private int chatId; 
	/**
	 * 참여자 키
	 */
	private int chatUserNo;
	/**
	 * 채팅방 참여 시점
	 */
	private LocalDateTime joinedAt;
	/**
	 * 최종 조회 채팅 전문
	 */
	private int lastMsgId;
	
	/**
	 * 채팅방 참여자 유형
	 */
	private String role;
	
	private String memId;
	private String memName;
}
