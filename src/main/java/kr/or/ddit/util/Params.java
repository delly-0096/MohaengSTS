package kr.or.ddit.util;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;

public class Params extends LinkedHashMap<String, Object> {

    private static final long serialVersionUID = 1L;
    
    // 실제 저장된 키 케이스를 추적하는 맵
    private final Map<String, String> keyTracker = new HashMap<>();
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    public static Params create() {
        return new Params();
    }

    public Params add(String key, Object value) {
        this.put(key, value);
        return this;
    }

    private String normalize(String key) {
        if (key == null) return null;
        return key.toLowerCase().replace("_", "");
    }
    

    @Override
    public Object put(String key, Object value) {
        // 1. MyBatis가 준 대문자 SnakeCase(RGN_NM)를 CamelCase(rgnNm)로 변환
        String camelKey = toCamelCase(key); 
        
        // 2. 검색용 트래커에는 소문자화하여 기록
        keyTracker.put(normalize(camelKey), camelKey);
        
        // 3. 실제 저장(super) 시 변환된 camelKey를 사용해야 JSON 응답이 카멜케이스로 나갑니다.
        return super.put(camelKey, value); 
    }

    // JdbcUtils 대체용 자체 변환 메서드
    private String toCamelCase(String target) {
        if (target == null || target.isEmpty()) return target;

        StringBuilder result = new StringBuilder();
        boolean nextUpper = false;
        String lowerTarget = target.toLowerCase();

        for (int i = 0; i < lowerTarget.length(); i++) {
            char currentChar = lowerTarget.charAt(i);
            if (currentChar == '_') {
                nextUpper = true;
            } else {
                if (nextUpper) {
                    result.append(Character.toUpperCase(currentChar));
                    nextUpper = false;
                } else {
                    result.append(currentChar);
                }
            }
        }
        return result.toString();
    }

    @Override
    public Object get(Object key) {
        if (key instanceof String) {
            String actualKey = keyTracker.get(normalize((String) key));
            return super.get(actualKey != null ? actualKey : key);
        }
        return super.get(key);
    }

    // --- VO 변환 메서드 (필수!) ---
    public <T> T toVO(Class<T> clazz) {
        try {
            T vo = clazz.getDeclaredConstructor().newInstance();
            for (Field field : clazz.getDeclaredFields()) {
                field.setAccessible(true);
                // Params에서 필드명으로 값을 찾아 VO에 세팅
                Object value = this.get(field.getName());
                if (value != null) {
                    field.set(vo, value);
                }
            }
            return vo;
        } catch (Exception e) {
            throw new RuntimeException("VO 변환 중 오류 발생", e);
        }
    }
    
    public Map<String, Object> toMap() {
        // 현재 Params에 담긴 데이터(이미 카멜케이스 변환됨)를 
        // 아무 로직이 없는 '순수한 LinkedHashMap'에 옮겨 담아 반환
        return new LinkedHashMap<>(this);
    }

    // --- 타입별 추출 메서드 ---
    public String getString(String key) {
        Object val = this.get(key);
        return (val == null) ? "" : String.valueOf(val);
    }

    public int getInt(String key) {
        Object val = this.get(key);
        if (val == null) return 0;
        if (val instanceof Number) return ((Number) val).intValue();
        try { return Integer.parseInt(getString(key)); } catch (Exception e) { return 0; }
    }
    
    public static Params of(HttpServletRequest request) {
        Params params = Params.create();

        // 1. GET 쿼리스트링 & POST Form 데이터 처리
        // (request.getParameterMap은 쿼리스트링과 폼데이터를 모두 가져옵니다)
        request.getParameterMap().forEach((key, values) -> {
            if (values != null && values.length > 0) {
                // 값이 하나면 String, 여러개면 콤마로 연결
                params.put(key, values.length == 1 ? values[0] : String.join(",", values));
            }
        });

        // 2. JSON 데이터 처리 (Axios POST application/json)
        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/json")) {
            try {
                // Body를 읽어서 Map으로 변환
                Map<String, Object> jsonMap = objectMapper.readValue(request.getInputStream(), Map.class);
                
                // Params의 put 메소드를 호출하여 CamelCase 변환 로직 적용
                jsonMap.forEach((key, value) -> params.put(key, value));
            } catch (Exception e) {
                // JSON 파싱 실패 혹은 Body가 이미 읽힌 경우 (무시)
                System.out.println("JSON 파싱 스킵: " + e.getMessage());
            }
        }

        return params;
    }
}