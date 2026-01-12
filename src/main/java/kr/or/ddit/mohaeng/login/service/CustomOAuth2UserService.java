package kr.or.ddit.mohaeng.login.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.MemUserVO;
import kr.or.ddit.mohaeng.vo.MemberAuthVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomOAuth2UserService extends DefaultOAuth2UserService {
	
	@Autowired
	private IMemberMapper memberMapper;
	
	BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
	
	public OAuth2User loadUser(OAuth2UserRequest userRequest) {
		
		OAuth2User oAuth2User = super.loadUser(userRequest);
		
		// provider (google)
		String provider = userRequest
				.getClientRegistration()
				.getRegistrationId()
				.toUpperCase();			// GOOGLE / NAVER
		
		Map<String, Object> attributes = oAuth2User.getAttributes();
		
//		String email = (String) attributes.get("email");
//		String snsId = (String) attributes.get("sub");	//Google 고유 ID
		
	    String email = null;
	    String snsId = null;
	    
	    // provider 분기
	    if ("GOOGLE".equals(provider)) {
	        email = (String) attributes.get("email");
	        snsId = (String) attributes.get("sub");

	    } else if ("NAVER".equals(provider)) {
	        // ⚠️ 네이버는 response 안에 있음
	        Map<String, Object> response =
	                (Map<String, Object>) attributes.get("response");

	        if (response != null) {
	            email = (String) response.get("email");
	            snsId = (String) response.get("id");
	        }
	    }
		
	    if (email == null || snsId == null) {
	        throw new RuntimeException(provider + " OAuth 응답에 필수 값이 없습니다.");
	    }
		
		// 이메일 기준 회원 조회
		MemberVO member = memberMapper.findByEmail(email);
		
		// 없으면 자동 회원가입
		if (member == null) {
			member = createSocialMember(email, snsId, provider);
		}
		
		// CustomUserDetails로 통합
		return new CustomUserDetails(
				member,
				Collections.singleton(new SimpleGrantedAuthority("ROLE_MEMBER")),
				attributes
		);
		
	}

	@Transactional
	private MemberVO createSocialMember(String email, String snsId, String provider) {
		
		MemberVO member = new MemberVO();
	    member.setMemEmail(email);
	    member.setMemId(provider.toLowerCase() + "_" + System.currentTimeMillis());
	    member.setMemPassword(encoder.encode("SOCIAL_LOGIN_" + snsId));
	    member.setMemName("SNS회원_" + snsId.substring(0,5));
	    member.setJoinCompleteYn("N");           
	    member.setTempPwYn("N");
	    member.setMemSnsYn("Y");
	    member.setSnsType(provider);   // GOOGLE
	    member.setSnsId(snsId);        // sub 값
	    member.setEnabled(1);
	    member.setDelYn("N");
	    
	    // 1. MEMBER 테이블 저장
	    memberMapper.insertSocialMember(member);
	    
	    log.info("생성된 번호 체크: {}", member.getMemNo());
	    
	    // 2. 권한 테이블(MEMBER_AUTH) 저장 (여기서 미리 넣어버리기!)
	    // memberVO에 memNo가 selectKey로 담겨온다면 바로 사용
	    memberMapper.insertAuth(member); 
	    
	    List<MemberAuthVO> authList = new ArrayList<>();
	    MemberAuthVO authVO = new MemberAuthVO();
	    authVO.setAuth("ROLE_MEMBER");
	    authList.add(authVO);
	    member.setAuthList(authList);

	    return member;
	}
	
	
	
	
	

}
