package kr.or.ddit.mohaeng.admin.inquiry.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.inquiry.mapper.IQnaMapper;
import kr.or.ddit.mohaeng.mailapi.service.MailService;
import kr.or.ddit.mohaeng.vo.AlarmVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AQnaServiceImpl implements IAQnaService {

	@Autowired
	private IQnaMapper qnaMapper;

	@Autowired
	private MailService mailService;

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
     * - INQRY_STATUS 자동으로 'ANSWERED'
     * - 알람 생성
     * - 답변 DB 저장, 내부 알림 생성, 외부 이메일 발송까지 한 번에!
	 */
	@Override
	@Transactional // 저장, 알람, 메일(선택)을 하나의 흐름으로!
	public int aInquiryReply(InquiryVO inquiryVO) { //답변 먼저 달기

		// 1.[검증] 진짜 정보가 들어있는 박스를 DB에서 새로 꺼낸다!(이메일,이름 정보 확보)
	    InquiryVO detail = qnaMapper.aInquiryDetail(inquiryVO.getInqryNo());
	    if (detail == null) return 0;

	    // 2.[저장] 답변 등록 실행
		int cnt = qnaMapper.aInquiryReply(inquiryVO);
		if(cnt == 0) return 0; 	//실패 시 리턴

		// 3.[알림] 성공 시 웹 내부 알람 생성
		AlarmVO alarm = new AlarmVO();
		alarm.setMemNo(detail.getMemNo()); // 문의 작성자에게
		alarm.setAlarmCont("문의하신 '"+inquiryVO.getInqryTitle()+"'답변이 완료되었습니다.");
		alarm.setMoveUrl("/mypage/inquiry/"+inquiryVO.getInqryNo());
		alarm.setReadYn("N");

		qnaMapper.insertAlarm(alarm);//실제 DB저장

		// 4.[이메일] 이메일 발송 추가! (조원의 MailService 활용)
		try {
			// 조원의 양식을 빌려온 HTML 생성
			String htmlBody = buildReplyHtml(detail.getMemberName(), detail.getInqryTitle(), inquiryVO.getReplyCn());

			//메일발송(MailService.sendEmail호출)
			mailService.sendEmail(
					detail.getInqryEmail(),  // [번역 1] 네 VO의 이메일을 -> MailService의 'to' 자리로!
					"[Mohaeng] 문의하신 내용에 대한 답변이 등록되었습니다.",  // [번역 2]  MailService의 'subject' 자리로!
					inquiryVO.getReplyCn(),  // [번역 3] 네가 쓴 답변을   -> MailService의 'textContent' 자리로!
					htmlBody);				 // [번역 4] 생성한 HTML을   -> MailService의 'htmlContent' 자리로!
			log.info("문의 답변 메일 발송 성공 : {}",detail.getInqryEmail());

		} catch (Exception e) {
			log.error("❌ 메일 발송 실패! 모든 작업을 취소합니다.");
			throw new RuntimeException("메일 발송에 실패하여 답변 등록이 취소되었습니다. 잠시 후 다시 시도해주세요.", e);

			// [다른 선택]메일 발송 실패가 전체 로직(DB 저장)을 취소시키면 안 된다면 여기서 예외 처리!
            // log.error("❌ 메일 발송 중 오류 발생했지만 답변 저장은 유지됨: {}", e.getMessage());
		}

		return cnt;
	}

	private String buildReplyHtml(String memName, String title, String content) {
		String safeName = (memName == null || memName.isBlank()) ? "고객" :memName;

		return """
				<!doctype html>
		        <html lang="ko">
		        <head><meta charset="utf-8"></head>
		        <body style="margin:0;padding:0;background:#f6f7fb;">
		          <table role="presentation" width="100%%" cellpadding="0" cellspacing="0" style="background:#f6f7fb;padding:24px 0;">
		            <tr>
		              <td align="center">
		                <table role="presentation" width="600" style="width:600px;background:#ffffff;border-radius:14px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.06);">
		                  <tr>
		                    <td style="padding:22px 28px;background:#111827;color:#ffffff;">
		                      <div style="font-size:18px;font-weight:700;">Mohaeng</div>
		                      <div style="margin-top:6px;font-size:13px;opacity:0.85;">문의 답변 완료 안내</div>
		                    </td>
		                  </tr>
		                  <tr>
		                    <td style="padding:26px 28px;color:#111827;">
		                      <div style="font-size:16px;line-height:1.6;">
		                        안녕하세요, <b>%s</b>님.<br>
		                        문의하신 사항에 대해 답변이 등록되었습니다.
		                      </div>
		                      <div style="margin-top:18px;padding:16px 18px;border:1px solid #e5e7eb;border-radius:12px;background:#f9fafb;">
		                        <div style="font-size:12px;color:#6b7280;margin-bottom:4px;">문의 제목</div>
		                        <div style="font-size:15px;font-weight:700;margin-bottom:12px;">%s</div>
		                        <div style="font-size:12px;color:#6b7280;margin-bottom:4px;">답변 내용</div>
		                        <div style="font-size:14px;line-height:1.6;color:#374151;white-space:pre-wrap;">%s</div>
		                      </div>
		                      <div style="margin-top:20px;">
		                        <a href="http://localhost:8272/inquiry/list"
		                           style="display:inline-block;padding:12px 16px;border-radius:10px;background:#2563eb;color:#ffffff;text-decoration:none;font-weight:700;font-size:14px;">
		                          나의 문의 내역 확인하기
		                        </a>
		                      </div>
		                    </td>
		                  </tr>
		                  <tr>
		                    <td style="padding:16px 28px;background:#f9fafb;color:#6b7280;font-size:11px;">
		                      © Mohaeng. All rights reserved. 본 메일은 발신 전용입니다.
		                    </td>
		                  </tr>
		                </table>
		              </td>
		            </tr>
		          </table>
		        </body>
		        </html>
				""".formatted(safeName, title, content);
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
	    alarm.setReadYn("N");

	    qnaMapper.insertAlarm(alarm);

		return cnt;
	}

	//다운로드 전용
	@Override
	public Map<String, Object> getAttachFile(int fileNo) {
		return qnaMapper.selectAttachFile(fileNo);
	}







}
