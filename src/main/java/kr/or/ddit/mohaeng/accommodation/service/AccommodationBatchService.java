package kr.or.ddit.mohaeng.accommodation.service;

import java.net.URI;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;

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
public class AccommodationBatchService {

    private final IAccommodationMapper accMapper;
    
    private final DummyRoomService dummyRoomService;

    // 너 프로젝트에 이미 있는 값이라고 가정
    private final String serviceKey = "n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";

    // ✅ RestClient는 매번 create() 하지 말고 한 번만
    private final RestClient restClient = RestClient.create();

    // =========================
    // Public Entry (배치 실행)
    // =========================

    /**
     * ✅ 배치 전체는 트랜잭션 걸지 않는다.
     * - API 호출 + sleep 때문에 DB 커넥션 점유 오래함
     * - 숙소 하나 실패해도 전체 롤백 방지
     */
    public void updateAccommodationDetailsBatch() {
        List<AccommodationVO> targetList = accMapper.selectListForDetailUpdate();

        log.info("상세 업데이트 대상 숙소 수: {}", targetList.size());

        int ok = 0;
        int fail = 0;

        for (AccommodationVO acc : targetList) {
            try {
                // 공공데이터 매너타임
                sleepSilently(1000);

                updateSingleAccommodation(acc);

                ok++;
            } catch (Exception e) {
                fail++;
                log.error("숙소 업데이트 실패 (accNo={}, contentId={}): {}",
                        acc.getAccNo(), acc.getApiContentId(), e.getMessage(), e);
            }
        }

        log.info("배치 완료. 성공: {}, 실패: {}", ok, fail);
    }

    // =========================
    // Single Accommodation Update
    // =========================

    /**
     * ✅ 숙소 1건 단위로 트랜잭션
     * - 여기서만 DB 업데이트
     * - 실패하면 해당 숙소만 롤백
     */
    @Transactional
    public void updateSingleAccommodation(AccommodationVO acc) {
        // 1) detailCommon1
        JsonNode commonItem = fetchFirstItem(buildCommonUrl(acc.getApiContentId()));
        if (commonItem != null) {
            String overview = commonItem.path("overview").asText("");
            String tel = commonItem.path("infocenterlodging").asText(""); // common에 있으면 여기서

            if (!overview.isBlank()) acc.setOverview(overview);
            if (!tel.isBlank()) acc.setTel(tel);

            accMapper.updateAccommodationDetail(acc);
        } else {
            log.warn("detailCommon1 item 없음 (accNo={}, contentId={})",
                    acc.getAccNo(), acc.getApiContentId());
        }

        // 공공데이터 매너타임
        sleepSilently(600);

        // 2) detailIntro1
        JsonNode introItem = fetchFirstItem(buildIntroUrl(acc.getApiContentId()));
        if (introItem != null) {

            // ✅ 체크인/아웃은 introItem에서 우선 조회 (버그 수정)
            acc.setCheckInTime(introItem.path("checkintime").asText("15:00"));
            acc.setCheckOutTime(introItem.path("checkouttime").asText("11:00"));

            // 만약 introItem에 전화번호가 여기 들어오는 케이스도 있어서 fallback
            if (isBlank(acc.getTel())) {
                String tel2 = introItem.path("infocenterlodging").asText("");
                if (!tel2.isBlank()) acc.setTel(tel2);
            }

            // 체크인/아웃까지 저장해야 하면 mapper에 update 메서드 필요
            // (너가 이미 updateAccommodationDetail에서 같이 업데이트한다면 OK)
            accMapper.updateAccommodationDetail(acc);

            AccFacilityVO facilityVO = buildAccFacility(acc, introItem);
            accMapper.upsertAccFacility(facilityVO);

        } else {
            log.warn("detailIntro1 item 없음 (accNo={}, contentId={})",
                    acc.getAccNo(), acc.getApiContentId());
        }

        // 공공데이터 매너타임
        sleepSilently(600);

        // 3) 객실 정보 (detailInfo1)
        updateRoomDetails(acc);

        log.info("숙소 업데이트 완료 (accNo={}, name='{}')", acc.getAccNo(), acc.getAccName());
    }

