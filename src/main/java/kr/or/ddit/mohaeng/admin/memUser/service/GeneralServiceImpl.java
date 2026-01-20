package kr.or.ddit.mohaeng.admin.memUser.service;

import java.io.OutputStream;

import java.util.List;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.admin.memUser.mapper.IGeneralMapper;
import kr.or.ddit.mohaeng.vo.AlarmConfigVO;
import kr.or.ddit.mohaeng.vo.CodeVO;
import kr.or.ddit.mohaeng.vo.MarketingConsentVO;
import kr.or.ddit.mohaeng.vo.MemberTermsAgreeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GeneralServiceImpl implements IGeneralService {


	@Autowired
	private IGeneralMapper generalMapper;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;


	// [코드 관련 추가]
	@Override
	public List<CodeVO> getCodeListByGroup(String cdgr) {
		return generalMapper.getCodeListByGroup(cdgr);
	}

	//전체 인원수 확인해서(Count) 페이지 계산하기 + 지금 필요한 만큼의 명단(List)만 뽑기 => pagInfoVO에 담기
	@Override
	public void getMemList(PaginationInfoVO<MemberVO> pagInfoVO) {
		// 인원파악
		int totalRecord = generalMapper.getMemCount(pagInfoVO);
		// 전체 인원수 기록
		pagInfoVO.setTotalRecord(totalRecord);
		// 명단 추출 : 창고에서 명단 가져와 리스트 작성
		List<MemberVO> dataList = generalMapper.getMemList(pagInfoVO);
		// 리스트 pagInfoVO에 담기=>화면으로 보낼것임
		pagInfoVO.setDataList(dataList);
	}

	@Override
	public MemberVO getMemDetail(int memNo) {
		return generalMapper.getMemDetail(memNo);
	}

	//--- 회원 등록 ---//
	@Transactional
	@Override
	public int registerMember(MemberVO member) {
		// 비밀번호 암호화
		member.setMemPassword(passwordEncoder.encode(member.getMemPassword()));

		//기본값 설정
		member.setJoinCompleteYn("Y"); //"가입 절차 끝났나?" → Yes
		member.setTempPwYn("N"); //"이거 임시 비밀번호인가?" → No, 본인이 직접 정한 거임.
		member.setMemSnsYn("N"); //"구글/카톡 로그인 회원인가?" → No
		member.setEnabled(1); //"이 사람 활동 가능한가?" → 계정사용여부 1(활성), 0(비활성)
		member.setDelYn("N"); //"이 사람 탈퇴했나?" → No

		// MEM_STATUS 대문자 변환(보험용)
		if (member.getMemStatus() != null) {
			member.setMemStatus(member.getMemStatus().toUpperCase());
		}

		// 1. MEMBER 테이블 insert : 여기서 '회원번호(memNo)'가 자동으로 생성
		int result = generalMapper.insertMember(member);

		// 2. [상세 정보 작성] MEM_USER 테이블 insert
		member.getMemUser().setMemNo(member.getMemNo()); //번호표 복사
		generalMapper.insertMemUser(member.getMemUser()); //db상세 정보 장부에 저장

		// 3. [권한 작성] MEMBER_AUTH 테이블 insert (ROLE_MEMBER)
		generalMapper.insertMemberAuth(member.getMemNo());

		 // 4. [알람 설정] ALARM_CONFIG 테이블 insert
		AlarmConfigVO alarmConfig = member.getAlarmConfig();
		if (alarmConfig != null) {
			alarmConfig.setMemNo(member.getMemNo());
			generalMapper.insertAlarmConfig(alarmConfig);
		}

        // 5. [약관 동의 작성] MEMBER_TERMS_AGREE 테이블 insert
		MemberTermsAgreeVO termsAgree = member.getTermsAgree();
		if (termsAgree !=null) {
			termsAgree.setMemNo(member.getMemNo());
			generalMapper.insertTermsAgree(termsAgree);
		}

        // 6. [마케팅 동의 작성] MARKETING_CONSENT 테이블 insert
        MarketingConsentVO marketingConsent = member.getMarketingConsent();
        if (marketingConsent !=null) {
        	marketingConsent.setMemNo(member.getMemNo());
        	generalMapper.insertMarketingConsent(marketingConsent);
		}
        return result; //가입 성공
	}

	//--- 회원 수정 ---//
	@Transactional
	@Override
	public int updateMember(MemberVO member) {

		// MEM_STATUS 대문자 변환(보험용)
		if (member.getMemStatus() != null) {
			member.setMemStatus(member.getMemStatus().toUpperCase());
		}

		// 1. 메인 정보 수정(MEMBER테이블)
		int result = generalMapper.updateMember(member);
		// 2. (있을 경우) 상세 정보 수정(MEMBER_USER테이블)
		if (member.getMemUser() !=null) {
			member.getMemUser().setMemNo(member.getMemNo());
			generalMapper.updateMemUser(member.getMemUser());
		}
		// 3. 알람 정보 수정
		AlarmConfigVO alarmConfig = member.getAlarmConfig();
		if (alarmConfig != null) {
			alarmConfig.setMemNo(member.getMemNo());
			generalMapper.updateAlarmConfig(alarmConfig);
		}

		// 4. 약관 동의 수정
		MemberTermsAgreeVO termsAgree = member.getTermsAgree();
		if (termsAgree != null) {
			termsAgree.setMemNo(member.getMemNo());
			generalMapper.updateTermsAgree(termsAgree);
		}

		// 5. 마케팅 동의 수정
		MarketingConsentVO marketingConsent = member.getMarketingConsent();
		if (marketingConsent !=null) {
			marketingConsent.setMemNo(member.getMemNo());
			generalMapper.updateMarketingConsent(marketingConsent);
		}
		return result;//수정성공 : 메인의 수정갯수가 회원의 수정 갯수와 같은게 편하기 때문
	}

	//--- 비밀번호 바꾸기 기능 ---//
	@Override
	public int changePassword(int memNo, String newPassword) {
		String encodedPassword = passwordEncoder.encode(newPassword); //사용자 입력 비밀번호 암호화
		return generalMapper.changePassword(memNo, encodedPassword);
	}

	//--- 아이디 중복 확인 기능 ---//
	@Override
	public boolean checkDuplicateId(String memId) {
		int count = generalMapper.checkDuplicateId(memId);//똑같은 아이디가 몇개인지 세어봄
		return count>0; //[결과] 0보다 크다-> 중복 true, 0이면 ->중복 false
	}

	//--- 이메일 중복 확인 기능 ---//
	@Override
	public boolean checkDuplicateEmail(String memEmail) {
		int count = generalMapper.checkDuplicateEmail(memEmail); //똑같은 이메일이 몇개인지 세어봄
		return count>0; //[결과] 0보다 크다-> 중복 true, 0이면 ->중복 false
	}

	//--- 회원 정보 엑셀 다운로드 ---//
	@Override
	public void downloadMemberExcel(OutputStream outputStream, PaginationInfoVO<MemberVO> pagInfoVO) {
		try {

			//1. 장보기 : DB에서 검색 조건에 맞는 회원 전체 데이터 조회(페이징 없음)
			List<MemberVO> memList = generalMapper.getAllMemList(pagInfoVO);

			//2. 엑셀 워크북 만들기(새 파일과 종이)
			Workbook workbook = new XSSFWorkbook();
		    Sheet sheet = workbook.createSheet("일반회원목록");

		    //헤더 스타일
		    CellStyle headerStyle = workbook.createCellStyle();
		    headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());//디자인: 배경색(회색 25%), 채우기 패턴 적용
		    headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		    headerStyle.setBorderBottom(BorderStyle.THIN);//레이아웃: 하단 테두리 추가 및 텍스트 중앙 정렬
		    headerStyle.setAlignment(HorizontalAlignment.CENTER);

		    Font headerFont = workbook.createFont();
		    headerFont.setBold(true);
		    headerStyle.setFont(headerFont);

		    //3. 제목 적기(헤더 생성)
		    Row headerRow = sheet.createRow(0); // 엑셀종이 첫번째 줄에 줄긋기
		    String[] headers = {"번호", "아이디", "이름", "닉네임", "이메일", "연락처",
                    			"생년월일", "성별", "상태", "가입일", "수정일"};

		    for (int i = 0; i < headers.length; i++) {
		    	Cell cell = headerRow.createCell(i); //칸 만들기
		    	cell.setCellValue(headers[i]); //그 칸에 글자 쓰기
		    	cell.setCellStyle(headerStyle); //그 칸에 스타일 입히기
		    	sheet.setColumnWidth(i, 4000); //크 칸의 공간 4000으로 넓혀줘
			}
		    // 데이터 스타일
		    CellStyle dataStyle = workbook.createCellStyle();
		    dataStyle.setBorderBottom(BorderStyle.THIN); //데이터 줄마다 아래에 아주 얇은 선을 하나씩 긋기
		    dataStyle.setAlignment(HorizontalAlignment.CENTER);//데이터들을 칸의 정가운데에 오게 함

		    //4. 데이터 생성
		    int rowNum = 1;
		    for (MemberVO member : memList) {
				Row row = sheet.createRow(rowNum++); //지금 rowNum에 써있는 번호(처음엔 1번)에 줄을 하나 만들고, 다 만들면 번호 올려놔

				//memNo
				Cell cell0 = row.createCell(0); //1. 이 줄의 맨 앞(0번)에 네모난 칸 하나 만들기
				cell0.setCellValue(member.getMemNo()); //2. 거기에 memNo를 넣어라
				cell0.setCellStyle(dataStyle); //3. 그 칸에 옷 입혀라.

				//memId
				Cell cell1 = row.createCell(1);
	            cell1.setCellValue(member.getMemId());
	            cell1.setCellStyle(dataStyle);

	            //memName
	            Cell cell2 = row.createCell(2);
	            cell2.setCellValue(member.getMemName());
	            cell2.setCellStyle(dataStyle);

	            //nickName
	            Cell cell3 = row.createCell(3);
	            cell3.setCellValue(member.getMemUser() !=null ? member.getMemUser().getNickname() : "");
	            cell3.setCellStyle(dataStyle);

	            //email
	            Cell cell4 = row.createCell(4);
	            cell4.setCellValue(member.getMemEmail());
	            cell4.setCellStyle(dataStyle);

	            //tell(전화번호)
	            Cell cell5 = row.createCell(5);
	            cell5.setCellValue(member.getMemUser() != null ? member.getMemUser().getTel() : "");
	            cell5.setCellStyle(dataStyle);

	            //birthDate
	            Cell cell6 = row.createCell(6);
	            cell6.setCellValue(member.getMemUser() !=null && member.getMemUser().getBirthDate() !=null
	            					? member.getMemUser().getBirthDate() : "");
	            cell6.setCellStyle(dataStyle);

	            //gender
	            Cell cell7 = row.createCell(7);
	            String gender = "";
	            if (member.getMemUser() != null && member.getMemUser().getGender() != null) {
					gender = "M".equals(member.getMemUser().getGender()) ? "남성" :
							 "F".equals(member.getMemUser().getGender()) ? "여성" : "";
				}
	            cell7.setCellValue(gender);
	            cell7.setCellStyle(dataStyle);

	            //memStatus
	            Cell cell8 = row.createCell(8);
	            cell8.setCellValue(member.getMemStatusName() != null ? member.getMemStatusName() : "");
	            cell8.setCellStyle(dataStyle);

	            //regDt
	            Cell cell9 = row.createCell(9);
	            //db있는지 확인-> 날짜 틀 만들기-> 가입일자 찍어내기 : "" 예외처리
	            cell9.setCellValue(member.getRegDt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(member.getRegDt()):"");
	            cell9.setCellStyle(dataStyle);

	            //udtDt
	            Cell cell10 = row.createCell(10);
	            cell10.setCellValue(member.getUdtDt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(member.getUdtDt()) : "");
	            cell10.setCellStyle(dataStyle);

	            //--** 엑셀 추가할 것 있으면 여기에 추가 **--

			}
		    //5. 다 만들어진 엑셀을 outputStream 통로로 보내기
		    workbook.write(outputStream);
		    workbook.close(); //사용한 엑셀 도구 정리

		} catch (Exception e) {
			 log.error("엑셀 다운로드 중 오류 발생", e);
			 throw new RuntimeException("엑셀 다운로드 실패", e);
		}

	}


}
