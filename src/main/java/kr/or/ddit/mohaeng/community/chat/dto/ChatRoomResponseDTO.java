package kr.or.ddit.mohaeng.community.chat.dto;

import lombok.Data;

@Data
public class ChatRoomResponseDTO {

	/**
	 * 채팅방 생성 Id
	 */
	private int chatId;
	/**
	 * 채팅방 이름
	 */
	private String chatName;
	/**
	 * 채팅방 카테고리
	 */
	private String chatCtgry;
	/**
	 * 채팅방 카테고리 이름
	 */
	private String chatCtgryName;
	/**
	 * 채팅방 정원
	 */
	private int currentUsers;
	/**
	 * 채팅방 최대 정원
	 */
	private int maxUsers;
	/**
	 * 
	 */
	private String createdBy;
	/**
	 * 
	 */
	private boolean isFull;
	
}
