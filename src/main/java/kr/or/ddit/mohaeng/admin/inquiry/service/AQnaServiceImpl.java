package kr.or.ddit.mohaeng.admin.inquiry.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.inquiry.mapper.IQnaMapper;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Service
public class AQnaServiceImpl implements IAQnaService {

	@Autowired
	private IQnaMapper qnaMapper;

	@Override
	public PaginationInfoVO<InquiryVO> aInquiryList(PaginationInfoVO<InquiryVO> pagingVO, InquiryVO inquiryVO) {
		//1. 전체 갯수 조회
		int totalCount = qnaMapper.aInquiryCount(pagingVO,inquiryVO);
		//2. 내부에서 페이징 계산 자동 완료
		pagingVO.setTotalRecord(totalCount);

		//3. db에서 실제 목록 조회
		List<InquiryVO> list = qnaMapper.aInquiryList(pagingVO,inquiryVO);
		//4. 리스트 담기
		pagingVO.setDataList(list);

		return pagingVO;
	}



	@Override
	public InquiryVO aInquiryDetail(int inqryNo) {
		//mapper를 통해 문의 상세정보 가져오기
		InquiryVO inquiry = qnaMapper.aInquiryDetail(inqryNo);

		// 만약 본문이 있다면, 그 문의글에 딸린 첨부파일 목록도 가져와!
		if (inquiry != null) {
			List<Map<String, Object>> attachFileList = qnaMapper.aAttachFileList(inqryNo);
			// [핵심] VO 안에 있는 attachFiles 칸에 파일을 쏙 넣어줘! (합체!)
			inquiry.setAttachFiles(attachFileList);
		}

	    // 이제 파일까지 꽉 찬 VO 하나만 딱 리턴!
		return inquiry;
	}

	/**
	 * 관리자 답변 등록
	 * - REPLY_CN, REPLY_MEM_NO, REPLY_DT 업데이트
     * - INQRY_STATUS 자동으로 'DONE'
     * - 알람 생성
	 */
	@Override
	@Transactional // 답변 등록과 알람 생성은 하나의 트랜잭션으로 처리
	public int aInquiryReply(InquiryVO inquiryVO) { //답변 먼저 달기

		// 1. 진짜 정보가 들어있는 박스를 DB에서 새로 꺼낸다!
	    InquiryVO detail = qnaMapper.aInquiryDetail(inquiryVO.getInqryNo());
	    if (detail == null) return 0;

		int cnt = qnaMapper.aInquiryReply(inquiryVO);
		//실패 시 리턴
		if(cnt == 0) return 0;

		//성공 시 알림보내기
		AlarmVO alarm = new AlarmVO();
		alarm.setMemNo(inquiryVO.getMemNo()); // 문의 작성자
		alarm.setAlarmCont("문의하신 '"+inquiryVO.getInqryTitle()+"'답변이 완료되었습니다.");
		alarm.setMoveUrl("/mypage/inquiry/"+inquiryVO.getInqryNo());
		alarm.setReadYn("N");

		//실제 DB저장
		qnaMapper.insertAlarm(alarm);

		return cnt;
	}

	/**
     * 관리자 문의 삭제(논리 삭제)
     * - DEL_YN = 'Y', DEL_DT 업데이트
     * - 알람 생성(삭제 사유 포함)
     */
	@Override
	@Transactional //삭제와 알람 생성을 하나의 트랜잭션으로 처리
	public int aInquiryDelete(int inqryNo, String alarmCont) {
		// 1. 삭제 전 알람 수신 대상자 정보를 확보
		InquiryVO detail = qnaMapper.aInquiryDetail(inqryNo);
		if (detail == null) return 0; // 정보 없으면 바로 끝!

		// 2. 문의글 논리 삭제
		int cnt = qnaMapper.inquiryDelete(inqryNo);
		if (cnt == 0) return 0 ; //삭제 실패시 여기서 바로 끝.

		// 3. 삭제 성공 시 알람 생성
		AlarmVO alarm = new AlarmVO();
		alarm.setMemNo(detail.getMemNo());

		alarm.setAlarmCont("문의하신'"+detail.getInqryTitle()+"'글이 삭제되었습니다. (사유: " + alarmCont + ")");
	    alarm.setMoveUrl("/mypage/inquiry");

	    qnaMapper.insertAlarm(alarm);

		return cnt;
	}







}
