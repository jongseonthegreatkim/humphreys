import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// 정류장 이름 및 위치로 구성된 클래스.
class Station {
  final String stationName;
  final LatLng stationPosition;

  Station({
    required this.stationName,
    required this.stationPosition,
  });
}

// 여기부터 Line 277까지는, 정리 완.
// "노선 별 정류장 리스트" 의 리스트
List<List> routes = [blueRoute, blackRoute, greenRoute, orangeRoute, purpleRoute];
// 노선 별 정류장 리스트
List<Station> blueRoute = [
  Station(
    stationName: 'Pedestrian Gate',
    stationPosition: LatLng(36.958283, 127.043168),
  ),
  Station(
    stationName: 'Provider Grill DFAC',
    stationPosition: LatLng(36.964917, 127.040191)
  ),
  Station(
    stationName: 'SLQs (12200s block)',
    stationPosition: LatLng(36.965851, 127.036572),
  ),
  Station(
    stationName: 'Eighth Army',
    stationPosition: LatLng(36.966111, 127.032083),
  ),
  Station(
    stationName: 'Corps of Engineers',
    stationPosition: LatLng(36.972941, 127.021504),
  ),
  Station(
    stationName: "TMP (Driver's Licensing)",
    stationPosition: LatLng(36.967635, 127.016371),
  ),
  Station(
    stationName: 'Airfield Operations',
    stationPosition: LatLng(36.965258, 127.019831),
  ),
  Station(
    stationName: 'Talon Cafe DFAC',
    stationPosition: LatLng(36.960985, 127.020035),
  ),
  Station(
    stationName: 'Barracks (6000s block)',
    stationPosition: LatLng(36.962490, 127.015501),
  ),
  Station(
    stationName: 'Pacific Victors Chapel',
    stationPosition: LatLng(36.966497, 127.010222),
  ),
  Station(
    stationName: 'Spartan DFAC',
    stationPosition: LatLng(36.970343, 127.008175),
  ),
  Station(
    stationName: 'LTG Timothy J. Maude Hall (9th Street)',
    stationPosition: LatLng(36.967778, 127.005071),
  ),
  Station(
    stationName: 'Commissary',
    stationPosition: LatLng(36.963948, 127.003098),
  ),
  Station(
    stationName: 'Main Post Office',
    stationPosition: LatLng(36.962969, 127.000192),
  ),
  Station(
    stationName: 'Main Exchange',
    stationPosition: LatLng(36.965583, 126.998128),
  ),
  Station(
    stationName: 'Pittman DFAC',
    stationPosition: LatLng(36.973587, 126.998386),
  ),
  Station(
    stationName: 'Sitman Fitness Center',
    stationPosition: LatLng(36.974992, 126.994145),
  ),
  Station(
    stationName: '2ID Sustainment',
    stationPosition: LatLng(36.977277, 126.987239),
  ),
  Station(
    stationName: 'Central Issue Facility',
    stationPosition: LatLng(36.972669, 126.985131),
  ),
];
List<Station> blackRoute = [
  Station(
    stationName: 'Pedestrian Gate',
    stationPosition: LatLng(36.958283, 127.043168),
  ),
  Station(
    stationName: 'Provider Grill DFAC',
    stationPosition: LatLng(36.964917, 127.040191),
  ),
  Station(
    stationName: 'SLQs (12200s block)',
    stationPosition: LatLng(36.965851, 127.036572),
  ),
  Station(
    stationName: 'Eighth Army',
    stationPosition: LatLng(36.966111, 127.032083),
  ),
  Station(
    stationName: 'Corps of Engineers',
    stationPosition: LatLng(36.972941, 127.021504),
  ),
  Station(
    stationName: 'Pacific Victors Chapel',
    stationPosition: LatLng(36.966497, 127.010222),
  ),
  Station(
    stationName: 'Commissary',
    stationPosition: LatLng(36.963948, 127.003098),
  ),
  Station(
    stationName: 'LTG Timothy J. Maude Hall (9th Street)',
    stationPosition: LatLng(36.967778, 127.005071),
  ),
  Station(
    stationName: 'Spartan DFAC',
    stationPosition: LatLng(36.970343, 127.008175),
  ),
];
List<Station> greenRoute = [
  Station(
    stationName: 'Pedestrian Gate',
    stationPosition: LatLng(36.958283, 127.043168),
  ),
  Station(
    stationName: 'Provider Grill DFAC',
    stationPosition: LatLng(36.964917, 127.040191),
  ),
  Station(
    stationName: 'Desiderio ATC Tower',
    stationPosition: LatLng(36.964293, 127.036618),
  ),
  Station(
    stationName: 'Law Enforcement Center (DES)',
    stationPosition: LatLng(36.952923, 127.034436),
  ),
  Station(
    stationName: 'Bus Terminal',
    stationPosition: LatLng(36.951259, 127.029953),
  ),
  Station(
    stationName: 'Lodging',
    stationPosition: LatLng(36.948529, 127.026887),
  ),
  Station(
    stationName: 'Korean Theater of Operations Museum',
    stationPosition: LatLng(36.948791, 127.025157),
  ),
  Station(
    stationName: 'MSG Henry L. Jenkins Medical Clinic',
    stationPosition: LatLng(36.949238, 127.023337),
  ),
  Station(
    stationName: 'Collier Community Fitness Center',
    stationPosition: LatLng(36.953496, 127.021939),
  ),
  Station(
    stationName: 'Family Housing Towers (5050s & 5070s Block)',
    stationPosition: LatLng(36.957873, 127.019084),
  ),
  Station(
    stationName: 'Talon Cafe DFAC',
    stationPosition: LatLng(36.960985, 127.020035),
  ),
  Station(
    stationName: 'Airfield Operations',
    stationPosition: LatLng(36.965258, 127.019831),
  ),
  Station(
    stationName: 'Barracks (6000s block)',
    stationPosition: LatLng(36.962490, 127.015501),
  ),
  Station(
    stationName: 'Pacific Victors Chapel',
    stationPosition: LatLng(36.966497, 127.010222),
  ),
  Station(
    stationName: 'Spartan DFAC',
    stationPosition: LatLng(36.970343, 127.008175),
  ),
  Station(
    stationName: 'LTG Timothy J. Maude Hall (9th Street)',
    stationPosition: LatLng(36.967778, 127.005071),
  ),
  Station(
    stationName: 'Commissary',
    stationPosition: LatLng(36.963948, 127.003098),
  ),
  Station(
    stationName: 'Main Exchange',
    stationPosition: LatLng(36.965583, 126.998128),
  ),
  Station(
    stationName: 'Balboni Sports Field Complex (7th Street)',
    stationPosition: LatLng(36.969713, 127.000252),
  ),
];
List<Station> orangeRoute = [
  Station(
    stationName: 'Pedestrian Gate',
    stationPosition: LatLng(36.958283, 127.043168),
  ),
  Station(
    stationName: 'Provider Grill DFAC',
    stationPosition: LatLng(36.964917, 127.040191),
  ),
  Station(
    stationName: 'SLQs (12200s block)',
    stationPosition: LatLng(36.965851, 127.036572),
  ),
  Station(
    stationName: 'Eighth Army',
    stationPosition: LatLng(36.966111, 127.032083),
  ),
  Station(
    stationName: "TMP (Driver's Licensing)",
    stationPosition: LatLng(36.967635, 127.016371),
  ),
];
List<Station> purpleRoute = [
  Station(
    stationName: 'Brian D. Allgood Army Community Hospital (Key Street)',
    stationPosition: LatLng(36.952395, 127.029093),
  ),
  Station(
    stationName: 'Bus Terminal',
    stationPosition: LatLng(36.951259, 127.029953),
  ),
  Station(
    stationName: 'Collier Community Fitness Center',
    stationPosition: LatLng(36.953496, 127.021939),
  ),
  Station(
    stationName: 'Turner Fitness Center',
    stationPosition: LatLng(36.960643, 127.024542),
  ),
  Station(
    stationName: "TMP (Driver's Licensing)",
    stationPosition: LatLng(36.967635, 127.016371),
  ),
  Station(
    stationName: 'Spartan DFAC',
    stationPosition: LatLng(36.970343, 127.008175),
  ),
  Station(
    stationName: 'Sitman Fitness Center',
    stationPosition: LatLng(36.974992, 126.994145),
  ),
  Station(
    stationName: 'Barracks (6800s & 6900s Block)',
    stationPosition: LatLng(36.973795, 126.990728),
  ),
  Station(
    stationName: 'Balboni Sports Field Complex (5th Street)',
    stationPosition: LatLng(36.970758, 126.994980),
  ),
  Station(
    stationName: 'Pittman DFAC',
    stationPosition: LatLng(36.973587, 126.998386),
  ),
];

