// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../models/bus_stop.dart';
// import '../models/bus_route.dart';
// import '../models/route_stop.dart';
// import '../models/path_segment.dart';
// import '../station.dart'; // 기존 하드코딩된 데이터
//
// /// 하드코딩된 데이터를 Firebase로 마이그레이션하는 클래스
// /// Firebase.app('new-humph') 인스턴스를 사용합니다
// class DataMigration {
//   /// 명명된 Firebase 앱 인스턴스에서 Firestore 가져오기
//   static FirebaseFirestore get _firestore {
//     final app = Firebase.app('new-humph');
//     return FirebaseFirestore.instanceFor(app: app);
//   }
//
//   /// 전체 마이그레이션 실행
//   static Future<void> migrateAllData() async {
//     print('🚀 데이터 마이그레이션 시작... (Firebase app: new-humph)');
//
//     try {
//       // Firebase 연결 상태 확인
//       final app = Firebase.app('new-humph');
//       print('✅ Firebase 앱 연결 확인: ${app.name}');
//       // 1. 정류장 데이터 마이그레이션
//       print('\n📍 정류장 데이터 마이그레이션 중...');
//       await _migrateStops();
//
//       // 2. 노선 데이터 마이그레이션
//       print('\n🚌 노선 데이터 마이그레이션 중...');
//       await _migrateRoutes();
//
//       print('\n✅ 마이그레이션 완료!');
//     } catch (e) {
//       print('❌ 마이그레이션 중 오류 발생: $e');
//       rethrow;
//     }
//   }
//
//   /// 정류장 데이터 마이그레이션
//   static Future<void> _migrateStops() async {
//     // 모든 정류장을 수집하고 중복 제거
//     Map<String, BusStop> uniqueStops = {};
//
//     // 각 노선별로 정류장 정보 수집
//     List<List<Station>> allRoutes = [
//       blueRoute,
//       blackRoute,
//       greenRoute,
//       orangeRoute,
//       purpleRoute
//     ];
//
//     List<String> routeIds = ['blue', 'black', 'green', 'orange', 'purple'];
//
//     for (int routeIndex = 0; routeIndex < allRoutes.length; routeIndex++) {
//       String routeId = routeIds[routeIndex];
//       List<Station> routeStations = allRoutes[routeIndex];
//
//       for (Station station in routeStations) {
//         String stopId = BusStop.nameToId(station.stationName);
//
//         if (uniqueStops.containsKey(stopId)) {
//           // 기존 정류장에 노선 추가
//           List<String> routes = List.from(uniqueStops[stopId]!.routes);
//           if (!routes.contains(routeId)) {
//             routes.add(routeId);
//             uniqueStops[stopId] = BusStop(
//               id: stopId,
//               name: station.stationName,
//               latitude: station.stationPosition.latitude,
//               longitude: station.stationPosition.longitude,
//               routes: routes,
//             );
//           }
//         } else {
//           // 새로운 정류장 생성
//           uniqueStops[stopId] = BusStop(
//             id: stopId,
//             name: station.stationName,
//             latitude: station.stationPosition.latitude,
//             longitude: station.stationPosition.longitude,
//             routes: [routeId],
//           );
//         }
//       }
//     }
//
//     print('총 ${uniqueStops.length}개의 고유 정류장 발견');
//
//     // Firebase에 업로드
//     WriteBatch batch = _firestore.batch();
//     int count = 0;
//
//     for (BusStop stop in uniqueStops.values) {
//       DocumentReference docRef = _firestore.collection('stops').doc(stop.id);
//       batch.set(docRef, stop.toFirestore());
//       count++;
//
//       // 배치 크기 제한 (500개씩)
//       if (count % 500 == 0) {
//         await batch.commit();
//         batch = _firestore.batch();
//         print('${count}개 정류장 업로드 완료...');
//       }
//     }
//
//     // 남은 데이터 커밋
//     if (count % 500 != 0) {
//       await batch.commit();
//     }
//
//     print('✅ ${count}개 정류장 업로드 완료');
//   }
//
//   /// 노선 데이터 마이그레이션
//   static Future<void> _migrateRoutes() async {
//     List<List<Station>> allRoutes = [
//       blueRoute,
//       blackRoute,
//       greenRoute,
//       orangeRoute,
//       purpleRoute
//     ];
//
//     List<String> routeIds = ['blue', 'black', 'green', 'orange', 'purple'];
//     List<String> routeNames = names; // station.dart에서 가져온 이름들
//     List<Color> routeColors = colors; // station.dart에서 가져온 색상들
//     List<List<LatLng>> routePaths = listOfLatLngList; // station.dart에서 가져온 경로들
//
//     WriteBatch batch = _firestore.batch();
//
//     for (int i = 0; i < allRoutes.length; i++) {
//       String routeId = routeIds[i];
//       List<Station> routeStations = allRoutes[i];
//
//       // 정류장 순서 생성 (정류장 이름을 ID로 변환)
//       List<String> stopsOrder = routeStations
//           .map((station) => BusStop.nameToId(station.stationName))
//           .toList();
//
//       // 노선 객체 생성
//       BusRoute busRoute = BusRoute(
//         id: routeId,
//         colorHex: BusRoute.colorToHex(routeColors[i]),
//         totalStops: routeStations.length,
//       );
//
//       // Firebase에 추가
//       DocumentReference docRef = _firestore.collection('routes').doc(routeId);
//       batch.set(docRef, busRoute.toFirestore());
//
//       print('${routeNames[i]} 노선 준비 완료 (정류장 ${stopsOrder.length}개, 경로점 ${routePaths[i].length}개)');
//     }
//
//     // 모든 노선 데이터 커밋
//     await batch.commit();
//     print('✅ ${routeIds.length}개 노선 업로드 완료');
//   }
//
//   /// 기존 데이터 삭제 (선택사항)
//   static Future<void> clearExistingData() async {
//     print('🗑️ 기존 데이터 삭제 중...');
//
//     // stops 컬렉션 삭제
//     QuerySnapshot stopsSnapshot = await _firestore.collection('stops').get();
//     WriteBatch batch = _firestore.batch();
//
//     for (DocumentSnapshot doc in stopsSnapshot.docs) {
//       batch.delete(doc.reference);
//     }
//
//     // routes 컬렉션 삭제
//     QuerySnapshot routesSnapshot = await _firestore.collection('routes').get();
//     for (DocumentSnapshot doc in routesSnapshot.docs) {
//       batch.delete(doc.reference);
//     }
//
//     await batch.commit();
//     print('✅ 기존 데이터 삭제 완료');
//   }
//
//   /// 계층적 구조로 전체 마이그레이션 실행 (시간표 제외)
//   static Future<void> migrateToHierarchicalStructure() async {
//     print('🏗️ 계층적 구조로 마이그레이션 시작... (Firebase app: new-humph)');
//
//     try {
//       // Firebase 연결 상태 확인
//       final app = Firebase.app('new-humph');
//       print('✅ Firebase 앱 연결 확인: ${app.name}');
//
//       // 1. 글로벌 정류장 데이터 마이그레이션
//       print('\n📍 글로벌 정류장 데이터 마이그레이션 중...');
//       await _migrateGlobalStops();
//
//       // 2. 계층적 노선 데이터 마이그레이션
//       print('\n🏗️ 계층적 노선 데이터 마이그레이션 중...');
//       await _migrateHierarchicalRoutes();
//
//       print('\n✅ 계층적 구조 마이그레이션 완료!');
//     } catch (e) {
//       print('❌ 계층적 구조 마이그레이션 중 오류 발생: $e');
//       rethrow;
//     }
//   }
//
//   /// 글로벌 정류장 마이그레이션 (중복 제거된 전체 정류장)
//   static Future<void> _migrateGlobalStops() async {
//     // 모든 정류장을 수집하고 중복 제거
//     Map<String, BusStop> uniqueStops = {};
//
//     // 각 노선별로 정류장 정보 수집
//     List<List<Station>> allRoutes = [
//       blueRoute,
//       blackRoute,
//       greenRoute,
//       orangeRoute,
//       purpleRoute
//     ];
//
//     List<String> routeIds = ['blue', 'black', 'green', 'orange', 'purple'];
//
//     for (int routeIndex = 0; routeIndex < allRoutes.length; routeIndex++) {
//       String routeId = routeIds[routeIndex];
//       List<Station> routeStations = allRoutes[routeIndex];
//
//       for (Station station in routeStations) {
//         String stopId = BusStop.nameToId(station.stationName);
//
//         if (uniqueStops.containsKey(stopId)) {
//           // 기존 정류장에 노선 추가
//           List<String> routes = List.from(uniqueStops[stopId]!.routes);
//           if (!routes.contains(routeId)) {
//             routes.add(routeId);
//             uniqueStops[stopId] = BusStop(
//               id: stopId,
//               name: station.stationName,
//               latitude: station.stationPosition.latitude,
//               longitude: station.stationPosition.longitude,
//               routes: routes,
//             );
//           }
//         } else {
//           // 새로운 정류장 생성
//           uniqueStops[stopId] = BusStop(
//             id: stopId,
//             name: station.stationName,
//             latitude: station.stationPosition.latitude,
//             longitude: station.stationPosition.longitude,
//             routes: [routeId],
//           );
//         }
//       }
//     }
//
//     print('총 ${uniqueStops.length}개의 고유 정류장 발견');
//
//     // global_stops 컬렉션에 업로드
//     WriteBatch batch = _firestore.batch();
//     int count = 0;
//
//     for (BusStop stop in uniqueStops.values) {
//       DocumentReference docRef = _firestore.collection('global_stops').doc(stop.id);
//       batch.set(docRef, stop.toFirestore());
//       count++;
//
//       // 배치 크기 제한 (500개씩)
//       if (count % 500 == 0) {
//         await batch.commit();
//         batch = _firestore.batch();
//         print('${count}개 글로벌 정류장 업로드 완료...');
//       }
//     }
//
//     // 남은 데이터 커밋
//     if (count % 500 != 0) {
//       await batch.commit();
//     }
//
//     print('✅ ${count}개 글로벌 정류장 업로드 완료');
//   }
//
//   /// 계층적 노선 데이터 마이그레이션
//   static Future<void> _migrateHierarchicalRoutes() async {
//     List<List<Station>> allRoutes = [
//       blueRoute,
//       blackRoute,
//       greenRoute,
//       orangeRoute,
//       purpleRoute
//     ];
//
//     List<String> routeIds = ['blue', 'black', 'green', 'orange', 'purple'];
//     List<String> routeNames = names;
//     List<Color> routeColors = colors;
//     List<List<LatLng>> routePaths = listOfLatLngList;
//
//     for (int i = 0; i < allRoutes.length; i++) {
//       String routeId = routeIds[i];
//       List<Station> routeStations = allRoutes[i];
//
//       print('\n🚌 ${routeNames[i]} 노선 마이그레이션 중...');
//
//       // 1. 메인 노선 문서 생성
//       BusRoute busRoute = BusRoute(
//         id: routeId,
//         colorHex: BusRoute.colorToHex(routeColors[i]),
//         totalStops: routeStations.length,
//       );
//
//       await _firestore.collection('routes').doc(routeId).set(busRoute.toFirestore());
//       print('  ✅ ${routeNames[i]} 메인 노선 문서 생성');
//
//       // 2. 정류장 서브컬렉션 생성
//       await _migrateRouteStops(routeId, routeStations);
//
//       // 3. 경로 세그먼트 서브컬렉션 생성
//       await _migratePathSegments(routeId, routePaths[i], routeNames[i]);
//
//       print('  🎉 ${routeNames[i]} 노선 마이그레이션 완료');
//     }
//   }
//
//   /// 노선별 정류장 서브컬렉션 마이그레이션
//   static Future<void> _migrateRouteStops(String routeId, List<Station> stations) async {
//     WriteBatch batch = _firestore.batch();
//
//     for (int j = 0; j < stations.length; j++) {
//       Station station = stations[j];
//
//       RouteStop routeStop = RouteStop(
//         id: RouteStop.generateOrderedId(j + 1, station.stationName),
//         name: station.stationName,
//         latitude: station.stationPosition.latitude,
//         longitude: station.stationPosition.longitude,
//         order: j + 1,
//         estimatedTimeFromStart: j * 3, // 정류장당 평균 3분 간격으로 추정
//       );
//
//       DocumentReference stopRef = _firestore
//           .collection('routes')
//           .doc(routeId)
//           .collection('stops')
//           .doc(routeStop.id);
//
//       batch.set(stopRef, routeStop.toFirestore());
//     }
//
//     await batch.commit();
//     print('  ✅ ${stations.length}개 정류장 서브컬렉션 생성');
//   }
//
//   /// 경로 세그먼트 서브컬렉션 마이그레이션
//   static Future<void> _migratePathSegments(String routeId, List<LatLng> pathPoints, String routeName) async {
//     if (pathPoints.isEmpty) {
//       print('  ⚠️ ${routeName} 노선의 경로 데이터가 없습니다');
//       return;
//     }
//
//     // 경로를 세그먼트로 분할 (50개씩)
//     List<PathSegment> segments = PathSegment.splitPathIntoSegments(pathPoints, maxPointsPerSegment: 50);
//
//     WriteBatch batch = _firestore.batch();
//
//     for (PathSegment segment in segments) {
//       DocumentReference segmentRef = _firestore
//           .collection('routes')
//           .doc(routeId)
//           .collection('path_segments')
//           .doc(segment.id);
//
//       batch.set(segmentRef, segment.toFirestore());
//     }
//
//     await batch.commit();
//     print('  ✅ ${segments.length}개 경로 세그먼트 생성 (총 ${pathPoints.length}개 포인트)');
//   }
//
//   /// 계층적 구조 마이그레이션 결과 검증
//   static Future<void> verifyHierarchicalMigration() async {
//     print('\n🔍 계층적 구조 마이그레이션 결과 검증 중...');
//
//     // 글로벌 정류장 수 확인
//     QuerySnapshot globalStopsSnapshot = await _firestore.collection('global_stops').get();
//     print('Firebase 글로벌 정류장 수: ${globalStopsSnapshot.docs.length}');
//
//     // 노선 수 확인
//     QuerySnapshot routesSnapshot = await _firestore.collection('routes').get();
//     print('Firebase 노선 수: ${routesSnapshot.docs.length}');
//
//     // 각 노선별 서브컬렉션 확인
//     for (DocumentSnapshot doc in routesSnapshot.docs) {
//       BusRoute route = BusRoute.fromFirestore(
//         doc.data() as Map<String, dynamic>,
//         doc.id
//       );
//
//       // 정류장 서브컬렉션 확인
//       QuerySnapshot stopsSubcollection = await _firestore
//           .collection('routes')
//           .doc(route.id)
//           .collection('stops')
//           .get();
//
//       // 경로 세그먼트 서브컬렉션 확인
//       QuerySnapshot pathSegmentsSubcollection = await _firestore
//           .collection('routes')
//           .doc(route.id)
//           .collection('path_segments')
//           .get();
//
//       print('${route.id} 노선:');
//       print('  - 총 정류장: ${route.totalStops}개');
//       print('  - 정류장 서브컬렉션: ${stopsSubcollection.docs.length}개');
//       print('  - 경로 세그먼트: ${pathSegmentsSubcollection.docs.length}개');
//     }
//
//     print('✅ 계층적 구조 검증 완료');
//   }
//
//   /// 기존 단순 구조 마이그레이션 결과 검증
//   static Future<void> verifyMigration() async {
//     print('\n🔍 마이그레이션 결과 검증 중...');
//
//     // 정류장 수 확인
//     QuerySnapshot stopsSnapshot = await _firestore.collection('stops').get();
//     print('Firebase 정류장 수: ${stopsSnapshot.docs.length}');
//
//     // 노선 수 확인
//     QuerySnapshot routesSnapshot = await _firestore.collection('routes').get();
//     print('Firebase 노선 수: ${routesSnapshot.docs.length}');
//
//     print('✅ 검증 완료');
//   }
// }
