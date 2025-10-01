import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 노선 경로 세그먼트 모델
/// 큰 경로 데이터를 여러 세그먼트로 나누어 저장합니다
class PathSegment {
  final String id;
  final int segmentOrder;
  final List<LatLng> points;

  PathSegment({
    required this.id,
    required this.segmentOrder,
    required this.points,
  });

  /// Firestore 문서에서 PathSegment 객체 생성
  factory PathSegment.fromFirestore(Map<String, dynamic> data, String id) {
    return PathSegment(
      id: id,
      segmentOrder: data['segment_order'] ?? 0,
      points: (data['points'] as List<dynamic>?)
          ?.map((point) => LatLng(
                point['lat']?.toDouble() ?? 0.0,
                point['lng']?.toDouble() ?? 0.0,
              ))
          .toList() ?? [],
    );
  }

  /// PathSegment 객체를 Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'segment_order': segmentOrder,
      'points': points
          .map((point) => {
                'lat': point.latitude,
                'lng': point.longitude,
              })
          .toList(),
    };
  }

  /// 세그먼트 ID 생성 (예: "segment_01")
  static String generateSegmentId(int order) {
    return 'segment_${order.toString().padLeft(2, '0')}';
  }

  /// 큰 경로를 여러 세그먼트로 분할
  static List<PathSegment> splitPathIntoSegments(
    List<LatLng> fullPath, 
    {int maxPointsPerSegment = 50}
  ) {
    final segments = <PathSegment>[];
    
    for (int i = 0; i < fullPath.length; i += maxPointsPerSegment) {
      final endIndex = (i + maxPointsPerSegment < fullPath.length) 
          ? i + maxPointsPerSegment 
          : fullPath.length;
      
      final segmentPoints = fullPath.sublist(i, endIndex);
      final segmentOrder = (i ~/ maxPointsPerSegment) + 1;
      
      segments.add(PathSegment(
        id: generateSegmentId(segmentOrder),
        segmentOrder: segmentOrder,
        points: segmentPoints,
      ));
    }
    
    return segments;
  }

  /// 여러 세그먼트를 하나의 경로로 결합
  static List<LatLng> combineSegments(List<PathSegment> segments) {
    // 순서대로 정렬
    segments.sort((a, b) => a.segmentOrder.compareTo(b.segmentOrder));
    
    final allPoints = <LatLng>[];
    for (final segment in segments) {
      allPoints.addAll(segment.points);
    }
    
    return allPoints;
  }

  @override
  String toString() {
    return 'PathSegment(id: $id, order: $segmentOrder, points: ${points.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PathSegment &&
        other.id == id &&
        other.segmentOrder == segmentOrder &&
        other.points.length == points.length;
  }

  @override
  int get hashCode {
    return id.hashCode ^ segmentOrder.hashCode ^ points.length.hashCode;
  }
}
