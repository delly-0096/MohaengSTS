package kr.or.ddit.mohaeng.vo;

	import java.util.List;
	import lombok.Data;


	@Data
	public class CompanyDashboardVO{
	  private Kpi kpi;
	  private List<MonthlySalesPoint> monthlySalesChart;
	  private List<TopTripProd> topProducts;
	  
	  
	  @Data
	  public static class Kpi {
	    private long monthlySales;       // 이번달 매출(결제완료)
	    private int monthlyReservations; // 이번달 예약건수(결제완료 기준)
	    private int sellingProductCount; // 판매중 상품 수
	  }

	  @Data
	  public static class MonthlySalesPoint {
	    private String month; // YYYY-MM
	    private long sales;
	  }

	  @Data
	  public static class TopTripProd {
	    private int tripProdNo;
	    private String tripProdTitle;
	    private long sales;
	    private int reservationCount;
	    private String approveStatus;
	    
	    @Data
	    public static class NotiItem {
	      private String type;     // order/review/inquiry/settle
	      private String title;    // "새 예약이 들어왔습니다"
	      private String message;  // 상품명 등
	      private String timeText; // "10분 전" 같은 텍스트(일단 SQL에서 만들어도 됨)
	      private String link;     // 클릭 이동 경로
	      private String unreadYn; // Y/N
	     
	      @Data
	      public static class RecentReservation {
	          private int payNo;
	          private String tripProdTitle;
	          private String buyerName;
	          private long payPrice;
	          private String payStatus;
	      }


	  }



	    }

	

	  public void setRecentReservations(Object selectRecentReservations) {

		
	  }
	}
	  


