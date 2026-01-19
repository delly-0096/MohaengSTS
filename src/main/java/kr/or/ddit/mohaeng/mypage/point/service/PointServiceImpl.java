package kr.or.ddit.mohaeng.mypage.point.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.mypage.point.mapper.IPointMapper;
import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PointServiceImpl implements IPointService {

	@Autowired
	private IPointMapper pointMapper;


	// ==================== 조회 기능 ====================

	@Override
	public PointSummaryVO pointSummary(int memNo) {
		// 요약정보 가져오기
		return pointMapper.pointSummary(memNo);
	}

	@Override
	public int pointHistoryCount(PointSearchVO searchVO) {
		// 전체 개수 파악하기
		return pointMapper.pointHistoryCount(searchVO);
	}

	@Override
	public List<PointDetailsVO> pointHistory(PointSearchVO searchVO) {
		// 실제 데이터 리스트 가져오기
		return pointMapper.pointHistory(searchVO);
	}

    // ==================== 포인트 정책 실행 ====================

	/**
	 [포인트 적립]

	 - 회원가입 : 5000p(1회)
	 - 여행기록 : 첫 1000p / 이후 500P (일정당 1회)
	 - 상품구매: 3% (이용 완료 시)
	 - 상품리뷰: 500P (주문번호당 1회)
	 */
	@Override
	@Transactional
	public void earnPoint(int memNo, String target, int targetId, int amount, String desc) {
		// 1. 중복 적립 방지 체크
		//mapper에게 db에서 이 회원이, 어떤 테이블에서, 어떤 것으로 인해 포인트를 받아간 적이 있는지 알아보게 시킴
		int duplCount = pointMapper.checkDuplEarn(memNo, target, targetId);
		//[판단 및 거절]
		if (duplCount >0) throw new RuntimeException("이미 적립된 내역입니다.");

		// 2. 포인트 내역 생성
		PointDetailsVO pointVO = new PointDetailsVO();
		pointVO.setMemNo(memNo);
		pointVO.setPointType("P");    // 포인트 증감유형
		pointVO.setPointAmt(amount);  // 변동 포인트
		pointVO.setPointDesc(desc);
		pointVO.setPointTarget(target);  // 포인트 발생 테이블명
		pointVO.setPointTargetId(targetId); //어떤 사건(주문/일정) 때문인가?
		pointVO.setRemainPoint(amount); //초기잔액 = 적립액. 나중에 **FIFO(선입선출)**를 하려고 '남은 돈'을 따로 관리
		//(추가 설명) setRemainPoint: 처음 적립할 때 **"적립액(amount)"**과 **"남은금액(remainPoint)"**을 똑같이 세팅해두고, 나중에 쓸 때마다 remainPoint만 깎음

		// 만료일: 적립일 + 180일
        // (SQL에서 SYSDATE + 180 처리 예정)

		// 3. POINT_DETAILS 테이블에 적립 내역 저장
		pointMapper.insertPointDetails(pointVO);

		// 4. MEMBER 테이블의 POINT 컬럼 업데이트 (잔액 추가)
		pointMapper.updateMemberPoint(memNo, amount);
		/*
		 포인트 시스템은 두번의 기록이 필요함. 1)상세장부에 적는것과(pointDetails) 2)총액 지갑을 최신화 하는 것(member테이블의 point).

		 EX)통장 내역: [1월 15일 / 입금 / 5,000원] 👈 이게 아까 만든 PointDetailsVO를 insert 하는 과정!
     		메인 화면 잔액: [현재 잔액 : 105,000원] 👈 이게 바로 updateMemberPoint를 하는 과정!

		    만약 상세 내역만 적고 총액을 안 고치면, 손님이 "나 아까 5천원 받았는데 왜 내 잔액은 그대로야?!"라고 항의함. 그래서 **지갑(MEMBER 테이블)**도 반드시 업데이트해줘야 합니다.
		 */
	}

	/**
	 [포인트 사용]
	 - 3,000P 이상 보유 시만 사용 가능
	 - FIFO 차감 (만료일 임박한 순서)
	 */
	@Override
	@Transactional
	public Map<String, Object> usePoint(int memNo, int useAmount, int targetId) {
		Map<String, Object> result = new HashMap<>();

		//1. 현재 보유 포인트 조회
		int currentPoint = pointMapper.selectMemberPoint(memNo);

		//2. 사용 조건 체크(3000p 이상)
		if (currentPoint<3000) {
			result.put("success", false);
			result.put("message", "포인트는 3000P 이상 보유 시 사용 가능합니다.");
			return result;
		}

		//3. 잔액 부족 체크
		if (currentPoint<useAmount) {
			result.put("success", false);
			result.put("message", "보유 포인트가 부족합니다.");
			return result;
		}

		//4. FIFO 차감 로직(만료 임박순으로 차감)
		int remainToSubtract = useAmount; //  ex) 3000p = 3000p

		//만료일 임박순으로 포인트 조회
		List<PointDetailsVO> availablePoints = pointMapper.availablePoints(memNo);

		// 유통기간 빠른 순서대로 포인트 봉투 하나씩 꺼내기
		for(PointDetailsVO point : availablePoints) {
			if (remainToSubtract<=0) break; // 빼야 할 돈이 0이 되면 그만 꺼내고 나가기

			//[용어 정리] deductAmount: 차감 할 금액. point.getRemainPoint(): 꺼낸 포인트 봉투 1개에 들어있는 포인트 금액
			// 꺼낸 포인트 봉투 금액(ex)500p)과 내야할 돈 비교(ex)3000p) 해서 작은게 deductAmount(500p)
			int deductAmount = Math.min(point.getRemainPoint(), remainToSubtract);

			//해당 포인트 레코드의 REMAIN_POINT차감
			/* mapper에게 남은 포인트를 깎으라(deductRemainPoint) 명령서 보냄.
			   괄호안 데이터는 구체적인 정보->point.getPointDetailsNo(): 어떤 것의 포인트를 깎을까? deductAmount: 얼마나 깎을까? */
			pointMapper.deductRemainPoint(point.getPointDetailsNo(),deductAmount);

			remainToSubtract -= deductAmount;
		}
		//5. 사용 내역 기록
		PointDetailsVO useVO = new PointDetailsVO();
		useVO.setMemNo(memNo);
		useVO.setPointType("M");
		useVO.setPointAmt(-useAmount); //음수로 저장
		useVO.setPointDesc("포인트 사용(결제)");
		useVO.setPointTarget("PAYMENT");
		useVO.setPointTargetId(targetId);
		useVO.setRemainPoint(0); //사용은 잔액 0

		//db에 useVO내용 insert
		pointMapper.insertPointDetails(useVO);

		//6. MEMBER테이블의 POINT 컬럼 차감
		pointMapper.updateMemberPoint(memNo, -useAmount);
		result.put("success", true);
		result.put("useAmount", useAmount);  //사용자에게 금액보고
		return result;
	}

	 /**
     [환불 시 포인트 복구(+): 사용 취소]
     - 원칙1: 원래 만료일 유지 (소멸 확정형)
     */
	@Override
	@Transactional
	public Map<String, Object> refundPoint(int memNo, int payNo) {
		Map<String, Object> result = new HashMap<>();

		//1. 결제 시 사용한 포인트가 있는지 조회
		PointDetailsVO usedPoint = pointMapper.usedPoint(memNo, payNo);

		if (usedPoint == null || usedPoint.getPointAmt()>=0) { //포인트 사용내역이 없거나, 포인트 사용금액이 음수가 아닌 경우(결제 안했음)
			result.put("success", false);
			result.put("message", "사용한 포인트 내역이 없습니다.");
			return result;
		}
		//돌려줄 포인트의 절대값 (-3000p를 3000p라고 씀)
		int refundAmount = Math.abs(usedPoint.getPointAmt());

		//2. 결제 시점으로 돌아가 사용했던 원래 포인트들의 만료일 조회(FIFO 순서) -> 그래야 다시 그 포인트 들에게 돌려줄 수 있으므로
		List<PointDetailsVO> originPoints = pointMapper.originPointsForRefund(memNo, usedPoint.getRegDt());

		//3. 복구 처리:채워야 할 금액을 변수에 담음
		int remainRefund = refundAmount;

		for (PointDetailsVO origin : originPoints) {
			if (remainRefund <=0) break;

			//만료일 체크 : (지금 시각을 기준으로 이 포인트의 수명이 끝났는지 확인. 지났으면 즉기 소멸 처리)
			Date now = new Date();
			if (origin.getPntExpireDt() != null && origin.getPntExpireDt().before(now)) {


				// -- 이미 유통기한이 지난 포인트인 경우 --

				//[형식상 복구 기록만 남김(+)]
				PointDetailsVO restoreVO = new PointDetailsVO();
				restoreVO.setMemNo(memNo);
				restoreVO.setPointType("P");
				restoreVO.setPointAmt(origin.getRemainPoint());
				restoreVO.setPointDesc("환불로 인한 포인트 복구 (즉시 소멸)");
				restoreVO.setPointTarget("REFUND_LOG");
				restoreVO.setPointTargetId(payNo);
				restoreVO.setRemainPoint(0); //즉시 소멸
				restoreVO.setPntExpireDt(origin.getPntExpireDt());// 원래 만료일
				pointMapper.insertPointDetails(restoreVO);

				//[복구하자마자 바로 소멸기록 남김(-)]
				PointDetailsVO expireVO = new PointDetailsVO();
				expireVO.setMemNo(memNo);
				expireVO.setPointType("M");
				expireVO.setPointAmt(-origin.getRemainPoint());// 다시 뺏기
				expireVO.setPointDesc("유효기간 만료");
				expireVO.setRemainPoint(0);
				pointMapper.insertPointDetails(expireVO);

				remainRefund -= origin.getRemainPoint();
				continue; // 이 포인트는 죽었으니 다음 포인트로 gogo~
			}


			    // -- 아직 유통기한이 남은 포인트인 경우 --

			// 내가 환불해 줘야 할 금액과 잔액 중 적은 금액 선택
			int restoreAmount = Math.min(origin.getRemainPoint(), remainRefund);

			//[진짜 복구 기록 남기기(+)]
			PointDetailsVO restoreVO = new PointDetailsVO();
			restoreVO.setMemNo(memNo);
			restoreVO.setPointType("P");
			restoreVO.setPointAmt(restoreAmount);
			restoreVO.setPointDesc("환불로 인한 포인트 복구");
			restoreVO.setPointTarget("REFUND_LOG");
			restoreVO.setPointTargetId(payNo);
			restoreVO.setRemainPoint(restoreAmount);
			restoreVO.setPntExpireDt(origin.getPntExpireDt()); //원래 만료일

			//사용기록
			pointMapper.insertPointDetails(restoreVO);
			//member의 point에 채우기
			pointMapper.updateMemberPoint(memNo, restoreAmount);

			// 차감하고 다음 봉투로 넘어가기
			remainRefund -= restoreAmount;
		}

		result.put("success", true);
		result.put("refundAmount", refundAmount);
		return result;
	}

    /**
     [환불 시 적립 포인트 회수(-): 적립 취소]
     * - 원칙2: 부족 시 현금 차감
     */
	@Override
	@Transactional
	public Map<String, Object> retrievePoint(int memNo, int payNo) {
		//결과 보고 주머니
		Map<String, Object> result = new HashMap<>();

		//1. 해당 결제(payNo)로 적립된 포인트 금액 조회
		PointDetailsVO earnPoint = pointMapper.earnPoint(memNo, payNo);

		//적립한게 없으면 통과~!
		if (earnPoint == null) {
			result.put("success", true);
			result.put("retrievedPoint", 0); //회수된 포인트가 0원이라는 뜻
			result.put("deductCash", 0); //깍인 환불금이 0원이라는 뜻
			return result;
		}

		//상태 파악 : 가져와야 할 돈과, 현재 이 회원의 잔액 비교
		int earnAmount = earnPoint.getPointAmt(); //가져올 목표 금액
		int currentPoint = pointMapper.memberPoint(memNo); //실제 지갑 잔액

		//2. 회수 가능 여부 판단
		if (currentPoint >= earnAmount) { //지갑에 가져올 돈이 충분한가?

			//---[전액 회수 가능시]---
			PointDetailsVO retrieveVO = new PointDetailsVO();
			retrieveVO.setMemNo(memNo);
			retrieveVO.setPointType("M");
			retrieveVO.setPointAmt(-earnAmount);
			retrieveVO.setPointDesc("환불로 인한 포인트 회수");
			retrieveVO.setPointTarget("REFUND_LOG");
			retrieveVO.setPointTargetId(payNo);
			retrieveVO.setRemainPoint(0);

			//기록 남기고 실제member에서도 전액 차감
			pointMapper.insertPointDetails(retrieveVO);
			pointMapper.updateMemberPoint(memNo, -earnAmount);

			result.put("success", true);
			result.put("retrievedPoint", earnAmount);// 회수 성공한 금액
			result.put("deductCash", 0);// 포인트로 다 해결됐으니 현금 차감은 0원

		} else {
			//돈이 모자라서---[부분회수 + 현금 차감]---

			//일단 있는 포인트 다 가져오고,
			int retrievePoint = currentPoint;
			//회수 못한 금액
			int deductCash = earnAmount - currentPoint;

			// 있는 포인트만큼만 가져오는 기록 남기기
			if (retrievePoint > 0) {
				PointDetailsVO retrieveVO = new PointDetailsVO();
				retrieveVO.setMemNo(memNo);
				retrieveVO.setPointType("M");
				retrieveVO.setPointAmt(-retrievePoint);
				retrieveVO.setPointDesc("환불로 인한 포인트 회수(일부분)");
				retrieveVO.setPointTarget("REFUND_LOG");
				retrieveVO.setPointTargetId(payNo);
				retrieveVO.setRemainPoint(0);

				//기록 남기고 실제member에서도 전액 차감
				pointMapper.insertPointDetails(retrieveVO);
				pointMapper.updateMemberPoint(memNo, -retrievePoint);
			}

			//최종적으로 포인트 회수액과 '현금에서 깎아야 할 금액'을 적어서 보냄
			result.put("success", true);
			result.put("retrievePoint", retrievePoint);
			result.put("deductCash", deductCash); //환불 시 현금에서 차감해야 할 금액
		}

		return result;
	}

}
