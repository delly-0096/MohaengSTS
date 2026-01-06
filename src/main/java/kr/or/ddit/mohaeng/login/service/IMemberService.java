package kr.or.ddit.mohaeng.login.service;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.mypage.profile.dto.MemberUpdateDTO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

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

	/**
	 *	<p> 일반회원 가입 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입을 위한 회원정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public ServiceResult register(MemberVO memberVO);

	/**
	 *	<p> 회원가입시 아이디 중복체크 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memId 회원가입을 위한 아이디
	 *	@return ServiceResult 아이디 중복 비중복 판별
	 */
	public ServiceResult idCheck(String memId);

	/**
	 *	<p> 기업회원 가입 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 *	@param memberVO 회원가입을 위한 회원정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	ServiceResult registerCompany(MemberVO memberVO, CompanyVO companyVO, MultipartFile bizFile);

	/**
	 *	<p> 내 정보 수정시 아이디 조회 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	public MemberVO findById(String memId);

	/**
	 *	<p> 내 정보 수정 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param updateDTO 회원 정보 수정 데이터(프로필 이미지, 기본정보, 상세정보, 비밀번호 등 포함)
	 *	@return void (Transactional에 의해 실패 시 롤백됨)
	 */
	public void updateMemberProfile(MemberUpdateDTO updateDTO);



}
