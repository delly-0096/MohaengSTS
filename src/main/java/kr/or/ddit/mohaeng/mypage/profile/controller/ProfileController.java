package kr.or.ddit.mohaeng.mypage.profile.controller;

import java.util.Collection;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.mypage.profile.dto.MemberUpdateDTO;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.AttachFileDetailVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage")
public class ProfileController {

	@Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private IFileService fileSerivce;
    
    @Autowired
    private IMemberService memberService;
    
    @Autowired
    private IMemberMapper memberMapper;
	
    /* 일반회원 내 정보 조회 */
    @GetMapping("/profile")
    public String myProfile(HttpSession session, Model model) {

    	// 1. 세션 체크
        Object authMember = session.getAttribute("loginMember");
        if (authMember == null) return "redirect:/member/login";

        String memId = "";
        if (authMember instanceof MemberVO) {
            memId = ((MemberVO) authMember).getMemId();
        } else if (authMember instanceof Map) {
            memId = String.valueOf(((Map<?, ?>) authMember).get("memId"));
        }

        if (memId == null || memId.isBlank()) {
            session.invalidate();
            return "redirect:/member/login";
        }

        // 2. DB 최신 정보 조회 (조인 쿼리 findById 사용)
        MemberVO memberDetail = memberService.findById(memId);
        if (memberDetail == null) {
            session.invalidate();
            return "redirect:/member/login";
        }

        // 3. 경로 가공 및 세션 동기화 (핵심!)
        String rawPath = memberDetail.getMemProfilePath(); 
        String processedPath = null;

        if (rawPath != null && !rawPath.isEmpty()) {
            processedPath = rawPath.replace("/resources", "");
        }

        // 세션 Map 업데이트 (헤더/사이드바 즉시 반영용)
        if (authMember instanceof Map) {
            Map<String, Object> loginMember = (Map<String, Object>) authMember;
            loginMember.put("memProfile", processedPath);
        }

        model.addAttribute("member", memberDetail);
        model.addAttribute("profileImgUrl", processedPath); // 본문용

        return "mypage/profile";
    }
    
