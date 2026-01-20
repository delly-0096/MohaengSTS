package kr.or.ddit.mohaeng.admin.memUser.service;

import java.io.OutputStream;
import java.util.List;

import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IGeneralService {

	// 일반회원 목록 조회 (페이징, 검색, 필터)
	void getMemList(PaginationInfoVO<MemberVO> pagInfoVO);

	// 일반회원 상세 조회
	MemberVO getMemDetail(int memNo);

	// 일반회원 등록
	int registerMember(MemberVO member);

	// 일반회원 정보 수정
	int updateMember(MemberVO member);

	// 비밀번호 변경
	int changePassword(int memNo, String newPassword);

	// 아이디 중복 체크
	boolean checkDuplicateId(String memId);

	// 이메일 중복 체크
	boolean checkDuplicateEmail(String memEmail);

	//[code관련 추가] 코드 조회
	List<CodeVO> getCodeListByGroup(String cdgr);

	// 엑셀 다운로드
	void downloadMemberExcel(OutputStream outputStream, PaginationInfoVO<MemberVO> pagInfoVO);
	//cf) ServletOutputStream(서버 전용 특수 미끄럼틀) vs OutputStream(미끄럼틀)
	//보통은 더 넓은 의미인 OutputStream을 많이 써. 그래야 나중에 미끄럼틀이 바뀌어도 코드를 고치지 않아도 되기 때문.


}
