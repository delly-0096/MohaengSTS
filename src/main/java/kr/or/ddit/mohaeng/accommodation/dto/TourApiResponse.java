package kr.or.ddit.mohaeng.accommodation.dto;

import java.util.List;

import lombok.Data;

@Data
public class TourApiResponse {
	private Response response;
	
	@Data
    public static class Response {
        private Body body;
    }

    @Data
    public static class Body {
        private Items items;
        private int totalCount;
    }

    @Data
    public static class Items {
        private List<TourApiItemDTO> item;
    }
    
}
