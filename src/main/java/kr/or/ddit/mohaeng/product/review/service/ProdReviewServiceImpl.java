package kr.or.ddit.mohaeng.product.review.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.product.review.mapper.IProdReviewMapper;
import kr.or.ddit.mohaeng.product.review.vo.ProdReviewVO;

@Service
public class ProdReviewServiceImpl implements IProdReviewService {

	@Autowired
    private IProdReviewMapper mapper;

	@Autowired
    private IFileService fileService;
	
	@Override
	public List<ProdReviewVO> getReviewPaging(int tripProdNo, int page, int pageSize) {
	    Map<String, Object> params = new HashMap<>();
	    params.put("tripProdNo", tripProdNo);
	    params.put("startRow", (page - 1) * pageSize);
	    params.put("endRow", page * pageSize);
	    return mapper.getReviewPaging(params);
	}

	@Override
	public ProdReviewVO getStat(int tripProdNo) {
		return mapper.getStat(tripProdNo);
	}

	@Override
    @Transactional 
    public int updateReview(ProdReviewVO vo) {
        return mapper.updateReview(vo);
    }

	@Override
	@Transactional 
	public int deleteReview(int prodRvNo, int memNo) {
		return mapper.deleteReview(prodRvNo, memNo);
	}

	@Override
	public Integer getReviewAttachNo(int prodRvNo) {
		return mapper.getReviewAttachNo(prodRvNo);
	}

	@Override
	public int updateReviewAttachNo(int prodRvNo, int attachNo) {
		return mapper.updateReviewAttachNo(prodRvNo, attachNo);
	}
	
	@Override
    @Transactional // 여러 테이블(파일, 리뷰)에 저장하므로 트랜잭션 필수
    public int insertReview(ProdReviewVO vo) {
        // 파일 업로드 처리 로직 추가
        if (vo.getUploadFiles() != null && vo.getUploadFiles().length > 0 && !vo.getUploadFiles()[0].isEmpty()) {
            // fileService를 호출하여 파일을 서버에 저장하고 통합첨부번호(ATTACH_NO)를 발급받음
            int newAttachNo = fileService.addFilesToAttach(
                null, 
                Arrays.asList(vo.getUploadFiles()), 
                "review", // 폴더명: C:/mohaeng/review/ 등
                "REVIEW", // 분류 코드: REVIEW
                vo.getMemNo()
            );
            // 발급받은 번호를 VO에 세팅하여 PROD_REVIEW 테이블의 ATTACH_NO 컬럼에 저장되게 함
            vo.setAttachNo(newAttachNo); 
        }
        
        // 최종적으로 매퍼를 호출하여 DB에 인서트
        return mapper.insertReview(vo); 
    }

}
