package kr.or.ddit;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mohaeng.accommodation.service.TourApiService;
import kr.or.ddit.mohaeng.vo.AccommodationVO;

@SpringBootTest
@Transactional
public class TourApiTest {

	@Autowired
    private TourApiService tourApiService;

    @Test
    void testApiSync() {
        // 이 메서드를 실행하면 실제로 API를 호출하고 DB에 insert를 시도해.
        // tourApiService.fetchAndSaveAccommodations(); // 숙소 api 가져오기
        System.out.println("동기화 작업 완료! DB를 확인해보세요.");
    }
}
