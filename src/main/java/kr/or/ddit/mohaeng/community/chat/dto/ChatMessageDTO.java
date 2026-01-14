package kr.or.ddit.mohaeng.community.chat.dto;

import lombok.Data;

@Data
public class ChatMessageDTO {

	/**
	 * 채팅방 id
	 */
    private Long chatId;
    /**
     * 보낸이
     */
    private String sender;
    /**
     * CHAT, ENTER, LEAVE
     */
    private String type;
    private String message;
    
    private int memNo;
    private String memId;
}
