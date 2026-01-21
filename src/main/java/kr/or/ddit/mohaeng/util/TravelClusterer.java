package kr.or.ddit.mohaeng.util;
import java.util.*;
import java.util.stream.Collectors;

public class TravelClusterer {
	

	
    public record Location(int id, String name, double lat, double lon) {}

    public static Map<Integer, List<Location>> groupLocationsByDay(List<Location> locations, int days) {
        if (locations.isEmpty() || days <= 0) return Collections.emptyMap();

        // 1. 초기 중심점(Centroid) 설정 (랜덤하게 일수만큼 선택)
        List<double[]> centroids = locations.stream()
                .limit(days)
                .map(l -> new double[]{l.lat(), l.lon()})
                .collect(Collectors.toList());

        Map<Integer, List<Location>> clusters = new HashMap<>();

        // 2. 최대 10번 반복 (보통 5번 내외로 수렴함)
        for (int iter = 0; iter < 10; iter++) {
            clusters.clear();
            for (int i = 0; i < days; i++) clusters.put(i, new ArrayList<>());

            // 각 장소를 가장 가까운 중심점에 할당
            for (Location loc : locations) {
                int nearestIdx = findNearestCentroid(loc, centroids);
                clusters.get(nearestIdx).add(loc);
            }

            // 중심점 재계산 (할당된 장소들의 평균 좌표로 이동)
            for (int i = 0; i < days; i++) {
                List<Location> clusterLocs = clusters.get(i);
                if (!clusterLocs.isEmpty()) {
                    double avgLat = clusterLocs.stream().mapToDouble(Location::lat).average().orElse(0);
                    double avgLon = clusterLocs.stream().mapToDouble(Location::lon).average().orElse(0);
                    centroids.set(i, new double[]{avgLat, avgLon});
                }
            }
        }
        return clusters;
    }

    private static int findNearestCentroid(Location loc, List<double[]> centroids) {
        int minIdx = 0;
        double minDistance = Double.MAX_VALUE;
        for (int i = 0; i < centroids.size(); i++) {
            double dist = Math.pow(loc.lat() - centroids.get(i)[0], 2) + Math.pow(loc.lon() - centroids.get(i)[1], 2);
            if (dist < minDistance) {
                minDistance = dist;
                minIdx = i;
            }
        }
        return minIdx;
    }
}