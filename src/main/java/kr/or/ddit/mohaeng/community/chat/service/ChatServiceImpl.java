package kr.or.ddit.mohaeng.community.chat.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomCreateRequestDTO;
import kr.or.ddit.mohaeng.community.chat.dto.ChatRoomResponseDTO;
import kr.or.ddit.mohaeng.community.chat.mapper.IChatMapper;
import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;

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
	        res.setCreatedBy(room.getCreatedBy());
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
	public void creatChatRoom(ChatRoomCreateRequestDTO request, int memNo) {
		
//		boolean valid = chatMapper.existsCode("CHAT_CATEGORY", request.getChatCtgry());
//		if(!valid) {
//			throw new IllegalArgumentException("유효하지 않은 카테고리입니다.");
//		}
		
		// 채팅방 생성
		ChatRoomVO room = new ChatRoomVO();
		room.setChatName(request.getChatName());
		room.setChatCtgry(request.getChatCtgry());
		room.setChatMax(request.getChatMax());
		
		chatMapper.insertChatRoom(room);
		
		// 방장 자동 입장
		ChatUserVO host = new ChatUserVO();
		host.setChatId(room.getChatId());
		host.setChatUserNo(memNo);
		host.setRole("HOST");
		host.setJoinedAt(LocalDateTime.now());
		
		chatMapper.insertChatHost(host);
		
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


}
