package kr.or.ddit.mohaeng.community.chat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import kr.or.ddit.mohaeng.community.chat.dto.ChatMessageDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.community.chat.service.IChatService;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;
import kr.or.ddit.mohaeng.vo.ChatVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/")
public class ChatController {

	@Autowired
	private IChatService chatService;
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;

	/* 채팅방 목록 가져오기 */
	@GetMapping("/chat/rooms")
	@ResponseBody
	public List<ChatRoomResponseDTO> getChatRooms(
			@RequestParam(required = false) String category, 
			@AuthenticationPrincipal CustomUserDetails user){
		
		String memId = (user != null) ? user.getUsername() : null;
		return chatService.getChatRooms(category, memId);
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
		
		int chatId = chatService.creatChatRoom(request, user);

		result.put("success", true);
		result.put("message", "채팅방이 생성되었습니다");
		result.put("chatId", chatId);
		return result;
	}

	/* 채팅방 입장 */
	@PostMapping("/chat/room/{chatId}/join")
	@ResponseBody
	public Map<String, Object> joinChatRoom(
			@PathVariable Long chatId,
			@AuthenticationPrincipal CustomUserDetails user
			){
		Map<String, Object> result = chatService.joinChatRoom(chatId, user.getMember().getMemNo());
		if ((boolean) result.get("success")) {
			chatService.updateLastReadMessage(chatId, user.getUsername());
			
			ChatRoomVO room = chatService.getChatRoomById(chatId);
			List<ChatUserVO> userList = chatService.getChatUsersByRoomId(chatId);
			
			result.put("room", room);
			result.put("userList", userList);
	    }
		return result;
	}
	
	/* 채팅방 유저 정보 불러오기 */
	@GetMapping("/chat/room/{chatId}/users")
	@ResponseBody
	public List<ChatUserVO> getChatUserList(@PathVariable Long chatId){
		return chatService.getChatUsersByRoomId(chatId);
	}
		
	/* 과거 메시지 내역 불러오기 */
	@GetMapping("/chat/room/{chatId}/messages")
	@ResponseBody
	public List<ChatVO> getChatMessages(@PathVariable Long chatId){
		return chatService.getChatMessagesByRoomId(chatId);
	}
	
	/* 채팅방 퇴장 및 삭제 처리 */
	@PostMapping("/chat/room/{chatId}/leave")
	@ResponseBody
	public Map<String, Object> leaveChatRoom(
			@PathVariable Long chatId, 
			@AuthenticationPrincipal CustomUserDetails user
	) {
		Map<String, Object> result = new HashMap<>();
	    String memId = user.getUsername(); 
	    int memNo = user.getMember().getMemNo();

	    try {
	        boolean isDestroyed = chatService.processLeaveOrDestroy(chatId, memId, memNo);

	        // 2. 방이 폭파되었다면 WebSocket으로 참여자들에게 알림 전송
	        if (isDestroyed) {
	            Map<String, Object> deleteSignal = new HashMap<>();
	            deleteSignal.put("type", "ROOM_DELETED");
	            deleteSignal.put("chatId", chatId);
	            deleteSignal.put("message", "방장에 의해 채팅방이 삭제되었습니다.");

	            messagingTemplate.convertAndSend("/topic/chat/" + chatId, deleteSignal);
	        }

	        result.put("success", true);
	        result.put("isDestroyed", isDestroyed); 
	        result.put("message", isDestroyed ? "방장에 의해 채팅방이 삭제되었습니다." : "채팅방에서 성공적으로 퇴장했습니다.");
	        
	    } catch (Exception e) {
	        log.error("❌ 채팅방 퇴장 처리 중 오류 발생: ", e);
	        result.put("success", false);
	        result.put("message", "퇴장 처리 중 오류가 발생했습니다.");
	    }

	    return result;
	}
	
	/* 채팅 파일 & 이미지 업로드 */
	@PostMapping("/chat/upload")
	@ResponseBody
	public Map<String, Object> uploadChatFile(
			@RequestParam("file") MultipartFile file,
			@RequestParam("chatId") Long chatId,
			@AuthenticationPrincipal CustomUserDetails user) {
		
		int memNo = user.getMember().getMemNo();
		return chatService.uploadChatFile(file, chatId, memNo);
	}
			

}
