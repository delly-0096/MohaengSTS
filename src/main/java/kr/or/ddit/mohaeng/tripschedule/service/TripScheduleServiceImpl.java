package kr.or.ddit.mohaeng.tripschedule.service;

import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import com.fasterxml.jackson.databind.JsonNode;

import kr.or.ddit.mohaeng.file.service.IFileService;
import kr.or.ddit.mohaeng.tripschedule.controller.TripScheduleController.ThumbnailData;
import kr.or.ddit.mohaeng.tripschedule.mapper.ITripScheduleMapper;
import kr.or.ddit.mohaeng.vo.TourPlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleDetailsVO;
import kr.or.ddit.mohaeng.vo.TripSchedulePlaceVO;
import kr.or.ddit.mohaeng.vo.TripScheduleVO;
import kr.or.ddit.util.Params;

@Service
public class TripScheduleServiceImpl implements ITripScheduleService {
	
	private final ChatClient chatClient;
	
	public TripScheduleServiceImpl(ChatClient.Builder builder) {
		this.chatClient = builder.build();
	}
	
	@Autowired
	ITripScheduleMapper iTripScheduleMapper;
	
	@Autowired
	IFileService fileService;
	
	@Override
	public List<Map<String, Object>> selectRegionList() {
		return iTripScheduleMapper.selectRegionList();
	}
	
	@Override
	public List<Map<String, Object>> selectPopRegionList() {
		return iTripScheduleMapper.selectPopRegionList();
	}

	@Override
	public List<Map<String, Object>> selectTourPlaceList() {
		return iTripScheduleMapper.selectTourPlaceList();
	}

	@Override
	public Params searchRegion(Params params) {
		return iTripScheduleMapper.searchRegion(params);
	}
	
	@Async("asyncTaskExecutor")
	@Override
	public void mergeSearchTourPlace(List<Map<String, String>> dataList) {

		List<TourPlaceVO> tourPlaceList = new ArrayList<>();
		for(Map<String, String> tourPlace : dataList) {
			int contentid = Integer.parseInt(tourPlace.get("contentid"));
			int areacode = Integer.parseInt(tourPlace.get("areacode"));
			String contenttypeid = tourPlace.get("contenttypeid");
			String title = tourPlace.get("title");
			String zip = tourPlace.get("zipcode");
			String addr1 = tourPlace.get("addr1");
			String addr2 = tourPlace.get("addr2");
			String mapy = tourPlace.get("mapy");
			String mapx = tourPlace.get("mapx");
			String defaultImg = tourPlace.get("firstimage");
			
			TourPlaceVO tourPlaceVO = new TourPlaceVO(contentid, areacode, contenttypeid, title, zip, addr1, addr2
					, mapy, mapx, "0", defaultImg);
			tourPlaceList.add(tourPlaceVO);
		}
		
		iTripScheduleMapper.mergeSearchTourPlace(tourPlaceList);
	}
	
	@Override
	public Params contentIdCheck(Params params) {
	    String contentTypeId = params.getString("contentTypeId");
	    
	    // 값을 담는 게 아니라, API의 '필드명(Key)'을 담을 변수
	    String operationHoursKey = "";
	    String plcPriceKey = "";
	    
	    switch (contentTypeId) {
	        case "12": // 관광지
	            operationHoursKey = "usetime";
	            // 12번은 명확한 이용요금 필드가 없고 보통 usetime에 섞여 있음.
	            // 비정형이라도 좋다면 'expguide'(체험안내)를 가격 키로 지정
	            plcPriceKey = "expguide"; 
	            break;

	        case "14": // 문화시설
	            operationHoursKey = "usetimeculture";
	            plcPriceKey = "usefee";
	            break;

	        case "15": // 축제/공연/행사
	            operationHoursKey = "playtime";
	            plcPriceKey = "usetimefestival";
	            break;

	        case "25": // 여행코스
	            // 코스는 시간이 아니라 'taketime'(소요시간) 필드를 사용
	            operationHoursKey = "taketime";
	            plcPriceKey = ""; // 코스는 가격 관련 필드가 아예 없음
	            break;

	        case "28": // 레포츠
	            operationHoursKey = "usetimeleports";
	            plcPriceKey = "usefeeleports";
	            break;

	        case "32": // 숙박
	            // 숙박은 입실/퇴실 시간 두 가지 키가 필요함
	            // 프론트에서 split해서 쓰거나 로직 처리를 위해 콤마로 구분해서 전달 추천
	            operationHoursKey = "checkintime,checkouttime"; 
	            plcPriceKey = ""; // 숙박비는 intro 정보에 없음 (객실정보 별도 조회 필요)
	            break;

	        case "38": // 쇼핑
	            operationHoursKey = "opentime";
	            // 가격 대신 판매품목(saleitem) 필드명을 매핑
	            plcPriceKey = "saleitem"; 
	            break;

	        case "39": // 음식점
	            operationHoursKey = "opentimefood";
	            // 가격 대신 대표메뉴(treatmenu) 필드명을 매핑
	            plcPriceKey = "treatmenu"; 
	            break;

	        default:
	            operationHoursKey = "";
	            plcPriceKey = "";
	            break;
	    }
	    
	    // 결과 Params에 '필드명'을 저장
	    params.put("operationHours", operationHoursKey);
	    params.put("plcPrice", plcPriceKey);
	    System.out.println("params : " + params);
	    return params;
	}

