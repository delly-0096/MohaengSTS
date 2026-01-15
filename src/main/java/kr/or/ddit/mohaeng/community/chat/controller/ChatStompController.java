package kr.or.ddit.mohaeng.community.chat.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
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
		if (principal instanceof Authentication) {
	        Authentication auth = (Authentication) principal;
	        CustomUserDetails user = (CustomUserDetails) auth.getPrincipal();
	        
	        message.setMemId(user.getUsername());
	        message.setMemNo(user.getMember().getMemNo());
	    }
		
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

        if ("ENTER".equals(message.getType())) {
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
