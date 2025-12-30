package kr.or.ddit.mohaeng.login.service;


public interface IMemberService {

	/**
	 *	<p> 로그인 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param memId 회원 로그인 아이디 정보
	 *	@return 회원 아이디가 존재하면 회원 타입 판별
	 */
	public String getMemberType(String memId);

	/**
	 *	<p> 비밀번호 체크 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param memId 회원 아이디 정보 memPassword 회원 비밀번호 정보
	 *	@return 아이디와 패스번호가 일치하면 true, 일치하지 않으면 false
	 */
	public boolean checkPassword(String memId, String memPassword);


}
