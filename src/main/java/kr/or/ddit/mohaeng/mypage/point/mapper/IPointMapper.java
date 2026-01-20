package kr.or.ddit.mohaeng.mypage.point.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

@Mapper
public interface IPointMapper {

	// ==================== 조회 기능 ====================

	//회원별 포인트 요약 정보 조회
	PointSummaryVO pointSummary(int memNo);

	//포인트 내역 전체 개수
	int pointHistoryCount(PointSearchVO searchVO);

	//포인트 내역 목록 조회 (페이징)
	List<PointDetailsVO> pointHistory(PointSearchVO searchVO);


	// ==================== 포인트 정책 실행 ====================

	//중복 적립 방지 체크
	int checkDuplEarn(@Param("memNo") int memNo,
 		              @Param("target") String target,
		              @Param("targetId") int targetId);

	//포인트 상세 내역 등록
	void insertPointDetails(PointDetailsVO pointVO);

	//MEMBER 테이블의 POINT 컬럼 업데이트
	void updateMemberPoint(@Param("memNo")int memNo, @Param("amount")int amount);

	//회원의 현재 보유 포인트 조회
	int selectMemberPoint(int memNo);

	//사용 가능한 포인트 목록 조회 (만료일 임박 순)
	List<PointDetailsVO> availablePoints(int memNo);

	//포인트 상세 내역의 잔여 포인트 차감
	void deductRemainPoint(@Param("pointDetailsNo")int pointDetailsNo, @Param("deductAmount")int deductAmount);

	//결제 시 사용한 포인트 조회
	PointDetailsVO usedPoint(@Param("memNo")int memNo, @Param("payNo")int payNo);

	//환불을 위한 원래 포인트 목록 조회 (FIFO)
	List<PointDetailsVO> originPointsForRefund(@Param("memNo")int memNo, @Param("usedDate")Date usedDate);

	//결제로 적립된 포인트 조회
	PointDetailsVO earnPoint(@Param("memNo")int memNo, @Param("payNo")int payNo);

	//회원의 현재 포인트 조회 (별칭용)
	int memberPoint(int memNo);

}
