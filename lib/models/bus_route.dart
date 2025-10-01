import 'package:flutter/material.dart';

/// Firebase에 저장될 버스 노선 모델 (계층적 구조용)
/// 실제 정류장과 경로 데이터는 서브컬렉션에 저장됩니다
class BusRoute {
  final String id;
  final String colorHex; // 색상을 hex 문자열로 저장
  final int totalStops; // 총 정류장 수

  BusRoute({
    required this.id,
    required this.colorHex,
    required this.totalStops,
  });

  @override
  String toString() {
    return 'BusRoute(id: $id, color: $colorHex, totalStops: $totalStops)';
  }
}
