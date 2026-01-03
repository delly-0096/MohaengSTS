package kr.or.ddit.mohaeng.login.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.MemberVO;

@Mapper
public interface IMemberMapper {

	/**
	 *	<p> 로그인 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param memId 회원 로그인 아이디 정보
	 *	@return 회원 아이디가 존재하면 회원 타입 판별
	 */
	public MemberVO selectByMemId(String memId);

	/**
	 *	<p> security 로그인 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param username 회원 로그인 아이디 정보
	 *	@return 회원 아이디가 존재하면 회원 타입 판별
	 */
	public MemberVO selectById(@Param("username") String username);

	/**
	 *	<p> 통합회원 정보 저장 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertMember(MemberVO memberVO);

	/**
	 *	<p> 일반회원 권한 정보 저장 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertAuth(MemberVO memberVO);

	/**
	 *	<p> 일반회원 정보 저장 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertUser(MemberVO memberVO);

	/**
	 *	<p> 회원가입시 아이디 중복 체크 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return 회원 아이디가 존재하는지 유무 판별
	 */
	public MemberVO idCheck(@Param("memId") String memId);

}
