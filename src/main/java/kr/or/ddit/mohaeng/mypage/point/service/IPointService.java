package kr.or.ddit.mohaeng.mypage.point.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

/**
 * 일반 회원 마이페이지 포인트 서비스 인터페이스
 */
public interface IPointService {

	//조회를 담당하는 기존 메서드//

	/**
     * 회원의 포인트 요약 정보 조회
     * @return 포인트 요약 VO
     */
	PointSummaryVO pointSummary(int memNo);

	/**
     * 페이징 처리를 위한 회원의 포인트 내역 전체 개수 조회
     * @return 내역 전체 개수
     */
	int pointHistoryCount(PointSearchVO searchVO);

	/**
     * 회원의 포인트 상세 내역 리스트 조회
     * @return 포인트 상세 내역 리스트
     */
	List<PointDetailsVO> pointHistory(PointSearchVO searchVO);



	// < 여기서부터는 포인트 정책에 따라 추가된 메서드 > //

	 /**
     * [정책 반영 - 적립]
     * @param memNo 회원번호
     * @param target 적립 대상 테이블명 (MEMBER, TRIP_RECORD, PAYMENT, PROD_REVIEW)
     * @param targetId 대상 테이블의 PK(적립의 근거. 어떤 활동을 통해 포인트를 받았는지 ex)리뷰를 썼네? → 과녁(target)은 '리뷰', 과녁번호(targetId)는 '10번 리뷰글')
     * @param amount 적립 포인트
     * @param desc 적립 설명
     */
    public void earnPoint(int memNo, String target, int targetId, int amount, String desc);


    /**
     * [정책 반영 - 사용]
     * - 3,000P 이상 조건 체크
     * - FIFO 차감 로직 (만료일 임박한 순서대로)
     * @param memNo 회원번호
     * @param useAmount 사용 포인트
     * @param targetId 결제번호 (PAY_NO) : (사용의 출처. 이 포인트가 어떤 결제에 사용됬는지)
     * @return 성공 여부 및 메시지 : 실패 확률이 높기 때문에(ex)잔액부족, 최소조건 미달 등) true/false가 아닌
     *          이유(메세지) 담아 보내기 위해 Map선택함. { "success": false, "message": "3,000포인트 이상부터 사용 가능합니다." }
     */
    public Map<String, Object> usePoint(int memNo, int useAmount, int targetId);


      //환불과 회수는 세트임//

    /**
     * [정책 반영 - 환불]
     * - 원칙1: 소멸 확정형 복구 (원래 만료일 유지)
     * - 원칙2: 부족 포인트 현금 차감
     * @param memNo 회원번호
     * @param payNo 결제번호
     * @return 환불 정보 (복구 포인트, 현금 차감액 등) 상세 내역을 알려주기 위해.ex){ "recoveredPoint": 800, "expiredPoint": 200, "cashDeduction": 0 }
     */
    public Map<String, Object> refundPoint(int memNo, int payNo);

    /**
     * [정책 반영 - 회수]
     * 상품구매 적립 포인트 회수 (환불 시)
     * @param memNo 회원번호 "누구 지갑에서 포인트를 뺏어올까?"
     * @param payNo 결제번호 "어떤 결제 건 때문에 줬던 포인트를 뺏는 건가? (결제 정보를 알아야 얼마를 줬었는지 알 수 있으니까)"
     * @return 회수 정보 (회수 포인트, 현금 차감액 등)
     *  ex){ "retrievedPoint": 0, "cashDeduction": 100 } : "포인트는 못 뺏었고, 대신 현금에서 100원 깠습니다!"
     */
     public Map<String, Object> retrievePoint(int memNo, int payNo);


     /**
      * [결제 시 포인트 사용 기록]
      * @param memNo 회원번호
      * @param payNo 결제번호
      * @param useAmount 사용 포인트
      */
     public void recordPointUse(int memNo, int payNo, int useAmount);

}
