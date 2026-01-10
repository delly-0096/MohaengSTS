package kr.or.ddit.mohaeng.login.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemCompVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Mapper
public interface IMemCompMapper {

	/**
	 * 기업회원 존재 여부 확인
	 * @param memNo 회원 번호 (MEMBER.MEM_NO)
	 * @return 존재하면 1
	 */
	public int countByMemNo(Integer memNo);

	/**
	 * 기업회원 승인 여부 확인
	 * @param memNo 회원 번호 (MEMBER.MEM_NO)
	 * @return 승인된 회원이면 1 아닐시 0
	 */
	public int selectAprvYnByMemNo(int memNo);

	/**
	 *	<p> 회원가입시 통합회원 정보 저장 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertMember(MemberVO memberVO);

	/**
	 *	<p> 회원가입시 기업회원 권한 정보 저장 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 *	@param memberVO 회원가입 정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertAuth(int memNo, String string);

	/**
	 *	<p> 회원가입시 기업 정보 저장 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 *	@param companyVO 회원가입 정보
	 */
	public int insertCompany(CompanyVO companyVO);

	/**
	 *	<p> 회원가입시 기업회원 정보 저장 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	public int insertMemComp(MemCompVO memCompVO);

	/**
	 *	<p> 내 정보 수정시 아이디 조회 </p>
	 *	@date 2026.01.05
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	public MemberVO findByCompId(String memId);

	/**
	 * <p>기업회원 내 정보 수정 (회원-기업 공통 정보)</p>
	 * @date 2026.01.06
	 * @author kdrs
	 * @param memComp
	 *        기업회원 번호(memNo)를 기준으로
	 *        수정할 기업 공통 정보를 담은 MemCompVO 객체
	 */
	public void updateMemComp(MemCompVO memComp);

	/**
	 * <p>기업회원 내 정보 수정 (기업 고유 정보)</p>
	 * @date 2026.01.06
	 * @author kdrs
	 * @param compDetail
	 *        기업회원 번호(memNo) 또는 기업 식별자(compNo)를 기준으로
	 *        수정할 기업 상세 정보를 담은 CompanyVO 객체
	 */
	public void updateCompany(CompanyVO compDetail);

	public void deactivateByMemNo(int memNo);

}
