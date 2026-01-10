package kr.or.ddit.mohaeng.util;

import java.time.Duration;
import java.util.Date;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.or.ddit.mohaeng.security.CustomUserDetails;
import kr.or.ddit.mohaeng.security.CustomUserDetailsService;
import kr.or.ddit.mohaeng.vo.MemAdminVO;
import kr.or.ddit.mohaeng.vo.CustomUser;
import kr.or.ddit.mohaeng.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TokenProvider {

	@Autowired
	private CustomUserDetailsService userDetailsService;

	@Autowired
	private JwtProperties jwtProperties;

	// 토큰 발급
	public String generateToken(MemberVO member, Duration expired) {
		Date now = new Date();
		return makeToken(new Date(now.getTime() + expired.toMillis()), member);
	}

	// 토큰 생성
	public String makeToken(Date expired, MemberVO member) {
		Date now = new Date();
		return Jwts.builder()
				.setHeaderParam(Header.TYPE, Header.JWT_TYPE)
				.setIssuer(jwtProperties.getIssuer())
				.setIssuedAt(now)
				.setExpiration(expired)
				.setSubject(member.getMemId())

				.claim("no", member.getMemNo())
				.claim("id", member.getMemId())
				.claim("auth", member.getAuthList())
				.signWith(SignatureAlgorithm.HS256, jwtProperties.getSecretKey().getBytes())
				.compact();
	}


	// 토큰 유효성 검사
	public boolean validToken(String token) {
		Jws<Claims> parseToken = null;
		try {
			parseToken = Jwts.parser().setSigningKey(jwtProperties.getSecretKey().getBytes())
					.parseClaimsJws(token);
		}catch (Exception e) {
			return false;
		}

		Date exp = parseToken.getBody().getExpiration();	// 유효기간
		return !exp.before(new Date());	// 현재 날짜보다 앞이면 false
	}

	// 인증 정보 가져오기
	public Authentication getAuthentication(String token) {
		String memId = getUserId(token);
		UserDetails userDetails = userDetailsService.loadUserByUsername(memId);                    
		
		MemberVO member = ((CustomUserDetails) userDetails).getMember();
				 
		return new UsernamePasswordAuthenticationToken(userDetails, "", 

				member.getAuthList().stream()
				.map(auth -> new SimpleGrantedAuthority(auth.getAuth())).
				collect(Collectors.toList()));

		 return new UsernamePasswordAuthenticationToken(
			        userDetails,
			        "",
			        userDetails.getAuthorities()
			    );

	}

	private String getUserId(String token) {
		Claims claims = getClaims(token);
		return claims.get("id", String.class);
	}

	private Claims getClaims(String token) {
		return Jwts.parser()
				.setSigningKey(jwtProperties.getSecretKey().getBytes())
				.parseClaimsJws(token)
				.getBody();
	}

}
