package kr.or.ddit.mohaeng.tripschedule.enums;

public enum BudgetPreference {
	LOW("저렴하게", "~10만원/일"),
    MEDIUM("적당하게", "10~20만원/일"),
    HIGH("럭셔리하게", "20만원~/일");

    private final String name;
    private final String description;

    BudgetPreference(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public String getName() { return name; }
    public String getDescription() { return description; }
}