	@Override
	public TourPlaceVO searchPlaceDetail(TourPlaceVO tourPlaceVO) {
		return iTripScheduleMapper.searchPlaceDetail(tourPlaceVO);
	}

	@Override
	public int saveTourPlacInfo(TourPlaceVO tourPlaceVO) {
		return iTripScheduleMapper.saveTourPlacInfo(tourPlaceVO);
	}

	@Override
	public int insertTripSchedule(Params params) {
		
	    TripScheduleVO tripScheduleVO = new TripScheduleVO(params.getInt("memNo"), null, "REGION", params.getInt("startPlaceId"), "REGION", params.getInt("targetPlaceId")
	    		, "UPCOMING", params.getString("schdlNm"), params.getString("schdlStartDt"), params.getString("schdlEndDt")
	    		, params.getInt("travelerCount"), params.getString("aiRecomYn"), params.getString("publicYn"), (long) params.getInt("totalBudget"));
	    
	    int resultSchedule = iTripScheduleMapper.insertTripSchedule(tripScheduleVO);
	    
	    List<Map<String, Object>> plannerDayList = (List<Map<String, Object>>) params.get("details");
	    String StartDt = tripScheduleVO.getSchdlStartDt();
	    if(resultSchedule > 0) {
	    	for(Map<String, Object> plannerDay : plannerDayList) {
		    	System.out.println("plannerDay : " + plannerDay);
		    	TripScheduleDetailsVO detailsVO = new TripScheduleDetailsVO(tripScheduleVO.getSchdlNo(), plannerDay.get("schdlTitle")+"", Integer.parseInt(plannerDay.get("schdlDt")+""));
		    	detailsVO.setSchdlStartDt(StartDt);
		    	
		    	plannerDay.put("detailsVO", detailsVO);
		    	int resultDetails = insertTripScheduleDetails(plannerDay);
		    }
	    }
		
		return resultSchedule;
	}
	
	@Override
	public int insertTripScheduleDetails(Map<String, Object> plannerDay) {
		
		TripScheduleDetailsVO detailsVO = (TripScheduleDetailsVO) plannerDay.get("detailsVO");
		
		int resultDetails = iTripScheduleMapper.insertTripScheduleDetails(detailsVO);
		
		int schdlDetailsNo = detailsVO.getSchdlDetailsNo();
		if(resultDetails > 0) {
			List<Map<String, String>> plannerItemList = (List<Map<String, String>>) plannerDay.get("places");
	    	for(Map<String, String> plannerItem : plannerItemList) {
	    		System.out.println("plannerItem : " + plannerItem);
	    		
	    		int placeId = Integer.parseInt(plannerItem.get("placeId"));
	    		int placeOrder = Integer.parseInt(String.valueOf(plannerItem.get("placeOrder")));
//	    		int destId = Integer.parseInt(plannerItem.get("destId"));
	    		Integer planCost = Integer.parseInt(plannerItem.get("planCost"));
	    		TripSchedulePlaceVO placeVO = new TripSchedulePlaceVO(schdlDetailsNo, plannerItem.get("placeType") , placeId, placeOrder
	    				, plannerItem.get("placeStartTime"), plannerItem.get("placeEndTime")
	    				, "N", plannerItem.get("destType"), planCost);
	    		
//	    		placeVO.set
	    		insertTripSchedulePlace(placeVO);
	    	}
		}
		
		return resultDetails;
	}
	
	@Override
	public int insertTripSchedulePlace(TripSchedulePlaceVO placeVO) {
		return iTripScheduleMapper.insertTripSchedulePlace(placeVO);
	}

