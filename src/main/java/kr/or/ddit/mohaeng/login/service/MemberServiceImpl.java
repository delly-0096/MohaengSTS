package kr.or.ddit.mohaeng.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.login.mapper.IMemCompMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemCompVO;
import kr.or.ddit.mohaeng.vo.MemberVO;

@Service
public class MemberServiceImpl implements IMemberService {

//	@Autowired
//	private IFileMapper iFileMapper;

	@Autowired
    private IMemberMapper memberMapper;
	
	@Autowired
    private IMemCompMapper memCompMapper;
	
	@Autowired
	private PasswordEncoder passwordEncoder;


	
	/**
	 *	<p> 로그인 </p>
	 *	@date 2025.12.28
	 *	@author kdrs
	 *	@param memId 회원 로그인 아이디 정보
	 *	@return 회원 아이디가 존재하면 회원 타입 판별
	 */
	@Override
	public String getMemberType(String memId) {
		MemberVO member = memberMapper.selectByMemId(memId);
		
	    if (member == null) {  
	        return null; // 로그인 실패
	    }
		
		int memNo = member.getMemNo();
		int compCount = memCompMapper.countByMemNo(memNo);
		
		if (compCount > 0) {
			int approved = memCompMapper.selectAprvYnByMemNo(memNo); // 승인된 기업회원인지 아닌지 유무 판별
		        if (approved == 0) {
		            return "BUSINESS_NOT_APPROVED";
		        }
        	return "BUSINESS";
        }
		
		return "MEMBER";
	}

	/**
	 *	<p> 비밀번호 체크 </p>
	 *	@date 2025.12.29
	 *	@author kdrs
	 *	@param memId 회원 아이디 정보, memPassword 회원 비밀번호 정보
	 *	@return 회원이 직접 입력한 비밀번호와 암호화된 비밀번호 체크
	 */
	@Override
	public boolean checkPassword(String memId, String memPassword) {
		
		MemberVO member = memberMapper.selectByMemId(memId);
	    if (member == null) return false;

	    String encodedPassword = member.getMemPassword(); // DB 암호문

	    return passwordEncoder.matches(memPassword, encodedPassword);
	}

	/**
	 *	<p> 일반회원 가입 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memberVO 회원가입을 위한 회원정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	@Override
	@Transactional
	public ServiceResult register(MemberVO memberVO) {
		
		//아이디 최종 중복 체크
		if (idCheck(memberVO.getMemId()) == ServiceResult.EXIST) {
			return ServiceResult.EXIST;	// 이미 존재
		}
		
		// 비밀번호 암호화
		String encodePw = passwordEncoder.encode(memberVO.getMemPassword());
		memberVO.setMemPassword(encodePw);
		
		
		// 회원가입 로직
        memberMapper.insertMember(memberVO);
        
        int cnt = memberMapper.insertAuth(memberVO);
        
        if (cnt == 0) {
            throw new RuntimeException("권한 저장 실패");
        }
        
        memberMapper.insertUser(memberVO);
		
		return ServiceResult.OK;
	}

	/**
	 *	<p> 기업회원 가입 </p>
	 *	@date 2026.01.01
	 *	@author kdrs
	 *	@param memberVO 회원가입을 위한 회원정보
	 *	@return ServiceResult 회원가입 후 결과(OK, FAILED)
	 */
	@Override
	@Transactional
	public ServiceResult registerCompany(MemberVO memberVO, CompanyVO companyVO, MultipartFile bizFile) {
		
		//아이디 중복 체크
		if (idCheck(memberVO.getMemId()) == ServiceResult.EXIST) {
			return ServiceResult.EXIST;	// 이미 존재
		}
		
		// 비밀번호 암호화
		memberVO.setMemPassword(passwordEncoder.encode(memberVO.getMemPassword()));
		memberVO.setMemStatus("WAIT");
		
		// MEMBER 테이블 저장
		memCompMapper.insertMember(memberVO);
	    int memNo = memberVO.getMemNo();
        
	    // MEMBER_AUTH 저장
	    memCompMapper.insertAuth(memNo, "BUSINESS");
	    
	    // 파일 업로드 처리 (사업자 등록증)
//	    if (bizFile != null && !bizFile.isEmpty()) {
//	    	int attachNo = fileService.uploadFile(bizFile, memNo);
//	    	companyVO.setCompBizFile(attachNo);
//	    }
	    
	    // COMPANY 테이블 저장 (기업 마스터)
	    companyVO.setMemNo(memNo);
	    companyVO.setRprsvEmladr(memberVO.getMemEmail());
	    memCompMapper.insertCompany(companyVO);
	    
	    // MEM_COMP 테이블 저장 (기업 담당자 전용 정보)
	    MemCompVO memCompVO = new MemCompVO();
	    memCompVO.setMemNo(memNo);
	    
	    memCompVO.setMemCompTel(companyVO.getCompTel());     // 담당자 연락처
	    memCompVO.setMemCompEmail(companyVO.getRprsvEmladr()); // 담당자 이메일
	    memCompVO.setMasterYn("Y"); // 최초 가입자이므로 마스터 권한 부여
	    memCompVO.setAprvYn("N");   // 승인 상태 'N' (대기)
		
	    memCompMapper.insertMemComp(memCompVO);

	    
	    return ServiceResult.OK;
	}
	
	/**
	 *	<p> 회원가입시 아이디 중복체크 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param memId 회원가입을 위한 아이디
	 *	@return ServiceResult 일치 여부에 따른 상태
	 */
	@Override
	public ServiceResult idCheck(String memId) {
		
		ServiceResult result = null;
		MemberVO member = memberMapper.idCheck(memId);
		
		if(member != null) {
			result = ServiceResult.EXIST;
		} else {
			result = ServiceResult.NOTEXIST;
		}
		
		return result;
	}



}
