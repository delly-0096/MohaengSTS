package kr.or.ddit.mohaeng.community.chat.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.community.chat.dto.ChatMessageDTO;
import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;
import kr.or.ddit.mohaeng.vo.ChatVO;

@Mapper
public interface IChatMapper {
	
	/**
	 *	<p> 채팅방 생성 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void insertChatRoom(ChatRoomVO room);

	/**
	 *	<p> 채팅방 host 생성 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void insertChatHost(ChatUserVO host);

	/**
	 *	<p> 채팅방 목록 조회 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public List<ChatRoomVO> selectChatRooms(String category);

	/**
	 *	<p> 채팅방 중복 입장 체크 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public boolean existsChatUser(Long chatId, int memNo);

	/**
	 *	<p> 채팅방 입장 시 현재 인원 수 체크 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public int countChatUsers(Long chatId);

	/**
	 *	<p> 채팅방 입장 시 최대 인원 수 체크 </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public int selectChatMax(Long chatId);

	/**
	 *	<p> 채팅방 입장 시 merge </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void insertChatUser(Long chatId, int memNo);

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
	 *	<p> 채팅방 퇴장 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void exitChatUser(Map<String, Object> params);

	/**
	 *	<p> 채팅방 메시지 insert </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void insertMessage(ChatMessageDTO message);

	/**
	 *	<p> 지난 채팅 내역 불러오기 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public List<ChatVO> getChatMessageByRoomId(Long chatId);

	/**
	 *	<p> 채팅방 유저 삭제 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void deleteAllChatUsersByRoomId(Long chatId);

	/**
	 *	<p> 채팅방 메시지 삭제 처리 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void deleteAllChatMessagesByRoomId(Long chatId);

	/**
	 *	<p> 채팅방 삭제 </p>
	 *	@date 2026.01.14
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void deleteChatRoomPermanently(Long chatId);


}
