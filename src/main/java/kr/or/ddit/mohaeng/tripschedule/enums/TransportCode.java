package kr.or.ddit.mohaeng.tripschedule.enums;

public enum TransportCode {
	CAR("자가용/렌트카"),
    PUBLIC("대중교통"),
    TAXI("택시/카풀");

    private final String description;

    TransportCode(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
