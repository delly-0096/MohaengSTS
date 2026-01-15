package kr.or.ddit.mohaeng.community.chat.service;

import java.util.List;
import java.util.Map;

import jakarta.validation.Valid;
import kr.or.ddit.mohaeng.community.chat.dto.ChatMessageDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;

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
	public int creatChatRoom(ChatRoomCreateRequestDTO request, CustomUserDetails user);

	
	/**
	 *	<p> 채팅방 입장 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원 번호 
	 *	@return 
	 */
	public Map<String, Object> joinChatRoom(Long chatId, int memNo);

	/**
	 *	<p> 채팅방 정보 가져오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public ChatRoomVO getChatRoomById(Long chatId);

	/**
	 *	<p> 채팅방 유저 정보 가져오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	public List<ChatUserVO> getChatUsersByRoomId(Long chatId);

	/**
	 *	<p> 채팅방 입장시 브로드 캐스팅</p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원의 닉네임
	 *	@return 
	 */
//	public void enterChatUser(Long chatId, String memNo);

	/**
	 *	<p> 채팅방 퇴장시 브로드 캐스팅</p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원의 닉네임
	 *	@return 
	 */
	public void exitChatUser(Long chatId, int memNo);

	/**
	 *	<p> 채팅 메시지 보내기</p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원의 닉네임
	 *	@return 
	 */
	public void insertMessage(ChatMessageDTO message);




}