    // =========================
    // Room Update
    // =========================

    @Transactional
    public void updateRoomDetails(AccommodationVO acc) {
        try {
            JsonNode roomItems = fetchItemsNode(buildRoomUrl(acc.getApiContentId()));

            if (roomItems == null || roomItems.isEmpty()) {
                log.info("객실 정보 없음 → 더미 생성 (accNo={})", acc.getAccNo());
                dummyRoomService.createDummyRooms(acc);
                return;
            }

            
            insertRoomFromApi(acc, roomItems);

        } catch (Exception e) {
            log.error("객실 정보 업데이트 중 에러 (accNo={}, contentId={}): {}",
                    acc.getAccNo(), acc.getApiContentId(), e.getMessage(), e);
        }
    }
    
    private void insertRoomFromApi(AccommodationVO acc, JsonNode roomItems) {
        if (roomItems.isArray()) {
            for (JsonNode room : roomItems) {
                insertRoomSingleFromApi(acc, room);
            }
        } else if (roomItems.isObject()) {
            insertRoomSingleFromApi(acc, roomItems);
        } else {
            log.warn("roomItems 타입이 이상함 (accNo={}, type={})",
                    acc.getAccNo(), roomItems.getNodeType());
        }
    }
    
    private void insertRoomSingleFromApi(AccommodationVO acc, JsonNode room) {

        // 1️⃣ ROOM_TYPE 생성
        RoomTypeVO roomType = new RoomTypeVO();
        roomType.setAccNo(acc.getAccNo());
        roomType.setRoomName(room.path("roomtitle").asText("기본객실"));
        roomType.setBaseGuestCount(room.path("roombasecount").asInt(2));
        roomType.setMaxGuestCount(room.path("roommaxcount").asInt(4));
        roomType.setBedCount(room.path("bedcount").asInt(1));
        roomType.setBedTypeCd(room.path("bedtype").asText("DOUBLE"));
        roomType.setTotalRoomCount(room.path("roomcount").asInt(1));
        roomType.setPrice(room.path("roomoffseasonminfee1").asInt(70000));
        roomType.setDiscount(0);
        roomType.setExtraGuestFee(20000);
        roomType.setRoomSize(room.path("roomsize1").asInt(20));
        roomType.setBreakfastYn(room.path("breakfast").asText("").contains("Y") ? "Y" : "N");

        accMapper.insertRoomType(roomType);
        int roomTypeNo = roomType.getRoomTypeNo();

        // 2️⃣ ROOM_FACILITY
        RoomFacilityVO facility = new RoomFacilityVO();
        facility.setRoomTypeNo(roomTypeNo);
        facility.setAirConYn(toYn(room.path("roomaircondition").asText("N")));
        facility.setTvYn(toYn(room.path("roomtv").asText("N")));
        facility.setMinibarYn(toYn(room.path("roomminibar").asText("N")));
        facility.setFridgeYn(toYn(room.path("roomrefrigerator").asText("N")));
        facility.setSafeBoxYn(toYn(room.path("roomsafebox").asText("N")));
        facility.setHairDryerYn(toYn(room.path("roomhairdryer").asText("N")));
        facility.setBathtubYn(toYn(room.path("roombath").asText("N")));
        facility.setToiletriesYn(toYn(room.path("roomtoiletries").asText("N")));

        accMapper.insertRoomFacility(facility);

        // 3️⃣ ROOM_FEATURE
        RoomFeatureVO feature = new RoomFeatureVO();
        feature.setRoomTypeNo(roomTypeNo);

        String intro = room.path("roomintro").asText("");

        feature.setOceanViewYn(intro.contains("바다") ? "Y" : "N");
        feature.setMountainViewYn(intro.contains("산") ? "Y" : "N");
        feature.setCityViewYn(intro.contains("시티") ? "Y" : "N");
        feature.setLivingRoomYn(intro.contains("거실") ? "Y" : "N");
        feature.setTerraceYn(intro.contains("테라스") ? "Y" : "N");
        feature.setFreeCancelYn(intro.contains("무료") ? "Y" : "N");
        feature.setNonSmokingYn(intro.contains("금연") ? "Y" : "N");
        feature.setKitchenYn(intro.contains("주방") || intro.contains("취사") ? "Y" : "N");

        accMapper.insertRoomFeature(feature);

        // 4️⃣ ROOM (실객실)
        int roomCnt = room.path("roomcount").asInt(1);
        for (int i = 0; i < roomCnt; i++) {
            accMapper.insertRoom(roomTypeNo);
        }
    }

