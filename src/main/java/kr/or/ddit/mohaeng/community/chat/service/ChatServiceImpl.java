package kr.or.ddit.mohaeng.community.chat.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.chat.dto.ChatMessageDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.community.chat.mapper.IChatMapper;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;
import kr.or.ddit.mohaeng.vo.ChatVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatServiceImpl implements IChatService{

	@Autowired
	private IChatMapper chatMapper;
	
	/**
	 *	<p> 채팅방 목록 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public List<ChatRoomResponseDTO> getChatRooms(String category) {
		
		List<ChatRoomVO> rooms = chatMapper.selectChatRooms(category);
		
		return rooms.stream().map(room -> {
			ChatRoomResponseDTO res = new ChatRoomResponseDTO();
			res.setChatId(room.getChatId());
			res.setChatName(room.getChatName());
			res.setChatCtgry(room.getChatCtgry());
			res.setChatCtgryName(room.getChatCtgryName());
			res.setCurrentUsers(room.getCurrentUsers());
	        res.setMaxUsers(room.getChatMax());
	        res.setCreatedByNickname(room.getCreatedByNickname());
	        res.setCreatedById(room.getCreatedById());
	        res.setFull(room.getCurrentUsers() >= room.getChatMax());
	        
	        return res;
		}).toList();
		
	}
	
	/**
	 *	<p> 채팅방 생성 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	@Transactional
	public int creatChatRoom(ChatRoomCreateRequestDTO request, CustomUserDetails user) {
		
//		boolean valid = chatMapper.existsCode("CHAT_CATEGORY", request.getChatCtgry());
//		if(!valid) {
//			throw new IllegalArgumentException("유효하지 않은 카테고리입니다.");
//		}
		
		// 채팅방 생성
		ChatRoomVO room = new ChatRoomVO();
		room.setChatName(request.getChatName());
		room.setChatCtgry(request.getChatCtgry());
		room.setChatMax(request.getChatMax());
		room.setRegId(user.getMember().getMemId());
		
		chatMapper.insertChatRoom(room);
		
		// 방장 자동 입장
		ChatUserVO host = new ChatUserVO();
		host.setChatId(room.getChatId());
		host.setChatUserNo(user.getMember().getMemNo());
		host.setRole("HOST");
		host.setJoinedAt(LocalDateTime.now());
		
		chatMapper.insertChatHost(host);
		
		return room.getChatId();
	}

	/**
	 *	<p> 채팅방 입장 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	@Transactional
	public Map<String, Object> joinChatRoom(Long chatId, int memNo) {
		
		Map<String, Object> result = new HashMap<>();
		
		// 이미 참여 중인지 확인
		boolean alreadyJoined = chatMapper.existsChatUser(chatId, memNo);
		if(alreadyJoined) {
			result.put("success", true);
			result.put("message", "이미 참여 중인 채팅방입니다.");
			return result;
		}
		
		// 정원 체크
		int currentCnt = chatMapper.countChatUsers(chatId);
		int maxCnt = chatMapper.selectChatMax(chatId);
		
		if (currentCnt >= maxCnt) {
			result.put("success", false);
			result.put("message", "정원이 가득 찬 채팅방입니다");
			return result;
		}
		
		// 입장 처리
		chatMapper.insertChatUser(chatId, memNo);
		result.put("success", true);
		result.put("message", "입장 성공");
		return result;
	}

	/**
	 *	<p> 채팅방 정보 가져오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public ChatRoomVO getChatRoomById(Long chatId) {
		return chatMapper.getChatRoomById(chatId);
	}

	/**
	 *	<p> 채팅방 유저 정보 가져오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return 
	 */
	@Override
	public List<ChatUserVO> getChatUsersByRoomId(Long chatId) {
		return chatMapper.getChatUsersByRoomId(chatId);
	}

	/*
	 * @Override public void enterChatUser(Long chatId, String memNo) { Map<String,
	 * Object> params = new HashMap<>(); params.put("chatId", chatId);
	 * params.put("memNo", memNo);
	 * 
	 * chatMapper.insertChatUser(params); }
	 */
	
	/**
	 *	<p> 채팅방 퇴장시 브로드 캐스팅</p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원의 닉네임
	 *	@return 
	 */
	@Override
	public void exitChatUser(Long chatId, int memNo) {
		Map<String, Object> params = new HashMap<>();
	    params.put("chatId", chatId);
	    params.put("memNo", memNo);
	    
	    // 작성해두신 exitChatUser 쿼리(UPDATE)를 실행합니다.
	    chatMapper.exitChatUser(params);
		
	}

	/**
	 *	<p> 채팅 메시지 보내기</p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id, memNo 회원의 닉네임
	 *	@return 
	 */
	@Override
	public void insertMessage(ChatMessageDTO message) {
		chatMapper.insertMessage(message);
	}

	/**
	 *	<p> 지난 채팅 내역 불러오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id
	 *	@return 
	 */
	@Override
	public List<ChatVO> getChatMessagesByRoomId(Long chatId) {
		return chatMapper.getChatMessageByRoomId(chatId);
	}

	/**
	 *	<p> HOST 퇴장 시 채팅방 삭제 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param chatId 채팅방 각각의 id
	 *	@return 
	 */
	@Override
	@Transactional
	public boolean processLeaveOrDestroy(Long chatId, String memId, int memNo) {
		
		ChatRoomVO room = chatMapper.getChatRoomById(chatId);
	    
	    // 2. 방장 여부 확인 (DB의 REG_ID 컬럼과 현재 사용자의 memId 비교)
		if (room != null && room.getRegId() != null && room.getRegId().equals(memId)) {
	        chatMapper.deleteAllChatUsersByRoomId(chatId);    // 참여자 전체 삭제
	        chatMapper.deleteAllChatMessagesByRoomId(chatId); // 메시지 CHAT_DEL = 'Y'
	        chatMapper.deleteChatRoomPermanently(chatId);    // 방 자체 삭제
	        return true; 
	        
	    } else {
	        Map<String, Object> params = new HashMap<>();
	        params.put("chatId", chatId);
	        params.put("memId", memId);
	        params.put("memNo", memNo);
	        
	        chatMapper.exitChatUser(params); 
	        return false; 
	    }
	}
	
	
	
}