	@Override
	public List<TripScheduleVO> selectTripScheduleList(int memNo) {
		List<TripScheduleVO> scheduleList = iTripScheduleMapper.selectTripScheduleList(memNo);
		if(scheduleList.size() > 0) {
			System.out.println("scheduleList : " + scheduleList);
			
			for(TripScheduleVO tripSchedule : scheduleList) {
			    List<String> displayPlaceNames = new ArrayList<>(); // 화면에 표시할 2개만 담을 리스트
			    int totalPlaceCnt = 0;
//			    String getUrl = "";
			    
			    for(TripScheduleDetailsVO details : tripSchedule.getTripScheduleDetailsList()) {
			        List<TripSchedulePlaceVO> places = details.getTripSchedulePlaceList();
			        if(places != null) {
			            for(TripSchedulePlaceVO place : places) {
			                // 전체 개수는 계속 세고
			                totalPlaceCnt++;
			                // 그 중 앞의 2개만 리스트에 담기
			                if(displayPlaceNames.size() < 2) {
			                    displayPlaceNames.add(place.getPlcNm());
			                }
//			                if(getUrl.equals("")) {
//			                	TourPlaceVO placeVO = new TourPlaceVO();
//			                	placeVO.setPlcNo(place.getDestId());
//			                	placeVO = searchPlaceDetail(placeVO);
//			                	if(placeVO.getDefaultImg() == null) {
//			                		System.out.println("placeVO : " + placeVO);
//			                		placeVO = updateTourPlace(placeVO.getPlcNo(),placeVO.getPlaceType());
//			                		getUrl = placeVO.getDefaultImg();
//			                	} else {
//			                		getUrl = placeVO.getDefaultImg();
//			                	}
//			                	
//			                	tripSchedule.setThumbnail(getUrl);
//			                	
//			                	//나중에 첨부파일이 셋팅이 되어있다는 기준으로 수정하기
//			                	if(placeVO.getAttachNo() != 0) {
////			                		tripSchedule.setThumbnail(placeVO.getAttachNo());
//			                	}
//			                }
			            }
			        }
			    }
			    tripSchedule.setPlaceCnt(totalPlaceCnt);
			    tripSchedule.setDisplayPlaceNames(displayPlaceNames); // VO에 필드 추가 필요
			}
		}
		
		return scheduleList;
	}
	
	@Override
	public TripScheduleVO selectTripSchedule(TripScheduleVO params) {
		TripScheduleVO tripSchedule = iTripScheduleMapper.selectTripSchedule(params);
		if(tripSchedule != null) {
			int totalPlaceCnt = 0;
//			String getUrl = "";
		    
		    for(TripScheduleDetailsVO details : tripSchedule.getTripScheduleDetailsList()) {
		        List<TripSchedulePlaceVO> places = details.getTripSchedulePlaceList();
		        if(places != null) {
		            for(TripSchedulePlaceVO place : places) {
		            	totalPlaceCnt++;
//		                if(getUrl.equals("")) {
//		                	TourPlaceVO placeVO = new TourPlaceVO();
//		                	placeVO.setPlcNo(place.getDestId());
//		                	placeVO = searchPlaceDetail(placeVO);
//		                	if(placeVO.getDefaultImg() == null) {
//		                		System.out.println("placeVO : " + placeVO);
//		                		placeVO = updateTourPlace(placeVO.getPlcNo(),placeVO.getPlaceType());
//		                		getUrl = placeVO.getDefaultImg();
//		                	} else {
//		                		getUrl = placeVO.getDefaultImg();
//		                	}
//		                	
//		                	tripSchedule.setThumbnail(getUrl);
//		                	
//		                	//나중에 첨부파일이 셋팅이 되어있다는 기준으로 수정하기
//		                	if(placeVO.getAttachNo() != 0) {
////			                		tripSchedule.setThumbnail(placeVO.getAttachNo());
//		                	}
//		                }
		            }
		        }
		    }
		    tripSchedule.setPlaceCnt(totalPlaceCnt);
		}
		
		return tripSchedule;
	}
	
