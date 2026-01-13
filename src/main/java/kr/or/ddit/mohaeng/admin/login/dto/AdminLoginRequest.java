package kr.or.ddit.mohaeng.admin.login.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AdminLoginRequest {

    private String loginId;
    private String password;
    private String captchaToken;
    
}
