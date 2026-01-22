package kr.or.ddit.mohaeng.community.travellog.likes.service;

import java.lang.reflect.Method;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.community.travellog.likes.mapper.ILikesMapper;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LikesServiceImpl implements ILikesService {

	private final ILikesMapper likesMapper;

	/**
	 * 로그인 사용자 memNo 추출 - 1) principal에 memNo가 있으면 reflection으로 꺼내보고 - 2) 없으면
	 * authentication.getName() = memId 로 MEMBER에서 memNo 조회
	 */
	@Override
	public Long resolveMemNo(Authentication authentication) {
		if (authentication == null || !authentication.isAuthenticated()
				|| "anonymousUser".equals(String.valueOf(authentication.getPrincipal()))) {
			throw new IllegalStateException("로그인이 필요합니다.");
		}

		Object principal = authentication.getPrincipal();

		// 1) principal.getMemNo()
		Long memNo = tryGetLong(principal, "getMemNo");
		if (memNo != null)
			return memNo;

		// 2) principal.getMember().getMemNo()
		Object memberObj = tryInvoke(principal, "getMember");
		if (memberObj != null) {
			memNo = tryGetLong(memberObj, "getMemNo");
			if (memNo != null)
				return memNo;
		}

		// 3) principal.getMemUser().getMemNo() 등 다양한 케이스
		Object memUserObj = tryInvoke(principal, "getMemUser");
		if (memUserObj != null) {
			memNo = tryGetLong(memUserObj, "getMemNo");
			if (memNo != null)
				return memNo;
		}

		// 4) fallback: username(memId)로 DB 조회
		String memId = authentication.getName();
		Long found = likesMapper.selectMemNoByMemId(memId);
		if (found == null)
			throw new IllegalStateException("회원 정보를 찾을 수 없습니다.");
		return found;
	}

	@Transactional
	@Override
	public boolean toggleLike(Long likesKey, String likesCatCd, Long memNo) {
		int exists = likesMapper.existsLike(likesKey, likesCatCd, memNo);
		if (exists > 0) {
			likesMapper.deleteLike(likesKey, likesCatCd, memNo);
			return false;
		} else {
			likesMapper.insertLike(likesKey, likesCatCd, memNo);
			return true;
		}
	}

	@Override
	public boolean isLiked(Long likesKey, String likesCatCd, Long memNo) {
		return likesMapper.existsLike(likesKey, likesCatCd, memNo) > 0;
	}

	@Override
	public int countLikes(Long likesKey, String likesCatCd) {
		return likesMapper.countLikes(likesKey, likesCatCd);
	}

	// ===== reflection helpers =====
	private Object tryInvoke(Object target, String methodName) {
		try {
			Method m = target.getClass().getMethod(methodName);
			return m.invoke(target);
		} catch (Exception e) {
			return null;
		}
	}

	private Long tryGetLong(Object target, String getterName) {
		Object v = tryInvoke(target, getterName);
		if (v == null)
			return null;
		if (v instanceof Number)
			return ((Number) v).longValue();
		try {
			return Long.valueOf(String.valueOf(v));
		} catch (Exception e) {
			return null;
		}
	}
}
