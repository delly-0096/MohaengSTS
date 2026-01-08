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
	 * <p> 회원 프로필 이미지 연결 해제 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 회원 고유 번호
	 * @return 수정된 행 수 (성공 시 1)
	 */
	public void clearMemberProfile(int memNo);

	/**
	 * <p> 비밀번호 변경을 위한 회원 조회 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 회원 고유 번호
	 * @return 회원 상세 정보
	 */
	public MemberVO selectByMemNo(int memNo);

	/**
	 * <p> 비밀번호 변경 실행 </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memNo 회원 고유 번호
	 * @param encodedPw 암호화된 비밀번호
	 * @return 수정된 행 수
	 */
	public int updatePassword(
		    @Param("memNo") int memNo,
		    @Param("encodedPw") String encodedPw
		);

	/**
	 * <p> 회원 탈퇴 처리 (상태값 변경) </p>
	 * @date 2026.01.02
	 * @author kdrs
	 * @param memberVO 탈퇴 정보를 담은 객체
	 * @return 수정된 행 수 (성공 시 1)
	 */
	public int updateWithdraw(MemberVO memberVO);

	/**
     * <p> 이름과 이메일을 이용한 아이디 조회 </p>
     * @date 2026.01.08
     * @author kdrs
     * @param memberVO 조회 조건(memName, memEmail)을 담은 객체
     * @return 일치하는 회원의 아이디 (없을 경우 null)
     */
	public String findIdByNameAndEmail(MemberVO memberVO);

	/**
     * <p> 비밀번호 재설정을 위한 회원 존재 여부 확인 </p>
     * @date 2026.01.08
     * @author kdrs
     * @param memberVO 본인 확인 조건(memId, memName, memEmail)을 담은 객체
     * @return 일치하는 데이터의 개수 (1이면 일치, 0이면 불일치)
     */
	public int checkMemberForPwReset(MemberVO memberVO);
	
	/**
	 * <p> 임시 비밀번호 발급 여부 상태값 변경 </p>
	 * @date 2026.01.08
	 * @author kdrs
	 * @param memNo     회원 고유 번호 (Primary Key)
	 * @param tempPwYn  임시 비밀번호 발급 여부 ('Y' 또는 'N')
	 * @return 상태값 변경 성공 시 1, 실패 시 0
	 */
	public int updateTempPwYn(@Param("memNo") int MemNo, @Param("tempPwYn") String tempPwYn);

	/**
	 * <p> 비밀번호 재설정을 위한 회원 조회 </p>
	 * @param memberVO memId, memName, memEmail 기준
	 * @return 일치하는 회원 정보 (memNo 포함)
	 */
	public MemberVO selectForPwReset(MemberVO memberVO);

}
