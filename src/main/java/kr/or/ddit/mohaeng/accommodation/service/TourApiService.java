package kr.or.ddit.mohaeng.accommodation.service;

import java.net.URI;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

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
		log.info(serviceKey);
		RestClient restClient = RestClient.create();
		String url = "https://apis.data.go.kr/B551011/KorService2/searchStay2?MobileOS=WEB&MobileApp=Mohaeng"
				+ "lDongRegnCd=11"
				+ "&_type=json"
				+ "&numOfRows=20"
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D&";
		
		URI uri = URI.create(url);
		
		//json 형태로 응답값 받기
		JsonNode responseNode = restClient.get()
			    .uri(uri)
			    .retrieve()
			    .body(JsonNode.class);
		
		ObjectMapper mapper = new ObjectMapper();
		
		log.info("responseNode : {}", responseNode.toPrettyString());
		
		//json을 map으로
		Map<String, Object> responseMap = mapper.convertValue(responseNode, Map.class);
		
		//json 값에서 item(응답리스트) 지정해서 새 json 객체로...
		JsonNode itemsNode = responseNode.path("response")
				.path("body")
				.path("items")
				.path("item");
		
		ObjectMapper objectMapper = new ObjectMapper();
		
		//itemsNode로 List<Map<String, String>>형태로 형변환
		List<Map<String, String>> tourPlaceList = objectMapper.convertValue(itemsNode, new TypeReference<>() {});

				for (Map<String, String> item : tourPlaceList) {
					String apiContentId = item.get("contentid");
					
					if (accMapper.checkDuplicate(apiContentId) == 0) {
				        AccommodationVO vo = new AccommodationVO();
				        
				        vo.setApiContentId(item.get("contentid"));
						vo.setAccName(item.get("title"));
						vo.setAccCatCd(item.get("cat3"));
						vo.setAccFilePath(item.get("firstimage"));
						vo.setAreaCode(item.get("areacode"));
						vo.setSigunguCode(item.get("sigungucode"));
						vo.setZip(item.get("zipcode"));
						vo.setAddr1(item.get("addr1"));
						vo.setAddr2(item.get("addr2"));
						vo.setMapx(item.get("mapx"));
						vo.setMapy(item.get("mapy"));
						vo.setLdongRegnCd("lDongRegnCd");
						vo.setLdongSignguCd("lDongSignguCd");
						
						accMapper.insertAccommodation(vo);
						log.info("저장 완료: {}", vo.getAccName());
					} else {
						log.info("중복된 데이터 건너뜀: {}", item.get("title"));
					} 
				}

	}
	
}
