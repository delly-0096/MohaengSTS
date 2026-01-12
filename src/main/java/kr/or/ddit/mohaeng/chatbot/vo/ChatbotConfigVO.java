package kr.or.ddit.mohaeng.chatbot.vo;

import lombok.Data;

@Data
public class ChatbotConfigVO {
	private int botConfigNo;         // 설정 고유 번호
    private String keyword;          // 매칭 키워드
    private String respContent;      // 챗봇 답변 내용
    private String respType;         // 응답 타입 (TEXT/LINK/IMG)
    private String targetUserType;   // 대상 (A:전체, P:개인, B:기업)
    private int dispSeq;             // 노출순서
    private String regId;            // 작성자
    private String linkUrl;          // 이동할 페이지 주소
}
