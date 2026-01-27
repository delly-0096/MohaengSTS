package kr.or.ddit.mohaeng.mypage.payments.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mohaeng.mypage.payments.mapper.IMyPaymentsMapper;
import kr.or.ddit.mohaeng.vo.MyPaymentsVO;
import kr.or.ddit.mohaeng.vo.PaginationInfoVO;

@Service
public class MyPaymentsServiceImpl implements IMyPaymentsService {

    @Autowired
    private IMyPaymentsMapper myPaymentsMapper;

    @Override
    public Map<String, Object> getPaymentStats(int memNo) {
        // 상단 4개 카드 데이터 (전체, 완료, 예정, 총금액) 조회
        return myPaymentsMapper.selectPaymentStats(memNo);
    }

    @Override
    public List<MyPaymentsVO> getMyPaymentList(int memNo) {
        // 항공, 숙소, 투어가 통합된 결제 리스트 조회
        return myPaymentsMapper.selectMyPaymentList(memNo);
    }

	@Override
	public int selectMyPaymentsCount(PaginationInfoVO<MyPaymentsVO> pagingVO) {
		return myPaymentsMapper.selectMyPaymentsCount(pagingVO);
	}

	@Override
	public List<MyPaymentsVO> selectMyPaymentsList(PaginationInfoVO<MyPaymentsVO> pagingVO) {
		return myPaymentsMapper.selectMyPaymentsList(pagingVO);
	}

	@Override
	public Map<String, Object> selectPaymentMaster(int payNo) {
	    return myPaymentsMapper.selectPaymentMaster(payNo);
	}

	@Override
	public List<Map<String, Object>> selectReceiptDetailList(int payNo) {
	    return myPaymentsMapper.selectReceiptDetailList(payNo);
	}

	@Override
	@Transactional // 트랜잭션 보장
	public void updateFileUseN(String filePath) {
	    myPaymentsMapper.updateFileUseN(filePath);
	}

	@Override
	@Transactional
	public Long processReviewFiles(MultipartFile[] files, int memNo, Long existingAttachNo) {
	    if (files == null || files.length == 0) return existingAttachNo;

	    Long attachNo = existingAttachNo;
	    
	    // 1. ATTACH_NO가 없으면(최초 등록이거나 기존에 이미지가 없었을 때) 마스터 생성
	    if (attachNo == null || attachNo == 0) {
	        attachNo = myPaymentsMapper.nextAttachNo();
	        Map<String, Object> master = new HashMap<>();
	        master.put("attachNo", attachNo);
	        master.put("regId", memNo);
	        myPaymentsMapper.insertAttachFile(master);
	    }

	    // 2. 실제 저장 폴더 설정 (WebConfig의 C:/mohaeng/ 매핑과 맞춰야 함)
	    String uploadRoot = "C:/mohaeng/product/"; 

	    for (MultipartFile file : files) {
	        if (file.isEmpty()) continue;
	        
	        try {
	            // 파일명 가공 (UUID + 확장자)
	            String originalName = file.getOriginalFilename();
	            String ext = originalName.substring(originalName.lastIndexOf("."));
	            String saveName = java.util.UUID.randomUUID().toString() + ext;
	            
	            // DB에 저장될 가상 경로 (JSP에서 /files 뒤에 붙을 경로)
	            String dbPath = "/product/" + saveName;

	            // 물리적 파일 저장
	            java.io.File saveFile = new java.io.File(uploadRoot + saveName);
	            if(!saveFile.getParentFile().exists()) saveFile.getParentFile().mkdirs();
	            file.transferTo(saveFile);

	            // 3. ATTACH_FILE_DETAIL 등록 (상세 데이터 추가)
	            Map<String, Object> detail = new HashMap<>();
	            detail.put("fileNo", myPaymentsMapper.nextFileNo());
	            detail.put("attachNo", attachNo); // 기존 또는 신규 번호 유지
	            detail.put("fileName", saveName);
	            detail.put("originalName", originalName);
	            detail.put("ext", ext.replace(".", ""));
	            detail.put("size", file.getSize());
	            detail.put("path", dbPath); 
	            detail.put("mimeType", file.getContentType());
	            detail.put("regId", memNo);
	            
	            myPaymentsMapper.insertAttachFileDetail(detail);
	            
	        } catch (Exception e) {
	            throw new RuntimeException("리뷰 이미지 처리 중 오류 발생", e);
	        }
	    }
	    return attachNo; // 최종적으로 사용된 attachNo 반환
	}
}