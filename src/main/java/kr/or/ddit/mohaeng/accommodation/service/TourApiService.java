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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.DefaultUriBuilderFactory;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;
import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.product.manage.mapper.IProductMangeMapper;
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
	
	
	@Autowired
	private IProductMangeMapper mangeMapper;	// 존재 여부 체크
	
	@Value("${tour.api.key}")
    private String serviceKey;
	
	private final RestClient restClient = RestClient.create();
	
	private RestTemplate restTemplate;	// api사용을 위해선는 객체
	
	/**
	 * service로직 실행하자마자 실행됨
	 * <p>API 사용을 위한 restTemplate 초기화</p>
	 * @author sdg
	 * @date 2026-01-24
	 */
	@PostConstruct
    public void init() {
        this.restTemplate = new RestTemplate();
        DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
        factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
        this.restTemplate.setUriTemplateHandler(factory);
        
        log.info("TourApiService: RestTemplate 초기화 완료");
    }


	/**
	 * <p>숙소 정보 가져오기</p>
	 * @author sdg
	 * @date 2026-01-23
	 * @param accommodation (lDongRegnCd, ldongSignguCd, zone, roadAddress, address, jibunAddress)
	 * @return 상세 정보 채워진 Accommodation
	 */
	public AccommodationVO getDetailedAccommodation(AccommodationVO accommodation) {
		
    	log.info("accommodation.lDongRegnCd : {}", accommodation.getLdongRegnCd());
    	log.info("accommodation.ldongSignguCd : {}", accommodation.getLdongSignguCd());
    	log.info("accommodation.zone : {}", accommodation.getZone());
    	log.info("accommodation .roadAddress: {}", accommodation.getRoadAddress());
    	log.info("accommodation.address : {}", accommodation.getAddress());
    	log.info("accommodation.jibunAddress : {}", accommodation.getJibunAddress());
    	
    	// 기본 값 세팅 - key값이 주요
    	accommodation = fetchContentIdByCd(accommodation);	// contentId 존재
    	
    	return accommodation;
		
		// 해볼것 
		/*
		 search할것
		 // 얘네는 그냥 스크립트에서 설정해서 보내기. 받을 변수가 있으니까
		 String lDongRegnCd = bcode.substring(0, 2);    // 시도 (예: 50)
    	 String lDongSignguCd = bcode.substring(2, 5);  // 시군구 (예: 110)
    	  
    	  이걸 해서 나온 List.
    	  밑의 것들과 매칭시 하나읙 밧이 나옴
    	  
    	  String zonecode  = zipcode와 매칭 
    	  String roadAddress = addr1과 매칭
    	  String address = addr1과 매칭
    	  String jibunAddress = addr1과 매칭
    	  
    	  http://apis.data.go.kr/B551011/KorService2/searchStay2?serviceKey=인증키&numOfRows=50&pageNo=1&MobileOS=ETC&MobileApp=AppTest&_type=json&lDongRegnCd=50&lDongSignguCd=110
    	  
    	  주차, 체크인 시간 등등
    	  http://apis.data.go.kr/B551011/KorService2/detailInfo2
			핵심 파라미터: contentId, contentTypeId=32
			
			객실 정보 (객실수, 객실 타입 등)
			Endpoint: http://apis.data.go.kr/B551011/KorService2/detailInfo2
			
			핵심 파라미터: contentId, contentTypeId=32
		 */
	}

	/**
	 * <p>기본값 세팅을 위한 api 호출</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param accommodation (법정동 시군구 코드, 법정동 시도 코드, 우편번호, 도로명주소, 주소, 지번 주소)
	 * @return 숙소 정보
	 */
	private AccommodationVO fetchContentIdByCd(AccommodationVO accommodation) {
		log.info("키값 찾기 : fetchContentIdByCd ");
		try {
			String baseUrl = "http://apis.data.go.kr/B551011/KorService2/searchStay2";
			
			StringBuilder urlBuilder = new StringBuilder(baseUrl);
			urlBuilder.append("?serviceKey=" + serviceKey);
			urlBuilder.append("&_type=json&MobileOS=ETC&MobileApp=Mohaeng&numOfRows=50");
			urlBuilder.append("&lDongRegnCd=" + accommodation.getLdongRegnCd());
			urlBuilder.append("&lDongSignguCd=" + accommodation.getLdongSignguCd());
			
			String jsonResponse = restTemplate.getForObject(urlBuilder.toString(), String.class);
			
			// 3. Jackson 파싱
			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode root = objectMapper.readTree(jsonResponse);
			JsonNode items = root.path("response").path("body").path("items").path("item");
			
			if (items.isArray()) {
	            for (JsonNode node : items) {
	                if (isMatch(node, accommodation)) {
	                    bindData(accommodation, node); // 매칭 성공 시 데이터 바인딩 후 즉시 반환
	                    break;
	                }
	            }
	        } else if (items.isObject()) {
	            if (isMatch(items, accommodation)) {
	                bindData(accommodation, items);
	            }
	        }
			
			log.info("기본 데이터 세팅 완료 : {}", accommodation);
			
			// 반환 받은 값들 기본 데이터 매핑 한 vo 객체의 키 여부를 확인해서 실행
			if (accommodation != null && accommodation.getApiContentId() != null) {

				// 해당 id의 등록 여부
				if(mangeMapper.existsByApiContentId(accommodation) == null) {
					// 2. 상세 소개 정보 채우기 (입실/퇴실/주차/개요 등)
					log.info("해당 키의 등록 정보 없음");
					fillDetailData(accommodation);
					// fetchRoomTypeList(accommodation);	// 이렇게 나눠야되나??
					log.info("최종 매핑 완료 숙소명: {}", accommodation.getAccName());
					return accommodation;
				} else {
					log.error("이미 등록된 숙소 입니다.");
					return null;
				}
		    }
			return null;
			
		} catch(Exception e){
			log.error("에러 발생 : {}", e.getMessage());
		}
		return null;
	}

	
	/**
	 * <p>일치하는 데이터 찾기</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param node	  (api 응답객체)
	 * @param target (시군구 코드, 시도 코드, 우편번호, 도로명주소, 주소, 지번 주소)
	 * @return true, false
	 */
	private boolean isMatch(JsonNode node, AccommodationVO target) {
	    String apiAddr = node.path("addr1").asText().replaceAll("\\s", "");
	    String apiZip = node.path("zipcode").asText();
	    
	    String targetRoad = target.getRoadAddress().replaceAll("\\s", "");
	    String targetZip = target.getZone();

	    // 우편번호가 같거나, 도로명 주소가 포함 관계일 때 매칭 성공으로 간주
	    return apiZip.equals(targetZip) || apiAddr.contains(targetRoad) || targetRoad.contains(apiAddr);
	}
	
	/**
	 * <p>숙소 데이터 세팅</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param vo (시군구 코드, 시도 코드, 우편번호, 도로명주소, 주소, 지번 주소)
	 * @param node (api 응답객체)
	 * @return 숙소정보를 담은 객체
	 */
	private AccommodationVO bindData(AccommodationVO vo, JsonNode node) {
		// mapx,mapy는 지도 api의 것을 사용 이미 프론트에서 값 지정해줌
		log.info("node : {}", node);
	    vo.setApiContentId(node.path("contentid").asText());	// api id
	    vo.setAccName(node.path("title").asText());				// 숙소명
	    vo.setTel(node.path("tel").asText());					// 전화번호 - 없을수도 있음
	    vo.setAccFilePath(node.path("firstimage").asText());	// 숙소 사진 경로
	    vo.setAccCatCd(node.path("cat3").asText());				// 숙소 타입
	    vo.setAreaCode(node.path("areacode").asText());			// 숙소 타입
	    vo.setSigunguCode(node.path("sigungucode").asText());	// 시군구코드
	    vo.setAddr1(node.path("addr1").asText());				// 주소 
	    vo.setAddr2(node.path("addr2").asText());				// 상세주소 
	    vo.setMapx(node.path("mapx").asText());					// x좌표
	    vo.setMapy(node.path("mapy").asText());					// y좌표
	    vo.setZip(node.path("zipcode").asText());				// 우편번호
	    return vo;
	}
	
	
	/**
	 * <p>숙소 소개</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param accommodation (contentId)
	 */
	private void fillDetailData(AccommodationVO accommodation) {
	    try {
	    	String contentId = accommodation.getApiContentId();	// contentId api 용 id
	    	
	        // A. 소개 정보 조회 (detailIntro2) -> 입실/퇴실/주차장 정보
	        StringBuilder introUrl = new StringBuilder("http://apis.data.go.kr/B551011/KorService2/detailIntro2");
	        introUrl.append("?serviceKey=").append(serviceKey);
	        introUrl.append("&_type=json&MobileOS=ETC&MobileApp=Mohaeng&contentTypeId=32");
	        introUrl.append("&contentId=").append(contentId);
	        
	        String introRes = restTemplate.getForObject(introUrl.toString(), String.class);
	        ObjectMapper mapper = new ObjectMapper();
	        JsonNode introNode = mapper.readTree(introRes).path("response").path("body").path("items").path("item");

	        // 결과가 리스트로 올 수도, 단일 객체로 올 수도 있으므로 안전하게 처리
	        JsonNode detail = introNode.isArray() ? introNode.get(0) : introNode;
	        
	        log.info("숙소 정보 가져오기 detail : {}", detail);
	        
	        // 숙소보유 시설
	        AccFacilityVO accFacility = new AccFacilityVO();
	        if (!detail.isMissingNode()) {
	        	accommodation.setCheckInTime(formatTime(detail.path("checkintime").asText()));	// 입실 시간
	        	accommodation.setCheckOutTime(formatTime(detail.path("checkouttime").asText()));// 퇴실 시간
	        	
	        	// 총 객실수
	        	String roomCountStr = detail.path("roomcount").asText("0");
	            String roomCountOnlyNum = roomCountStr.replaceAll("[^0-9]", ""); // 숫자만 추출
	            if(!roomCountOnlyNum.isEmpty()) {
	                accommodation.setTotalRoomCnt(roomCountOnlyNum);
	            }
	            
	            // 전화번호
	        	if(accommodation.getTel() == null || accommodation.getTel().equals("")) {
	        		accommodation.setTel(detail.path("infocenterlodging").asText());
	        	}
	        	
	            // 만약 주차 여부를 overview 등에 합치고 싶다면 여기서 추출
	            String parking = detail.path("parkinglodging").asText();
	            accFacility.setParkingYn(parking.contains("가능") || parking.contains("유료") ? "Y" : "N");	// 주차장
	            
	            accFacility.setPoolYn(isTrue(detail.path("swimmingpool").asText()) ? "Y" : "N");			// 수영장
	            accFacility.setGymYn(isTrue(detail.path("fitness").asText()) ? "Y" : "N");					// 피트니스
	            accFacility.setSpaYn(isTrue(detail.path("sauna").asText()) ? "Y" : "N");					// 스파/사우나
	            accFacility.setRestaurantYn(!detail.path("foodplace").asText().isEmpty() ? "Y" : "N");		// 레스토랑
	            
	            // 부가 시설
	            String subFacility = detail.path("subfacility").asText("");
	            if (!subFacility.isEmpty()) {
	                if (subFacility.contains("세탁") && accFacility.getLaundryYn().equals("N")) {
	                	accFacility.setLaundryYn("Y");
	                }
	                if (subFacility.contains("흡연") && accFacility.getSmokingAreaYn().equals("N")) {
	                	accFacility.setSmokingAreaYn("Y");
	                }
	            }
	             
	             log.info("accFacility 일부 저장한 값 조회 : {}", accFacility);
	        }

	        log.info("공통 정보 조회 coomUrl로 이동");
	        
	        
	        // B. 공통 정보 조회 (detailCommon2). 숙소 개요(Overview) + 반려동물 ,조식, 와이파이
	        StringBuilder commonUrl = new StringBuilder("http://apis.data.go.kr/B551011/KorService2/detailCommon2");
	        commonUrl.append("?serviceKey=").append(serviceKey);
	        commonUrl.append("&_type=json&MobileOS=ETC&MobileApp=Mohaeng");
	        commonUrl.append("&contentId=").append(contentId);
	        
	        String commonRes = restTemplate.getForObject(commonUrl.toString(), String.class);
	        JsonNode commonNode = mapper.readTree(commonRes);
			JsonNode items = commonNode.path("response").path("body").path("items").path("item");
	        JsonNode commonDetail = items.isArray() ? items.get(0) : items;		// 배열 여부

			log.info("공통 정보 API 원본 items 체크 : {}", items);
			log.info("공통 정보 API 원본 commonDetail : {}", commonDetail);
	        if (!commonDetail.isMissingNode()) {
	            String overview = commonDetail.path("overview").asText("");
	            accommodation.setOverview(overview);	// overView
	            if(overview != null) {		// api에 없는 항목 overview에서 가져오기
	            	accFacility.setPetFriendlyYn(overview.contains("반려동물") ? "Y" : "N");
	                accFacility.setBreakfastYn(overview.contains("조식") ? "Y" : "N");
	                accFacility.setWifiYn(overview.contains("와이파이") || overview.contains("WiFi") ? "Y" : "N");
	                accFacility.setRoomServiceYn(overview.contains("룸서비스") ? "Y" : "N");
	                accFacility.setLaundryYn(overview.contains("세탁") || overview.contains("코인세탁") ? "Y" : "N");
	                accFacility.setPetFriendlyYn(overview.contains("반려동물") || overview.contains("애견") ? "Y" : "N");
	                accFacility.setSmokingAreaYn(overview.contains("흡연구역") || overview.contains("흡연실") ? "Y" : "N");
	            }
	            log.info("최종 매핑된 overview : {}", overview);
	            log.info("accFacility 반려동물등등추가 : {}", accFacility);
	        } else {
	            log.warn("아이템 노드를 찾을 수 없습니다. 응답 확인 필요: {}", commonRes);
	        }

	        
	        log.info("객실 상세정보 검색 시작");
	        // roomFacility, 
	        // C. 객실 상세 정보 조회 (detailInfo2) -> RoomTypeVO 리스트 생성
	        StringBuilder infoUrl = new StringBuilder("http://apis.data.go.kr/B551011/KorService2/detailInfo2");
	        infoUrl.append("?serviceKey=").append(serviceKey);
	        infoUrl.append("&_type=json&MobileOS=ETC&MobileApp=Mohaeng&contentTypeId=32");
	        infoUrl.append("&contentId=").append(contentId);

	        String infoRes = restTemplate.getForObject(infoUrl.toString(), String.class);
	        JsonNode infoItems = mapper.readTree(infoRes).path("response").path("body").path("items").path("item");
	        log.info("객실 상세정보 검색 결과 : {}", infoItems);
	        if (!infoItems.isMissingNode()) {
	            List<RoomTypeVO> roomTypeList = new ArrayList<>();
	            
	            // 데이터가 여러 개일 수도, 하나일 수도 있음
	            if (infoItems.isArray()) {
	                for (JsonNode item : infoItems) {
	                    roomTypeList.add(mapRoomData(item));
	                }
	            } else {
	                roomTypeList.add(mapRoomData(infoItems));
	            }
	            
	            // wiif세팅
	            if ("N".equals(accFacility.getWifiYn())) {
	                boolean hasRoomInternet = roomTypeList.stream()
	                        .anyMatch(room -> "Y".equals(room.getInternet()));
	                
	                if (hasRoomInternet) {
	                    accFacility.setWifiYn("Y");
	                }
	            }
	            
	            log.info("와이파이 유무 : {}", accFacility.getWifiYn());
	            accommodation.setAccFacility(accFacility);		// wifi 정보까지 담은것 추가
	            accommodation.setRoomTypeList(roomTypeList);	// 상세정보 담긴것 출력
	        }
	        
	    } catch (Exception e) {
	        log.error("상세 정보 세팅 중 에러: {}", e.getMessage());
	    }
	}
	
	
	/**<p>시간 정보에 한글있을때를 대비</p>
	 * @param timeStr	시간 정보
	 * @return
	 */
	private String formatTime(String timeStr) {
	    if (timeStr == null || timeStr.isEmpty()) return "";

	    // 1. "익일 12:00" -> "12:00" (숫자와 : 만 남기기)
	    // 정규식 [^0-9:] 은 숫자와 콜론이 아닌 모든 문자를 제거합니다.
	    String cleaned = timeStr.replaceAll("[^0-9:]", "").trim();

	    // 2. 만약 결과가 "1200" 처럼 콜론이 빠진 경우 "12:00"으로 보정 (필요시)
	    if (cleaned.length() == 4 && !cleaned.contains(":")) {
	        cleaned = cleaned.substring(0, 2) + ":" + cleaned.substring(2);
	    }
	    
	    // 3. 최종적으로 HH:mm 형식이 맞는지 확인 (예: 12:00)
	    return cleaned;
	}

	// 
	
	/**
	 * <p>RoomType객체 api 응답객체와 매핑</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param item api 응답 값
	 * @return 매칭된 RoomTypeVo객체
	 */
	private RoomTypeVO mapRoomData(JsonNode item) {
		// roomInterNet이란게 있음 - Y일때는 wifi도 Y로 하기
		RoomTypeVO roomTypeVO = new RoomTypeVO();	// 인터넷 추가해서 accommodation에 세팅
		RoomFeatureVO featureVO = new RoomFeatureVO();
		RoomFacilityVO facilityVO = new RoomFacilityVO();

		// roomTypeVO 설정
		roomTypeVO.setRoomName(item.path("roomtitle").asText());			// 방이름
		roomTypeVO.setRoomSize(item.path("roomsize2").asInt(0));			// 2가 m^2
		roomTypeVO.setPrice(item.path("roomoffseasonminfee1").asInt(0));	// 1박 요금
		roomTypeVO.setBaseGuestCount(item.path("roombasecount").asInt(0));	// 최소 인원
		roomTypeVO.setMaxGuestCount(item.path("roommaxcount").asInt(0));	// 최대 인원		
		roomTypeVO.setTotalRoomCount(item.path("roomcount").asInt(0));		// 최대 인원		
		roomTypeVO.setBreakfastYn("N");										// 조식 포함 여부 수동 설정하자(체크박스여서)
		roomTypeVO.setBedTypeCd("single");									// 침대수 (수동 설정)
		roomTypeVO.setInternet(isTrue(item.path("roominternet").asText()) ? "Y" : "N");		// interNet
		// 숙소 특징
		featureVO.setKitchenYn(isTrue(item.path("roomcook").asText()) ? "Y" : "N");// 부억 유무
		
		// 숙소내 시설
		facilityVO.setAirConYn(isTrue(item.path("roomaircondition").asText()) ? "Y" : "N");		// 에어컨
	    facilityVO.setHairDryerYn(isTrue(item.path("roomhairdryer").asText()) ? "Y" : "N");		// 헤어드라이
	    facilityVO.setBathtubYn(isTrue(item.path("roombath").asText()) ? "Y" : "N");			// 욕조
	    facilityVO.setTvYn(isTrue(item.path("roomtv").asText()) ? "Y" : "N");					// tv
	    facilityVO.setFridgeYn(isTrue(item.path("roomrefrigerator").asText()) ? "Y" : "N");		// 냉장고
	    facilityVO.setToiletriesYn(isTrue(item.path("roomtoiletries").asText()) ? "Y" : "N");	// 세면도구
		
		log.info("매칭 roomtypevO : {}", roomTypeVO);
		log.info("매칭 featureVO 부억 : {}", featureVO.getKitchenYn());
		log.info("매칭 facilityVO : {}", facilityVO);
		
		roomTypeVO.setFeature(featureVO);
		roomTypeVO.setFacility(facilityVO);
		return roomTypeVO;
	}


	/**
	 * <p>숙소 관련 1의 값이 있는것들 필터링</p>
	 * @author sdg
	 * @date 2026-01-24
	 * @param val	api 응답 값 (1, 있음, 가능)
	 * @return true, false
	 */
	private boolean isTrue(String val) {
	    if(val == null) return false;
	    return val.equals("1") || val.contains("있음") || val.contains("가능") || val.equalsIgnoreCase("Y");
	}
}

