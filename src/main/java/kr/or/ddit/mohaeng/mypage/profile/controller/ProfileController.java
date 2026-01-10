package kr.or.ddit.mohaeng.mypage.profile.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
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
    	
    	// DB 최신 정보 조회 (조인 쿼리 findById 사용)
    	MemberVO memberDetail = memberService.findById(memId);
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


	
	/*정보 수정 기능*/
	@PostMapping("/profile/update")
	public String updateProfile(@ModelAttribute MemberUpdateDTO updateDTO, 
								HttpSession session, RedirectAttributes rttr) {
		log.info("DTO 데이터 확인: " + updateDTO);
		
		// 세션에서 꺼내기 (특정 타입으로 단정짓지 않음)
	    Object sessionObj = session.getAttribute("loginMember");
	    
	    if (sessionObj == null) {
	        return "redirect:/member/login";
	    }

	    String memId = "";
	    int memNo = 0;

	    // 타입에 따라 안전하게 데이터 추출
	    if (sessionObj instanceof kr.or.ddit.mohaeng.vo.MemberVO) {
	        kr.or.ddit.mohaeng.vo.MemberVO vo = (kr.or.ddit.mohaeng.vo.MemberVO) sessionObj;
	        memId = vo.getMemId();
	        memNo = vo.getMemNo();
	    } else if (sessionObj instanceof java.util.Map) {
	        java.util.Map<String, Object> map = (java.util.Map<String, Object>) sessionObj;
	        memId = String.valueOf(map.get("memId"));
	        // Map에서 꺼낼 때 Integer 타입 안정성 확인
	        Object noObj = map.get("memNo");
	        memNo = (noObj instanceof Integer) ? (Integer)noObj : Integer.parseInt(String.valueOf(noObj));
	    }

	   // 비밀번호 확인을 위해 DB에서 최신 정보 조회 (Map에는 비번이 없을 수 있으므로)
	   MemberVO memberDetail = memberService.findById(memId);

	    if (!passwordEncoder.matches(updateDTO.getCurrentPassword(), memberDetail.getMemPassword())) {
	        rttr.addFlashAttribute("errorMessage", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:/mypage/profile";
	    }

	    // 데이터 업데이트 진행
	    updateDTO.setMemNo(memNo);	    
	    if (updateDTO.isProfileImageDeleted()) {
	    	fileSerivce.deleteProfileFile(memNo); // 파일 + DB 삭제
	        updateDTO.setMemProfile(null);
	    }

	    memberService.updateMemberProfile(updateDTO);
	    
	    // DB 업데이트 후
	    MemberVO updatedMember = memberService.findById(memId); // 최신 경로 포함
	    String updatedPath = updatedMember.getMemProfilePath();
	    
	    if (updatedPath != null) {
	        updatedPath = updatedPath.replace("/resources", ""); // 경로 가공
	    }

	    // 세션 Map 갱신 (중요!)
	    if (sessionObj instanceof Map) {
	        Map<String, Object> loginMember = (Map<String, Object>) sessionObj;
	        loginMember.put("memProfile", updatedPath); // 가공된 경로 주입
	        loginMember.put("memName", updatedMember.getMemName()); // 이름 변경 시 대비
	    }

	    // 4. 시큐리티 권한 갱신 (기존 로직 유지)
	    CustomUserDetails newUserDetails = new CustomUserDetails(updatedMember);
	    Authentication newAuth = new UsernamePasswordAuthenticationToken(
	            newUserDetails, null, newUserDetails.getAuthorities()
	    );
	    SecurityContextHolder.getContext().setAuthentication(newAuth);
	   
	    rttr.addFlashAttribute("successMessage", "정보가 성공적으로 수정되었습니다.");
	    return "redirect:/mypage/profile";
		
	}

	
	
}
