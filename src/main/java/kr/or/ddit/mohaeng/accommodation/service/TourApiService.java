package kr.or.ddit.mohaeng.accommodation.service;

import java.net.URI;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

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
        log.info("데이터 수집 및 초기화 시작==========");
        
        // 1. 기존 데이터 삭제 (새로 싹 받기 위해 도화지 비우기)
        // mapper에 deleteAllAccommodation 쿼리가 없다면 그냥 실행해도 되지만, 
        // 전체 수집할 때는 중복 체크를 빼고 삭제 후 넣는 게 가장 빨라!
        // accMapper.deleteAllAccommodation(); 

        // 2. 수집하고 싶은 지역 코드들 (1:서울, 3:대전, 6:부산, 31:경기, 32:강원, 39:제주)
        String[] areaCodes = {"1", "3", "6", "31", "32", "39"};
        
        RestClient restClient = RestClient.create();
        ObjectMapper mapper = new ObjectMapper();

        for (String code : areaCodes) {
            log.info("{}번 지역 수집 중...", code);
            
            // URL에 numOfRows=100 (한 번에 100개씩) 조절!
            String url = "https://apis.data.go.kr/B551011/KorService2/searchStay2?MobileOS=WEB&MobileApp=Mohaeng"
                    + "&areaCode=" + code 
                    + "&_type=json"
                    + "&pageNo=1"
                    + "&numOfRows=100" 
                    + "&serviceKey=" + serviceKey; // @Value로 받은 키 사용!
            
            try {
                JsonNode responseNode = restClient.get()
                        .uri(URI.create(url))
                        .retrieve()
                        .body(JsonNode.class);

                JsonNode itemsNode = responseNode.path("response").path("body").path("items").path("item");
                
                if (itemsNode.isMissingNode()) {
                    log.warn("{}번 지역에 데이터가 없습니다.", code);
                    continue;
                }

                List<Map<String, String>> tourPlaceList = mapper.convertValue(itemsNode, new TypeReference<>() {});

                for (Map<String, String> item : tourPlaceList) {
                	String firstImage = item.get("firstimage");

                    // ★ 이미지가 null이거나 비어있으면 저장하지 않고 그냥 넘어가기!
                    if (firstImage == null || firstImage.trim().isEmpty()) {
                        log.info("이미지 없는 숙소 '{}' 건너뜀", item.get("title"));
                        continue; 
                    }
                    String apiContentId = item.get("contentid");
                    
                    // 중복 체크는 유지 (도화지를 안 비웠을 경우를 대비)
                    if (accMapper.checkDuplicate(apiContentId) == 0) {
                        AccommodationVO vo = new AccommodationVO();
                        vo.setApiContentId(apiContentId);
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
                        vo.setLdongRegnCd("L_REGN"); // 더미값
                        vo.setLdongSignguCd("L_SIGNGU"); // 더미값
                        
                        accMapper.insertAccommodation(vo);
                    }
                }
                log.info("{}번 지역 {}개 수집 완료!", code, tourPlaceList.size());
                
            } catch (Exception e) {
                log.error("{}번 지역 수집 중 에러 발생: {}", code, e.getMessage());
            }
        }
        log.info("모든 지역 데이터 수집 완료! 건배! 🍻");
    }
//	public void fetchAndSaveAccommodations() {
//		log.info("fetchAndSaveAccommodations() 실행==========");
//		log.info(serviceKey);
//		RestClient restClient = RestClient.create();
//		String url = "https://apis.data.go.kr/B551011/KorService2/searchStay2?MobileOS=WEB&MobileApp=Mohaeng"
//				+ "areaCode=1"
//				+ "&_type=json"
//				+ "&numOfRows=100"
//				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D&";
//		
//		URI uri = URI.create(url);
//		
//		//json 형태로 응답값 받기
//		JsonNode responseNode = restClient.get()
//			    .uri(uri)
//			    .retrieve()
//			    .body(JsonNode.class);
//		
//		ObjectMapper mapper = new ObjectMapper();
//		
//		log.info("responseNode : {}", responseNode.toPrettyString());
//		
//		//json을 map으로
//		Map<String, Object> responseMap = mapper.convertValue(responseNode, Map.class);
//		
//		//json 값에서 item(응답리스트) 지정해서 새 json 객체로...
//		JsonNode itemsNode = responseNode.path("response")
//				.path("body")
//				.path("items")
//				.path("item");
//		
//		ObjectMapper objectMapper = new ObjectMapper();
//		
//		//itemsNode로 List<Map<String, String>>형태로 형변환
//		List<Map<String, String>> tourPlaceList = objectMapper.convertValue(itemsNode, new TypeReference<>() {});
//
//				for (Map<String, String> item : tourPlaceList) {
//					String apiContentId = item.get("contentid");
//					
//					if (accMapper.checkDuplicate(apiContentId) == 0) {
//				        AccommodationVO vo = new AccommodationVO();
//				        
//				        vo.setApiContentId(item.get("contentid"));
//						vo.setAccName(item.get("title"));
//						vo.setAccCatCd(item.get("cat3"));
//						vo.setAccFilePath(item.get("firstimage"));
//						vo.setAreaCode(item.get("areacode"));
//						vo.setSigunguCode(item.get("sigungucode"));
//						vo.setZip(item.get("zipcode"));
//						vo.setAddr1(item.get("addr1"));
//						vo.setAddr2(item.get("addr2"));
//						vo.setMapx(item.get("mapx"));
//						vo.setMapy(item.get("mapy"));
//						vo.setLdongRegnCd("lDongRegnCd");
//						vo.setLdongSignguCd("lDongSignguCd");
//						
//						accMapper.insertAccommodation(vo);
//						log.info("저장 완료: {}", vo.getAccName());
//					} else {
//						log.info("중복된 데이터 건너뜀: {}", item.get("title"));
//					} 
//				}
//
//	}
	
}
