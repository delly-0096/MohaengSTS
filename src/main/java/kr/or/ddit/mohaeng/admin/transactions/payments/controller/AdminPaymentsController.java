package kr.or.ddit.mohaeng.admin.transactions.payments.controller;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.mohaeng.admin.transactions.payments.service.IAdminPaymentsService;
import kr.or.ddit.mohaeng.vo.AdminPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@RestController
@RequestMapping("/api/admin/transactions/payments")
@CrossOrigin(origins = "http://localhost:7272")
public class AdminPaymentsController {
    
    @Autowired
    private IAdminPaymentsService adminPaymentsService;
    
    // 통계 조회
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        return ResponseEntity.ok(adminPaymentsService.getAdminPaymentDashboard());
    }
    
    // 리스트 조회
    @GetMapping("/list")
    public ResponseEntity<PaginationInfoVO<AdminPaymentsVO>> getPaymentsList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String searchType) {
        
        PaginationInfoVO<AdminPaymentsVO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setCurrentPage(page);
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchType(searchType);
        
        return ResponseEntity.ok(adminPaymentsService.getAdminPaymentsList(pagingVO));
    }
    
    // 상세 조회 (회원 영수증과 동일한 구조)
    @GetMapping("/{payNo}")
    public ResponseEntity<Map<String, Object>> getPaymentDetail(@PathVariable int payNo) {
        Map<String, Object> result = new HashMap<>();
        
        // 1. 결제 기본 정보 (마스터)
        result.put("master", adminPaymentsService.getPaymentDetail(payNo));
        // 2. 상세 품목 리스트
        result.put("details", adminPaymentsService.getReceiptDetailList(payNo));
        
        return ResponseEntity.ok(result);
    }
    
    // 엑셀 다운로드
    @GetMapping("/excel")
    public ResponseEntity<byte[]> downloadExcel(
            @RequestParam(required = false) String searchWord,
            @RequestParam(required = false) String searchType) throws IOException {
        
        // 전체 데이터 조회 (페이징 없이)
        PaginationInfoVO<AdminPaymentsVO> pagingVO = new PaginationInfoVO<>(999999, 5);
        pagingVO.setCurrentPage(1);
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchType(searchType);
        
        PaginationInfoVO<AdminPaymentsVO> result = adminPaymentsService.getAdminPaymentsList(pagingVO);
        List<AdminPaymentsVO> paymentsList = result.getDataList();
        
        // 엑셀 생성
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("결제내역");
        
        // 헤더 스타일
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 헤더 생성
        Row headerRow = sheet.createRow(0);
        String[] headers = {"주문번호", "결제일시", "결제자", "이메일", "연락처", "상품명", 
                           "결제금액", "할인", "포인트사용", "결제수단", "상태", "판매자", "사업자번호"};
        
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 데이터 스타일
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setAlignment(HorizontalAlignment.LEFT);
        
        CellStyle numberStyle = workbook.createCellStyle();
        numberStyle.setBorderBottom(BorderStyle.THIN);
        numberStyle.setAlignment(HorizontalAlignment.RIGHT);
        
        // 데이터 입력
        int rowNum = 1;
        for (AdminPaymentsVO payment : paymentsList) {
            Row row = sheet.createRow(rowNum++);
            
            // 주문번호
            Cell cell0 = row.createCell(0);
            cell0.setCellValue(payment.getOrderNo());
            cell0.setCellStyle(dataStyle);
            
            // 결제일시
            Cell cell1 = row.createCell(1);
            cell1.setCellValue(payment.getPayDt());
            cell1.setCellStyle(dataStyle);
            
            // 결제자
            Cell cell2 = row.createCell(2);
            cell2.setCellValue(payment.getMemName());
            cell2.setCellStyle(dataStyle);
            
            // 이메일
            Cell cell3 = row.createCell(3);
            cell3.setCellValue(payment.getMemEmail());
            cell3.setCellStyle(dataStyle);
            
            // 연락처
            Cell cell4 = row.createCell(4);
            cell4.setCellValue(payment.getMemTel());
            cell4.setCellStyle(dataStyle);
            
            // 상품명
            Cell cell5 = row.createCell(5);
            cell5.setCellValue(payment.getProdName());
            cell5.setCellStyle(dataStyle);
            
            // 결제금액
            Cell cell6 = row.createCell(6);
            cell6.setCellValue(payment.getPayTotalAmt());
            cell6.setCellStyle(numberStyle);
            
            // 할인
            Cell cell7 = row.createCell(7);
            cell7.setCellValue(payment.getDiscount());
            cell7.setCellStyle(numberStyle);
            
            // 포인트사용
            Cell cell8 = row.createCell(8);
            cell8.setCellValue(payment.getUsePoint());
            cell8.setCellStyle(numberStyle);
            
            // 결제수단
            Cell cell9 = row.createCell(9);
            cell9.setCellValue(payment.getPayMethodCd());
            cell9.setCellStyle(dataStyle);
            
            // 상태
            Cell cell10 = row.createCell(10);
            String status = "";
            switch(payment.getPayStatus()) {
                case "DONE": status = "이용완료"; break;
                case "WAIT": status = "이용예정"; break;
                case "CANCEL": status = "취소완료"; break;
                default: status = payment.getPayStatus();
            }
            cell10.setCellValue(status);
            cell10.setCellStyle(dataStyle);
            
            // 판매자
            Cell cell11 = row.createCell(11);
            cell11.setCellValue(payment.getBzmnNm() != null ? payment.getBzmnNm() : "");
            cell11.setCellStyle(dataStyle);
            
            // 사업자번호
            Cell cell12 = row.createCell(12);
            cell12.setCellValue(payment.getBrno() != null ? payment.getBrno() : "");
            cell12.setCellStyle(dataStyle);
        }
        
        // 열 너비 자동 조정
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
            sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1024);
        }
        
        // 바이트 배열로 변환
        java.io.ByteArrayOutputStream outputStream = new java.io.ByteArrayOutputStream();
        workbook.write(outputStream);
        workbook.close();
        
        // 파일명 생성
        String fileName = "결제내역_" + java.time.LocalDate.now().toString() + ".xlsx";
        
        // 응답 헤더 설정
        HttpHeaders headers2 = new HttpHeaders();
        headers2.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        headers2.setContentDispositionFormData("attachment", 
            new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
        
        return new ResponseEntity<>(outputStream.toByteArray(), headers2, HttpStatus.OK);
    }
}