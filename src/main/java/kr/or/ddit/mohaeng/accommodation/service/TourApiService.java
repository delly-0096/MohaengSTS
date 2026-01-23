package kr.or.ddit.mohaeng.accommodation.service;


import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.vo.AccFacilityVO;
import kr.or.ddit.mohaeng.vo.AccommodationVO;
import kr.or.ddit.mohaeng.vo.RoomFacilityVO;
import kr.or.ddit.mohaeng.vo.RoomFeatureVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class TourApiService {

	@Autowired
	private IAccommodationMapper accMapper;
	
	
	
	
	@Value("${tour.api.key}")
    private String serviceKey;
	
	private final RestClient restClient = RestClient.create();
	
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
	
	
	// 1. 안전하게 아이템 가져오는 헬퍼 메소드 추가
	private JsonNode getFirstItem(JsonNode res) {
	    JsonNode items = res.path("response").path("body").path("items").path("item");
	    if (items.isArray() && items.size() > 0) {
	        return items.get(0);
	    }
	    return null; // 데이터 없으면 null 반환해서 터지는 거 방지!
	}
	

	public void updateAccommodationDetails() {
	    // 1. 상세 정보가 비어있는 숙소 리스트를 DB에서 가져오기
	    List<AccommodationVO> targetList = accMapper.selectListForDetailUpdate();
	    RestClient restClient = RestClient.create();

	    for (AccommodationVO acc : targetList) {
	        try {
	        	
	            // [STEP 1] URL 조립 시 UriComponentsBuilder 사용 (인코딩 자동 해결)
	            String commonUrl = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailCommon1")
	                    .queryParam("serviceKey", serviceKey)
	                    .queryParam("contentId", acc.getApiContentId())
	                    .queryParam("defaultYN", "Y")
	                    .queryParam("overviewYN", "Y")
	                    .queryParam("telNoYN", "Y")
	                    .queryParam("_type", "json")
	                    .queryParam("MobileOS", "WEB")
	                    .queryParam("MobileApp", "Mohaeng")
	                    .build().toUriString();

	            JsonNode commonRes = restClient.get().uri(URI.create(commonUrl)).retrieve().body(JsonNode.class);
	            JsonNode commonItem = getFirstItem(commonRes); // .get(0) 대신 안전
            
            if (commonItem != null) {
                acc.setOverview(commonItem.path("overview").asText());
                acc.setTel(commonItem.path("infocenterlodging").asText());
                accMapper.updateAccommodationDetail(acc); // 설명/전화번호 업데이트
                
            }


            String introUrl = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailIntro1")
                    .queryParam("serviceKey", serviceKey)
                    .queryParam("contentId", acc.getApiContentId())
                    .queryParam("contentTypeId", "32")
                    .queryParam("_type", "json")
                    .queryParam("MobileOS", "WEB")
                    .queryParam("MobileApp", "Mohaeng")
                    .build().toUriString();

            JsonNode introRes = restClient.get().uri(URI.create(introUrl)).retrieve().body(JsonNode.class);
            JsonNode introItem = getFirstItem(introRes);
            
            if (introItem != null) {
            	acc.setCheckInTime(introItem.path("checkintime").asText("15:00"));
            	acc.setCheckOutTime(introItem.path("checkouttime").asText("11:00"));
            	
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
	    	String roomUrl = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailInfo1")
	                .queryParam("serviceKey", serviceKey)
	                .queryParam("contentId", acc.getApiContentId())
	                .queryParam("contentTypeId", "32")
	                .queryParam("_type", "json")
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .build().toUriString();

	        JsonNode roomRes = restClient.get().uri(URI.create(roomUrl)).retrieve().body(JsonNode.class);
	        JsonNode roomItems = roomRes.path("response").path("body").path("items").path("item");

	        // ★ 객실 데이터가 배열로 정상적으로 올 때만 반복문 실행!
	        if (roomItems.isArray() && roomItems.size() > 0) {
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
	        }
	    } catch (Exception e) {
	        log.error("객실 정보 업데이트 중 에러 (ID:{}): {}", acc.getAccNo(), e.getMessage());
	    }
	}


	/**
	 * <p>숙소 정보 가져오기</p>
	 * @author sdg
	 * @date 2026-01-23
	 * @param accommodation (accName, areaCode, ldongRegnCd)
	 * @return 상세 정보 채워진 Accommodation
	 */
	public AccommodationVO getDetailedAccommodation(AccommodationVO accommodation) {
		
		String contentId = null;
	    if (accommodation.getMapx() != null && accommodation.getMapy() != null) {
	        contentId = fetchContentIdByLocation(accommodation);
	    }
	    
		if (contentId == null) {
			contentId = fetchContentIdByName(accommodation);
	        log.warn("검색 결과 없음");
	        return null;
	    }
		
		accommodation.setApiContentId(contentId);
		// 3. 공통 정보 & 소개 정보 채우기 (이미지, 개요, 체크인/아웃, 숙소보유시설)
		fillCommonAndIntroData(accommodation);
		
		try {
	        // 4. 객실 목록 정보 채우기 (객실명, 가격, 객실 시설)
	        List<RoomTypeVO> roomTypeList = fetchRoomTypeList(accommodation);
	        accommodation.setRoomTypeList(roomTypeList);
	        log.info("숙소 상세 데이터 통합 로드 완료: {}", accommodation.getAccName());
	        return accommodation;
	    } catch (Exception e) {
	        log.error("상세 데이터 조립 중 에러 발생: {}", e.getMessage());
	        return accommodation; // 에러가 나더라도 찾은 부분까지는 반환
	    }
	}

	/**
	 * [신규] 좌표 기반 주변 숙소 검색
	 */
	private String fetchContentIdByLocation(AccommodationVO accommodation) {
	    try {
	    	URI uri = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService2/locationBasedList2")
	                .queryParam("serviceKey", serviceKey)
	                .queryParam("mapX", accommodation.getMapx())
	                .queryParam("mapY", accommodation.getMapy())
	                .queryParam("radius", "200")
	                .queryParam("contentTypeId", "32")
	                .queryParam("_type", "json")
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .build(true) // <--- true로 고정
	                .toUri();
	    	
	        JsonNode res = restClient.get().uri(uri).retrieve().body(JsonNode.class);
	        JsonNode item = getFirstItem(res);

	        if (item != null) {
	        	log.info("위치 검색 성공: {}", item.path("title").asText());
	            
	            // [추가] 위치 기반 검색 결과에서 미리 챙길 수 있는 것들 다 챙기기
	            accommodation.setAccCatCd(item.path("cat3").asText());
	            accommodation.setAreaCode(item.path("areacode").asText(""));
	            accommodation.setSigunguCode(item.path("sigungucode").asText("")); // 시군구 코드 해결
	            
	            // [중요] 여기서 미리 이미지를 세팅해두면 안전합니다.
	            String img = item.path("firstimage").asText("");
	            if(img.isEmpty()) img = item.path("firstimage2").asText("");
	            accommodation.setAccFilePath(img); 

	            return item.path("contentid").asText();
	        }
	    } catch (Exception e) {
	        log.error("위치 기반 검색 중 에러: {}", e.getMessage());
	    }
	    return null;
	}
	
	/**
	 * <p>contentId 가져오기</p>
	 * @author sdg
	 * @date 2026-01-23
	 * @param accName 숙소명
	 * @param areaCode 시군구 지역코드
	 * @return contentId
	 */
	private String fetchContentIdByName(AccommodationVO accommodation) {
		try {
			String keyword = accommodation.getAccName();
	        log.info("API 검색 시도 - 키워드: [{}], 지역코드: [{}]", keyword, accommodation.getAreaCode());

	        // 1. serviceKey가 이미 인코딩된 상태라면, build(true)를 써야 합니다.
	        // 2. 하지만 한글은 수동으로 인코딩해서 넣어줘야 'Invalid character'를 피합니다.
	        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);

	        URI uri = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService2/searchKeyword2")
	                .queryParam("serviceKey", serviceKey) // 서비스키 그대로 주입
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .queryParam("keyword", encodedKeyword) // 인코딩된 키워드 주입
	                .queryParam("areaCode", accommodation.getAreaCode())
	                .queryParam("contentTypeId", "32")
	                .queryParam("_type", "json")
	                .build(true) // <--- 핵심: "이미 인코딩 다 끝냈으니 더 이상 건드리지 마!"
	                .toUri();

	        JsonNode res = restClient.get().uri(uri).retrieve().body(JsonNode.class);
	        log.info("API 응답 결과: {}", res.toString());
		    
		    JsonNode item = getFirstItem(res);
		    if (item != null) {
		    	String contentId = item.path("contentid").asText();
	            accommodation.setApiContentId(contentId);
	            accommodation.setAccCatCd(item.path("cat3").asText());
	            return contentId;
	        } else {
	            // 3. 지역 코드 없이 재검색 시도 (선택 사항: 지역 코드가 잘못 매핑되었을 가능성 대비)
	            log.warn("지역 코드 포함 검색 실패. 지역 코드 없이 재검색 시도 중...");
	            // 여기서 areaCode를 뺀 URL로 한 번 더 요청해보는 로직을 넣을 수도 있습니다.
	        }
	        return null;
		}catch (Exception e) {
			log.error("관광 API 키워드 검색 중 예외 발생 [숙소명: {}]: {}", accommodation.getAccName(), e.getMessage());
	        return null;
		}
	}
	
	/**
	 * <p>숙소 정보, 숙소 보유시설 값 불러오기</p>
	 * @author sdg
	 * @date 2026-01-23
	 * @param accommodation 
	 */
	private void fillCommonAndIntroData(AccommodationVO accommodation) {
		try {
	        // [STEP 1] detailCommon2: 개요 및 대표이미지
			URI commonUri = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService2/detailCommon2")	                .queryParam("serviceKey", serviceKey)
	                .queryParam("contentId", accommodation.getApiContentId())
	                .queryParam("defaultYN", "Y")    // 기본정보(주소, 제목 등)
	                .queryParam("overviewYN", "Y")   // 개요(설명)
	                .queryParam("firstImageYN", "Y") // 이미지
	                .queryParam("addrinfoYN", "Y")   // 주소/우편번호
	                .queryParam("telNoYN", "Y")      // 전화번호
	                .queryParam("mapinfoYN", "Y")    // 좌표(X, Y)
	                .queryParam("addrinfoYN", "Y")   // 주소
	                .queryParam("_type", "json")
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .build(true) // <--- true
	                .toUri();
			
			JsonNode commonRes = restClient.get().uri(commonUri).retrieve().body(JsonNode.class);
	        JsonNode commonItem = getFirstItem(commonRes);
	        
	        if (commonItem != null) {
	            // 기본 정보 세팅 (데이터 누락 방지용 asText 기본값 설정)
	            accommodation.setOverview(commonItem.path("overview").asText("등록된 설명이 없습니다."));
	            accommodation.setTel(commonItem.path("infocenterlodging").asText(commonItem.path("tel").asText("")));
	            accommodation.setAddr1(commonItem.path("addr1").asText(""));
	            accommodation.setAddr2(commonItem.path("addr2").asText(""));
	            accommodation.setZip(commonItem.path("zipcode").asText(""));
	            
	            if(accommodation.getAccFilePath() == null || accommodation.getAccFilePath().isEmpty()) {
	                String mainImg = commonItem.path("firstimage").asText("");
	                if (mainImg.isEmpty()) mainImg = commonItem.path("firstimage2").asText("");
	                accommodation.setAccFilePath(mainImg);
	            }
	            
	            accommodation.setMapx(commonItem.path("mapx").asText(accommodation.getMapx()));
	            accommodation.setMapy(commonItem.path("mapy").asText(accommodation.getMapy()));
	            accommodation.setAreaCode(commonItem.path("areacode").asText(""));
	            accommodation.setSigunguCode(commonItem.path("sigungucode").asText(""));
	        }
	        
	        log.info("숙소 정보, 숙소내 정보 가져오기 성공 : {}",accommodation);
	        // [STEP 2] detailIntro2: 체크인/아웃 및 부대시설 키워드 추출
	        URI introUri = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService2/detailIntro2")
	                .queryParam("serviceKey", serviceKey)
	                .queryParam("contentId", accommodation.getApiContentId())
	                .queryParam("contentTypeId", "32") // 숙박 카테고리 고정
	                .queryParam("_type", "json")
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .build(true) // <--- true
	                .toUri();

	        JsonNode introRes = restClient.get().uri(introUri).retrieve().body(JsonNode.class);
	        JsonNode introItem = getFirstItem(introRes);

	        if (introItem != null) {
	            // 1. 운영 시간
	            accommodation.setCheckInTime(introItem.path("checkintime").asText("15:00"));
	            accommodation.setCheckOutTime(introItem.path("checkouttime").asText("11:00"));

	            // 2. 부대시설 매핑 (AccFacilityVO)
	            AccFacilityVO facility = new AccFacilityVO();
	            
	            // API의 여러 텍스트 필드를 통합 분석하여 누락 최소화
	            String sub = introItem.path("subfacility").asText("");  // 부대시설 텍스트
	            String parking = introItem.path("parkinglodging").asText(""); // 주차 여부
	            String pet = introItem.path("petlodging").asText(""); // 반려동물 여부
	            String food = introItem.path("foodplace").asText(""); // 식당 정보

	            // Y/N 판별 로직 적용
	            facility.setParkingYn(parking.contains("가능") || parking.contains("있음") ? "Y" : "N");
	            facility.setWifiYn(sub.contains("와이파이") || sub.contains("인터넷") || sub.contains("무선") ? "Y" : "N");
	            facility.setPoolYn(sub.contains("수영장") || sub.contains("풀장") ? "Y" : "N");
	            facility.setGymYn(sub.contains("헬스") || sub.contains("휘트니스") || sub.contains("체력단련") ? "Y" : "N");
	            facility.setRestaurantYn(food.length() > 2 || sub.contains("식당") || sub.contains("레스토랑") ? "Y" : "N");
	            facility.setPetFriendlyYn(pet.contains("가능") || pet.contains("있음") ? "Y" : "N");
	            facility.setLaundryYn(sub.contains("세탁") || sub.contains("코인") ? "Y" : "N");
	            facility.setBarYn(sub.contains("바") || sub.contains("라운지") || sub.contains("주점") ? "Y" : "N");
	            facility.setSpaYn(sub.contains("스파") || sub.contains("사우나") || sub.contains("욕조") ? "Y" : "N");
	            
	            // 완성된 facility를 accommodation에 세팅
	            accommodation.setAccFacility(facility); 
	            log.info("숙소 정보, 숙소내 정보 가져오기 성공 : {}, {}",accommodation, accommodation.getAccFacility());
	        }
	    } catch (Exception e) {
	        log.error("공통/소개 정보 채우기 실패: {}", e.getMessage());
	    }
	}
	
	
	/**
	 * <p>객실타입</p>
	 * @param accommodation
	 * @return
	 */
	private List<RoomTypeVO> fetchRoomTypeList(AccommodationVO accommodation) {
		List<RoomTypeVO> roomTypeList = new ArrayList<>();
	    
	    try {
	        // [STEP 1] detailInfo1 호출: 객실별 상세 사양(이름, 정원, 요금, 시설 등)
	        URI roomUrl = UriComponentsBuilder.fromHttpUrl("https://apis.data.go.kr/B551011/KorService2/detailInfo2")
	                .queryParam("serviceKey", serviceKey)
	                .queryParam("contentId", accommodation.getApiContentId())
	                .queryParam("contentTypeId", "32")
	                .queryParam("_type", "json")
	                .queryParam("MobileOS", "WEB")
	                .queryParam("MobileApp", "Mohaeng")
	                .build(true) // <--- true
	                .toUri();

	        JsonNode roomRes = restClient.get().uri(roomUrl).retrieve().body(JsonNode.class);
	        JsonNode roomItems = roomRes.path("response").path("body").path("items").path("item");

	        // 객실 데이터가 존재할 경우에만 처리
	        if (roomItems.isArray()) {
	            for (JsonNode room : roomItems) {
	                RoomTypeVO roomType = new RoomTypeVO();
	                
	                // 1. 객실 기본 사양
	                roomType.setRoomName(room.path("roomtitle").asText("기본 객실"));
	                roomType.setBaseGuestCount(room.path("roombasecount").asInt(2));
	                roomType.setMaxGuestCount(room.path("roommaxcount").asInt(4));
	                // 비성수기 주중 최소 요금을 기본값으로 세팅
	                int minFee = room.path("roomoffseasonminfee1").asInt(0);
	                roomType.setPrice(minFee > 0 ? minFee : 50000); 
	                roomType.setRoomSize(room.path("roomsize1").asInt(0));

	                // 2. 객실 내 시설 매핑 (RoomFacilityVO)
	                RoomFacilityVO facility = new RoomFacilityVO();
	                // API는 "Y" 또는 "있음" 등으로 응답하므로 contains("Y")나 "1" 등으로 체크
	                facility.setAirConYn(isPositive(room.path("roomaircondition").asText()) ? "Y" : "N");
	                facility.setTvYn(isPositive(room.path("roomtv").asText()) ? "Y" : "N");
	                facility.setFridgeYn(isPositive(room.path("roomrefrigerator").asText()) ? "Y" : "N");
	                facility.setHairDryerYn(isPositive(room.path("roomhairdryer").asText()) ? "Y" : "N");
	                facility.setToiletriesYn(isPositive(room.path("roomtoiletries").asText()) ? "Y" : "N");
	                facility.setBathtubYn(isPositive(room.path("roombath").asText()) ? "Y" : "N");
	                
	                roomType.setFacility(facility);

	                // 3. 객실 특징/속성 매핑 (RoomFeatureVO) - 소개글 텍스트 분석
	                RoomFeatureVO feature = new RoomFeatureVO();
	                String intro = room.path("roomintro").asText("");
	                String cook = room.path("roomcook").asText("");

	                // 텍스트 포함 여부로 특징 추출 (데이터 누락 방지 핵심)
	                feature.setOceanViewYn((intro.contains("바다") || intro.contains("오션")) ? "Y" : "N");
	                feature.setMountainViewYn((intro.contains("산") || intro.contains("마운틴")) ? "Y" : "N");
	                feature.setCityViewYn((intro.contains("시티") || intro.contains("도심")) ? "Y" : "N");
	                feature.setKitchenYn((isPositive(cook) || intro.contains("취사") || intro.contains("주방")) ? "Y" : "N");
	                feature.setNonSmokingYn(intro.contains("금연") ? "Y" : "N");
	                feature.setTerraceYn((intro.contains("테라스") || intro.contains("발코니")) ? "Y" : "N");
	                
	                roomType.setFeature(feature);
	                
	                roomTypeList.add(roomType);
	            }
	        }
	    } catch (Exception e) {
	        log.error("객실 리스트 매핑 중 에러 발생: {}", e.getMessage());
	    }
	    return roomTypeList;
	}
	
	/**
	 * API 응답값이 긍정(Y, 있음, 1)인지 판단하는 헬퍼 메서드
	 */
	private boolean isPositive(String val) {
	    if (val == null || val.isEmpty()) return false;
	    return val.equalsIgnoreCase("Y") || val.contains("있음") || val.equals("1");
	}

}

