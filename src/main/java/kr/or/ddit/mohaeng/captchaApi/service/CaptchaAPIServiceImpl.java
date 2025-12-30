package kr.or.ddit.mohaeng.captchaApi.service;

import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpServletRequest;

@Service
public class CaptchaAPIServiceImpl implements ICaptchaAPIService{

	 private static final String VERIFY_URL = "https://www.google.com/recaptcha/api/siteverify";

	 // 내 테스트 키
	 private static final String SECRET_KEY = "6Ld9JjksAAAAAC0VNf-dW2LPPp2JFlQ4dzzGp46J";
	 
	 // 공식 테스트 키
	 //private static final String SECRET_KEY = "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe";

	@Override
	public boolean verify(HttpServletRequest request) {
	
	    String recaptchaResponse =
	        request.getParameter("g-recaptcha-response");
	
	    // CAPTCHA 체크 안 했을 경우
	    if (recaptchaResponse == null || recaptchaResponse.isEmpty()) {
	        return false;
	    }
	
	    try {
	        RestTemplate restTemplate = new RestTemplate();
	
	        String url = VERIFY_URL
	            + "?secret=" + SECRET_KEY
	            + "&response=" + recaptchaResponse;
	
	        Map<String, Object> response =
	            restTemplate.postForObject(url, null, Map.class);
	
	        if (response == null) return false;
	
	        return Boolean.TRUE.equals(response.get("success"));
	
	    } catch (Exception e) {
	        return false;
	    }
	}

	@Override
	public boolean adminVerify(String captchaToken) {
		
		// CAPTCHA 체크 안 했을 경우
	    if (captchaToken == null || captchaToken.isEmpty()) {
	        return false;
	    }

	    try {
	        RestTemplate restTemplate = new RestTemplate();

	        String url = VERIFY_URL
	            + "?secret=" + SECRET_KEY
	            + "&response=" + captchaToken;

	        Map<String, Object> response =
	            restTemplate.postForObject(url, null, Map.class);

	        if (response == null) return false;

	        return Boolean.TRUE.equals(response.get("success"));

	    } catch (Exception e) {
	        return false;
	    }
	}


}
