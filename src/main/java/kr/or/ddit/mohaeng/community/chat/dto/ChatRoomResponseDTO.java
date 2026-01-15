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
	 * 채팅방 생성자 닉네임
	 */
	private String createdByNickname;
	/**
	 * 채팅방 생성자 아이디
	 */
	private String createdById;
	/**
	 * 채팅방 full 정원
	 */
	private boolean isFull;
	/**
	 * 안 읽은 메세지 수
	 */
	private int unreadCount;
}
