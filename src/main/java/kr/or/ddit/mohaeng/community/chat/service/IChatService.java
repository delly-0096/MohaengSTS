package kr.or.ddit.mohaeng.community.chat.service;

import java.util.List;
import java.util.Map;

import jakarta.validation.Valid;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;

public interface IChatService {

	/**
	 *	<p> 채팅방 목록 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public List<ChatRoomResponseDTO> getChatRooms(String category);
	
	/**
	 *	<p> 채팅방 생성 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public void creatChatRoom(ChatRoomCreateRequestDTO request, CustomUserDetails user);

	
	/**
	 *	<p> 채팅방 입장 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public Map<String, Object> joinChatRoom(Long chatId, int memNo);




}
