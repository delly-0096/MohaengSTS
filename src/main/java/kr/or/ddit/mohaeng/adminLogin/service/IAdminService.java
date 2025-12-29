package kr.or.ddit.mohaeng.adminLogin.service;


import kr.or.ddit.mohaeng.vo.AdminLoginVO;


public interface IAdminService {

	public AdminLoginVO login(String loginId, String password);


}
