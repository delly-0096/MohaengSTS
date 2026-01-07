package kr.or.ddit.mohaeng.login.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.MemUserVO;
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

	/**
	 *	<p> 내 정보 수정시 아이디 조회 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	public MemberVO findById(String memId);


	/**
	 *	<p> 정보 수정 시 회원 테이블 변경 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 * @param memberVO 회원 정보를 담은 MemberVO
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	public void updateMember(MemberVO member);

	/**
	 *	<p> 정보 수정 시 일반 회원 테이블 변경 </p>
	 *	@date 2026.01.02
	 *	@author kdrs
	 * @param MemUserVO 일반 회원 정보를 담은 테이블
	 * @return 조회된 일반 회원 정보를 담은 MemUserVO 객체 (없을 경우 null)
	 */
	public void updateMemUser(MemUserVO userDetail);

	/**
	 * <p>회원 프로필 이미지 첨부파일 번호 조회</p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 회원 고유 번호
	 * @return 프로필 이미지로 연결된 첨부파일 번호
	 *         (등록된 이미지가 없을 경우 null 반환)
	 */
	public Integer selectProfileAttachNo(int memNo);

	/**
	 * <p>회원 프로필 이미지 연결 해제</p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 회원 고유 번호
	 */
	public void clearMemberProfile(int memNo);

	/**
	 * <p>비밀번호 변경을 위한 회원 조회</p>
	 * @param memNo
	 * @return
	 */
	public MemberVO selectByMemNo(int memNo);

	/**
	 * 비밀번호 변경을 위한 회원 테이블 변경
	 * @param memNo
	 * @return
	 */
	public int updatePassword(
		    @Param("memNo") int memNo,
		    @Param("encodedPw") String encodedPw
		);

	/**
	 * 회원 탈퇴
	 * @param memNo
	 * @return
	 */
	public int updateWithdraw(MemberVO memberVO);


}
