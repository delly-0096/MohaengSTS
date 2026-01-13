package kr.or.ddit.mohaeng.community.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.ChatRoomVO;
import kr.or.ddit.mohaeng.vo.ChatUserVO;

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
	 *	<p> 채팅방 입장 시 insert </p>
	 *	@date 2026.01.12
	 *	@author kdrs
	 *	@param 
	 *	@return
	 */
	public void insertChatUser(Long chatId, int memNo);

}
