package kr.or.ddit.mohaeng.login.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.ServiceResult;
import kr.or.ddit.mohaeng.file.mapper.IFileMapper;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.login.mapper.IMemCompMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.mypage.profile.dto.MemberUpdateDTO;
import kr.or.ddit.mohaeng.vo.CompanyVO;
import kr.or.ddit.mohaeng.vo.MemCompVO;
import kr.or.ddit.mohaeng.vo.MemUserVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemberServiceImpl implements IMemberService {

	@Autowired
	private IFileService fileService; 
	
	@Autowired
	private IFileMapper iFileMapper;
	
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
		
	    // 기업회원의 "대표 회원 정보" 확정
	    memberVO.setMemName(memberVO.getManagerName());
	    memberVO.setMemEmail(memberVO.getManagerEmail());
	    
		// 비밀번호 암호화
		memberVO.setMemPassword(passwordEncoder.encode(memberVO.getMemPassword()));
		memberVO.setMemStatus("WAIT");
		
		try {
		// MEMBER 테이블 저장
		memCompMapper.insertMember(memberVO);
	    int memNo = memberVO.getMemNo();
        
	    // MEMBER_AUTH 저장
	    memCompMapper.insertAuth(memNo, "ROLE_BUSINESS");
	    
	    // 파일 업로드 처리 (사업자 등록증)
	    if (bizFile != null && !bizFile.isEmpty()) {
	    	int attachNo = fileService.uploadBizFile(bizFile, memNo);
	    	companyVO.setCompBizFile(attachNo);
	    }
	    
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
		
		} catch (Exception e) {
			throw new RuntimeException("회원가입 중 파일 처리 오류 발생", e);
		}

	    
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

	/**
	 *	<p> 내 정보 수정시 아이디 조회 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	@Override
	public MemberVO findById(String memId) {
		return memberMapper.findById(memId);
	}

	
	/**
	 *	<p> 내 정보 수정 </p>
	 *	@date 2025.12.31
	 *	@author kdrs
	 *	@param updateDTO 회원 정보 수정 데이터(프로필 이미지, 기본정보, 상세정보, 비밀번호 등 포함)
	 * @return 
	 **/
	@Override
	@Transactional
	public void updateMemberProfile(MemberUpdateDTO dto, boolean isBusiness) {
		
		// MemberVO 객체 생성 및 기본 세팅
		MemberVO member = new MemberVO();
		member.setMemNo(dto.getMemNo());
		member.setMemName(dto.getMemName());
		member.setMemEmail(dto.getMemEmail());
		
		// 프로필 이미지 처리
		if (dto.isProfileImageDeleted()) {
		    member.setMemProfile(null);
		} 
		else if (dto.getProfileImage() != null && !dto.getProfileImage().isEmpty()) {
		    int newAttachNo = fileService.saveFile(dto.getProfileImage(), dto.getMemNo());
		    member.setMemProfile(newAttachNo);
		}
		
		memberMapper.updateMember(member);

		// 기업 회원
		if(isBusiness) {
		
			log.info("기업 회원 수정을 진행합니다. 회원번호: {}", dto.getMemNo());
			
			MemCompVO memComp = new MemCompVO();
			memComp.setMemNo(dto.getMemNo());
			memComp.setMemCompTel(dto.getMemCompTel());
			memComp.setMemCompEmail(dto.getMemEmail());
			
			memCompMapper.updateMemComp(memComp);
			
			CompanyVO compDetail = new CompanyVO();
			compDetail.setMemNo(dto.getMemNo());
			compDetail.setCompUrl(dto.getCompUrl());
			compDetail.setCompIntro(dto.getCompIntro());
			compDetail.setBankCd(dto.getBankCd());
			compDetail.setDepositor(dto.getDepositor());
			compDetail.setAccountNo(dto.getAccountNo());
			
			memCompMapper.updateCompany(compDetail);
			
		} else {
			
			log.info("일반 회원 수정을 진행합니다. 회원번호: {}", dto.getMemNo());
			
			MemUserVO userDetail = new MemUserVO();
			userDetail.setMemNo(dto.getMemNo());
			userDetail.setNickname(dto.getNickname());
			userDetail.setBirthDate(dto.getBirthDate());
			userDetail.setGender(dto.getGender());
			userDetail.setZip(dto.getZip());
			userDetail.setAddr1(dto.getAddr1());
			userDetail.setAddr2(dto.getAddr2());
			userDetail.setTel(dto.getTel());
			
			memberMapper.updateMemUser(userDetail);
		}
		
	}

	/**
	 *	<p> 기업회원 : 내 정보 수정시 아이디 조회 </p>
	 *	@date 2026.01.05
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 */
	@Override
	public MemberVO findByCompId(String memId) {
		return memCompMapper.findByCompId(memId);
	}

	/**
	 *	<p> 비밀번호 변경 </p>
	 *	@date 2026.01.05
	 *	@author kdrs
	 * @param username 세션을 통해 들어온 아이디 값 (memId)
	 * @return 조회된 회원 전체 정보를 담은 MemberVO 객체 (없을 경우 null)
	 * @throws IllegalAccessException 
	 */
	@Override
	@Transactional
	public void changePassword(int memNo, String currentPassword, String newPassword){
		
		MemberVO member = memberMapper.selectByMemNo(memNo);
	    if (member == null) {
	        throw new IllegalArgumentException("회원 정보가 존재하지 않습니다.");
	    }

	    if (!passwordEncoder.matches(currentPassword, member.getMemPassword())) {
	        throw new IllegalArgumentException("현재 비밀번호가 일치하지 않습니다.");
	    }

	    if (passwordEncoder.matches(newPassword, member.getMemPassword())) {
	        throw new IllegalArgumentException("기존 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.");
	    }

	    String encodedPw = passwordEncoder.encode(newPassword);

	    int updated = memberMapper.updatePassword(memNo, encodedPw);

	    log.info("🔐 비밀번호 변경 update row = {}", updated);

	    if (updated != 1) {
	        throw new RuntimeException("비밀번호 변경 실패 (DB update 실패)");
	    }
	}

	/**
	 *	<p> 회원 탈퇴 처리 (논리 삭제) </p>
	 *	@date 2026.01.07
	 *	@author kdrs
	 *	@param memNo 탈퇴할 회원의 고유 번호 (PK)
	 *	@param password 본인 확인을 위한 현재 비밀번호
	 *	@throws RuntimeException 비밀번호 불일치 시 발생
	 */
	@Override
	@Transactional
	public void withdrawMember(int memNo, String currentPassword, String withdrawReason) {
		log.info("탈퇴 진행 - 회원번호: {}, 사유: {}", memNo, withdrawReason);
		
		// 회원 정보 조회
		MemberVO member = memberMapper.selectByMemNo(memNo);
		
		// 비밀번호 일치 여부 확인
		if (member == null || !passwordEncoder.matches(currentPassword, member.getMemPassword())) {
			throw new RuntimeException("비밀번호가 일치하지 않습니다.");
		}
		
		if ("0".equals(member.getEnabled())) {
			throw new RuntimeException("이미 탈퇴 처리된 계정입니다.");
		}
		
		MemberVO withdrawInfo = new MemberVO();
	    withdrawInfo.setMemNo(memNo);
	    withdrawInfo.setWdrwResn(withdrawReason);
		
	    int result = memberMapper.updateWithdraw(withdrawInfo);
	    
	    if (result <= 0) {
	        throw new RuntimeException("탈퇴 처리 중 오류가 발생했습니다.");
	    }

	}



}