    private void insertRoomAll(AccommodationVO acc, JsonNode room) {
        // [STEP 1] ROOM_TYPE
        RoomTypeVO roomType = new RoomTypeVO();
        roomType.setAccNo(acc.getAccNo());
        roomType.setRoomName(room.path("roomtitle").asText("기본 객실"));
        roomType.setBaseGuestCount(room.path("roombasecount").asInt(2));
        roomType.setMaxGuestCount(room.path("roommaxcount").asInt(4));
        roomType.setPrice(room.path("roomoffseasonminfee1").asInt(50000));
        roomType.setRoomSize(room.path("roomsize1").asInt(0));

        accMapper.insertRoomType(roomType);
        int roomTypeNo = roomType.getRoomTypeNo();

        // [STEP 2] ROOM_FACILITY
        RoomFacilityVO facility = new RoomFacilityVO();
        facility.setRoomTypeNo(roomTypeNo);

        facility.setAirConYn(toYn(room.path("roomaircondition").asText("N")));
        facility.setTvYn(toYn(room.path("roomtv").asText("N")));
        facility.setFridgeYn(toYn(room.path("roomrefrigerator").asText("N")));
        facility.setHairDryerYn(toYn(room.path("roomhairdryer").asText("N")));
        facility.setToiletriesYn(toYn(room.path("roomtoiletries").asText("N")));

        accMapper.insertRoomFacility(facility);

        // [STEP 3] ROOM_FEATURE
        RoomFeatureVO feature = new RoomFeatureVO();
        feature.setRoomTypeNo(roomTypeNo);

        String intro = room.path("roomintro").asText("");
        String roomCook = room.path("roomcook").asText("");

        feature.setOceanViewYn(containsAny(intro, "바다", "오션뷰", "해변") ? "Y" : "N");
        feature.setMountainViewYn(containsAny(intro, "산", "마운틴뷰", "숲") ? "Y" : "N");
        feature.setCityViewYn(containsAny(intro, "시티", "전망", "야경") ? "Y" : "N");

        feature.setLivingRoomYn(containsAny(intro, "거실", "스위트", "분리형") ? "Y" : "N");
        feature.setTerraceYn(containsAny(intro, "테라스", "발코니", "베란다") ? "Y" : "N");

        feature.setFreeCancelYn(containsAny(intro, "무료취소", "환불가능") ? "Y" : "N");
        feature.setNonSmokingYn(containsAny(intro, "금연", "쾌적") ? "Y" : "N");

        boolean canCook = containsAny(roomCook, "가능") || containsAny(intro, "취사", "주방", "싱크대");
        feature.setKitchenYn(canCook ? "Y" : "N");

        accMapper.insertRoomFeature(feature);
    }

    // =========================
    // Facility Builder
    // =========================

    private AccFacilityVO buildAccFacility(AccommodationVO acc, JsonNode introItem) {
        AccFacilityVO facilityVO = new AccFacilityVO();
        facilityVO.setAccNo(acc.getAccNo());

        String sub = introItem.path("subfacility").asText("");
        String food = introItem.path("foodplace").asText("");
        String parking = introItem.path("parkinglodging").asText("");

        facilityVO.setParkingYn(parking.contains("가능") ? "Y" : "N");
        facilityVO.setWifiYn(containsAny(sub, "무선인터넷", "와이파이", "WiFi") ? "Y" : "N");
        facilityVO.setPoolYn(sub.contains("수영장") ? "Y" : "N");

        facilityVO.setBreakfastYn(introItem.path("breakfastlodging").asText("").contains("가능") ? "Y" : "N");
        facilityVO.setPetFriendlyYn(introItem.path("petlodging").asText("").contains("가능") ? "Y" : "N");

        facilityVO.setGymYn(containsAny(sub, "헬스장", "피트니스", "체력단련") ? "Y" : "N");
        facilityVO.setSpaYn(containsAny(sub, "스파", "사우나", "욕조", "마사지") ? "Y" : "N");
        facilityVO.setLaundryYn(containsAny(sub, "세탁", "코인세탁", "드라이클리닝") ? "Y" : "N");
        facilityVO.setSmokingAreaYn(sub.contains("흡연구역") ? "Y" : "N");

        boolean hasRestaurant = food.length() > 2 || containsAny(sub, "식당", "레스토랑", "카페");
        facilityVO.setRestaurantYn(hasRestaurant ? "Y" : "N");
        facilityVO.setBarYn(containsAny(sub, "바", "라운지", "주점") ? "Y" : "N");
        facilityVO.setRoomServiceYn(sub.contains("룸서비스") ? "Y" : "N");

        return facilityVO;
    }

