package kr.or.ddit.mohaeng.admin.report.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.mohaeng.vo.BlacklistVO;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.ReportVO;

@Mapper
public interface IAReportMapper {




	//--- 신고 현황 파악 ----

	//신고 목록을 페이지 단위로 쪼개서 가져옴. (최신순/미처리순 필터링 포함)
	List<ReportVO> getReportList(PaginationInfoVO<ReportVO> pagInfoVO);

	//전체 신고가 몇 건인가? 페이징 버튼의 개수를 결정
	int getReportCount(PaginationInfoVO<ReportVO> pagInfoVO);

	//목록에서 하나를 클릭했을 때, 신고 내용과 신고 대상자를 상세히 보여줌
	ReportVO getReportDetail(Long rptNo);

	//신고 카테고리의 이름들을 공통 코드 테이블에서 불러와서 화면에 표시
	List<CodeVO> getCodeByGroup(String cdgr);


	//--- 판결 및 상태 변경 ----

	//신고 처리가 끝났음을 기록(벌칙 종류, 관리자 메모 등을 업데이트)
	int updateReportProcess(ReportVO reportVO);

	//기각 사유를 적고 종결
	int rejectReport(ReportVO reportVO);

	//제제를 가하기 전 일반회원인지 기업회원인지 조회
	String getMemberType(Long targetMemNo);



	//--- 즉각적인 현장 조치 ----

	//판결이 나오면 나쁜 콘텐츠가 더 이상 노출되지 않도록 각 게시판의 상태를 바꾸는 기능

	void hideProdReview(Long targetNo);

	void hideTripRecord(Long targetNo);

	void hideBoard(Long targetNo);

	void hideComment(Long targetNo);

	void hideChat(Long targetNo);



	//--- 블랙리스트 조치 ----

	//유저를 블랙리스트 명단에 올려서 로그인을 막아 활동을 제한
	void insertBlacklist(BlacklistVO blacklist);

	//오해가 풀렸을 때 블랙리스트에서 풀어주는 기능
	int releaseBlackList(int blacklistNo);

}
