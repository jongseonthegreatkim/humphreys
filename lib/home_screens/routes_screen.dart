import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {

  Future<void> fetchBasicDataFromFirestore() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Firestore 인스턴스 가져오기
      final firestore = FirebaseFirestore.instanceFor(app: Firebase.app('new-humph'));

      // 'routes' 컬렉션의 모든 도큐먼트 스냅샷 가져오기
      QuerySnapshot querySnapshot = await firestore.collection('routes').get();

      // [1번, 2번] 도큐먼트 스냅샷에서 도큐먼트 ID(이름)만 추출하여 리스트로 만들기
      List<String> routeNames = querySnapshot.docs.map((doc) => doc.id).toList();

      // [3번]
      List<Map<String, dynamic>> routeDetails = querySnapshot.docs.map((doc) {
        // doc.data()는 Map<String, dynamic>을 반환합니다.
        final detailData = doc.data() as Map<String, dynamic>;

        return {
          'name': doc.id,
          'colorHex': detailData['color_hex'],
          'totalStops': detailData['total_stops'],
        };
      }).toList();

      // [4번]
      List<Future<Map<String, dynamic>>> stopsDetails = querySnapshot.docs.map((doc) async {
        QuerySnapshot stopsSnapshot = await doc.reference.collection('stops').get();

        List<Map<String, dynamic>> stopsDetail = stopsSnapshot.docs.map((stopDoc) {
          final stopData = stopDoc.data() as Map<String, dynamic>;
          return {
            'name': stopDoc.id,
            'estimated_time_from_start': stopData['estimated_time_from_start'],
            'latitude': stopData['latitude'],
            'longitude': stopData['longitude'],
            'stopName': stopData['name'],
            'order': stopData['order'],
          };
        }).toList();

        return {
          'name': doc.id,
          'stops': stopsDetail,
        };
      }).toList();

      List<Map<String, dynamic>> displayingStopsDetail = await Future.wait(stopsDetails);

      /// [5번] -> path_segments 컬렉션에서 segment들을 가져와서 순서대로 정렬하고 points를 연결
      List<Future<Map<String, dynamic>>> pathsDetails = querySnapshot.docs.map((doc) async {
        QuerySnapshot pathsSnapshot = await doc.reference.collection('path_segments').get();

        // segment_order에 따라 정렬
        List<QueryDocumentSnapshot> sortedSegments = pathsSnapshot.docs.toList();
        sortedSegments.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          return (aData['segment_order'] as int).compareTo(bData['segment_order'] as int);
        });

        // 모든 segment의 points를 순서대로 연결
        List<Map<String, dynamic>> allPoints = [];
        for (var segmentDoc in sortedSegments) {
          final segmentData = segmentDoc.data() as Map<String, dynamic>;
          final points = segmentData['points'] as List<dynamic>;
          
          // 각 point를 allPoints에 추가
          for (var point in points) {
            final pointMap = point as Map<String, dynamic>;
            allPoints.add({
              'lat': pointMap['lat'],
              'lng': pointMap['lng'],
            });
          }
        }

        return {
          'name': doc.id,
          'paths': allPoints,
        };
      }).toList();

      List<Map<String, dynamic>> displayingPathsDetail = await Future.wait(pathsDetails);

      print('routeNames: $routeNames');
      print('routesCount: ${routeNames.length}');
      print('routeDetails: $routeDetails');
      print('displayingStopsDetail: $displayingStopsDetail');
      print('displayingPathsDetail: $displayingPathsDetail');
      setState(() {
        showRouteNames = routeNames;
        showRoutesCount = routeNames.length;
        showRouteDetails = routeDetails;
        showDisplayingStopsDetail = displayingStopsDetail;
        showDisplayingPathsDetail = displayingPathsDetail;
        isLoading = false;
      });
    } catch (e) {
      // 에러 처리
      print('Error fetching route names: $e');
    }
  }

  bool isLoading = false;

  List<String> showRouteNames = [];
  int showRoutesCount = 0;
  List<Map<String, dynamic>> showRouteDetails = [];
  List<Map<String, dynamic>> showDisplayingStopsDetail = [];
  List<Map<String, dynamic>> showDisplayingPathsDetail = [];

  @override
  void initState() {
    fetchBasicDataFromFirestore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:(isLoading) ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We have ${showRoutesCount.toString()} routes and they are ${showRouteNames.toString()}.',
                ),
                // 이 밑은 5번을 보여주는 코드 (Path Segments)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: showDisplayingPathsDetail.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          'Route ${index}: ${showDisplayingPathsDetail[index]['name']} - Path Segments',
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: showDisplayingPathsDetail[index]['paths'].length,
                          itemBuilder: (context, subIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Point ${subIndex}: lat: ${showDisplayingPathsDetail[index]['paths'][subIndex]['lat']}',
                                ),
                                Text(
                                  'Point ${subIndex}: lng: ${showDisplayingPathsDetail[index]['paths'][subIndex]['lng']}',
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 12);
                          },
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                ),
                // 이 밑은 4번을 보여주는 코드
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: showDisplayingStopsDetail.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Text(
                          'Route ${index}: ${showDisplayingStopsDetail[index]['name']}',
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: showDisplayingStopsDetail[index]['stops'].length,
                          itemBuilder: (context, subIndex) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['name']}',
                                ),
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['estimated_time_from_start']}',
                                ),
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['latitude']}',
                                ),
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['longitude']}',
                                ),
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['stopName']}',
                                ),
                                Text(
                                  'Stops: ${showDisplayingStopsDetail[index]['stops'][subIndex]['order']}',
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 12);
                          },
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
