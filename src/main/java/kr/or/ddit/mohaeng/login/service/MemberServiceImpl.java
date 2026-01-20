package kr.or.ddit.mohaeng.login.service;


import java.util.UUID;

import org.apache.ibatis.annotations.Param;
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
import kr.or.ddit.mohaeng.mailapi.service.MailService;
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
	private MailService mailService;

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
	public ServiceResult register(MemberVO memberVO, MemUserVO memUserVO) {
		
		//아이디 최종 중복 체크
		if (idCheck(memberVO.getMemId()) == ServiceResult.EXIST) {
			return ServiceResult.EXIST;	// 이미 존재
		}
		
		// 비밀번호 암호화
		String encodePw = passwordEncoder.encode(memberVO.getMemPassword());
		memberVO.setMemPassword(encodePw);
		
		
		// 회원가입 로직
        memberMapper.insertMember(memberVO);
        
        memUserVO.setMemNo(memberVO.getMemNo());
        
        int cnt = memberMapper.insertAuth(memberVO);
        
        if (cnt == 0) {
            throw new RuntimeException("권한 저장 실패");
        }
        
        memberMapper.insertUser(memUserVO);
		
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

	    // 새 비밀번호 암호화
	    String encodedPw = passwordEncoder.encode(newPassword);

	    // 비밀번호 변경
	    int updated = memberMapper.updatePassword(memNo, encodedPw);
	    log.info("🔐 비밀번호 변경 update row = {}", updated);

	    if (updated != 1) {
	        throw new RuntimeException("비밀번호 변경 실패 (DB update 실패)");
	    }

	    // 🔥 임시 비밀번호 상태 해제 (핵심)
	    memberMapper.updateTempPwYn(memNo, "N");
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

	/**
     * <p> 아이디 찾기 처리 </p>
     * @date 2026.01.08
     * @author kdrs
     * @param memberVO 이름(memName)과 이메일(memEmail) 정보를 담은 객체
     * @return 조회된 회원의 마스킹 처리된 아이디 (예: ab****)
     * @throws RuntimeException 일치하는 회원 정보가 없을 시 발생
     */
	@Override
	public String findIdProcess(MemberVO memberVO) {
		
		String fullId = memberMapper.findIdByNameAndEmail(memberVO);
		
		if(fullId == null || fullId.isEmpty()) {
			return null;
		}
		
		if (fullId.length() <= 3) {
            return fullId.replaceAll("(?<=.{1}).", "*");
        }
        return fullId.replaceAll("(?<=.{3}).", "*");
	}

	/**
     * <p> 비밀번호 찾기 본인 확인 </p>
     * @date 2026.01.08
     * @author kdrs
     * @param memberVO 아이디(memId), 이름(memName), 이메일(memEmail) 정보를 담은 객체
     * @return 본인 확인 일치 여부 (일치 시 "success", 불일치 시 "fail")
     */
	@Override
	public boolean findPasswordProcess(MemberVO memberVO) {
	    int count = memberMapper.checkMemberForPwReset(memberVO);
	    return count > 0;
	}


	/**
	 * <p> 임시 비밀번호 생성 메서드 </p>
	 * @date 2026.01.08
	 * @author kdrs
	 * @return 생성된 임시 비밀번호 문자열
	 */
	private String generateTempPassword() {
		
	    return UUID.randomUUID().toString()
	               .replace("-", "")
	               .substring(0, 10);
	}
	
	/**
     * <p> 비밀번호 재설정 인증 메일 발송 </p>
     * @date 2026.01.08
     * @author kdrs
     * @param memberVO 인증 토큰 생성 및 메일 수신을 위한 회원 정보 객체
     * @throws RuntimeException 메일 서버 오류 혹은 발송 실패 시 발생
     */
	@Override
	@Transactional
	public void sendPasswordResetMail(MemberVO memberVO) {
		
		// 회원 재조회 (memNo 확보)
	    MemberVO member = memberMapper.selectForPwReset(memberVO);
	    if (member == null) {
	        throw new IllegalArgumentException("회원 정보가 존재하지 않습니다.");
	    }

	    // 임시 비밀번호 생성 + 암호화
	    String tempPassword = generateTempPassword();
	    String encodedPw = passwordEncoder.encode(tempPassword);

	    log.info("임시 비밀번호 = {}", tempPassword);
	    
	    // DB에 즉시 반영
	    memberMapper.updatePassword(member.getMemNo(), encodedPw);
	    memberMapper.updateTempPwYn(member.getMemNo(), "Y"); // 임시 비밀번호를 발급 받은 상태
	    
	    String textContent = """
	    		임시 비밀번호가 발급되었습니다.
	    		임시 비밀번호: %s
	    		로그인 후 반드시 비밀번호를 변경해주세요.
	    		""".formatted(tempPassword);
	    
	    String htmlContent = buildTempPwHtml(
	    	    memberVO.getMemName(),
	    	    tempPassword,
	    	    "http://localhost:8272/mypage/profile/update"
	    	);

	    mailService.sendEmail(
	        memberVO.getMemEmail(),
	        "[Mohaeng] 임시 비밀번호 안내",
	        textContent,
	        htmlContent
	    );
    }
	
	/**
	 * <p> 임시 비밀번호 발급 안내 HTML 메일 본문 생성 </p>
	 *
	 * <p>
	 * 비밀번호 찾기 요청 시 발급되는 임시 비밀번호를
	 * HTML 형식의 메일 본문으로 생성한다.
	 * </p>
	 *
	 * <p>
	 * 생성된 메일에는 다음 정보가 포함된다.
	 * <ul>
	 *   <li>회원 이름(없을 경우 기본 호칭 처리)</li>
	 *   <li>임시 비밀번호 (복사 가능하도록 강조 표시)</li>
	 *   <li>로그인 후 비밀번호 변경을 유도하는 안내 문구</li>
	 *   <li>내 정보 수정(비밀번호 변경) 화면으로 이동하는 링크</li>
	 * </ul>
	 * </p>
	 *
	 * <p>
	 * 본 메서드는 메일 발송 로직과 분리된 순수 템플릿 생성용 메서드이며,
	 * Mailgun API의 <code>html</code> 파라미터에 그대로 전달되어 사용된다.
	 * </p>
	 *
	 * @date 2026.01.08
	 * @author kdrs
	 *
	 * @param memName      메일 수신자 이름 (null 또는 공백일 경우 기본값 처리)
	 * @param tempPassword 발급된 임시 비밀번호 (암호화되지 않은 원문)
	 * @param profileUrl   로그인 후 비밀번호 변경을 위한 내 정보 수정 페이지 URL
	 *
	 * @return 임시 비밀번호 안내용 HTML 메일 본문 문자열
	 */
	private String buildTempPwHtml(String memName, String tempPassword, String profileUrl) {
		String safeName = (memName == null || memName.isBlank()) ? "회원" : memName;

	    return """
		<!doctype html>
		<html lang="ko">
		<head>
		  <meta charset="utf-8">
		  <meta name="viewport" content="width=device-width,initial-scale=1">
		  <title>Mohaeng 임시 비밀번호 안내</title>
		</head>
		<body style="margin:0;padding:0;background:#f6f7fb;">
		  <table role="presentation" width="100%%" cellpadding="0" cellspacing="0" style="background:#f6f7fb;padding:24px 0;">
		    <tr>
		      <td align="center">
		        <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="width:600px;max-width:600px;background:#ffffff;border-radius:14px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.06);">
		          <tr>
		            <td style="padding:22px 28px;background:#111827;color:#ffffff;">
		              <div style="font-size:18px;font-weight:700;letter-spacing:-0.2px;">Mohaeng</div>
		              <div style="margin-top:6px;font-size:13px;opacity:0.85;">임시 비밀번호 안내</div>
		            </td>
		          </tr>
	
		          <tr>
		            <td style="padding:26px 28px;color:#111827;">
		              <div style="font-size:16px;line-height:1.6;">
		                안녕하세요, <b>%s</b>님.<br>
		                요청하신 <b>임시 비밀번호</b>가 발급되었습니다.
		              </div>
	
		              <div style="margin-top:18px;padding:16px 18px;border:1px solid #e5e7eb;border-radius:12px;background:#f9fafb;">
		                <div style="font-size:12px;color:#6b7280;margin-bottom:8px;">임시 비밀번호</div>
		                <div style="font-size:22px;font-weight:800;letter-spacing:1px;font-family:ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace;">
		                  %s
		                </div>
		                <div style="margin-top:10px;font-size:12px;color:#6b7280;">
		                  * 보안을 위해 로그인 후 즉시 비밀번호를 변경해주세요.
		                </div>
		              </div>
	
		              <div style="margin-top:18px;font-size:14px;line-height:1.7;color:#374151;">
		                아래 버튼을 눌러 내 정보 수정 화면에서 비밀번호를 변경할 수 있습니다.
		              </div>
	
		              <div style="margin-top:16px;">
		                <a href="http://localhost:8272/member/login"
		                   style="display:inline-block;padding:12px 16px;border-radius:10px;background:#2563eb;color:#ffffff;text-decoration:none;font-weight:700;font-size:14px;">
		                  임시 비밀번호로 로그인하기
		                </a>
		              </div>
	
		              <div style="margin-top:22px;padding-top:18px;border-top:1px solid #e5e7eb;">
		                <div style="font-size:12px;color:#6b7280;line-height:1.6;">
		                  본 메일은 비밀번호 찾기를 요청한 경우에만 발송됩니다.<br>
		                  요청한 적이 없다면 이 메일을 무시해도 됩니다.
		                </div>
		              </div>
		            </td>
		          </tr>
	
		          <tr>
		            <td style="padding:16px 28px;background:#f9fafb;color:#6b7280;font-size:11px;line-height:1.6;">
		              © Mohaeng. All rights reserved.<br>
		              이 메일은 발신 전용입니다.
		            </td>
		          </tr>
	
		        </table>
		      </td>
		    </tr>
		  </table>
		</body>
		</html>
		""".formatted(safeName, tempPassword, profileUrl);
	}

	/**
	 * <p>임시 비밀번호 사용 여부를 해제한다.</p>
	 * @date 2026.01.09
	 * @author kdrs
	 * @param memNo 회원 번호
	 * @param tempPwYn 임시 비밀번호 사용 여부 ('Y' / 'N')
	 */
	@Override
	@Transactional
	public void updateTempPwYn(int memNo, String tempPwYn) {
		
		 int result = memberMapper.updateTempPwYn(memNo, tempPwYn);

		    if (result <= 0) {
		        throw new RuntimeException("임시 비밀번호 상태 변경 실패");
		    }
		
	}

	@Override
	public void setPasswordForSnsUser(int memNo, String newPassword) {
	    String encoded = passwordEncoder.encode(newPassword);
	    memberMapper.updatePassword(memNo, encoded);
	    memberMapper.updateTempPwYn(memNo, "N"); // 안전
		
	}

	@Override
	@Transactional
	public void updateSnsMemberProfile(MemberUpdateDTO updateDTO) {
		if (updateDTO.getMemName() == null || updateDTO.getMemName().isBlank()) {
	        throw new IllegalArgumentException("SNS 회원은 이름 필수");
	    }

	    int memNo = updateDTO.getMemNo();

	    // 2️⃣ MEMBER 업데이트 (이름, 이메일 등)
	    memberMapper.updateSnsProfile(updateDTO);

	    // 3️⃣ MEM_USER 존재 여부 확인
	    MemUserVO existing = memberMapper.selectMemUserByMemNo(memNo);

	    if (existing == null) {
	        // 🔥 최초 SNS Complete → INSERT
	        MemUserVO memUser = new MemUserVO();
	        memUser.setMemNo(memNo);
	        memUser.setNickname(updateDTO.getNickname());
	        memUser.setTel(updateDTO.getTel());
	        memUser.setBirthDate(updateDTO.getBirthDate());
	        memUser.setGender(updateDTO.getGender());
	        memUser.setZip(updateDTO.getZip());
	        memUser.setAddr1(updateDTO.getAddr1());
	        memUser.setAddr2(updateDTO.getAddr2());

	        log.error("🔥🔥🔥 SNS MEM_USER INSERT 진입 memNo={}", memNo);
	        memberMapper.insertMemUser(memUser);
	    } else {
	        // 🔁 재진입 → UPDATE
	        memberMapper.updateMemUser(existing);
	    }
		
	}

	@Override
	public void updateJoinCompleteYn(int memNo, String joinCompleteYn) {
		int updated = memberMapper.updateJoinCompleteYn(memNo, "Y");

	    if (updated != 1) {
	        throw new RuntimeException("SNS 가입 완료 처리 실패");
	    }
		
	}

	@Override
	public MemberVO selectByMemNo(int memNo) {
		return memberMapper.selectByMemNo(memNo);
	}

	@Override
	public MemUserVO selectMemUserByMemNo(int memNo) {
		return memberMapper.selectMemUserByMemNo(memNo);
	}

}

