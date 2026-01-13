package kr.or.ddit.mohaeng.community.chat.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ChatRoomCreateRequestDTO {
	
	/**
	 * 채팅방 이름
	 */
	@NotBlank
	private String chatName;
	
	/**
	 * 채팅방 카테고리
	 */
	@NotBlank
	private String chatCtgry;
	
	/**
	 * 채팅방 최대 인원수
	 */
	@NotNull
	private Integer chatMax;
}