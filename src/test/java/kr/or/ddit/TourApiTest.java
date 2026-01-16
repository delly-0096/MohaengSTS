package kr.or.ddit;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import kr.or.ddit.mohaeng.accommodation.service.TourApiService;

@SpringBootTest
public class TourApiTest {

	@Autowired
    private TourApiService tourApiService;

    @Test
    void testApiSync() {
        // 이 메서드를 실행하면 실제로 API를 호출하고 DB에 insert를 시도해.
        tourApiService.fetchAndSaveAccommodations();
        System.out.println("동기화 작업 완료! DB를 확인해보세요.");
    }
}