    // =========================
    // API Call Helpers
    // =========================

    private String buildCommonUrl(String contentId) {
        return UriComponentsBuilder
                .fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailCommon1")
                .queryParam("serviceKey", serviceKey)
                .queryParam("contentId", contentId)
                .queryParam("defaultYN", "Y")
                .queryParam("overviewYN", "Y")
                .queryParam("telNoYN", "Y")
                .queryParam("_type", "json")
                .queryParam("MobileOS", "ETC")
                .queryParam("MobileApp", "AppTest")
                .build()
                .toUriString();
    }

    private String buildIntroUrl(String contentId) {
        return UriComponentsBuilder
                .fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailIntro1")
                .queryParam("serviceKey", serviceKey)
                .queryParam("contentId", contentId)
                .queryParam("contentTypeId", "32")
                .queryParam("_type", "json")
                .queryParam("MobileOS", "ETC")
                .queryParam("MobileApp", "AppTest")
                .build()
                .toUriString();
    }

    private String buildRoomUrl(String contentId) {
        return UriComponentsBuilder
                .fromHttpUrl("https://apis.data.go.kr/B551011/KorService1/detailInfo1")
                .queryParam("serviceKey", serviceKey)
                .queryParam("contentId", contentId)
                .queryParam("contentTypeId", "32")
                .queryParam("_type", "json")
                .queryParam("MobileOS", "ETC")
                .queryParam("MobileApp", "AppTest")
                .build()
                .toUriString();
    }

    /**
     * ✅ API 응답에서 items.item을 가져오되
     * - item이 배열이면 첫 번째
     * - object면 그 자체
     * - 없으면 null
     */
    private JsonNode fetchFirstItem(String url) {
        JsonNode root = callApi(url);
        if (root == null) return null;

        JsonNode item = root.path("response").path("body").path("items").path("item");

        if (item.isArray()) {
            return item.size() > 0 ? item.get(0) : null;
        }
        if (item.isObject()) {
            return item;
        }
        return null;
    }

    /**
     * ✅ items.item 노드 자체가 필요할 때 (객실 목록)
     */
    private JsonNode fetchItemsNode(String url) {
        JsonNode root = callApi(url);
        if (root == null) return null;

        JsonNode item = root.path("response").path("body").path("items").path("item");
        if (item.isMissingNode() || item.isNull()) return null;
        return item;
    }

    /**
     * ✅ API 호출 공통화 + 상태/에러 로그
     */
    private JsonNode callApi(String url) {
        try {
            return restClient.get()
                    .uri(URI.create(url))
                    .retrieve()
                    .body(JsonNode.class);
        } catch (Exception e) {
            log.error("API 호출 실패 url={} msg={}", url, e.getMessage(), e);
            return null;
        }
    }

    // =========================
    // Utils
    // =========================

    private void sleepSilently(long millis) {
        try {
            Thread.sleep(millis);
        } catch (InterruptedException ie) {
            Thread.currentThread().interrupt();
        }
    }

    private String toYn(String value) {
        return "Y".equalsIgnoreCase(value) ? "Y" : "N";
    }

    private boolean containsAny(String src, String... keys) {
        if (src == null || src.isBlank()) return false;
        for (String k : keys) {
            if (src.contains(k)) return true;
        }
        return false;
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }
}
