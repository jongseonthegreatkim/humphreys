import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:humphreys/models/bus_route.dart';
import 'package:humphreys/models/route_stop.dart';
import 'package:humphreys/models/path_segment.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  // 현재 위치 버튼 중복 호출 방지
  bool _isLoadingLocation = false;
  
  // Firestore에서 가져온 Orange 노선 데이터
  BusRoute? _orangeRoute;
  List<RouteStop> _orangeStops = [];
  List<LatLng> _orangePathPoints = [];
  bool _isLoadingFirestoreData = false;
  String? _errorMessage; // 에러 메시지 저장
  
  // 커스텀 마커 아이콘 캐시
  BitmapDescriptor? _currentLocationIcon;
  BitmapDescriptor? _busStopIcon;

  /// Firestore에서 Orange 노선 데이터 가져오기. initState에서만 호출됨.
  /// 추후에, loadRoutesFromFirestore 함수로 변경될 예정.
  Future<void> _loadOrangeRouteFromFirestore() async {
    if (_isLoadingFirestoreData) return;
    
    setState(() {
      _isLoadingFirestoreData = true;
    });
    
    try {
      final firestore = FirebaseFirestore.instanceFor(app: Firebase.app('new-humph'));
      
      print('🔄 Firestore에서 Orange 노선 데이터 로딩 중...');
      
      // 1. Orange 노선 기본 정보 가져오기
      final orangeRouteDoc = await firestore.collection('routes').doc('orange').get();
      if (!orangeRouteDoc.exists) {
        throw 'Orange 노선을 찾을 수 없습니다';
      }

      _orangeRoute = BusRoute(
        id: orangeRouteDoc.id,
        colorHex: orangeRouteDoc.data()!['color_hex'] ?? '',
        totalStops: orangeRouteDoc.data()!['total_stops'] ?? 0,
      );

      print('✅ Orange 노선 기본 정보 로드 완료: ${_orangeRoute}');

      // 2. Orange 노선의 정류장들 가져오기
      final orangeStopsQuery = await firestore
          .collection('routes')
          .doc('orange')
          .collection('stops')
          .orderBy('order')
          .get();

      _orangeStops = orangeStopsQuery.docs.map((doc) => RouteStop(
        id: doc.id,
        name: doc.data()['name'] ?? '',
        latitude: doc.data()['latitude']?.toDouble() ?? 0.0,
        longitude: doc.data()['longitude']?.toDouble() ?? 0.0,
        order: doc.data()['order'] ?? 0,
        estimatedTimeFromStart: doc.data()['estimated_time_from_start'] ?? 0,
      )).toList();

      print('✅ Orange 노선 정류장들 ${_orangeStops} 로드 완료');
      
      // 3. Orange 노선의 경로 세그먼트들 가져오기
      final orangePathSegmentsQuery = await firestore
          .collection('routes')
          .doc('orange')
          .collection('path_segments')
          .orderBy('segment_order')
          .get();
      
      final orangePathSegments = orangePathSegmentsQuery.docs
          .map((doc) => PathSegment.fromFirestore(doc.data(), doc.id))
          .toList();
      
      // 세그먼트들을 하나의 경로로 결합
      _orangePathPoints = PathSegment.combineSegments(orangePathSegments);
      
      print('✅ Orange 노선 경로 ${orangePathSegments.length}개 세그먼트, 총 ${_orangePathPoints.length}개 포인트 로드 완료');
      
      setState(() {
        _errorMessage = null; // 성공 시 에러 메시지 제거
      });
      
      print('🎉 Firestore Orange 노선 로드 성공! 정류장: ${_orangeStops.length}개, 경로점: ${_orangePathPoints.length}개');
      
    } catch (e) {
      print('❌ Firestore Orange 노선 로드 실패: $e');
      
      setState(() {
        _errorMessage = 'Orange 노선 로드 실패';
      });
    } finally {
      setState(() {
        _isLoadingFirestoreData = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 자동으로 Firestore 데이터 로드
    _loadOrangeRouteFromFirestore();
    // 커스텀 마커 아이콘들 생성 (Current Loaction, Bus Stop)
    _createCurrentLocationIcon();
    _createBusStopIcon();
  }

  Future<Position> _getPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw '위치 서비스가 꺼져 있습니다.';
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      throw '위치 권한이 영구적으로 거부되었습니다.';
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw '위치 권한이 거부되었습니다.';
      }
    }
    return Geolocator.getCurrentPosition();
  }

  // 현재 위치로 이동하는 함수
  void _goToCurrentLocation() async {
    if (_isLoadingLocation) return; // 중복 실행 방지

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await _getPosition();
      setState(() {
        _currentPosition = position;
      });

      // 현재 줌 레벨 유지
      final currentZoom = _mapController != null
          ? await _mapController!.getZoomLevel()
          : 15.5;

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: currentZoom,
          ),
        ),
      );

      // 성공 로그
      print('Moved to current location: '
          '(${position.latitude}, ${position.longitude}), '
          'zoom=$currentZoom');
    } catch (e) {
      // 에러 로그
      print('Failed to move to current location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _getPosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: SelectableText.rich(
              TextSpan(
                text: '오류: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final pos = snapshot.data!;
        _currentPosition = pos; // 초기 위치 저장

        final camera = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 15.5,
        );

        return Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              initialCameraPosition: camera,
              // 기본 위치 관련 기능 끄기 (커스텀으로 대체)
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.satellite,
              // 제스처
              zoomGesturesEnabled: true,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              // 줌 범위 설정
              minMaxZoomPreference: const MinMaxZoomPreference(6, 21),
              markers: {
                // 현재 위치 마커 추가 (네이버 지도 스타일 원형 마커)
                if (_currentPosition != null && _currentLocationIcon != null)
                  Marker(
                    markerId: const MarkerId('current_location'),
                    position: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    icon: _currentLocationIcon!,
                    anchor: const Offset(0.5, 0.5), // 마커 중앙 정렬
                  ),
                // 버스 정류장 마커들
                ..._buildStationMarkers(),
              },
              // 버스 노선 폴리라인들
              polylines: _buildRoutePolylines(),
            ),
            // 커스텀 위치 버튼 (좌측 하단)
            Positioned(
              left: 16,
              bottom: 100,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: Colors.blue[600],
                          size: 24,
                        ),
                  onPressed: _isLoadingLocation ? null : _goToCurrentLocation,
                  tooltip: '현재 위치로 이동',
                ),
              ),
            ),
            // 로딩 상태 표시 (우측 상단)
            if (_isLoadingFirestoreData)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Orange 노선 로딩 중...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // 에러 메시지 표시 (우측 상단)
            if (_errorMessage != null)
              Positioned(
                top: 100,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => setState(() => _errorMessage = null),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // 지도 상단 검색바 (UI만, 기능 미구현)
            Positioned(
              top: 60, // 상태바 아래
              left: 16,
              right: 16,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  enabled: false, // 기능 미구현으로 비활성화
                  decoration: InputDecoration(
                    hintText: 'Search Anything...',
                    hintStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    suffixIcon: Icon(
                      Icons.tune,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 네이버 지도 스타일의 예쁜 원형 현재 위치 마커 생성
  Future<void> _createCurrentLocationIcon() async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final double size = 60.0; // 마커 크기
      
      // 외부 원 (흰색 테두리)
      final Paint outerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, outerPaint);
      
      // 내부 원 (파란색)
      final Paint innerPaint = Paint()
        ..color = const Color(0xFF4285F4) // Google 파란색
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size / 2, size / 2), (size / 2) - 4, innerPaint);
      
      // 중앙 점 (흰색)
      final Paint centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(size / 2, size / 2), 8, centerPaint);
      
      // 그림자 효과를 위한 외부 테두리
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2, shadowPaint);
      
      final ui.Picture picture = pictureRecorder.endRecording();
      final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      _currentLocationIcon = BitmapDescriptor.fromBytes(pngBytes);
      
      // 마커 생성 완료 후 UI 업데이트
      if (mounted) {
        setState(() {});
      }
      
      print('✅ 커스텀 현재 위치 마커 아이콘 생성 완료');
    } catch (e) {
      print('❌ 커스텀 마커 아이콘 생성 실패: $e');
      // 기본 마커로 폴백
      _currentLocationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  /// 폴리라인과 융화된 버스 정류장 마커 생성 (가로로 두꺼운 느낌)
  /// 추후에, 색상도 조정해야 함.
  Future<void> _createBusStopIcon() async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final double width = 40.0; // 가로 길이 (두꺼운 느낌)
      final double height = 40.0; // 세로 길이
      
      // 배경 둥근 직사각형 (폴리라인과 동일한 오렌지색)
      final Paint backgroundPaint = Paint()
        ..color = const Color(0xFFF16D25) // Orange 색상 (폴리라인과 동일)
        ..style = PaintingStyle.fill;
      
      final RRect backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(10), // 둥근 모서리
      );
      canvas.drawRRect(backgroundRect, backgroundPaint);
      
      // 테두리 (흰색으로 선명하게)
      final Paint borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(backgroundRect, borderPaint);
      
      // 중앙 버스 정류장 표시 (흰색 원)
      final Paint centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(width / 2, height / 2), 4, centerPaint);
      
      // 그림자 효과
      final Paint shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(backgroundRect, shadowPaint);
      
      final ui.Picture picture = pictureRecorder.endRecording();
      final ui.Image image = await picture.toImage(width.toInt(), height.toInt());
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      
      _busStopIcon = BitmapDescriptor.fromBytes(pngBytes);
      
      // 마커 생성 완료 후 UI 업데이트
      if (mounted) {
        setState(() {});
      }
      
      print('✅ 커스텀 버스 정류장 마커 아이콘 생성 완료 (폴리라인 융화 디자인)');
    } catch (e) {
      print('❌ 커스텀 버스 정류장 마커 아이콘 생성 실패: $e');
      // 기본 마커로 폴백
      _busStopIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }
  }

  /// Orange 노선 정류장 마커들 생성 (Firestore 데이터만 사용)
  Set<Marker> _buildStationMarkers() {
    final markers = <Marker>{};
    
    // Firestore에서 가져온 Orange 노선 정류장만 표시 (폴리라인과 융화된 커스텀 디자인)
    if (_busStopIcon != null) {
      for (int i = 0; i < _orangeStops.length; i++) {
        final stop = _orangeStops[i];
        markers.add(
          Marker(
            markerId: MarkerId('orange_stop_${i}'),
            position: LatLng(stop.latitude, stop.longitude),
            icon: _busStopIcon!,
            anchor: const Offset(0.5, 0.5), // 마커 중앙 정렬
            infoWindow: InfoWindow(
              title: '🚏 ${stop.name}',
              snippet: 'Orange Route (${stop.order}번째 정류장, 예상시간: ${stop.estimatedTimeFromStart}분)',
            ),
            onTap: () {
              print('Orange 정류장 탭: ${stop.name} (${stop.estimatedTimeFromStart}분)');
            },
          ),
        );
      }
    }
    return markers;
  }

  /// Orange 노선 폴리라인 생성 (Firestore 데이터만 사용)
  Set<Polyline> _buildRoutePolylines() {
    final polylines = <Polyline>{};
    
    // Firestore에서 가져온 Orange 노선 경로만 표시
    if (_orangePathPoints.isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('orange_route'),
          points: _orangePathPoints,
          color: const Color(0xFFF16D25), // Orange 색상
          width: 5, // 명확하게 보이도록 적절한 두께
          zIndex: 1,
          patterns: [], // 실선으로 표시
        ),
      );
    }
    
    return polylines;
  }
}