	public TourPlaceVO updateTourPlace(int contentId, String contenttypeId) {
		Params params = new Params();
		RestClient restClient = RestClient.create();
		params.put("contentId", contentId);
		params.put("contenttypeId", contenttypeId);
		
		String introUrlString = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&contentTypeId=" + contenttypeId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		String detailUrlString = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		// 2. URI 객체로 변환 (이러면 RestClient가 내부에서 자동 인코딩을 안 합니다)
		URI introUri = URI.create(introUrlString);
		URI detailUri = URI.create(detailUrlString);
		
		JsonNode introNode = restClient.get()
			    .uri(introUri)
			    .retrieve()
			    .body(JsonNode.class);
		
		JsonNode introItemNode = introNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		JsonNode detailNode = restClient.get()
				.uri(detailUri)
				.retrieve()
				.body(JsonNode.class);
		
		JsonNode detailItemNode = detailNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		//어떤 키값에 비용과 이용시간 정보가 있는건지 체킹 후 params 에 넣음
		contentIdCheck(params);
		
		System.out.println("		JsonNode detailItemNode : "+ detailItemNode);
		
		String plcDesc = detailItemNode.get("overview")+"";
		String plcNm = detailItemNode.get("title")+"";
		String defaultImg = detailItemNode.get("firstimage")+"";
		String plcAddr1 = detailItemNode.get("addr1")+"";
		
		String operationHours = null;
		String plcPrice = null;
		
		if(!detailNode.path("response").path("body").path("totalCount").equals("0")) {
			operationHours = introItemNode.get(params.getString("operationhours"))+"";
			plcPrice = introItemNode.get(params.getString("plcprice"))+"";
		} else {
	        String message = String.format("""
		            관광지 정보를 찾고 있어.
		            [관광지키]
		            %s
		            
		            [관광지이름]
		            %s
		            
		            [관광지 소개]
		            %s
		            
		            내가 필요한 [관광지이름]과 [관광지 소개]정보야
		            해당 관광지의 운영시간과 비용에대한 정보를 알고싶어.
		            [관광지키]는 한국관광관련 TourApi에서 사용하는 key값이야
		            배열형태로 배치해하여 0번째 인덱스는 운영시간, 1번째 인덱스는 비용에 대한 정보를 JSON으로 줘.
		            검색하여 정보를 찾는 행위허용
		            예시형태 [운영시간, 비용] 
		            """, contentId,plcNm, plcDesc);
	        
	        String[] result = chatClient.prompt()
	                .user(message)
	                .call()
	                .entity(new ParameterizedTypeReference<String[]>() {});
	        System.out.println("result:  " + result);
	        
	        operationHours = result[0];
	        plcPrice = result[1];
		}
		
		TourPlaceVO tourPlaceVO = new TourPlaceVO();
		tourPlaceVO.setPlcNo(contentId);
		tourPlaceVO.setPlcNm(plcNm);
		tourPlaceVO.setPlcDesc(plcDesc.replace("\"", ""));
		tourPlaceVO.setOperationHours(operationHours.replace("\"", ""));
		tourPlaceVO.setPlcPrice(plcPrice.replace("\"", ""));
		tourPlaceVO.setDefaultImg(defaultImg.replace("\"", ""));
		tourPlaceVO.setPlcAddr1(plcAddr1.replace("\"", ""));
		
		int cnt = saveTourPlacInfo(tourPlaceVO);
		
		return tourPlaceVO;
	}

	@Override
	public boolean toggleBookmark(Params params) {
		// 1. 해당 유저의 해당 일정 북마크가 있는지 확인 (식별 관계 PK 조회)
	    int count = iTripScheduleMapper.checkBookmarkExists(params);
	    
	    if(params.get("bkmkYn").equals("Y")) {
	    	if (count == 0) {
	    		iTripScheduleMapper.insertBookmark(params);
		        return true; // 등록됨
	    	} else {
	    		return true;
	    	}
	    } else {
	    	iTripScheduleMapper.deleteBookmark(params);
	        return false; // 해제됨
	    }
	}

	@Override
	public int deleteTripSchedule(int schdlNo) {
		return iTripScheduleMapper.deleteTripSchedule(schdlNo);
	}

	@Override
	public void refreshScheduleStates() {
		
	}

