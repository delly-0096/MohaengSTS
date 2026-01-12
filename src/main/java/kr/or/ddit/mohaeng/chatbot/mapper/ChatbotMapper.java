package kr.or.ddit.mohaeng.chatbot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.chatbot.vo.ChatbotConfigVO;
import kr.or.ddit.mohaeng.chatbot.vo.ChatbotLogVO;

@Mapper
public interface ChatbotMapper {
    
    // 키워드로 챗봇 설정 검색
    List<ChatbotConfigVO> selectByKeyword(@Param("keyword") String keyword);
    
    // 대화 로그 저장
    int insertChatLog(ChatbotLogVO log);
}
