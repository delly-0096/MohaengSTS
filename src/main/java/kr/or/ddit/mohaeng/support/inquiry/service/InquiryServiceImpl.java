package kr.or.ddit.mohaeng.support.inquiry.service;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mohaeng.support.inquiry.mapper.IInquiryMapper;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.InquiryVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InquiryServiceImpl implements IInquiryService{

	@Autowired
	private IInquiryMapper inquiryMapper;



	@Override
	public List<InquiryVO> getInquiryListByCategory(Map<String, Object> params) {
		// 지금 params에 담긴 카테고리 ID나 이름을 확인
		log.info("문의 목록 조회 (카테고리별) - params:", params);
		// DB 호출: 이번엔 '카테고리 필터'가 걸린 전용 매퍼 메서드를 호출
		List<InquiryVO> list = inquiryMapper.selectInquiryListByCategory(params);

		return formatInquiryDates(list);
	}

	@Override
	public int getInquiryCountByCategory(Map<String, Object> params) {
		// 그 카테고리에 글이 총 몇개인지 확인
		log.info("문의 갯수 조회(카테고리별)-params",params);
		// 해당 카테고리의 글 갯수만 세어서 확인(그래야 카테고리 안에서 페이징이 정확하게 작동하므로)
		return inquiryMapper.selectInquiryCountByCategory(params);
	}


	// ========== 공통 ==========

	//문의 상세 조회-(사용자가 게시글 제목을 클릭했을 때 실행)
	@Override
	public InquiryVO getInquiryDetail(int inqryNo) {
		log.info("문의 상세 조회-inqryNo:",inqryNo);

		// [1] DB에서 글 번호(inqryNo)로 한 건의 데이터를 가져옴.
		InquiryVO inquiry = inquiryMapper.selectInquiryDetail(inqryNo);

		// [2] 데이터가 있을 때만 날짜를 예쁘게 바꿈 (NPE 방지)
		if (inquiry !=null) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
			SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy.MM.dd HH:mm");

			// 작성일은 날짜만, 답변일은 시간까지
			if (inquiry.getRegDt() != null) {
				inquiry.setRegDtStr(sdf.format(inquiry.getRegDt()));
			}
			if (inquiry.getReplyDt() !=null) {
				inquiry.setReplyDtStr(sdfTime.format(inquiry.getReplyDt()));
			}
		}
		return inquiry;
	}

	//문의 등록 -(사용자가 새로운 문의글을 작성해서 "저장" 버튼을 눌렀을 때 실행)
	@Override
	public int insertInquiry(InquiryVO inquiry) {
		log.info("문의 등록 - inquiry:", inquiry);

		// [1] 초기값 세팅: 사용자가 입력 안 해도 기본으로 들어가야 하는 값들
		inquiry.setDelYn("N"); //삭제 여부는 일단 '아니오(N)'
		inquiry.setInqryStatus("waiting"); //방금 썼으니 상태는 '답변대기'

		// [2] DB에 저장
		return inquiryMapper.insertInquiry(inquiry);
	}

	//카테고리 목록 조회-(글 쓸 때 선택하는 드롭다운 메뉴에 뿌려줄 데이터 가져옴)
	@Override
	public List<CodeVO> getInquiryCategoryList() {
		log.info("문의 카테고리 목록 조회");
		return inquiryMapper.selectInquiryCategoryList();
	}

	//관리자.답변등록 없음.
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
