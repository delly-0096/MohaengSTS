package kr.or.ddit.mohaeng.vo;

import java.util.Date;

import kr.or.ddit.mohaeng.community.chat.enums.ChatMessageType;
import lombok.Data;

@Data
public class ChatVO {

	/**
	 * 채팅 메시지 번호
	 */
	private int chatNo; 
	/**
	 * 채팅방 키
	 */
	private int chatId; 
	/**
	 * 대화 내용 
	 */
	private String chatDesc; 
	/**
	 * 발송자 키 
	 */
	private String chatSenderId;
	/**
	 * 발송 시점
	 */
	private Date chatSendtime;
	/**
	 *  삭제 여부(Y,N)
	 */
	private String chatDel; 
	/**
	 * 첨부 파일
	 */
	private int chatAtch;
	/**
	 * 메시지타입(메시지, 파일...)
	 */
	private ChatMessageType chatType;
}
