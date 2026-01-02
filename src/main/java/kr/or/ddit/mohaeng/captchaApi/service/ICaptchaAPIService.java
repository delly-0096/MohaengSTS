package kr.or.ddit.mohaeng.captchaApi.service;

import jakarta.servlet.http.HttpServletRequest;

public interface ICaptchaAPIService {

	public boolean verify(HttpServletRequest request);
	public boolean adminVerify(String captchaToken);

}
