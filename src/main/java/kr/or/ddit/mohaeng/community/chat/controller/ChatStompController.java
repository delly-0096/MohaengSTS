package kr.or.ddit.mohaeng.community.chat.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;

import kr.or.ddit.mohaeng.community.chat.dto.ChatMessageDTO;
import kr.or.ddit.mohaeng.community.chat.service.IChatService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatStompController {

	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	
	@Autowired
	private IChatService chatService;
	
	@MessageMapping("/chat/send")
	public void sendMessage(
			ChatMessageDTO message, 
			Principal principal
			) {
		log.info("sendMessage()에서 getMemId 확인하기 : ", message.getMemId());
		
		if ("CHAT".equals(message.getType())) {
			chatService.insertMessage(message);
	    }
		
		messagingTemplate.convertAndSend(
				"/topic/chat/" + message.getChatId(),
				message
		);
	}
	
	@MessageMapping("/chat/system")
    public void systemMessage(ChatMessageDTO message) {
		log.info("📢 퇴장 시도 - 방번호: {}, 회원식별자: {}", message.getChatId(), message.getMemNo());

        if ("ENTER".equals(message.getType())) {
			/* chatService.enterChatUser(message.getChatId(), message.getMemNo()); */
            message.setMessage(message.getSender() + "님이 입장했습니다.");
        } else if ("LEAVE".equals(message.getType())) {
            chatService.exitChatUser(message.getChatId(), message.getMemNo());
        	
        	message.setMessage(message.getSender() + "님이 퇴장했습니다.");
        }

        messagingTemplate.convertAndSend(
            "/topic/chat/" + message.getChatId(),
            message
        );
    }
}
