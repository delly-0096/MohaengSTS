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
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
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
        log.info("모든 지역 데이터 수집 완료!");
    }
	
	@Transactional
	public void updateAccommodationDetails() {
	    // 1. 상세 정보가 비어있는 숙소 리스트를 DB에서 가져오기
	    List<AccommodationVO> targetList = accMapper.selectListForDetailUpdate();
	    
	    RestClient restClient = RestClient.create();
        ObjectMapper mapper = new ObjectMapper();

	    for (AccommodationVO acc : targetList) {
	    	try {
	    		Thread.sleep(2000);
	        // 2. 상세 정보 API URL 생성 (detailCommon1)
	        String commonUrl = "https://apis.data.go.kr/B551011/KorService1/detailCommon1?"
	                + "serviceKey=" + serviceKey
	                + "&contentId=" + acc.getApiContentId() // 저장해둔 API용 ID
	                + "&defaultYN=Y&overviewYN=Y&telNoYN=Y&_type=json&MobileOS=ETC&MobileApp=AppTest"; // 필요한 정보들 다 Y!

	        JsonNode commonRes = restClient.get().uri(URI.create(commonUrl)).retrieve().body(JsonNode.class);
            JsonNode commonItem = commonRes.path("response").path("body").path("items").path("item").get(0);
            
            if (commonItem != null) {
                acc.setOverview(commonItem.path("overview").asText());
                acc.setTel(commonItem.path("infocenterlodging").asText()); // 숙박은 infocenterlodging이 전화번호인 경우가 많아!
                acc.setCheckInTime(commonItem.path("checkintime").asText("15:00")); 
                acc.setCheckOutTime(commonItem.path("checkouttime").asText("11:00"));
                accMapper.updateAccommodationDetail(acc); // 설명/전화번호 업데이트
                
            }


            String introUrl = "https://apis.data.go.kr/B551011/KorService1/detailIntro1?"
                    + "serviceKey=" + serviceKey
                    + "&contentId=" + acc.getApiContentId()
                    + "&contentTypeId=32&_type=json&MobileOS=ETC&MobileApp=AppTest"; // 숙박 타입(32) 지정

            JsonNode introRes = restClient.get().uri(URI.create(introUrl)).retrieve().body(JsonNode.class);
            JsonNode introItem = introRes.path("response").path("body").path("items").path("item").get(0);
            
            if (introItem != null) {
            	acc.setCheckInTime(commonItem.path("checkintime").asText("15:00")); 
            	acc.setCheckOutTime(commonItem.path("checkouttime").asText("11:00"));
            	
                AccFacilityVO facilityVO = new AccFacilityVO();
                facilityVO.setAccNo(acc.getAccNo());

                String sub = introItem.path("subfacility").asText("");
                String food = introItem.path("foodplace").asText("");
                String parking = introItem.path("parkinglodging").asText("");
                String cook = introItem.path("chkcooking").asText(""); // 취사 가능 여부

                facilityVO.setParkingYn(parking.contains("가능") ? "Y" : "N");
                facilityVO.setWifiYn(sub.contains("무선인터넷") || sub.contains("와이파이") ? "Y" : "N");
                facilityVO.setPoolYn(sub.contains("수영장") ? "Y" : "N");
                facilityVO.setBreakfastYn(introItem.path("breakfastlodging").asText("").contains("가능") ? "Y" : "N");
                facilityVO.setPetFriendlyYn(introItem.path("petlodging").asText("").contains("가능") ? "Y" : "N");
                facilityVO.setPoolYn(sub.contains("수영장") ? "Y" : "N");
                facilityVO.setGymYn((sub.contains("헬스장") || sub.contains("피트니스") || sub.contains("체력단련")) ? "Y" : "N");
                facilityVO.setSpaYn((sub.contains("스파") || sub.contains("사우나") || sub.contains("욕조") || sub.contains("마사지")) ? "Y" : "N");
                facilityVO.setLaundryYn((sub.contains("세탁") || sub.contains("코인세탁") || sub.contains("드라이클리닝")) ? "Y" : "N");
                facilityVO.setSmokingAreaYn(sub.contains("흡연구역") ? "Y" : "N");
                
                boolean hasRestaurant = food.length() > 2 || sub.contains("식당") || sub.contains("레스토랑") || sub.contains("카페");
                facilityVO.setRestaurantYn(hasRestaurant ? "Y" : "N");
                facilityVO.setBarYn((sub.contains("바") || sub.contains("라운지") || sub.contains("주점")) ? "Y" : "N");
                
                facilityVO.setRoomServiceYn(sub.contains("룸서비스") ? "Y" : "N");
                
                
                accMapper.upsertAccFacility(facilityVO); // 시설 정보 MERGE INTO 실행
                
                updateRoomDetails(acc, restClient);

                log.info("숙소 '{}' 전체 업데이트 성공!", acc.getAccName());
                Thread.sleep(1000); // 매너 타임
            }
            
            log.info("숙소 '{}' (ID:{}) 상세 및 시설 정보 업데이트 완료!", acc.getAccName(), acc.getAccNo());
            Thread.sleep(1000); // API 서버 매너 지키기

        } catch (Exception e) {
            log.error("숙소 업데이트 중 에러 발생 (ID:{}): {}", acc.getAccNo(), e.getMessage());
        }
	    }
	
	}
	@Transactional
	public void updateRoomDetails(AccommodationVO acc, RestClient restClient) {
	    try {
	        // 1. detailInfo1 호출 (객실 정보 조회)
	        String roomUrl = "https://apis.data.go.kr/B551011/KorService1/detailInfo1?"
	                + "serviceKey=" + serviceKey
	                + "&contentId=" + acc.getApiContentId()
	                + "&contentTypeId=32&_type=json&MobileOS=ETC&MobileApp=AppTest";

	        JsonNode roomRes = restClient.get().uri(URI.create(roomUrl)).retrieve().body(JsonNode.class);
	        JsonNode roomItems = roomRes.path("response").path("body").path("items").path("item");

	        // 객실이 여러 개일 수 있으니 반복문 시작!
	        for (JsonNode room : roomItems) {
	            RoomTypeVO roomType = new RoomTypeVO();
	            roomType.setAccNo(acc.getAccNo());
	            roomType.setRoomName(room.path("roomtitle").asText("기본 객실"));
	            roomType.setBaseGuestCount(room.path("roombasecount").asInt(2));
	            roomType.setMaxGuestCount(room.path("roommaxcount").asInt(4));
	            roomType.setPrice(room.path("roomoffseasonminfee1").asInt(50000)); // 비성수기 요금 기준
	            roomType.setRoomSize(room.path("roomsize1").asInt(0));

	            // [STEP 1] ROOM_TYPE 저장 (Generated Keys로 roomTypeNo를 받아와야 함!)
	            accMapper.insertRoomType(roomType);
	            int roomTypeNo = roomType.getRoomTypeNo();

	            // [STEP 2] ROOM_FACILITY (객실 내 시설) - API 텍스트 기반 매핑
	            RoomFacilityVO facility = new RoomFacilityVO();
	            facility.setRoomTypeNo(roomTypeNo);
	            
	            // API 응답 중 시설 관련 필드들 (roomaircondition, roomtv 등)
	            facility.setAirConYn(room.path("roomaircondition").asText("N").equals("Y") ? "Y" : "N");
	            facility.setTvYn(room.path("roomtv").asText("N").equals("Y") ? "Y" : "N");
	            facility.setFridgeYn(room.path("roomrefrigerator").asText("N").equals("Y") ? "Y" : "N");
	            facility.setHairDryerYn(room.path("roomhairdryer").asText("N").equals("Y") ? "Y" : "N");
	            facility.setToiletriesYn(room.path("roomtoiletries").asText("N").equals("Y") ? "Y" : "N");
	            // 나머지는 기본값 N
	            accMapper.insertRoomFacility(facility);
	            
	         // [STEP 3] ROOM_FEATURE (객실 특징) 상세 매핑
	            RoomFeatureVO feature = new RoomFeatureVO();
	            feature.setRoomTypeNo(roomTypeNo);

	            // API에서 텍스트 데이터 가져오기
	            String intro = room.path("roomintro").asText(""); // 객실 소개글
	            String roomCook = room.path("roomcook").asText(""); // 취사 여부 전용 필드

	            // 1. 전망 관련 (소개글에서 키워드 추출)
	            feature.setOceanViewYn((intro.contains("바다") || intro.contains("오션뷰") || intro.contains("해변")) ? "Y" : "N");
	            feature.setMountainViewYn((intro.contains("산") || intro.contains("마운틴뷰") || intro.contains("숲")) ? "Y" : "N");
	            feature.setCityViewYn((intro.contains("시티") || intro.contains("전망") || intro.contains("야경")) ? "Y" : "N");

	            // 2. 공간 구성 관련
	            feature.setLivingRoomYn((intro.contains("거실") || intro.contains("스위트") || intro.contains("분리형")) ? "Y" : "N");
	            feature.setTerraceYn((intro.contains("테라스") || intro.contains("발코니") || intro.contains("베란다")) ? "Y" : "N");

	            // 3. 서비스 및 기타
	            // API에서 "무료취소" 정보는 잘 안 오지만, 보통 예약 정책 문자열에 포함되니 체크!
	            feature.setFreeCancelYn(intro.contains("무료취소") || intro.contains("환불가능") ? "Y" : "N");
	            feature.setNonSmokingYn((intro.contains("금연") || intro.contains("쾌적")) ? "Y" : "N");

	            // 4. 취사 가능 여부 (전용 필드 우선, 없으면 소개글 체크)
	            boolean canCook = roomCook.contains("가능") || intro.contains("취사") || intro.contains("주방") || intro.contains("싱크대");
	            feature.setKitchenYn(canCook ? "Y" : "N");

	            // DB에 쑤셔넣기 (Insert 실행)
	            accMapper.insertRoomFeature(feature);
	        }
	       
	    } catch (Exception e) {
	        log.error("객실 정보 업데이트 중 에러 (ID:{}): {}", acc.getAccNo(), e.getMessage());
	    }
	}
}
