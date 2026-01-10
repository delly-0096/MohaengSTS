package kr.or.ddit.mohaeng.mailapi.service;


import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

@Service
public class MailService {

    @Value("${mailgun.api.key}")
    private String apiKey;

    @Value("${mailgun.domain}")
    private String domain;

    @Value("${mailgun.api.base}")
    private String baseUrl;
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    public void sendEmail(String to, String subject, String textContent, String htmlContent) {
    	
    	String url = baseUrl + "/" + domain + "/messages";
    	
    	HttpHeaders headers = new HttpHeaders();
    	headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
    	headers.setBasicAuth("api", apiKey);
    	
    	MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
    	body.add("from", "Mohaeng <postmaster@" + domain + ">");
    	body.add("to", to);
    	body.add("subject", subject);
    	body.add("text", textContent);
    	body.add("html", htmlContent);
    	
    	HttpEntity<MultiValueMap<String, String>> request =
    			new HttpEntity<>(body, headers);
    	
    	restTemplate.postForEntity(url, request, String.class);
    }
}