    /* 기업회원 내 정보 조회 */
    @GetMapping("/business/profile")
    public String myProfileBusiness(HttpSession session, Model model) {
    	  	
    	
    	Object authMember = session.getAttribute("loginMember");
    	if (authMember == null) return "redirect:/member/login";
    	
    	String memId = "";
    	if (authMember instanceof MemberVO) {
    		memId = ((MemberVO) authMember).getMemId();
    	} else if (authMember instanceof Map) {
    		memId = String.valueOf(((Map<?, ?>) authMember).get("memId"));
    	}
    	
    	if (memId == null || memId.isBlank()) {
    		session.invalidate();
    		return "redirect:/member/login";
    	}
    	
    	// DB 최신 정보 조회 (조인 쿼리 findById 사용)
    	MemberVO memberDetail = memberService.findByCompId(memId);
    	if (memberDetail == null) {
    		session.invalidate();
    		return "redirect:/member/login";
    	}

    	// 경로 가공 및 세션 동기화
    	String rawPath = memberDetail.getMemProfilePath(); 
    	String processedPath = null;
    	
    	if (rawPath != null && !rawPath.isEmpty()) {
    		processedPath = rawPath.replace("/resources", "");
    	}
    	
    	// 세션 Map 업데이트 (헤더/사이드바 즉시 반영용)
    	if (authMember instanceof Map) {
    		Map<String, Object> loginMember = (Map<String, Object>) authMember;
    		loginMember.put("memProfile", processedPath);
    	}
    	
    	model.addAttribute("member", memberDetail);
    	model.addAttribute("profileImgUrl", processedPath); // 본문용
    	
    	return "mypage/business/profile";
    }


	
	/* 정보 수정 기능 */
	@PostMapping("/profile/update")
	public String updateProfile(@ModelAttribute MemberUpdateDTO updateDTO, 
								HttpSession session, RedirectAttributes rttr) {
		
		log.info("DTO 데이터 확인: " + updateDTO);

		// 인증 정보 획득
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	    if (auth == null || !(auth.getPrincipal() instanceof CustomUserDetails)) {
	        return "redirect:/member/login";
	    }

	    CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
	    String memId = userDetails.getUsername();
	    int memNo = userDetails.getMember().getMemNo();

	    // 권한에 따른 리다이렉트 경로 설정
	    boolean isBusiness = auth.getAuthorities().stream()
	            .anyMatch(a -> a.getAuthority().equals("ROLE_BUSINESS"));
	    String redirectUrl = isBusiness ? "/mypage/business/profile" : "/mypage/profile";
	 
	    // 현재 비밀번호 검증 (DB 조회)
	    MemberVO memberDetail = memberService.findById(memId);
	    if (memberDetail == null || !passwordEncoder.matches(updateDTO.getCurrentPassword(), memberDetail.getMemPassword())) {
	        rttr.addFlashAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:" + redirectUrl;
	    }
	    
	    try {
	    // 비밀번호 변경 처리 (입력값이 있을 때만)
        if (updateDTO.getNewPassword() != null && !updateDTO.getNewPassword().isBlank()) {
            if (!updateDTO.getNewPassword().equals(updateDTO.getConfirmPassword())) {
                rttr.addFlashAttribute("errorMessage", "새 비밀번호 확인이 일치하지 않습니다.");
                return "redirect:" + redirectUrl;
            }
            memberService.changePassword(memNo, updateDTO.getCurrentPassword(), updateDTO.getNewPassword());
        }
	    
        // 프로필 정보 업데이트
        updateDTO.setMemNo(memNo);
        if (updateDTO.isProfileImageDeleted()) {
            fileSerivce.deleteProfileFile(memNo);
            updateDTO.setMemProfile(null);
        }
        
        memberService.updateMemberProfile(updateDTO, isBusiness);
	    
        // SecurityContext 갱신 (세션 정보 최신화)
        MemberVO updatedMember = isBusiness ? memberService.findByCompId(memId) : memberService.findById(memId);
        
        // 경로 가공 (Service에서 처리하는 것을 권장하지만, 유지한다면 여기서 수행)
        if (updatedMember.getMemProfilePath() != null) {
            updatedMember.setMemProfilePath(updatedMember.getMemProfilePath().replace("/resources", ""));
        }

        CustomUserDetails newUserDetails = new CustomUserDetails(updatedMember);

	     // 생성자 내부에서 권한을 세팅하지 않는다면, 수동으로 기존 권한을 넣어줍니다.
	     Authentication newAuth = new UsernamePasswordAuthenticationToken(
	             newUserDetails, 
	             auth.getCredentials(), 
	             auth.getAuthorities() // DB 재조회 대신 기존에 검증된 권한을 재사용
	     );
	
	     SecurityContextHolder.getContext().setAuthentication(newAuth);

        rttr.addFlashAttribute("successMessage", "정보가 성공적으로 수정되었습니다.");
        
    } catch (Exception e) {
        log.error("프로필 수정 중 오류 발생: ", e);
        rttr.addFlashAttribute("errorMessage", "수정 중 오류가 발생했습니다: " + e.getMessage());
    }

    return "redirect:" + redirectUrl;
		
	}
	
	// 비밀번호 확인 시 체크
	@PostMapping("/profile/checkPassword")
	@ResponseBody
	public boolean checkPassword(@RequestParam String currentPassword) {
		
		log.info("checkPassword()==================== 실행 중");

		Authentication auth  = SecurityContextHolder.getContext().getAuthentication();
		CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
		
		// DB에서 현재 비밀번호 정보 가져오기
		MemberVO member = memberService.findById(userDetails.getUsername());
		return passwordEncoder.matches(currentPassword, member.getMemPassword());
		
	}
	
	@PostMapping("/profile/withdraw")
	public String withdraw(@RequestParam String currentPassword,
						   @RequestParam String withdrawReason,
							Authentication auth,
							HttpSession session,
							RedirectAttributes rttr) {
		
		CustomUserDetails userDetails= (CustomUserDetails) auth.getPrincipal();
		int memNo = userDetails.getMember().getMemNo();
		
		try {
			
			// 서비스 호출
			memberService.withdrawMember(memNo, currentPassword, withdrawReason);
			
			SecurityContextHolder.clearContext();	//인증 정보 삭제
			if (session != null) {
				session.invalidate();				// 세션 무효화
			}
			
			rttr.addFlashAttribute("successMessage", "회원 탈퇴가 정상적으로 처리되었습니다");
			return "redirect:/";		// 메인으로 이동
			
		} catch (Exception e) {
			log.error("탈퇴 처리 중 에러 발생: {}", e.getMessage());
			rttr.addFlashAttribute("errorMessage", e.getMessage());
			return "redirect:/mypage/profile";
		}
		
	}
}
