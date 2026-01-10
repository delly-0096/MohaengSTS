package kr.or.ddit.mohaeng.login.service;

import java.util.Collections;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.vo.MemberVO;

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
				.toUpperCase();			// GOOGLE
		
		Map<String, Object> attributes = oAuth2User.getAttributes();
		
		String email = (String) attributes.get("email");
		String snsId = (String) attributes.get("sub");	//Google 고유 ID
		
		if (email == null) {
			throw new RuntimeException("Google OAuth 응답에 email이 없습니다.");
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

	private MemberVO createSocialMember(String email, String snsId, String provider) {
		
		MemberVO member = new MemberVO();
		member.setMemEmail(email);
		member.setMemId(provider.toLowerCase() + "_" + System.currentTimeMillis());
		member.setMemPassword(
				encoder.encode("SOCIAL_LOGIN_" + snsId)
				);
		member.setMemName("SNS회원");
		member.setMemSnsYn("Y");
		member.setSnsType(provider);
		member.setSnsId(snsId);
		member.setTempPwYn("N");
		member.setEnabled(1);
		member.setDelYn("N");
		
		memberMapper.insertSocialMember(member);
		
		return memberMapper.findByEmail(email);
	}
	
	
	
	
	
	

}
