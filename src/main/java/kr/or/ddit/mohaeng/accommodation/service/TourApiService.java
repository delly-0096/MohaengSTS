package kr.or.ddit.mohaeng.accommodation.service;

import java.net.URI;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import kr.or.ddit.mohaeng.accommodation.dto.TourApiItemDTO;
import kr.or.ddit.mohaeng.accommodation.dto.TourApiResponse;
import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TourApiService {

	@Autowired
	private IAccommodationMapper accMapper;
	
	@Value("${tour.api.key}")
    private String serviceKey;
	
	@Transactional
	public void fetchAndSaveAccommodations() {
		log.info("fetchAndSaveAccommodations() 실행==========");
		
//		String url = "http://apis.data.go.kr/B551011/KorService1/searchStay1" + "?serviceKey=" + serviceKey + "&_type=json&MobileOS=ETC&MobileApp=Mohaeng&_type=json";
		
		URI uri = UriComponentsBuilder.fromHttpUrl("http://apis.data.go.kr/B551011/KorService1/searchStay1")
		        .queryParam("serviceKey", serviceKey)
		        .queryParam("_type", "json")
		        // ... 생략
		        .build() // true를 넣지 않음!
		        .toUri();
		
		RestTemplate restTemplate = new RestTemplate();
		
		try {
			TourApiResponse response = restTemplate.getForObject(uri, TourApiResponse.class);
			
			if (response != null && response.getResponse().getBody().getItems() != null) {
				List<TourApiItemDTO> apiItems = response.getResponse().getBody().getItems().getItem();
				
				for (TourApiItemDTO item : apiItems) {
					if (accMapper.checkDuplicate(item.getContentid()) == 0) {
						AccommodationVO vo = new AccommodationVO();
						vo.setApiContentId(item.getContentid());
						vo.setAccName(item.getTitle());
						vo.setAccCatCd(item.getCat3());
						vo.setAccFilePath(item.getFirstImage());
						vo.setZip(item.getZipcode());
						vo.setAddr1(item.getAddr1());
						vo.setAddr2(item.getAddr2());
						vo.setMapx(item.getMapx() != null ? item.getMapx() : "0");
						vo.setMapy(item.getMapy() != null ? item.getMapy() : "0");
						vo.setAreacode(item.getAreacode());
						vo.setSigungucode(item.getSigungucode());
						
						accMapper.insertAccommodation(vo);
						log.info("저장 완료: {}", item.getTitle());
					}
				}
			}
		} catch (Exception e) {
			log.error("API 호출 중 에러 발생: ", e);
        }
	}
	
}
