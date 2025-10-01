/// 노선 내 정류장 정보를 위한 모델
/// 각 노선의 stops 서브컬렉션에 저장됩니다
class RouteStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int order; // 노선 내에서의 순서
  final int estimatedTimeFromStart; // 첫 정류장으로부터 예상 소요시간(분)

  RouteStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.order,
    required this.estimatedTimeFromStart,
  });

  @override
  String toString() {
    return 'RouteStop(id: $id, name: $name, lat: $latitude, lng: $longitude, order: $order, estimatedTime: ${estimatedTimeFromStart}min)';
  }
}
