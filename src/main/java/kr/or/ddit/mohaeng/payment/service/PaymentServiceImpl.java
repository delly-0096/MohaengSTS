package kr.or.ddit.mohaeng.payment.service;

import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.OffsetDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.mohaeng.accommodation.mapper.IAccommodationMapper;
import kr.or.ddit.mohaeng.alarm.service.AlarmService;
import kr.or.ddit.mohaeng.community.travellog.place.controller.PlaceApiController;
import kr.or.ddit.mohaeng.flight.mapper.IFlightMapper;
import kr.or.ddit.mohaeng.login.mapper.IMemberMapper;
import kr.or.ddit.mohaeng.mailapi.service.MailService;
import kr.or.ddit.mohaeng.payment.mapper.IPaymentMapper;
import kr.or.ddit.mohaeng.vo.AccResvAgreeVO;
import kr.or.ddit.mohaeng.vo.AccResvVO;
import kr.or.ddit.mohaeng.vo.FlightPassengersVO;
import kr.or.ddit.mohaeng.vo.FlightProductVO;
import kr.or.ddit.mohaeng.vo.FlightReservationVO;
import kr.or.ddit.mohaeng.vo.FlightResvAgreeVO;
import kr.or.ddit.mohaeng.vo.MemberVO;
import kr.or.ddit.mohaeng.vo.PaymentInfoVO;
import kr.or.ddit.mohaeng.vo.PaymentVO;
import kr.or.ddit.mohaeng.vo.RoomTypeVO;
import kr.or.ddit.mohaeng.vo.SalesVO;
import kr.or.ddit.mohaeng.vo.TripProdListVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class PaymentServiceImpl implements IPaymentService {

    private final PlaceApiController placeApiController;

	@Autowired
	private IPaymentMapper payMapper;

	@Autowired
	private IFlightMapper flightMapper;
	
	@Autowired
	private IAccommodationMapper accMapper;
	
	@Autowired
	private IMemberMapper memberMapper;
	
	@Autowired
	private MailService mailService;
	
	@Autowired
    private AlarmService alarmService;

    PaymentServiceImpl(PlaceApiController placeApiController) {
        this.placeApiController = placeApiController;
    }

	@Override
	@Transactional
	public Map<String, Object> confirmPayment(PaymentVO paymentVO) {
		log.info("PaymentServiceImpl - confirmPayment {}", paymentVO);

		// api - 요청
		String url = "https://api.tosspayments.com/v1/payments/confirm"; // 요청 주소
		String widgetSecretKey = "test_gsk_docs_OaPz8L5KdmQXkzRz3y47BMw6"; // 요청 키
		byte[] encodedBytes = Base64.getEncoder().encode((widgetSecretKey + ":").getBytes(StandardCharsets.UTF_8));
		String authorizations = "Basic " + new String(encodedBytes); // 암호화된 키를 이용해서 권한 설정

		RestTemplate restTemplate = new RestTemplate();

		HttpHeaders headers = new HttpHeaders(); // 헤더에 정보 담기
		headers.setContentType(MediaType.APPLICATION_JSON);
		headers.set("Authorization", authorizations);

		// 4. 바디 설정 (토스 API 규격에 맞는 필드만 구성)
		Map<String, Object> params = new HashMap<>();
		params.put("orderId", paymentVO.getOrderId());
		params.put("amount", paymentVO.getAmount());
		params.put("paymentKey", paymentVO.getPaymentKey());

		HttpEntity<Map<String, Object>> entity = new HttpEntity<>(params, headers); // 헤더, 바디 담기

		// 5. API 요청 (POST)
		ResponseEntity<Map> response = restTemplate.postForEntity(url, entity, Map.class);

		if (response.getStatusCode() == HttpStatus.OK) { // server 연결 성공
			Map<String, Object> responseBody = response.getBody();
			log.info("결제 승인 API 성공: {}", response.getBody());

			// api 에서 가져올 정보
			// memNo이미 존재
			paymentVO.setPaymentKey(responseBody.get("paymentKey").toString());
			int amount = (int) responseBody.get("totalAmount");	// 실제 결제된 금액
			paymentVO.setPayTotalAmt(amount); // 숫자
			String payMethod = responseBody.get("method").toString(); 
			paymentVO.setPayMethodCd(payMethod);

			String approvedAtStr = responseBody.get("approvedAt").toString();
			OffsetDateTime payDt = OffsetDateTime.parse(approvedAtStr);
			paymentVO.setPayDt(payDt); // 날짜
			String status = responseBody.get("status").toString();
			paymentVO.setPayStatus(status);

			// 포인트사용 경우
			int discount = 0;
			if(responseBody.get("metadata") != null) {
				Map<String, Object> metadata = (Map<String, Object>) responseBody.get("metadata");
			    if (metadata.get("usedPoints") != null) {
			        discount = Integer.parseInt(metadata.get("usedPoints").toString());
			    }
			}
			paymentVO.setUsePoint(discount); // 사용포인트
			// 취소 사유 2개는 = 취소 환불시 사용하기

			log.info("paymentVO : {}", paymentVO);

			int payResult = payMapper.insertPayment(paymentVO);
			log.info("insertPayment : {}", payResult);

			// 결제 상세 정보
			PaymentInfoVO paymentInfo = new PaymentInfoVO();
			log.info("paymentInfo : {}", paymentInfo);
			
			paymentInfo.setPayNo(paymentVO.getPayNo());
			paymentInfo.setTid(paymentVO.getPaymentKey());
			paymentInfo.setResCode(status);
			paymentInfo.setResMsg(status + " " + responseBody.get("orderName"));
			paymentInfo.setPayMethodType(payMethod);
			
			// 카드, 승인번호
			if (responseBody.get("card") != null) {
			    Map<String, Object> card = (Map<String, Object>) responseBody.get("card");
			    paymentInfo.setCardCorpCode(card.get("issuerCode").toString()); // 카드사 코드 (예: 11)
			    paymentInfo.setAuthNo(card.get("approveNo").toString());        // 승인번호
			}else {
				paymentInfo.setCardCorpCode("");  // 카드사 코드 (예: 11)
				paymentInfo.setAuthNo("");        // 승인번호
			}
			
			// 가상 계좌
			if (responseBody.get("virtualAccount") != null) {
			    Map<String, Object> vbank = (Map<String, Object>) responseBody.get("virtualAccount");
			    paymentInfo.setVbankNum(vbank.get("accountNumber").toString());
			    
			    String dueDateStr = vbank.get("dueDate").toString();
			    paymentInfo.setVbankExpDt(OffsetDateTime.parse(dueDateStr));
			}else {
				paymentInfo.setVbankNum("");
				paymentInfo.setVbankExpDt(null);
			}
			paymentInfo.setPayRawData(responseBody.toString());		// 전체 데이터
			
			int paymentInfoResult = payMapper.insertPaymentInfo(paymentInfo);
			log.info("insertPaymentInfo : {}", paymentInfoResult);
			
			
			// 포인트 정책 - 결제 금액의 3%
			int pointResult = 0;
			if(discount == 0) {
				MemberVO member = new MemberVO();
				member.setMemNo(paymentVO.getMemNo());
				double point = (double)amount * 0.03;
				member.setPoint((int) point);
				pointResult = payMapper.insertPoint(member);
				log.info("pointResult 결과 : {}", pointResult);
			}
			
			int minusPointResult = 0;
			if(discount != 0) {
				MemberVO member = new MemberVO();
				member.setMemNo(paymentVO.getMemNo());
				member.setPoint(discount);	// 사용 포인트를 빼는 update
				minusPointResult = payMapper.updatePoint(member);
				log.info("minusPointResult 결과 : {}", minusPointResult);
			}
			
			int result = 0;		// 결제 결과
			if(paymentVO.getProductType().equals("flight")) {
				result = flightPayConfirm(paymentVO);
				log.info("flight pay : {}", result);
				
				int adult = 0;
				int child = 0;
				int infant = 0;
				for(FlightPassengersVO flightPassengers : paymentVO.getFlightPassengersList()) {
					if(flightPassengers.getPassengersType().equals("성인")) {
						adult++;
					} else if (flightPassengers.getPassengersType().equals("소아")) {
						child++;
					} else {
						infant++;
					}
				}
				
				if(adult != 0) {
					String adultInfo = "성인 " + adult + "명";
					responseBody.put("adult", adultInfo);
				}
				if(child != 0) {
					String childInfo = "소아 " + child + "명";
					responseBody.put("child", childInfo);
				}
				if(infant != 0) {
					String infantInfo = "유아 " + infant + "명";
					responseBody.put("infant", infantInfo);
				}
				
                responseBody.put("payNo", paymentVO.getPayNo());
                
			} else if(paymentVO.getProductType().equals("tour")) {
				result = tourPayConfirm(paymentVO);
			    log.info("tour pay : {}", result);
			    
			    // 투어 인원 정보 추가
			    int quantity = paymentVO.getTripProdList().get(0).getQuantity();
			    responseBody.put("quantity", quantity + "명");
			    responseBody.put("payNo", paymentVO.getPayNo());
			    
			} else if(paymentVO.getProductType().equals("accommodation")) { 
                // 1. 숙소 예약 로직 호출
                result = accommodationPayConfirm(paymentVO); 
                log.info("accommodation pay result : {}", result);
                
                // 2. 영수증 화면에 보여줄 인원 정보 가공 (성인 2, 아동 1...)
                AccResvVO resv = paymentVO.getAccResvVO();
                if(resv != null) {
                    String guestInfo = "성인 " + resv.getAdultCnt() + "명";
                    if(resv.getChildCnt() > 0) guestInfo += ", 아동 " + resv.getChildCnt() + "명";
                    responseBody.put("guestInfo", guestInfo);
                    responseBody.put("payNo", paymentVO.getPayNo());
                }
                
                if (result > 0) {
                	accMapper.insertAccResvAgree(resv);
                	log.info("약관 동의 저장 완료 : {}", resv.getAccResvNo());
                }
                
			}
                
			if (paymentVO.getPayNo() > 0) {
                try {
                    // 공통 메일 함수 호출
                    sendCommonReservationEmail(paymentVO); 
                    log.info("결제 완료 공통 메일 발송 성공!");
                } catch (Exception e) {
                    // 메일 발송 실패가 결제 전체의 실패는 아니므로 로그만 남김
                    log.error("메일 발송 중 오류 발생: {}", e.getMessage());
                }
            }
			
			// 1. 포인트 적립 알림
            if (discount == 0 && pointResult > 0) {
                int earnedPoint = (int) ((double) amount * 0.03);
                alarmService.sendPointEarnAlarm(paymentVO.getMemNo(), earnedPoint);
            }
            
            // 2. 포인트 사용 알림
            if (discount != 0 && minusPointResult > 0) {
                alarmService.sendPointUseAlarm(paymentVO.getMemNo(), discount);
            }
            
            // 3. 결제 완료 알림 (일반회원)
            String orderName = responseBody.get("orderName") != null 
                ? responseBody.get("orderName").toString() 
                : "상품";
            alarmService.sendPaymentCompleteAlarm(
                paymentVO.getMemNo(), 
                orderName, 
                paymentVO.getPayNo()
            );
            
            // 4. 기업회원에게 상품 판매 알림 (투어 상품인 경우)
            if ("tour".equals(paymentVO.getProductType())) {
                sendSellerAlarm(paymentVO);
            }

			return responseBody;
		} 
		
		else {
			log.error("결제 승인 API 실패: {}", response.getStatusCode());
			return null;
	}
}

	
	/**
	 * 숙박 상품 예약 확정 처리
	 * @author kdrs
	 */
	@Transactional
	private int accommodationPayConfirm(PaymentVO paymentVO) {
	    int result = 0;
	    AccResvVO resvVO = paymentVO.getAccResvVO();
	    
	    if (resvVO != null) {
	    	// 예약 마스터 정보 저장 (ACC_RESV)
	        resvVO.setPayNo(paymentVO.getPayNo()); 
	        result = accMapper.insertAccommodationReservaion(resvVO); 
	        log.info("ACC_RESV 테이블 INSERT 결과 : {}", result);
	        
		        if(result > 0) {
		        // 구입 상품 목록 저장 (PROD_LIST)
		        TripProdListVO tripProdListVO = new TripProdListVO();
		        RoomTypeVO room = accMapper.getRoomTypeDetail(resvVO.getRoomTypeNo());
		        int extraFeeUnit = room.getExtraGuestFee();
		        
		        tripProdListVO.setPayNo(paymentVO.getPayNo());
		        tripProdListVO.setTripProdNo(resvVO.getTripProdNo());
		        
		        // 판매 단가
		        int unitPrice = resvVO.getPrice();
		        // 박수
		        int nights = resvVO.getStayDays();
		        // 실제 결제 금액
		        int payPrice = paymentVO.getPayTotalAmt(); 
		        // 추가 인원 계산 (기준 인원 초과분)
		        int extraGuests = Math.max(0, (resvVO.getAdultCnt() + resvVO.getChildCnt()) - room.getBaseGuestCount());
		        // 총 추가 요금 계산
		        int totalExtraFee = extraGuests * extraFeeUnit * resvVO.getStayDays();
		        // 할인액 계산(1박 단가 * 박수) + 총 추가요금 - 실제 결제액
		        int totalNormalPrice = (resvVO.getPrice() * resvVO.getStayDays()) + totalExtraFee;
		        int discountAmt = totalNormalPrice - paymentVO.getPayTotalAmt();
		        
		        tripProdListVO.setUnitPrice(unitPrice);
		        tripProdListVO.setPayPrice(payPrice);
		        tripProdListVO.setDiscountAmt(Math.max(0, discountAmt));
		        
		        tripProdListVO.setQuantity(1);
		        tripProdListVO.setResvDt(new SimpleDateFormat("yy-MM-dd").format(resvVO.getStartDt()));
		        tripProdListVO.setUseTime("15:00");
		        tripProdListVO.setRsvMemo(resvVO.getResvRequest());
		        
		        //Mapper에서 selectKye로 prodListNo를 받아온다고 가정
	            accMapper.insertProdList(tripProdListVO);
	            
	            // 매출 데이터 생성 (SALES)
	            SalesVO salesVO = new SalesVO();
	            salesVO.setProdListNo(tripProdListVO.getProdListNo());
	            salesVO.setNetSales(tripProdListVO.getPayPrice());
	            salesVO.setSettleStatCd("정산대기");
	            
	            accMapper.insertSales(salesVO);
	            log.info("SALES 테이블 매출 등록 완료 : {}" , salesVO.getSaleNo());
	            
		        
		        // 약관 동의 객체가 null일 때 처리
		        if (resvVO.getAccResvAgree() == null) {
		            AccResvAgreeVO agreeVO = new AccResvAgreeVO();
		            // resvVO에서 바로 꺼내서 agreeVO에 세팅해야 함
		            agreeVO.setStayTermYn(resvVO.getStayTermYn());
		            agreeVO.setPrivacyAgreeYn(resvVO.getPrivacyAgreeYn());
		            agreeVO.setRefundAgreeYn(resvVO.getRefundAgreeYn());
		            agreeVO.setMarketAgreeYn(resvVO.getMarketAgreeYn());
		            
		            // 생성한 객체를 다시 resvVO에 꽂아줌
		            resvVO.setAccResvAgree(agreeVO);
		        }
		    }
	    }
	    
	    return result;
	}

	/**
	 * <p>항공상품 결제</p>
	 * @author sdg
	 * @param paymentVO	항공권 정보
	 * @return
	 */
	private int flightPayConfirm(PaymentVO paymentVO) {
		// 항공권 담기 - pk = 시퀀스
		int productResult = 0;
		int extraBaggagePrice = paymentVO.getFlightProductList().get(0).getExtraBaggagePrice(); // 수하물 가격 세팅
		
		for (FlightProductVO flightProductVO : paymentVO.getFlightProductList()) {
			Integer fltProdId = flightMapper.getFlightKey(flightProductVO);
			// 해당 정보와 일치하는 항공권 있는지 확인하기. 없으면 insert
			if(fltProdId != null) {
				flightProductVO.setFltProdId(fltProdId);
			}else {
				productResult = flightMapper.insertFlight(flightProductVO); // 항공권 없으면 insert 있으면 안하기
			}
			log.info("insertFlight getFltProdId {}", flightProductVO.getFltProdId());
			log.info("insertFlight : {}", productResult);
		}

		// fltProdId
		List<FlightReservationVO> flightReservationList = paymentVO.getFlightReservationList(); 
		int depProductNo = paymentVO.getFlightProductList().get(0).getFltProdId(); // 가는편 항공권 키 시퀀스
		log.info("depProductNo {}", depProductNo);
		flightReservationList.get(0).setFltProdId(depProductNo);

		int arrProductNo = 0;
		if (paymentVO.getFlightProductList().size() >= 2) {
			arrProductNo = paymentVO.getFlightProductList().get(1).getFltProdId(); // 오는편 항공권 키 시퀀스
			log.info("arrProductNo {}", arrProductNo);
			flightReservationList.get(1).setFltProdId(arrProductNo);				// 오는편 항공권 키 세팅
		}
		
		// 예약 정보 담기
		int reservationResult = 0;
		for (FlightReservationVO flightReservationVO : flightReservationList) {
			flightReservationVO.setPayNo(paymentVO.getPayNo()); // 결제키
			reservationResult = flightMapper.insertFlightReservation(flightReservationVO);
			log.info("flightReservation insert {}", reservationResult);
		}

		// reservNo
		long depReservationNo = paymentVO.getFlightReservationList().get(0).getReserveNo(); // 가는편 예약키
		long arrReservationNo = 0;
		if (paymentVO.getFlightProductList().size() >= 2) {
			arrReservationNo = paymentVO.getFlightReservationList().get(1).getReserveNo(); // 오는편 예약키
		}

		// 항공이용약관 동의 담기
		int reservationAgreeResult = 0;
		FlightResvAgreeVO flightResvAgreeVO = paymentVO.getFlightResvAgree();
		flightResvAgreeVO.setReserveNo(depReservationNo);
		
		reservationAgreeResult = flightMapper.insertFlightAgree(flightResvAgreeVO);
		log.info("insertFlightAgree dep : {}", reservationAgreeResult);
		if(paymentVO.getFlightReservationList().size() >= 2) {
			flightResvAgreeVO.setReserveNo(arrReservationNo);
			reservationAgreeResult = flightMapper.insertFlightAgree(flightResvAgreeVO);
			log.info("insertFlightAgree arr : {}", reservationAgreeResult);
		}
		
		// 탑승객 정보 담기
		int passengersResult = 0;
		List<FlightPassengersVO> flightPassengerList = paymentVO.getFlightPassengersList();
		// 가는편 insert
		for (FlightPassengersVO flightPassengersVO : flightPassengerList) {
			flightPassengersVO.setReserveNo(depReservationNo);
			flightPassengersVO.setFlightSeat(flightPassengersVO.getOutSeat());
			flightPassengersVO.setExtraBaggage(flightPassengersVO.getExtraBaggageOutbound());
			flightPassengersVO.setBaggagePrice(flightPassengersVO.getExtraBaggage() * extraBaggagePrice);
			passengersResult = flightMapper.insertPassengers(flightPassengersVO); // 출발 탑승객 정보
			log.info("flightPassengers out insert {}", passengersResult);
		}

		// 오는편 insert
		if (paymentVO.getFlightProductList().size() >= 2) {
			for (FlightPassengersVO flightPassengersVO : paymentVO.getFlightPassengersList()) {
				flightPassengersVO.setPassengerId(0); // 초기화 해야 오는편이 받아짐
				flightPassengersVO.setReserveNo(arrReservationNo);
				flightPassengersVO.setFlightSeat(flightPassengersVO.getInSeat());
				flightPassengersVO.setExtraBaggage(flightPassengersVO.getExtraBaggageInbound());
				flightPassengersVO.setBaggagePrice(flightPassengersVO.getExtraBaggage() * extraBaggagePrice);
				passengersResult = flightMapper.insertPassengers(flightPassengersVO); // 도착 탑승객 정보
				log.info("flightPassengers in insert {}", passengersResult);
			}
		}

		int result = productResult + reservationResult + reservationAgreeResult + passengersResult;
		
		return result;
	}

	/**
	 * 투어 상품 결제
	 */
	private int tourPayConfirm(PaymentVO paymentVO) {
		int result = 0;
	    
	    // TRIP_PROD_LIST 테이블에 저장
	    List<TripProdListVO> tripProdList = paymentVO.getTripProdList();
	    for (TripProdListVO item : tripProdList) {
	    	// 재고 감소 먼저 시도
	        int stockResult = payMapper.decreaseStock(item.getTripProdNo(), item.getQuantity());
	        
	        // 재고 부족하면 롤백
	        if (stockResult == 0) {
	            throw new RuntimeException("재고가 부족합니다. 상품번호: " + item.getTripProdNo());
	        }
	    	
	        item.setPayNo(paymentVO.getPayNo());
	        result = payMapper.insertTripProdList(item);
	        
	        // 매출 테이블 INSERT
	        SalesVO sales = new SalesVO();
	        sales.setProdListNo(item.getProdListNo());
	        sales.setNetSales(item.getPayPrice());
	        payMapper.insertSales(sales);
	        
	        // 재고 0이면 판매중지로 변경
	        int currentStock = payMapper.getCurrentStock(item.getTripProdNo());
	        if (currentStock <= 0) {
	            payMapper.updateSoldOut(item.getTripProdNo());
	        }
	    }
	    
	    // 마케팅 동의 업데이트 (N → Y인 경우만)
	    if ("Y".equals(paymentVO.getMktAgreeYn())) {
	        payMapper.updateMktAgree(paymentVO.getMemNo());
	    }
	    
	    return result;
	}

	/**
	 * 이용일 지나면 정산가능 상태 변경
	 */
	@Override
	public int updateSettleStatus() {
		return payMapper.updateSettleStatus();
	}
	
	private void sendCommonReservationEmail(PaymentVO payment) {
	    // 1. 회원 정보 조회 (이메일, 이름)
		MemberVO member = memberMapper.getMemberInfo(payment.getMemNo());
	    if (member == null || member.getMemEmail() == null) return;

	    String safeName = member.getMemName();
	    // 2. 주문명 추출 (paymentVO에 담긴 정보가 없다면 responseBody나 DB에서 세팅된 resMsg 활용)
	    // 리더가 말한 대로 PaymentInfoVO에 저장한 resMsg를 꺼내오자!
	    String orderName = (payment.getPaymentKey() != null) ? "결제 상품" : "주문 상품"; 
	    // 실제로는 결제 승인 후 저장된 resMsg를 꺼내오는 로직이 필요함
	    // 여기서는 가독성을 위해 가공된 정보를 사용!
	    
	    String productIcon = "";
	    String detailInfo = "";
	    
	    // 상품 타입별 아이콘 및 정보 분기
	    switch (payment.getProductType()) {
	        case "accommodation":
	            productIcon = "🏠";
	            AccResvVO resv = payment.getAccResvVO();
	            detailInfo = String.format("체크인: %s / 체크아웃: %s", 
	                new SimpleDateFormat("yyyy.MM.dd").format(resv.getStartDt()), 
	                new SimpleDateFormat("yyyy.MM.dd").format(resv.getEndDt()));
	            break;
	        case "flight":
	            productIcon = "✈️";
	            detailInfo = "항공권 상세 정보는 마이페이지 예약 내역에서 확인 가능합니다.";
	            break;
	        default:
	            productIcon = "🚩";
	            detailInfo = "이용 예정일: " + (payment.getTripProdList() != null ? payment.getTripProdList().get(0).getResvDt() : "마이페이지 확인");
	    }

	    String subject = "[모행] 예약 및 결제가 정상적으로 완료되었습니다.";
	    String formattedPrice = String.format("%,d", payment.getPayTotalAmt());

	    // 3. 리더의 임시 비밀번호 템플릿 스타일을 입힌 결제 완료 HTML
	    String html = """
	        <!doctype html>
	        <html lang="ko">
	        <head>
	          <meta charset="utf-8">
	          <meta name="viewport" content="width=device-width,initial-scale=1">
	          <title>Mohaeng 결제 완료 안내</title>
	        </head>
	        <body style="margin:0;padding:0;background:#f6f7fb;">
	          <table role="presentation" width="100%%" cellpadding="0" cellspacing="0" style="background:#f6f7fb;padding:24px 0;">
	            <tr>
	              <td align="center">
	                <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="width:600px;max-width:600px;background:#ffffff;border-radius:14px;overflow:hidden;box-shadow:0 4px 20px rgba(0,0,0,0.06);">
	                  <tr>
	                    <td style="padding:22px 28px;background:#111827;color:#ffffff;">
	                      <div style="font-size:18px;font-weight:700;letter-spacing:-0.2px;">Mohaeng</div>
	                      <div style="margin-top:6px;font-size:13px;opacity:0.85;">결제 완료 안내</div>
	                    </td>
	                  </tr>
	                  <tr>
	                    <td style="padding:26px 28px;color:#111827;">
	                      <div style="font-size:16px;line-height:1.6;">
	                        안녕하세요, <b>%s</b>님.<br>
	                        선택하신 상품의 <b>결제 및 예약</b>이 정상적으로 완료되었습니다.
	                      </div>
	                      <div style="margin-top:18px;padding:16px 18px;border:1px solid #e5e7eb;border-radius:12px;background:#f9fafb;">
	                        <div style="font-size:12px;color:#6b7280;margin-bottom:8px;">주문 내역 (%s)</div>
	                        <div style="font-size:18px;font-weight:800;letter-spacing:-0.5px;color:#2563eb;">
	                          %s
	                        </div>
	                        <div style="margin-top:10px;font-size:14px;color:#374151; font-weight: 600;">
	                          결제 금액 : %s원
	                        </div>
	                        <div style="margin-top:6px;font-size:12px;color:#6b7280;">
	                          %s
	                        </div>
	                      </div>
	                      <div style="margin-top:18px;font-size:14px;line-height:1.7;color:#374151;">
	                        자세한 예약 정보 및 티켓 확인은 마이페이지에서 확인하실 수 있습니다.
	                      </div>
	                      <div style="margin-top:16px;">
	                        <a href="http://localhost:8272/mypage/payments"
	                           style="display:inline-block;padding:12px 16px;border-radius:10px;background:#2563eb;color:#ffffff;text-decoration:none;font-weight:700;font-size:14px;">
	                          예약 내역 확인하러 가기
	                        </a>
	                      </div>
	                    </td>
	                  </tr>
	                  <tr>
	                    <td style="padding:16px 28px;background:#f9fafb;color:#6b7280;font-size:11px;line-height:1.6;">
	                      © Mohaeng. All rights reserved.<br>
	                      이 메일은 발신 전용입니다. 이용해 주셔서 감사합니다.
	                    </td>
	                  </tr>
	                </table>
	              </td>
	            </tr>
	          </table>
	        </body>
	        </html>
	        """.formatted(safeName, productIcon, payment.getOrderId(), formattedPrice, detailInfo); 
	        // ※ payment.getOrderId() 대신 아까 말한 resMsg 변수를 넣어주면 돼!

	    mailService.sendEmail(member.getMemEmail(), subject, member.getMemName() + "님 결제 완료", html);
	}
    
    /**
     * 기업회원에게 판매 알림 전송
     */
    private void sendSellerAlarm(PaymentVO paymentVO) {
        try {
            List<TripProdListVO> tripProdList = paymentVO.getTripProdList();
            for (TripProdListVO item : tripProdList) {
                // 상품 정보에서 기업회원 memNo 조회 필요
                Integer sellerMemNo = payMapper.getSellerMemNo(item.getTripProdNo());
                String productName = payMapper.getProductName(item.getTripProdNo());
                
                if (sellerMemNo != null) {
                    alarmService.sendProductSoldAlarm(
                        sellerMemNo, 
                        productName, 
                        item.getQuantity()
                    );
                }
            }
        } catch (Exception e) {
            log.error("기업회원 판매 알림 전송 실패: {}", e.getMessage());
        }
    }

}