	@Override
	public int updateTripSchedule(Params params) {
		TripScheduleVO tripScheduleVO = new TripScheduleVO(params.getInt("memNo"), null, "REGION", params.getInt("startPlaceId"), "REGION", params.getInt("targetPlaceId")
	    		, "UPCOMING", params.getString("schdlNm"), params.getString("schdlStartDt"), params.getString("schdlEndDt")
	    		, params.getInt("travelerCount"), params.getString("aiRecomYn"), params.getString("publicYn"), (long) params.getInt("totalBudget"));
	    
		int schdlNo = params.getInt("schdlNo");
		
		tripScheduleVO.setSchdlNo(params.getInt("schdlNo"));
		
	    int resultSchedule = iTripScheduleMapper.updateTripSchedule(tripScheduleVO);
	    
	    //이전 상세내용을 지우는 코드
	    iTripScheduleMapper.deleteSchedulePlace(schdlNo);
	    iTripScheduleMapper.deleteScheduleDetails(schdlNo);
	    
	    List<Map<String, Object>> plannerDayList = (List<Map<String, Object>>) params.get("details");
	    String StartDt = tripScheduleVO.getSchdlStartDt();
	    if(resultSchedule > 0) {
	    	for(Map<String, Object> plannerDay : plannerDayList) {
		    	System.out.println("plannerDay : " + plannerDay);
		    	TripScheduleDetailsVO detailsVO = new TripScheduleDetailsVO(tripScheduleVO.getSchdlNo(), plannerDay.get("schdlTitle")+"", Integer.parseInt(plannerDay.get("schdlDt")+""));
		    	detailsVO.setSchdlStartDt(StartDt);
		    	
		    	plannerDay.put("detailsVO", detailsVO);
		    	int resultDetails = insertTripScheduleDetails(plannerDay);
		    }
	    }
		
		return resultSchedule;
	}

	@Override
	public int updateScheduleThumbnail(ThumbnailData thumbnailData) {
		int resultKey = 0;
		if(thumbnailData.getDefaultYn().equals("N")) {
			Map<String, String> uploadInfo = new HashMap<>();
			
			uploadInfo.put("fileGbCd", "TRIP_SCHEDULE");
			uploadInfo.put("filePath", "/tripschedule/thumbnail");
			
			resultKey = fileService.saveFile(thumbnailData.getThumbnailFile(), uploadInfo, thumbnailData.getMemNo());
			thumbnailData.setAttachNo(resultKey);
		}
		
		int result = iTripScheduleMapper.updateScheduleThumbnail(thumbnailData);
		
		return result;
	}

	@Override
	public List<Params> tourContentList() {
		return iTripScheduleMapper.tourContentList();
	}

	@Override
	public void updateTripScheduleState() {
		iTripScheduleMapper.scheduleOngoing();
		iTripScheduleMapper.scheduleCompleted();
	}

	@Override
	public TourPlaceVO updatePlaceDetail(Params params) {
		RestClient restClient = RestClient.create();
		
		int contentId = params.getInt("contentId");
		int contenttypeId = params.getInt("contenttypeId");
		
		String introUrlString = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&contentTypeId=" + contenttypeId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		String detailUrlString = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?MobileOS=WEB&MobileApp=Mohaeng&_type=json"
				+ "&contentId=" + contentId
				+ "&serviceKey=n8J%2Bnn7gf89CR3axQIKR7ATCydVTUVMUV2oA%2BMfcwz56A%2BcvFS3fSNrKACRVe68G2t9iRj%2FCEY1dLXCr1cNejg%3D%3D";
		
		// 2. URI 객체로 변환 (이러면 RestClient가 내부에서 자동 인코딩을 안 합니다)
		URI introUri = URI.create(introUrlString);
		URI detailUri = URI.create(detailUrlString);
		
		JsonNode introNode = restClient.get()
			    .uri(introUri)
			    .retrieve()
			    .body(JsonNode.class);
		
		JsonNode introItemNode = introNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		JsonNode detailNode = restClient.get()
				.uri(detailUri)
				.retrieve()
				.body(JsonNode.class);
		
		JsonNode detailItemNode = detailNode.path("response")
				.path("body")
				.path("items")
				.path("item")
				.get(0);
		
		//어떤 키값에 비용과 이용시간 정보가 있는건지 체킹 후 params 에 넣음
		contentIdCheck(params);
		
		String plcDesc = detailItemNode.get("overview")+"";
		String plcNm = detailItemNode.get("title")+"";
		
//		if(params.get("operationhours") != null && introItemNode.get(params.getString("operationhours")) != null) {
//			operationHours = introItemNode.get(params.getString("operationhours"))+"";
//		}
		
		String operationHours = null;
		String plcPrice = null;
		
		if(introItemNode != null) {
			System.out.println("detailNode.path(\"response\").path(\"body\").path(\"totalCount\").equals(\"0\") : " + detailNode.path("response").path("body").path("totalCount").equals("0"));
			operationHours = introItemNode.get(params.getString("operationhours"))+"";
			plcPrice = introItemNode.get(params.getString("plcprice"))+"";
		} else {
//	        String message = String.format("""
//		            관광지 정보를 찾고 있어.
//		            [관광지키]
//		            %s
//		            
//		            [관광지이름]
//		            %s
//		            
//		            [관광지 소개]
//		            %s
//		            
//		            내가 필요한 [관광지이름]과 [관광지 소개]정보야
//		            해당 관광지의 운영시간과 비용에대한 정보를 알고싶어.
//		            [관광지키]는 한국관광관련 TourApi에서 사용하는 key값이야
//		            배열형태로 배치해하여 0번째 인덱스는 운영시간, 1번째 인덱스는 비용에 대한 정보를 JSON으로 줘.
//		            검색하여 정보를 찾는 행위허용
//		            예시형태 [운영시간, 비용] 
//		            """, contentId,plcNm, plcDesc);
//	        
//	        String[] result = chatClient.prompt()
//	                .user(message)
//	                .call()
//	                .entity(new ParameterizedTypeReference<String[]>() {});
//	        System.out.println("result:  " + result);
//	        
//	        if(result != null) {
//		        operationHours = result[0];
//		        plcPrice = result[1];
//	        }
		}
		
		String defaultImg = detailItemNode.get("firstimage")+"";
		String plcAddr1 = detailItemNode.get("addr1")+"";
		
		TourPlaceVO tourPlaceVO = new TourPlaceVO();
		tourPlaceVO.setPlcNo(contentId);
		tourPlaceVO.setPlcNm(plcNm);
		tourPlaceVO.setPlcDesc(plcDesc.replace("\"", ""));
		if(operationHours != null && !operationHours.equals("")) {
			tourPlaceVO.setOperationHours(operationHours.replace("\"", ""));
		}
		tourPlaceVO.setPlcPrice(plcPrice.replace("\"", ""));
		tourPlaceVO.setDefaultImg(defaultImg.replace("\"", ""));
		tourPlaceVO.setPlcAddr1(plcAddr1.replace("\"", ""));
		
		saveTourPlacInfo(tourPlaceVO);
		
		return tourPlaceVO;
	}

