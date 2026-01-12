package kr.or.ddit.mohaeng.vo;

import java.util.Date;

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
	private Date joinedAt;
	/**
	 * 최종 조회 채팅 전문
	 */
	private int lastMsgId;
}
