package kr.or.ddit.mohaeng.mailapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.mohaeng.mailapi.service.MailService;

@Controller
@RequestMapping("/mail")
public class MailController {

	@Autowired
	private MailService mailService;
	
	public MailController(MailService mailService) {
		this.mailService = mailService;
	}
	
	@GetMapping("/test")
	@ResponseBody
	public String sendTestMail() {
		
		
	    String text = "메일 오면 성공! (텍스트)";
	    String html = """
	        <html>
	          <body>
	            <h2>Mailgun 테스트</h2>
	            <p>이 메일이 보이면 <b>HTML 메일 성공</b>입니다.</p>
	          </body>
	        </html>
	        """;

	    mailService.sendEmail(
	        "etlz1323@gmail.com",
	        "MailGun HTML Test",
	        text,
	        html
	    );

	    return "메일 전송 완료!";
	}
}
