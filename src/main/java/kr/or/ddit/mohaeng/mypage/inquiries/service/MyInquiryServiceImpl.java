package kr.or.ddit.mohaeng.mypage.inquiries.service;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.mypage.inquiries.mapper.IMyInquiryMapper;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MyInquiryServiceImpl implements IMyInquiryService {

	@Autowired
	private IMyInquiryMapper inquiryMapper;

	// ========== 마이페이지용 ==========

	@Override
	public List<InquiryVO> getInquiryList(Map<String, Object> params) {
		log.info("마이페이지 문의 목록 조회 (상태별) - params:",params);
		List<InquiryVO> list = inquiryMapper.selectInquiryList(params); //DB 조회: Mapper를 통해 DB에서 문의글 리스트를 몽땅 가져와
		return formatInquiryDates(list);// [3] 가공 작업: DB에서 가져온 날짜 형식(예: 2023-10-27 15:30:00)을
	    							    // 화면에 예쁘게 뿌려줄 수 있게(예: 2023.10.27) 변환해서 리턴
	}

	@Override
	public int getInquiryCount(Map<String, Object> params) {
		log.info("마이페이지 문의 개수 조회(상태별)-params:[]",params);
		return inquiryMapper.selectInquiryCount(params);//페이징 처리를 하려면 '전체 게시글이 몇 개인지' 알아야 하니까 DB에 물어보기
	}


	@Override
	public Map<String, Integer> getInquiryStats(int memNo) {
		//어떤 회원의 통계를 낼 건지 확인 (memNo: 회원번호)
		log.info("마이페이지 문의 통계 조회 - memNo:", memNo);

		//통계 수치들을 담아서 한꺼번에 보낼 Map을 준비
		Map<String, Integer> stats = new HashMap<>();

		//각각의 Mapper 메서드를 호출해서 숫자들을 바구니에 담기
		stats.put("total", inquiryMapper.selectTotalCount(memNo)); //전체 문의 갯수
        stats.put("answered", inquiryMapper.selectAnsweredCount(memNo));//답변 완료된 개수
        stats.put("waiting", inquiryMapper.selectWaitingCount(memNo));//답변 대기중인 개수

        //결과 반환: "전체: 10건, 답변: 8건, 대기: 2건" 이런 정보가 담긴 바구니를 컨트롤러로 보내줘
		return stats;
	}

	 /**
     * 문의 목록의 날짜 포맷팅
     */
	private List<InquiryVO> formatInquiryDates(List<InquiryVO> list){
		// 방어 코드: 리스트가 비어있으면 작업할 필요가 없으니 바로 돌려보내
		if (list == null || list.isEmpty()) {
	        return list;
	    }
		// sdf: 질문 등록일용 (날짜만 깔끔하게: 2023.10.27)
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
		// sdfTime: 답변 등록일용 (시간까지 자세하게: 2023.10.27 14:30)
		SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy.MM.dd:mm");

		for(InquiryVO inquiry : list) {
			// [2] 질문 등록일 처리
			if (inquiry.getRegDt() !=null) {
				inquiry.setRegDtStr(sdf.format(inquiry.getRegDt()));
			}
			// [3] 답변 등록일 처리
			if (inquiry.getReplyDt()!=null) {
				inquiry.setReplyDtStr(sdfTime.format(inquiry.getReplyDt()));
			}
		}
		return list;
	}

}
