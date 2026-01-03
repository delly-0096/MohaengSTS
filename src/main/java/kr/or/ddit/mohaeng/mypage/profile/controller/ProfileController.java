package kr.or.ddit.mohaeng.mypage.profile.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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
import kr.or.ddit.mohaeng.login.service.IMemberService;
import kr.or.ddit.mohaeng.mypage.profile.dto.MemberUpdateDTO;
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
	
    /* 내 정보 조회 */
    @GetMapping("/profile")
    public String myProfile(HttpSession session, Model model) {

        Object authMember = session.getAttribute("loginMember");
        if (authMember == null) {
            return "redirect:/member/login";
        }

        String memId = null;

        if (authMember instanceof MemberVO) {
            memId = ((MemberVO) authMember).getMemId();
        } else if (authMember instanceof Map) {
            Object idObj = ((Map<?, ?>) authMember).get("memId");
            if (idObj != null) {
                memId = String.valueOf(idObj);
            }
        }


        if (memId == null || memId.isBlank()) {
            // 세션 관리
            session.invalidate();
            return "redirect:/member/login";
        }

        // 회원 기본 정보 조회
        MemberVO memberDetail = memberService.findById(memId);

        if (memberDetail == null) {
            session.invalidate();
            return "redirect:/member/login";
        }

        model.addAttribute("member", memberDetail);

        if (memberDetail.getMemProfile() != null) {
            AttachFileDetailVO profileFile =
                    fileSerivce.getProfileFile(memberDetail.getMemProfile());

            if (profileFile != null) {
                model.addAttribute("profileImgUrl", profileFile.getFilePath().replace("/resources/upload", "/upload"));
            }
        }

        return "mypage/profile";
    }


	
	/*정보 수정 기능*/
	@PostMapping("/profile/update")
	public String updateProfile(@ModelAttribute MemberUpdateDTO updateDTO, 
								HttpSession session, RedirectAttributes rttr) {
		log.info("DTO 데이터 확인: " + updateDTO);
		
		// 1. 세션에서 꺼내기 (특정 타입으로 단정짓지 않음)
	    Object sessionObj = session.getAttribute("loginMember");
	    
	    if (sessionObj == null) {
	        return "redirect:/member/login";
	    }

	    String memId = "";
	    int memNo = 0;

	    // 2. 타입에 따라 안전하게 데이터 추출
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

	    // 3. 비밀번호 확인을 위해 DB에서 최신 정보 조회 (Map에는 비번이 없을 수 있으므로)
	   MemberVO memberDetail = memberService.findById(memId);

	    if (!passwordEncoder.matches(updateDTO.getCurrentPassword(), memberDetail.getMemPassword())) {
	        rttr.addFlashAttribute("error", "현재 비밀번호가 일치하지 않습니다.");
	        return "redirect:/mypage/profile";
	    }

	    // 데이터 업데이트 진행
	    updateDTO.setMemNo(memNo);	    
	    if (updateDTO.isProfileImageDeleted()) {
	    	fileSerivce.deleteProfileFile(memNo); // 파일 + DB 삭제
	        updateDTO.setMemProfile(null);
	    }

	    memberService.updateMemberProfile(updateDTO);

	    rttr.addFlashAttribute("message", "정보가 성공적으로 수정되었습니다.");
	    return "redirect:/mypage/profile";
		
	}

	
}
