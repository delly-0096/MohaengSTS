package kr.or.ddit.mohaeng.community.chat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.validation.Valid;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.community.chat.service.IChatService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class ChatController {

	@Autowired
	private IChatService chatService;

	/* 채팅방 목록 가져오기 */
	@GetMapping("/chat/rooms")
	@ResponseBody
	public List<ChatRoomResponseDTO> getChatRooms(@RequestParam(required = false) String category){
		return chatService.getChatRooms(category);
	}

	/* 채팅방 만들기 */
	@PostMapping("/chat/room")
	@ResponseBody
	public Map<String, Object> createChatRoom(
			@Valid ChatRoomCreateRequestDTO request,
			BindingResult br,
			@AuthenticationPrincipal CustomUserDetails user
			) {
		Map<String, Object> result = new HashMap<>();

		if(br.hasErrors()) {
			result.put("success", false);
			result.put("message", "입력값이 올바르지 않습니다.");
			return result;
		}
		chatService.creatChatRoom(request, user);

		result.put("success", true);
		result.put("message", "채팅방이 생성되었습니다");
		return result;
	}

	/* 채팅방 입장 */
	@PostMapping("/chat/room/{chatId}/join")
	@ResponseBody
	public Map<String, Object> joinChatRoom(
			@PathVariable Long chatId,
			@AuthenticationPrincipal CustomUserDetails user
			){
		return chatService.joinChatRoom(chatId, user.getMember().getMemNo());
	}

}
