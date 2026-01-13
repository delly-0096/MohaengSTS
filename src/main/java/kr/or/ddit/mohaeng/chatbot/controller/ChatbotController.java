package kr.or.ddit.mohaeng.chatbot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.mohaeng.chatbot.service.ChatbotService;
import jakarta.servlet.http.HttpSession;

import java.util.Map;

@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {
    
    @Autowired
    private ChatbotService chatbotService;
    
    @PostMapping
    public Map<String, Object> chat(@RequestBody Map<String, String> request,
                                     HttpSession session) {
        String message = request.get("message");
        
        @SuppressWarnings("unchecked")
        Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");
        
        Integer memNo = null;
        String userType = "N";
        
        if (loginMember != null) {
            // memNo 가져오기
        	memNo = (Integer) loginMember.get("memNo");
            
            // memType 가져오기
            String memType = (String) loginMember.get("memType");
            
            userType = convertMemTypeToUserType(memType);
        }
        
        return chatbotService.processMessage(message, memNo, userType);
    }
    
    /**
     * 로그인 memType → CHATBOT_CONFIG.TARGET_USER_TYPE 변환
     */
    private String convertMemTypeToUserType(String memType) {
        if (memType == null) return "N";
        
        return switch (memType) {
            case "ADMIN" -> "A";      // 관리자 → 전체
            case "BUSINESS" -> "B";   // 기업회원
            case "MEMBER" -> "P";     // 일반회원 → 개인
            default -> "N";
        };
    }
}