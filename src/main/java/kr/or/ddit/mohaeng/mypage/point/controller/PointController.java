package kr.or.ddit.mohaeng.mypage.point.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mohaeng.mypage.point.service.IPointService;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import kr.or.ddit.mohaeng.vo.PointDetailsVO;
import kr.or.ddit.mohaeng.vo.PointSearchVO;
import kr.or.ddit.mohaeng.vo.PointSummaryVO;

@Controller
@RequestMapping("/mypage/points")
public class PointController {

	@Autowired
	private IPointService pointService;

	/**
	 * 포인트 내역 페이지
	 */
	@GetMapping("")
	public String pointList(HttpSession session, Model model) {

		// 1. 세션에서 로그인 정보 꺼내기 (로그인 체크 겸 데이터 확보!)
		@SuppressWarnings("unchecked") //자바가 '확인 안 됐다고(unchecked)' 잔소리하는 거, 그 경고만 딱 집어서 무시(Suppress)해줘! (suppress:막다, 억압하다)
		Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");

		// 2. 로그인 안 되어 있으면 입구컷!
		if (loginMember == null) {
			return "redirect:/member/login";
		}

		//3. 아무것도 안담고 그냥 화면(JSP)로 보냄.-> "나머지 데이터는 화면이 뜬 다음에 AJAX 네가 알아서 가져와!"
		return "mypage/points";
	}

	/**
	 * 포인트 요약 정보 조회(AJAX)
	 */
	@GetMapping("/summary")
	@ResponseBody //map데이터만 넘겨주겠다!
	public Map<String, Object> pointSummary(HttpSession session){ //pointSummary: 포인트 요약 전달

		//1. 데이터를 넘겨줄 빈 박스 준비
		Map<String, Object> result = new HashMap<>();

		//2. 세션에서 로그인 정보 꺼내기
		@SuppressWarnings("unchecked") //자바가 확인 안됬다고 하는것만 무시하기
		Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");

		//3. 로그인 안 되어 있으면 입구컷!
		if (loginMember == null) {
			result.put("success", false);//result박스에 success칸에 false적기
			result.put("message", "로그인이 필요합니다");
			return result;
			/* Q. 어차피 마이페이지는 로그인 안 하면 못 들어가게 막아놨는데, 굳이 메서드 안에서 또 검사해야 하나요?
 			   A. '보안의 2중 잠금' - "바지가 내려가지 않게 허리띠와 멜빵을 같이 하는 거다!"
			    이유1) 시큐리티가 문을 잘 지키고 있어도, 우리 코드에서 session.getAttribute("loginMember")를 통해 꺼낸 데이터가 진짜로 제대로 들어있는지는 별개의 문제
			          ex)혹시라도 세션이 만료, 서버가 재시작되는 아주 찰나의 순간에 데이터가 튈 수 있기 때문.
			    이유2) AJAX 통신은 '화면'이 아니라 '데이터'를 원하기 때문.
			          ex)시큐리티 설정이 꼬여서 어쩌다 이 주소(.../summary)로 직접 접근이 가능해졌을 때, "로그인이 필요합니다"라는 깔끔한 JSON 데이터를 보내줘야 프론트엔드(React/JS)가 에러 없이 처리
			 */
		}
		try {
			//1. 지금 로그인 한 사람이 누군지 이름표 확인
			 int memNo = (Integer) loginMember.get("memNo");

			 //2. db에서 service호출
			 PointSummaryVO summary = pointService.pointSummary(memNo); //pointSummary: 포인트 요약 조회

			 //3. result박스에 담기
			 result.put("success", true);
			 result.put("data", summary);

		} catch (Exception e) {
			 result.put("success", false);
			 result.put("message", "포인트 정보 조회 중 오류가 발생했습니다.");
			 e.printStackTrace();
		}
		return result;
	}

	/**
	 * 포인트 내역 목록 조회(AJAX)
	 */
	@GetMapping("/history")
	@ResponseBody
	public Map<String, Object> pointHistory(
			HttpSession session,
			@RequestParam(defaultValue = "all") String pointType, //ex)적립만 보기, 사용만 보기
			@RequestParam(defaultValue = "all") String pointTarget,
			@RequestParam(defaultValue = "3month") String period,
			@RequestParam(required = false) String startDate, // 👈 추가: 시작일
	        @RequestParam(required = false) String endDate,   // 👈 추가: 종료일
			@RequestParam(defaultValue = "1") int page){

		Map<String, Object> result = new HashMap<>();

		@SuppressWarnings("unchecked")
		Map<String, Object> loginMember = (Map<String, Object>) session.getAttribute("loginMember");

		if (loginMember == null) {
			result.put("result", false);
			result.put("message", "로그인이 필요합니다.");
			return result;
		}

		try {
			//1. 로그인 주머니에서 필요한 회원 번호만 추출
			int memNo = (Integer) loginMember.get("memNo");

			//2-1. 주문서 작성 : 어떤 데이터를 찾을지 조건표(VO) 새로 만듬
			PointSearchVO searchVO = new PointSearchVO();
			searchVO.setMemNo(memNo);
			//2-2.필터링 번역 : 화면에서 온 all을 db의 조건없음(null)으로 바꿔 담기
			searchVO.setPointType("all".equals(pointType) ? null : pointType);
			searchVO.setPointTarget("all".equals(pointTarget) ? null : pointTarget);
			searchVO.setPeriod(period);

			// 👈 추가: 날짜 정보 세팅
	        searchVO.setStartDate(startDate);
	        searchVO.setEndDate(endDate);

			//3. (조건에 맞는)전체 갯수 조회
			int totalCount = pointService.pointHistoryCount(searchVO);

			//4. 페이지 계산기
			PaginationInfoVO<PointDetailsVO> pagingVO = new PaginationInfoVO<>(5,5); //여기 바꾸면 되~ 원하는대로
			pagingVO.setTotalRecord(totalCount); //계산기에게 전체 개수 입력
			pagingVO.setCurrentPage(page); //EX)"전체가 100개니까 총 10페이지가 필요하겠군!" 자동 계산

			//5. 최종 주문서 완성. 검색 조건에 페이지 정보 추가(합체)
			searchVO.setPaginationVO(pagingVO);

			//6. 내역 조회(DB에서 진짜 데이터 리스트 조회)
			List<PointDetailsVO> historyList = pointService.pointHistory(searchVO);

			//7. 성공 신호+데이터와 페이징 정보 ->result박스에 담아 포장
			result.put("success", true);
			result.put("data", historyList); // 실제 포인트 내역들
			result.put("paginationVO", pagingVO); // 하단에 보여줄 [1][2][3] 페이지 번호 정보

		} catch (Exception e) {
			result.put("success", false);
			result.put("message", "포인트 내역 조회 중 오류가 발생했습니다.");
			e.printStackTrace();
		}
		//8.완성된 내용을 ajax로 넘기기
		return result;
	}
}
