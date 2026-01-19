package kr.or.ddit.mohaeng.admin.memUser.service;

import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

public interface IGeneralService {

	void getMemList(PaginationInfoVO<MemberVO> pagInfoVO);

	MemberVO getMemDetail(int memNo);

	int registerMember(MemberVO member);

	int updateMember(MemberVO member);

	int changePassword(int memNo, String newPassword);

	boolean checkDuplicateId(String memId);

	boolean checkDuplicateEmail(String memEmail);


}