// 이것도 정리 완.
// 노선 별 색상 리스트
List<Color> colors = [Color(0xFF0029FF), Color(0xFF000000), Color(0xFF4CA546), Color(0xFFF16D25), Color(0xFF8A2574)];

// 이것도 정리 완.
// 노선 별 이름 리스트
List<String> routeNames = ['Blue', 'Black', 'Green', 'Orange', 'Purple'];

// 여기부터 Line 786까지 정리 완.
// "노선 별 폴리라인을 위한 LatLng 리스트" 의 리스트
List<List<LatLng>> listOfLatLngList = [blueRouteLatLngList, blackRouteLatLngList, greenRouteLatLngList, orangeRouteLatLngList, purpleRouteLatLngList];
// 노선 별 폴리라인을 위한 LatLng 리스트
List<LatLng> blueRouteLatLngList = [
  LatLng(36.958283, 127.043168), // S1 : Pesestrian Gate
  LatLng(36.959024, 127.041985), // P1.1
  LatLng(36.959528, 127.041050), // P1.2
  LatLng(36.959749, 127.040621), // P1.3
  LatLng(36.959893, 127.040301), // P1.4
  LatLng(36.960100, 127.040470), // P1.5
  LatLng(36.960159, 127.040492), // P1.6
  LatLng(36.960230, 127.040495), // P1.7
  LatLng(36.960335, 127.040460), // P1.8
  LatLng(36.961027, 127.040007), // P1.9
  LatLng(36.961131, 127.039968), // P1.10
  LatLng(36.961237, 127.039960), // P1.11
  LatLng(36.963264, 127.040149), // P1.12
  LatLng(36.964342, 127.040196), // P1.13
  LatLng(36.964917, 127.040191), // S2 : Provider Grill DFAC
  LatLng(36.965304, 127.040180), // P2.1
  LatLng(36.965247, 127.036592), // P2.2
  LatLng(36.965851, 127.036572), // S3 : SLQs (12200s block)
  LatLng(36.966279, 127.036557), // P3.1
  LatLng(36.966214, 127.032623), // P3.2
  LatLng(36.966194, 127.032370), // P3.3
  LatLng(36.966111, 127.032083), // S4 : Eighth Army
  LatLng(36.966042, 127.031941), // P4.1
  LatLng(36.965937, 127.031792), // P4.2
  LatLng(36.964830, 127.030529), // P4.3
  LatLng(36.969891, 127.023370), // P4.4
  LatLng(36.970347, 127.022904), // P4.5
  LatLng(36.970762, 127.022639), // P4.6
  LatLng(36.972246, 127.022108), // P4.7
  LatLng(36.972506, 127.021957), // P4.8
  LatLng(36.972692, 127.021795), // P4.9
  LatLng(36.972941, 127.021504), // S5 : Corps of Engineers
  LatLng(36.973130, 127.021073), // P5.1
  LatLng(36.973194, 127.020860), // P5.2
  LatLng(36.973244, 127.020567), // P5.3
  LatLng(36.973718, 127.014751), // P5.4
  LatLng(36.973771, 127.014372), // P5.5
  LatLng(36.973725, 127.014161), // P5.6
  LatLng(36.973597, 127.013909), // P5.7
  LatLng(36.973461, 127.013766), // P5.8
  LatLng(36.973345, 127.013686), // P5.9
  LatLng(36.972583, 127.013289), // P5.10
  LatLng(36.969517, 127.011773), // P5.11
  LatLng(36.969080, 127.012007), // P5.12
  LatLng(36.967635, 127.016371), // S6 : TMP (Driver's Licensing)
  LatLng(36.967315, 127.017335), // P6.1
  LatLng(36.967214, 127.017525), // P6.2
  LatLng(36.967143, 127.017605), // P6.3
  LatLng(36.967082, 127.017651), // P6.4
  LatLng(36.966494, 127.017962), // P6.5
  LatLng(36.966373, 127.018053), // P6.6
  LatLng(36.966270, 127.018200), // P6.7
  LatLng(36.966040, 127.018616), // P6.8
  LatLng(36.965948, 127.018785), // P6.9
  LatLng(36.965258, 127.019831), // S7 : Airfield Operations
  LatLng(36.964071, 127.021598), // P7.1
  LatLng(36.963609, 127.021113), // P7.2
  LatLng(36.963418, 127.020967), // P7.3
  LatLng(36.963151, 127.020809), // P7.4
  LatLng(36.962792, 127.020648), // P7.5
  LatLng(36.962194, 127.020531), // P7.6
  LatLng(36.961828, 127.020432), // P7.7
  LatLng(36.961569, 127.020329), // P7.8
  LatLng(36.960985, 127.020035), // S8 : Talon Cafe DFAC
  LatLng(36.962121, 127.016607), // P8.1
  LatLng(36.962490, 127.015501), // S9 : Barracks (6000s block)
  LatLng(36.964561, 127.009246), // P9.1
  LatLng(36.966497, 127.010222), // S10 : Pacific Victors Chapel
  LatLng(36.968902, 127.011457), // P10.1
  LatLng(36.969339, 127.011233), // P10.2
  LatLng(36.970343, 127.008175), // S11 : Spartan DFAC
  LatLng(36.970851, 127.006650), // P11.1
  LatLng(36.967778, 127.005071), // S12 : LTG Timothy J. Maude Hall (9th Street)
  LatLng(36.963948, 127.003098), // S13 : Commissary
  LatLng(36.963716, 127.002981), // P13.1
  LatLng(36.963519, 127.002915), // P13.2
  LatLng(36.963382, 127.002891), // P13.3
  LatLng(36.963007, 127.002886), // P13.4
  LatLng(36.962969, 127.000192), // S14 : Main Post Office
  LatLng(36.962964, 126.999558), // P14.1
  LatLng(36.962986, 126.999191), // P14.2
  LatLng(36.963062, 126.998809), // P14.3
  LatLng(36.963205, 126.998404), // P14.4
  LatLng(36.963410, 126.998032), // P14.5
  LatLng(36.963598, 126.997789), // P14.6
  LatLng(36.963809, 126.997586), // P14.7
  LatLng(36.964385, 126.997115), // P14.8
  LatLng(36.964561, 126.997442), // P14.9
  LatLng(36.964706, 126.997626), // P14.10
  LatLng(36.964896, 126.997775), // P14.11
  LatLng(36.965583, 126.998128), // S15 : Main Exchange
  LatLng(36.972500, 127.001684), // P15.1
  LatLng(36.973587, 126.998386), // S16 : Pittman DFAC
  LatLng(36.974992, 126.994145), // S17 : Sitman Fitness Center
  LatLng(36.975785, 126.991749), // P17.1
  LatLng(36.977277, 126.987239), // S18 : 2ID Sustainment
  LatLng(36.977422, 126.986769), // P18.1
  LatLng(36.972895, 126.984443), // P18.2
  LatLng(36.972669, 126.985131), // S19 : Central Issue Facility
  LatLng(36.971253, 126.989420), // P19.1
  LatLng(36.975785, 126.991749), // P19.2 == P17.1
  LatLng(36.974992, 126.994145), // S20 : Sitman Fitness Center
  // from here, go back from Sitman Fitness Center -> Pittman DFAC -> ...
]; // for bluePolyline
List<LatLng> blackRouteLatLngList = [
  LatLng(36.958283, 127.043168), // S1 : Pesestrian Gate
  LatLng(36.959024, 127.041985), // P1.1
  LatLng(36.959528, 127.041050), // P1.2
  LatLng(36.959749, 127.040621), // P1.3
  LatLng(36.959893, 127.040301), // P1.4
  LatLng(36.960100, 127.040470), // P1.5
  LatLng(36.960159, 127.040492), // P1.6
  LatLng(36.960230, 127.040495), // P1.7
  LatLng(36.960335, 127.040460), // P1.8
  LatLng(36.961027, 127.040007), // P1.9
  LatLng(36.961131, 127.039968), // P1.10
  LatLng(36.961237, 127.039960), // P1.11
  LatLng(36.963264, 127.040149), // P1.12
  LatLng(36.964342, 127.040196), // P1.13
  LatLng(36.964917, 127.040191), // S2 : Provider Grill DFAC
  LatLng(36.965304, 127.040180), // P2.1
  LatLng(36.965247, 127.036592), // P2.2
  LatLng(36.965851, 127.036572), // S3 : SLQs (12200s block)
  LatLng(36.966279, 127.036557), // P3.1
  LatLng(36.966214, 127.032623), // P3.2
  LatLng(36.966194, 127.032370), // P3.3
  LatLng(36.966111, 127.032083), // S4 : Eighth Army
  LatLng(36.966042, 127.031941), // P4.1
  LatLng(36.965937, 127.031792), // P4.2
  LatLng(36.964830, 127.030529), // P4.3
  LatLng(36.969891, 127.023370), // P4.4
  LatLng(36.970347, 127.022904), // P4.5
  LatLng(36.970762, 127.022639), // P4.6
  LatLng(36.972246, 127.022108), // P4.7
  LatLng(36.972506, 127.021957), // P4.8
  LatLng(36.972692, 127.021795), // P4.9
  LatLng(36.972941, 127.021504), // S5 : Corps of Engineers
  LatLng(36.973130, 127.021073), // P5.1
  LatLng(36.973194, 127.020860), // P5.2
  LatLng(36.973244, 127.020567), // P5.3
  LatLng(36.973718, 127.014751), // P5.4
  LatLng(36.973771, 127.014372), // P5.5
  LatLng(36.973725, 127.014161), // P5.6
  LatLng(36.973597, 127.013909), // P5.7
  LatLng(36.973461, 127.013766), // P5.8
  LatLng(36.973345, 127.013686), // P5.9
  LatLng(36.972583, 127.013289), // P5.10
  LatLng(36.969517, 127.011773), // P5.11
  LatLng(36.966497, 127.010222), // S6 : Pacific Victors Chapel
  LatLng(36.964561, 127.009246), // P6.1
  LatLng(36.962542, 127.008173), // P6.2
  LatLng(36.962902, 127.006849), // P6.3
  LatLng(36.962956, 127.006621), // P6.4
  LatLng(36.962988, 127.006401), // P6.5
  LatLng(36.963012, 127.006054), // P6.6
  LatLng(36.963012, 127.005708), // P6.7
  LatLng(36.962996, 127.003904), // P6.8
  LatLng(36.963012, 127.003301), // P6.9
  LatLng(36.963007, 127.002886), // P6.10
  LatLng(36.963382, 127.002891), // P6.11
  LatLng(36.963519, 127.002915), // P6.12
  LatLng(36.963716, 127.002981), // P6.13
  LatLng(36.963948, 127.003098), // S7 : Commissary
  LatLng(36.967778, 127.005071), // S8 : LTG Timothy J. Maude Hall (9th Street)
  LatLng(36.970851, 127.006650), // P8.1
  LatLng(36.970343, 127.008175), // S9 : Spartan DFAC
  LatLng(36.969339, 127.011233), // P10.2
  LatLng(36.969517, 127.011773), // P10.3 == P5.11
]; // for blackPolyline
List<LatLng> greenRouteLatLngList =  [
  LatLng(36.958283, 127.043168), // S1 : Pesestrian Gate
  LatLng(36.959024, 127.041985), // P1.1
  LatLng(36.959528, 127.041050), // P1.2
  LatLng(36.959749, 127.040621), // P1.3
  LatLng(36.959893, 127.040301), // P1.4
  LatLng(36.960100, 127.040470), // P1.5
  LatLng(36.960159, 127.040492), // P1.6
  LatLng(36.960230, 127.040495), // P1.7
  LatLng(36.960335, 127.040460), // P1.8
  LatLng(36.961027, 127.040007), // P1.9
  LatLng(36.961131, 127.039968), // P1.10
  LatLng(36.961237, 127.039960), // P1.11
  LatLng(36.963264, 127.040149), // P1.12
  LatLng(36.964342, 127.040196), // P1.13
  LatLng(36.964917, 127.040191), // S2 : Provider Grill DFAC
  LatLng(36.965304, 127.040180), // P2.1
  LatLng(36.965247, 127.036592), // P2.2
  LatLng(36.964293, 127.036618), // S3 : Desiderio ATC Tower
  LatLng(36.963488, 127.036613), // P3.1
  LatLng(36.963205, 127.036609), // P3.2
  LatLng(36.962324, 127.036548), // P3.3
  LatLng(36.962216, 127.036548), // P3.4
  LatLng(36.962070, 127.036574), // P3.5
  LatLng(36.961861, 127.036661), // P3.6
  LatLng(36.961254, 127.036931), // P3.7
  LatLng(36.961173, 127.036980), // P3.8
  LatLng(36.961131, 127.037023), // P3.9
  LatLng(36.961066, 127.037166), // P3.10
  LatLng(36.960987, 127.036680), // P3.11
  LatLng(36.960984, 127.036612), // P3.12
  LatLng(36.960987, 127.036563), // P3.13
  LatLng(36.961002, 127.036505), // P3.14
  LatLng(36.961855, 127.035220), // P3.15
  LatLng(36.962318, 127.034415), // P3.16
  LatLng(36.962322, 127.034380), // P3.17
  LatLng(36.962314, 127.034345), // P3.18
  LatLng(36.962297, 127.034316), // P3.19
  LatLng(36.962199, 127.034205), // P3.20
  LatLng(36.957655, 127.040605), // P3.21
  LatLng(36.957603, 127.040689), // P3.22
  LatLng(36.956782, 127.042429), // P3.23
  LatLng(36.956714, 127.042539), // P3.24
  LatLng(36.955041, 127.044758), // P3.25
  LatLng(36.954925, 127.044855), // P3.26
  LatLng(36.954834, 127.044899), // P3.27
  LatLng(36.954725, 127.044918), // P3.28
  LatLng(36.953661, 127.044937), // P3.29
  LatLng(36.953393, 127.044893), // P3.30
  LatLng(36.953199, 127.044773), // P3.31
  LatLng(36.953004, 127.044531), // P3.32
  LatLng(36.952927, 127.044295), // P3.33
  LatLng(36.952883, 127.043943), // P3.34
  LatLng(36.952885, 127.043629), // P3.35
  LatLng(36.952917, 127.043228), // P3.36
  LatLng(36.953468, 127.040354), // P3.37
  LatLng(36.953473, 127.040240), // P3.38
  LatLng(36.953460, 127.040119), // P3.39
  LatLng(36.953429, 127.040001), // P3.40
  LatLng(36.953383, 127.039879), // P3.41
  LatLng(36.953119, 127.039326), // P3.42
  LatLng(36.952939, 127.038742), // P3.43
  LatLng(36.952723, 127.037942), // P3.44
  LatLng(36.952713, 127.037805), // P3.45
  LatLng(36.952713, 127.037567), // P3.46
  LatLng(36.952773, 127.037096), // P3.47
  LatLng(36.952913, 127.036263), // P3.48
  LatLng(36.952980, 127.035431), // P3.49
  LatLng(36.952923, 127.034436), // S4 : Law Enforcement Center (DES)
  LatLng(36.952508, 127.030422), // P4.1
  LatLng(36.952325, 127.030415), // P4.2
  LatLng(36.952194, 127.030429), // P4.3
  LatLng(36.950987, 127.030702), // P4.4
  LatLng(36.950949, 127.030434), // P4.5
  LatLng(36.951301, 127.030363), // P4.6
  LatLng(36.951259, 127.029953), // S5 : Bus Terminal
  LatLng(36.951208, 127.029552), // P5.1
  LatLng(36.950845, 127.029637), // P5.2
  LatLng(36.950749, 127.028918), // P5.3
  LatLng(36.950101, 127.029034), // P5.4
  LatLng(36.950015, 127.028327), // P5.5
  LatLng(36.949975, 127.028175), // P5.6
  LatLng(36.949935, 127.028075), // P5.7
  LatLng(36.949886, 127.027981), // P5.8
  LatLng(36.949831, 127.027904), // P5.9
  LatLng(36.949460, 127.027547), // P5.10
  LatLng(36.949372, 127.027446), // P5.11
  LatLng(36.949315, 127.027355), // P5.12
  LatLng(36.949276, 127.027238), // P5.13
  LatLng(36.949251, 127.027086), // P5.14
  LatLng(36.949242, 127.027030), // P5.15
  LatLng(36.949205, 127.026992), // P5.16
  LatLng(36.949138, 127.026982), // P5.17
  LatLng(36.948939, 127.027103), // P5.18
  LatLng(36.948907, 127.027120), // P5.19
  LatLng(36.948873, 127.027120), // P5.20
  LatLng(36.948840, 127.027108), // P5.21
  LatLng(36.948529, 127.026887), // S6 : Lodging
  LatLng(36.948449, 127.026837), // P6.1
  LatLng(36.948646, 127.026322), // P6.2
  LatLng(36.948403, 127.026169), // P6.3
  LatLng(36.948272, 127.025851), // P6.4
  LatLng(36.948311, 127.025010), // P6.5
  LatLng(36.948395, 127.025007), // P6.6
  LatLng(36.948577, 127.025040), // P6.7
  LatLng(36.948653, 127.025069), // P6.8
  LatLng(36.948791, 127.025157), // S7 : Korean Theater of Operations Museum
  LatLng(36.948974, 127.025266), // P7.1
  LatLng(36.949007, 127.025162), // P7.2
  LatLng(36.949075, 127.024895), // P7.3
  LatLng(36.949094, 127.024772), // P7.4
  LatLng(36.949094, 127.024619), // P7.5
  LatLng(36.949018, 127.023662), // P7.6
  LatLng(36.949007, 127.023528), // P7.7
  LatLng(36.949238, 127.023337), // S8 : MSG Henry L. Jenkins Medical Clinic
  LatLng(36.949392, 127.023259), // P8.1
  LatLng(36.949478, 127.023232), // P8.2
  LatLng(36.949751, 127.023185), // P8.3
  LatLng(36.949998, 127.023199), // P8.4
  LatLng(36.950699, 127.023057), // P8.5
  LatLng(36.950806, 127.023059), // P8.6
  LatLng(36.950972, 127.023100), // P8.7
  LatLng(36.951133, 127.023113), // P8.8
  LatLng(36.951588, 127.023047), // P8.9 (Center of Circle)
  LatLng(36.951874, 127.022935), // P8.10
  LatLng(36.951951, 127.022872), // P8.11
  LatLng(36.952034, 127.022747), // P8.12
  LatLng(36.952083, 127.022642), // P8.13
  LatLng(36.952168, 127.022523), // P8.14
  LatLng(36.952454, 127.022247), // P8.15
  LatLng(36.952548, 127.022185), // P8.16
  LatLng(36.952643, 127.022137), // P8.17
  LatLng(36.952709, 127.022115), // P8.18
  LatLng(36.953496, 127.021939), // S9 : Collier Community Fitness Center
  LatLng(36.953876, 127.021856), // P9.1
  LatLng(36.954004, 127.021844), // P9.2
  LatLng(36.954120, 127.021849), // P9.3
  LatLng(36.954232, 127.021869), // P9.4
  LatLng(36.954436, 127.021911), // P9.5
  LatLng(36.954567, 127.021919), // P9.6
  LatLng(36.954690, 127.021889), // P9.7
  LatLng(36.955244, 127.021681), // P9.8 (Center of Circle)
  LatLng(36.955710, 127.021455), // P9.9
  LatLng(36.955788, 127.021408), // P9.10
  LatLng(36.955973, 127.021268), // P9.11
  LatLng(36.956770, 127.020553), // P9.12
  LatLng(36.957250, 127.019922), // P9.13
  LatLng(36.957873, 127.019084), // S10 : Family Housing Towers (5050s & 5070s Block)
  LatLng(36.958223, 127.018616), // P10.1
  LatLng(36.958355, 127.018417), // P10.2
  LatLng(36.958425, 127.018284), // P10.3
  LatLng(36.958493, 127.018139), // P10.4
  LatLng(36.958557, 127.017998), // P10.5
  LatLng(36.959277, 127.018502), // P10.6
  LatLng(36.959427, 127.018611), // P10.7
  LatLng(36.959542, 127.018704), // P10.8
  LatLng(36.959659, 127.018813), // P10.9
  LatLng(36.960384, 127.019580), // P10.10
  LatLng(36.960489, 127.019690), // P10.11
  LatLng(36.960608, 127.019798), // P10.12
  LatLng(36.960718, 127.019880), // P10.13
  LatLng(36.960888, 127.019983), // P10.14
  LatLng(36.960985, 127.020035), // S11 : Talon Cafe DFAC
  LatLng(36.961569, 127.020329), // P11.2
  LatLng(36.961828, 127.020432), // P11.3
  LatLng(36.962194, 127.020531), // P11.4
  LatLng(36.962792, 127.020648), // P11.5
  LatLng(36.963151, 127.020809), // P11.6
  LatLng(36.963418, 127.020967), // P11.7
  LatLng(36.963609, 127.021113), // P11.8
  LatLng(36.964071, 127.021598), // P11.9
  LatLng(36.965258, 127.019831), // S12 : Airfield Operations
  LatLng(36.965948, 127.018785), // P12.1
  LatLng(36.966040, 127.018616), // P12.2
  LatLng(36.962121, 127.016607), // P12.3
  LatLng(36.962490, 127.015501), // S13 : Barracks (6000s Block)
  LatLng(36.964561, 127.009246), // P13.1
  LatLng(36.966497, 127.010222), // S14 : Parcific Victors Chapel
  LatLng(36.968902, 127.011457), // P14.1
  LatLng(36.969339, 127.011233), // P14.2
  LatLng(36.970343, 127.008175), // S15 : Spartan DFAC
  LatLng(36.970851, 127.006650), // P15.1
  LatLng(36.967778, 127.005071), // S16 : LTG Timothy J. Maude Hall (9th Street)
  LatLng(36.963948, 127.003098), // S17 : Commissary
  LatLng(36.963716, 127.002981), // P17.1
  LatLng(36.963519, 127.002915), // P17.2
  LatLng(36.963382, 127.002891), // P17.3
  LatLng(36.963007, 127.002886), // P17.4
  LatLng(36.962969, 127.000192), // P17.5 (S14 : Main Post Office)
  LatLng(36.962964, 126.999558), // P17.6
  LatLng(36.962986, 126.999191), // P17.7
  LatLng(36.963062, 126.998809), // P17.8
  LatLng(36.963205, 126.998404), // P17.9
  LatLng(36.963410, 126.998032), // P17.10
  LatLng(36.963598, 126.997789), // P17.11
  LatLng(36.963809, 126.997586), // P17.12
  LatLng(36.964385, 126.997115), // P17.13
  LatLng(36.964561, 126.997442), // P17.14
  LatLng(36.964706, 126.997626), // P17.15
  LatLng(36.964896, 126.997775), // P17.16
  LatLng(36.965583, 126.998128), // S18 : Main Exchange
  LatLng(36.969713, 127.000252), // S19 : Balboni Sports Field Complex (7th Street)
  LatLng(36.972500, 127.001684), // P19.1
  LatLng(36.970851, 127.006650), // P19.2 == P11.1
]; // for greenPolyline
List<LatLng> orangeRouteLatLngList = [
  LatLng(36.958283, 127.043168), // S1 : Pesestrian Gate
  LatLng(36.959024, 127.041985), // P1.1
  LatLng(36.959528, 127.041050), // P1.2
  LatLng(36.959749, 127.040621), // P1.3
  LatLng(36.959893, 127.040301), // P1.4
  LatLng(36.960100, 127.040470), // P1.5
  LatLng(36.960159, 127.040492), // P1.6
  LatLng(36.960230, 127.040495), // P1.7
  LatLng(36.960335, 127.040460), // P1.8
  LatLng(36.961027, 127.040007), // P1.9
  LatLng(36.961131, 127.039968), // P1.10
  LatLng(36.961237, 127.039960), // P1.11
  LatLng(36.963264, 127.040149), // P1.12
  LatLng(36.964342, 127.040196), // P1.13
  LatLng(36.964917, 127.040191), // S2 : Provider Grill DFAC
  LatLng(36.965304, 127.040180), // P2.1
  LatLng(36.965247, 127.036592), // P2.2
  LatLng(36.965851, 127.036572), // S3 : SLQs (12200s block)
  LatLng(36.966279, 127.036557), // P3.1
  LatLng(36.966214, 127.032623), // P3.2
  LatLng(36.966194, 127.032370), // P3.3
  LatLng(36.966111, 127.032083), // S4 : Eighth Army
  LatLng(36.966042, 127.031941), // P4.1
  LatLng(36.965937, 127.031792), // P4.2
  LatLng(36.964830, 127.030529), // P4.3
  LatLng(36.969891, 127.023370), // P4.4
  LatLng(36.970347, 127.022904), // P4.5
  LatLng(36.970762, 127.022639), // P4.6
  LatLng(36.972246, 127.022108), // P4.7
  LatLng(36.972506, 127.021957), // P4.8
  LatLng(36.972692, 127.021795), // P4.9
  LatLng(36.972941, 127.021504), // P4.10 (S5 : Corps of Engineers)
  LatLng(36.972660, 127.021318), // P4.11
  LatLng(36.972629, 127.021288), // P4.12
  LatLng(36.972540, 127.021177), // P4.13
  LatLng(36.972485, 127.021060), // P4.14
  LatLng(36.972413, 127.020877), // P4.15
  LatLng(36.972334, 127.020722), // P4.16
  LatLng(36.972061, 127.020272), // P4.17
  LatLng(36.971995, 127.020131), // P4.18
  LatLng(36.971791, 127.019697), // P4.19
  LatLng(36.971506, 127.019185), // P4.20
  LatLng(36.971383, 127.019016), // P4.21
  LatLng(36.971193, 127.018829), // P4.22
  LatLng(36.970867, 127.018581), // P4.23
  LatLng(36.970759, 127.018536), // P4.24
  LatLng(36.970604, 127.018523), // P4.25
  LatLng(36.969652, 127.018783), // P4.26
  LatLng(36.969503, 127.018814), // P4.27
  LatLng(36.969367, 127.018823), // P4.28
  LatLng(36.969313, 127.018805), // P4.29
  LatLng(36.968970, 127.018697), // P4.30
  LatLng(36.968240, 127.018231), // P4.31
  LatLng(36.968524, 127.018405), // P4.32
  LatLng(36.967744, 127.017901), // P4.33
  LatLng(36.967309, 127.017695), // P4.34
  LatLng(36.967143, 127.017605), // P4.35
  LatLng(36.967214, 127.017525), // P4.36
  LatLng(36.967315, 127.017335), // P4.37
  LatLng(36.967635, 127.016371), // S5 : TMP (Driver's Licensing)
  LatLng(36.969080, 127.012007), // P5.1
  LatLng(36.969517, 127.011773), // P5.2
  LatLng(36.972583, 127.013289), // P5.3
  LatLng(36.973345, 127.013686), // P5.4
  LatLng(36.973461, 127.013766), // P5.5
  LatLng(36.973597, 127.013909), // P5.6
  LatLng(36.973725, 127.014161), // P5.7
  LatLng(36.973771, 127.014372), // P5.8
  LatLng(36.973718, 127.014751), // P5.9
  LatLng(36.973244, 127.020567), // P5.10
  LatLng(36.973194, 127.020860), // P5.11
  LatLng(36.973130, 127.021073), // P5.12
  LatLng(36.972941, 127.021504), // S6 : Corps of Engineers == P4.10
]; // for orangePolyline
List<LatLng> purpleRouteLatLngList = [
  LatLng(36.952395, 127.029093), // S1 : Brian D. Allgood Army Community Hospital (Key Street)

  LatLng(36.951259, 127.029953), // S2 : Bus Terminal

  LatLng(36.953496, 127.021939), // S3 : Collier Community Fitness Center

  LatLng(36.960643, 127.024542), // S4 : Turner Fitness Center
  LatLng(36.963106, 127.023047), // P4.1
  LatLng(36.963188, 127.022985), // P4.2
  LatLng(36.963244, 127.022924), // P4.3
  LatLng(36.963421, 127.022638), // P4.4
  LatLng(36.963844, 127.022053), // P4.5
  LatLng(36.963993, 127.021680), // P4.6
  LatLng(36.964071, 127.021598), // P4.7
  LatLng(36.965258, 127.019831), // P4.8 (S7 : Airfield Operations)
  LatLng(36.965948, 127.018785), // P4.9
  LatLng(36.966040, 127.018616), // P4.10
  LatLng(36.966270, 127.018200), // P4.11
  LatLng(36.966373, 127.018053), // P4.12
  LatLng(36.966494, 127.017962), // P4.13
  LatLng(36.967082, 127.017651), // P4.14
  LatLng(36.967143, 127.017605), // P4.15
  LatLng(36.967214, 127.017525), // P4.16
  LatLng(36.967315, 127.017335), // P4.17
  LatLng(36.967635, 127.016371), // S5 : TMP (Driver's Licensing)
  LatLng(36.970343, 127.008175), // S6 : Spartan DFAC
  LatLng(36.974140, 126.996712), // P6.1
  LatLng(36.974992, 126.994145), // S7 : Sitman Fitness Center
  LatLng(36.975785, 126.991749), // P7.1
  LatLng(36.973795, 126.990728), // S8 : Barracks (6800s & 6900s Block)
  LatLng(36.971253, 126.989420), // P8.1
  LatLng(36.969609, 126.994382), // P8.2
  LatLng(36.970758, 126.994980), // S9 : Balboni Sports Field Complex (5th Street)
  LatLng(36.974140, 126.996712), // P9.1 == P6.1
  LatLng(36.973587, 126.998386), // S10 : Pittman DFAC
]; // for purplePolyline

// "노선 별 폴리라인" 의 리스트
List<List> listOfPolyline = [bluePolyline, blackPolyline, greenPolyline, orangePolyline, purplePolyline];
// 노선 별 폴리라인
final List<Polyline> bluePolyline = [];
final List<Polyline> blackPolyline = [];
final List<Polyline> greenPolyline = [];
final List<Polyline> orangePolyline = [];
final List<Polyline> purplePolyline = [];
