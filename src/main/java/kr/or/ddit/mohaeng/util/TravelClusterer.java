package kr.or.ddit.mohaeng.util;
import java.util.*;
import java.util.stream.Collectors;

public class TravelClusterer {

    public record Location(int id, String name, double lat, double lon) {}

    // 메인 메서드: 군집화 후 정렬까지 수행하여 반환
    public static Map<Integer, List<Location>> groupAndSortLocations(List<Location> locations, int days, double startLat, double startLon) {
        // 1. 기존 K-Means 로직으로 일자별 그룹핑 (Clustering)
        Map<Integer, List<Location>> clusters = groupLocationsByDay(locations, days);

        // 2. 각 그룹별로 최단거리 정렬 (Routing) 수행
        Map<Integer, List<Location>> sortedClusters = new HashMap<>();
        
        // 첫날 시작점 (보통 공항/숙소)
        double currentLat = startLat;
        double currentLon = startLon;

        for (int i = 0; i < days; i++) {
            List<Location> dayList = clusters.getOrDefault(i, new ArrayList<>());
            
            if (dayList.isEmpty()) {
                sortedClusters.put(i, dayList);
                continue;
            }

            // 그리디 알고리즘으로 정렬
            List<Location> sortedDayList = sortRouteGreedy(dayList, currentLat, currentLon);
            sortedClusters.put(i, sortedDayList);

            // 다음 날의 시작점은 오늘 마지막 방문지로 설정 (또는 숙소 좌표로 고정 가능)
            Location lastLocation = sortedDayList.get(sortedDayList.size() - 1);
            currentLat = lastLocation.lat();
            currentLon = lastLocation.lon();
        }

        return sortedClusters;
    }

    // ------------------------------------------------------------------
    // [추가된 로직] 그리디(Greedy) 정렬 : 가까운 곳부터 방문
    // ------------------------------------------------------------------
    private static List<Location> sortRouteGreedy(List<Location> locations, double startLat, double startLon) {
        List<Location> sorted = new ArrayList<>();
        List<Location> remaining = new ArrayList<>(locations); // 원본 보호

        double currentLat = startLat;
        double currentLon = startLon;

        while (!remaining.isEmpty()) {
            Location nearest = null;
            double minDist = Double.MAX_VALUE;

            // 남은 장소 중 현재 위치에서 가장 가까운 곳 찾기
            for (Location loc : remaining) {
                // 단순 유클리드 거리 비교 (속도 최적화, 정밀한 거리 계산 필요 시 Haversine 사용)
                double dist = Math.pow(currentLat - loc.lat(), 2) + Math.pow(currentLon - loc.lon(), 2);
                if (dist < minDist) {
                    minDist = dist;
                    nearest = loc;
                }
            }

            if (nearest != null) {
                sorted.add(nearest);
                remaining.remove(nearest);
                // 이동
                currentLat = nearest.lat();
                currentLon = nearest.lon();
            }
        }
        return sorted;
    }

    // ------------------------------------------------------------------
    // [기존 로직] K-Means 군집화 (약간의 최적화 포함)
    // ------------------------------------------------------------------
    private static Map<Integer, List<Location>> groupLocationsByDay(List<Location> locations, int days) {
        if (locations.isEmpty() || days <= 0) return Collections.emptyMap();
        
        // 예외처리: 장소 개수가 일수보다 적으면 그냥 1개씩 배분
        if (locations.size() <= days) {
            Map<Integer, List<Location>> map = new HashMap<>();
            for(int i=0; i<locations.size(); i++) {
                map.put(i, new ArrayList<>(List.of(locations.get(i))));
            }
            return map;
        }

        // 1. 초기 중심점 설정
        List<double[]> centroids = locations.stream()
                .limit(days)
                .map(l -> new double[]{l.lat(), l.lon()})
                .collect(Collectors.toList());

        Map<Integer, List<Location>> clusters = new HashMap<>();

        for (int iter = 0; iter < 10; iter++) { // 10회 반복
            clusters.clear();
            for (int i = 0; i < days; i++) clusters.put(i, new ArrayList<>());

            for (Location loc : locations) {
                int nearestIdx = findNearestCentroid(loc, centroids);
                clusters.get(nearestIdx).add(loc);
            }

            // 중심점 재계산
            boolean changed = false;
            for (int i = 0; i < days; i++) {
                List<Location> clusterLocs = clusters.get(i);
                if (!clusterLocs.isEmpty()) {
                    double avgLat = clusterLocs.stream().mapToDouble(Location::lat).average().orElse(0);
                    double avgLon = clusterLocs.stream().mapToDouble(Location::lon).average().orElse(0);
                    
                    if (centroids.get(i)[0] != avgLat || centroids.get(i)[1] != avgLon) {
                        centroids.set(i, new double[]{avgLat, avgLon});
                        changed = true;
                    }
                }
            }
            // 중심점이 더 이상 변하지 않으면 조기 종료 (속도 향상)
            if (!changed) break;
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