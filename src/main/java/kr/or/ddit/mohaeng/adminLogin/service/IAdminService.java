package kr.or.ddit.mohaeng.adminLogin.service;


import kr.or.ddit.mohaeng.vo.AdminLoginVO;
import kr.or.ddit.mohaeng.vo.MemberVO;


public interface IAdminService {

	public AdminLoginVO login(String loginId, String password);


}
