package kr.or.ddit.mohaeng.chatbot.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ChatbotLogVO {
	private int chatLogNo;           // 로그 고유 번호
    private Integer botConfigNo;     // 설정번호 (FK, null 가능)
    private Integer memNo;           // 회원번호 (비회원시 null)
    private String userMsg;          // 사용자가 보낸 메세지
    private String botResp;          // 챗봇 실제 응답 내용
    private String intentTag;        // 대화의도 분류 (추천, 예약 등)
    private Date chatDt;             // 채팅 발생 시각
}
