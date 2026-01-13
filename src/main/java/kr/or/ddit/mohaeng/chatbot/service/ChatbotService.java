package kr.or.ddit.mohaeng.chatbot.service;

import kr.or.ddit.mohaeng.chatbot.mapper.ChatbotMapper;
import kr.or.ddit.mohaeng.chatbot.vo.ChatbotConfigVO;
import kr.or.ddit.mohaeng.chatbot.vo.ChatbotLogVO;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

@Slf4j
@Service
public class ChatbotService {

    @Autowired
    private ChatbotMapper chatbotMapper;

    private static final String API_URL = "https://api.anthropic.com/v1/messages";

    @Value("${claude.api.key}")
    private String apiKey;

    private final Gson gson = new Gson();

    /**
     * 회원 유형별 시스템 프롬프트 생성
     */
    private String buildSystemPrompt(String userType) {
        String userTypeDesc = switch (userType) {
            case "N" -> "비회원 (로그인하지 않은 상태)";
            case "P" -> "일반회원 (개인 여행자)";
            case "B" -> "기업회원 (여행 상품 판매자)";
            default -> "비회원";
        };

        String availableFeatures = switch (userType) {
            case "N" -> """
                [비회원 이용 가능 기능]
                - AI 여행 일정 만들기 (/schedule/search)
                - 항공권 검색 (/product/flight)
                - 숙소 검색 (/product/accommodation)
                - 투어/체험/티켓 검색 (/product/tour)
                - 회원가입 안내(/member/register)
                - 로그인 안내(/member/login)
                - 여행톡 커뮤니티 조회 (/community/talk)
                - 여행기록 조회 (/community/travel-log)
                - 자주 묻는 질문 (/support/faq)
                - 공지사항 (/support/notice)
                - 1:1 문의 (/support/inquiry)

                [안내 사항]
                - 예약/결제는 로그인 후 이용 가능
                - 회원가입 시 다양한 혜택 제공
                """;
            case "P" -> """
                [일반회원 이용 가능 기능]
                - AI 여행 일정 만들기 (/schedule/search)
                - 내 일정 조회 (/schedule/my)
                - 내 북마크 조회 (/schedule/bookmark)
                - 항공권 검색/예약 (/product/flight)
                - 숙소 검색/예약 (/product/accommodation)
                - 투어/체험/티켓 예약 (/product/tour)
                - 여행톡 커뮤니티 (/community/talk)
                - 여행기록 작성 (/community/travel-log)
                - 회원 정보 수정 (/mypage/profile)
                - 예약/결제 내역 (/mypage/payments)
                - 포인트 내역 (/mypage/points)
                - 알림 내역 (/mypage/notifications)
                - 1:1 문의 (/support/inquiry)
                """;
            case "B" -> """
                [기업회원 이용 가능 기능]
                - 상품 조회 (항공, 숙박, 투어)
                - 여행기록 조회 (/community/travel-log)
                - 대시보드 (/mypage/business/dashboard)
                - 회원 정보 수정 (/mypage/business/profile)
                - 매출 집계 (/mypage/business/sales)
                - 상품 등록/관리 (/mypage/business/products)
                - 알림 내역 (/mypage/business/notifications)
                - 통계 (/mypage/business/statistics)

                [안내 사항]
                - 일반회원용 기능(일정 만들기, 여행톡 등)은 이용 불가
                """;
            default -> "";
        };

        return """
            너는 '모행' 여행 플랫폼의 AI 어시스턴트야.

            [현재 사용자 정보]
            - 회원 유형: %s

            %s

            [응답 규칙]
            1. 사용자의 회원 유형에 맞는 기능만 안내해
            2. 비회원에게는 로그인/회원가입을 자연스럽게 권유해
            3. 기업회원에게 일반회원 기능을 안내하지 마
            4. 친근하고 도움이 되는 말투로 응답해

            [응답 형식]
            반드시 아래 JSON 형식으로만 응답해. 마크다운 코드 블록(```)을 사용하지 마.

            {
                "message": "사용자에게 보여줄 친근한 응답 메시지",
                "action": "수행할 액션 (navigate, info, none)",
                "pageType": "이동할 페이지 타입 또는 none",
                "redirectUrl": "이동할 URL 경로 또는 null",
                "intentTag": "의도 분류 (추천, 예약, 문의, 일반)"
            }

            반드시 순수 JSON 형식으로만 응답해.
            """.formatted(userTypeDesc, availableFeatures);
    }

