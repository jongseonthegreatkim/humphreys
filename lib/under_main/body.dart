import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:humphreys/under_body/station.dart';
import 'package:humphreys/under_body/bottom_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {

  // 현재 위치 받아오는 함수
  Future<Position> getCurrentPosition() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  // customMarker 정의
  BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;
  // customMarker에 asset 이미지 할당
  void iconFromAssets() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/images/bus-stop-96.png").then(
            (icon) {
          setState(() {
            customMarker = icon;
            // 왜 여전히 marker를 함수로 빼서 marker: blueMarker로 하면
      // 기본 마커 아이콘으로 되돌아가는 것인가?
          });
        }
    );
  }
  // iconFromAssets을 최초에 실행.
  @override
  void initState() {
    super.initState();
    iconFromAssets();
  }

  // 실시간 줌 레벨을 _currentZoom에 저장
  double _currentZoom = 15.5;
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentZoom = position.zoom;
    });
  }

  // 줌 값 max, min for minMaxZoomPreference
  double _minZoom = 15.5;
  double _maxZoom = 15.5;

  // 그린 루트 맨 위로 오게 하기 위해서 임시로 만든 함수.
  int _zIndex(int index) {
    int ans = 0;
    if(index==2) {
      ans = 100;
    } else if(index==4) {
      ans = 1000;
    } else {
      ans = index;
    };
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.hasData == false) {
          // data를 아직 받아오지 못 했을 때 실행되는 부분.
          return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
                strokeWidth: 5,
              )
          );
        } else if (snapshot.hasError) {
          // data에 에러가 있을 때 실행되는 부분.
          return Text('Error: ${snapshot.error}');
        } else {
          // data를 정상적으로 받아왔을 때 실행되는 부분.
          // 사실상의 body에 해당하는 부분이다.
          return GoogleMap(
            onCameraMove: _onCameraMove,
            mapType: MapType.satellite,
            initialCameraPosition: CameraPosition(
              target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
              zoom: _currentZoom,
            ),
            markers: {
              if(_currentZoom > 15) ...[
                for(int index=0; index<routes.length; index++) ...[
                  for(int subIndex=0; subIndex<routes[index].length; subIndex++) ...[
                    Marker(
                      markerId: MarkerId('${names[index]} Marker'),
                      position: routes[index][subIndex].stationPosition,
                      infoWindow: InfoWindow(
                        title: routes[index][subIndex].stationName,
                      ),
                      icon: customMarker,
                      anchor: Offset(0.5, 0.5),
                      onTap: () {
                        _minZoom = 14;
                        _maxZoom = 17;
                        customBottomSheet(routes[index][subIndex].stationName, context);
                      },
                    ),
                  ],
                ],
              ],
            },
            polylines: {
              if(_currentZoom > 15) ...[
                for(int index=0; index<listOfLatLngList.length; index++) ...[
                  for(int subIndex=0; subIndex<listOfLatLngList[index].length; subIndex++) ...[
                    Polyline(
                      polylineId: PolylineId('${names[index]} Polyline'),
                      points: listOfLatLngList[index],
                      color: colors[index],
                      width: 4,
                      //width: 4 + index*4,
                      zIndex: _zIndex(index),
                    ),
                  ],
                ],
              ],
            },
            minMaxZoomPreference: MinMaxZoomPreference(_minZoom, _maxZoom),
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          );
        }
      },
    );
  }
}