	@Override
	public List<TourPlaceVO> selectPopularPlaceList(List<Map<String, String>> tourPlaceList) {
		List<TourPlaceVO> popularTourPlaceList = iTripScheduleMapper.selectPopularPlaceList(tourPlaceList);
		return popularTourPlaceList;
	}

	@Override
	public List<TourPlaceVO> searchTourPlaceList(int rgnNo) {
		
		List<TourPlaceVO> tourPlaceVO = iTripScheduleMapper.searchTourPlaceList(rgnNo);
		
		return tourPlaceVO;
	}
	
	public String formatStyleCatList(List<Params> dbList) {
	    if (dbList == null || dbList.isEmpty()) {
	        return "관련된 장소 정보가 없습니다.";
	    }

	    StringBuilder sb = new StringBuilder();
	    
	    for (Params params : dbList) {
	        // 1. 필요한 정보만 쏙쏙 뽑기 (null 처리도 안전하게)
	        String title = String.valueOf(params.get("TITLE")); // 제목
	        String addr = String.valueOf(params.get("ADDR1"));  // 주소
	        // String tel = String.valueOf(params.get("TEL")); // 전화번호 필요하면 추가

	        // 2. AI가 이해하기 쉬운 라벨 붙이기
	        sb.append("- 장소명: ").append(title).append("\n");
	        sb.append("  주소: ").append(addr).append("\n");
	        // sb.append("  설명: ...").append("\n"); // 설명 컬럼이 있다면 추가
	        
	        sb.append("\n"); // 가독성을 위해 한 줄 띄우기
	    }
	    
	    return sb.toString();
	}

	@Override
	public List<Params> selectTripStyleList(String[] tripStyleCatList) {
		List<Params> tripStyleList = iTripScheduleMapper.selectTripStyleList(tripStyleCatList);
		
		return tripStyleList;
	}

	@Override
	public void updateTourPlaceInfo() {
		
		List<TourPlaceVO> updateDataList = iTripScheduleMapper.selectTargetPlaceList();
		
		for(TourPlaceVO place : updateDataList) {
			Params params = new Params();
			params.put("content_Id", place.getPlcNo());
			params.put("contenttype_Id", place.getPlaceType());
			updatePlaceDetail(params);
		}
		
	}
	
	// 텍스트 정제용 프라이빗 메소드 (예시)
//	private String cleanText(String input) {
//	    if (input == null) return "";
//	    // HTML 태그 제거 (<br> -> 줄바꿈 등) 처리가 필요할 수 있음
//	    return input.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").trim();
//	}
	
}