    /**
     * 메시지 처리
     */
    public Map<String, Object> processMessage(String userMessage, Integer memNo, String userType) {
    	log.info("챗봇 요청 - memNo: {}, userType: {}, message: {}", memNo, userType, userMessage);
        Map<String, Object> result;

        // 1. DB에서 키워드 매칭 검색 (공통 응답)
        List<ChatbotConfigVO> configs = chatbotMapper.selectByKeyword(userMessage);

        ChatbotLogVO cblog = new ChatbotLogVO();
        cblog.setMemNo(memNo);
        cblog.setUserMsg(userMessage);

        if (configs != null && !configs.isEmpty()) {
            // DB에서 매칭된 응답 사용
            ChatbotConfigVO config = configs.get(0);

            result = new HashMap<>();
            result.put("message", config.getRespContent());
            result.put("action", config.getLinkUrl() != null ? "navigate" : "info");
            result.put("redirectUrl", config.getLinkUrl());
            result.put("respType", config.getRespType());

            cblog.setBotConfigNo(config.getBotConfigNo());
            cblog.setBotResp(config.getRespContent());
            cblog.setIntentTag("DB매칭");

        } else {
            // Claude API 호출 (회원 유형 정보 포함)
            result = callClaudeApi(userMessage, userType);

            cblog.setBotConfigNo(null);
            cblog.setBotResp((String) result.get("message"));
            cblog.setIntentTag((String) result.getOrDefault("intentTag", "AI응답"));
        }

        // 대화 로그 저장
        try {
            chatbotMapper.insertChatLog(cblog);
        } catch (Exception e) {
            e.printStackTrace();
        }

        log.info("챗봇 응답 - {}", result.get("message"));
        return result;
    }

    /**
     * Claude API 호출 (회원 유형 정보 포함)
     */
    private Map<String, Object> callClaudeApi(String userMessage, String userType) {
        Map<String, Object> result = new HashMap<>();

        try {
            // 회원 유형에 맞는 시스템 프롬프트 생성
            String systemPrompt = buildSystemPrompt(userType);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", "claude-sonnet-4-20250514");
            requestBody.put("max_tokens", 1024);
            requestBody.put("system", systemPrompt);

            List<Map<String, String>> messages = new ArrayList<>();
            Map<String, String> userMsg = new HashMap<>();
            userMsg.put("role", "user");
            userMsg.put("content", userMessage);
            messages.add(userMsg);
            requestBody.put("messages", messages);

            HttpPost httpPost = new HttpPost(API_URL);
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setHeader("x-api-key", apiKey);
            httpPost.setHeader("anthropic-version", "2023-06-01");
            httpPost.setEntity(new StringEntity(gson.toJson(requestBody), "UTF-8"));

            try (CloseableHttpClient httpClient = HttpClients.createDefault();
                 CloseableHttpResponse response = httpClient.execute(httpPost)) {

                String responseBody = EntityUtils.toString(response.getEntity());
                System.out.println("Claude API Response: " + responseBody);
                return parseResponse(responseBody);
            }

        } catch (Exception e) {
            e.printStackTrace();
            result.put("message", "죄송해요, 잠시 문제가 생겼어요. 다시 시도해 주세요.");
            result.put("action", "none");
        }

        return result;
    }

    private Map<String, Object> parseResponse(String apiResponse) {
        try {
            JsonObject jsonResponse = gson.fromJson(apiResponse, JsonObject.class);

            if (jsonResponse.has("error")) {
                Map<String, Object> errorResult = new HashMap<>();
                errorResult.put("message", "API 오류가 발생했어요.");
                errorResult.put("action", "none");
                return errorResult;
            }

            JsonArray content = jsonResponse.getAsJsonArray("content");
            String text = content.get(0).getAsJsonObject().get("text").getAsString();

            // 마크다운 코드 블록 제거
            text = text.trim();
            if (text.startsWith("```json")) {
                text = text.substring(7);
            } else if (text.startsWith("```")) {
                text = text.substring(3);
            }
            if (text.endsWith("```")) {
                text = text.substring(0, text.length() - 3);
            }
            text = text.trim();

            JsonObject parsed = gson.fromJson(text, JsonObject.class);

            Map<String, Object> result = new HashMap<>();
            result.put("message", parsed.get("message").getAsString());
            result.put("action", getJsonString(parsed, "action", "none"));
            result.put("intentTag", getJsonString(parsed, "intentTag", "AI응답"));
            result.put("redirectUrl", getJsonString(parsed, "redirectUrl", null));

            return result;

        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("message", "응답 처리 중 오류가 발생했어요.");
            errorResult.put("action", "none");
            return errorResult;
        }
    }

    private String getJsonString(JsonObject obj, String key, String defaultValue) {
        if (obj.has(key) && !obj.get(key).isJsonNull()) {
            return obj.get(key).getAsString();
        }
        return defaultValue;
    }
}